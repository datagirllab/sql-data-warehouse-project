--Check for duplicate or NULL cst_id in bronze layer.
SELECT cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Retrieve full records with duplicate or NULL cst_id
SELECT *
FROM bronze.crm_cust_info
WHERE cst_id IN (
    SELECT cst_id
    FROM bronze.crm_cust_info
    GROUP BY cst_id
    HAVING COUNT(*) > 1 OR cst_id IS NULL
);


-- Identify duplicates by assigning row numbers (latest record gets flag_last = 1) 
-- Uses a window function to rank records by cust_create_date in descending order
SELECT *, 
       ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cust_create_date DESC) AS flag_last
FROM bronze.crm_cust_info;


-- Select duplicates except the latest record (flag_last != 1)
SELECT * 
FROM (
    SELECT *,  
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cust_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
) as Duplicates
WHERE flag_last != 1;



-- Select only the latest record per customer (flag_last = 1) for silver layer
SELECT * 
FROM (
    SELECT *,  
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cust_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
) as to_use
WHERE flag_last = 1;


-- Identify records with leading/trailing spaces in customer names and gender columns.
-- This query compares the original value to its trimmed version.
-- If they are not equal (!=), it indicates the original value has extra spaces at the beginning or end.

SELECT cust_firstname 
FROM bronze.crm_cust_info
WHERE cust_firstname != TRIM (cust_firstname);

SELECT cust_lastname 
FROM bronze.crm_cust_info
WHERE cust_lastname != TRIM (cust_lastname);

SELECT cust_gndr
FROM bronze.crm_cust_info
WHERE cust_gndr != TRIM (cust_gndr);


-- Standardize gender and marital status, trim names, and select latest record only
SELECT  
    cst_id,
    cst_key,
    TRIM(cust_firstname) AS cust_firstname,
    TRIM(cust_lastname) AS cust_lastname,
       CASE 
        WHEN UPPER(TRIM(cust_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cust_marital_status)) = 'M' THEN 'Married'
        ELSE 'Unknown'
    END AS cust_marital_status,  
   	 CASE 
        WHEN UPPER(TRIM(cust_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cust_gndr)) = 'M' THEN 'Male'
        ELSE 'Unknown'
    END AS cust_gndr,
    cust_create_date
FROM (
    SELECT *,  
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cust_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) AS to_use
WHERE flag_last = 1;
  

-- Insert cleaned and deduplicated records into silver layer
PRINT '>> Truncating Table: silver.crm_cust_info'
TRUNCATE TABLE silver.crm_cust_info
PRINT '>> Inserting data into:silver.crm_cust_info'
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cust_firstname,
    cust_lastname,
    cust_marital_status,
    cust_gndr,
    cust_create_date
)
SELECT  
    cst_id,
    cst_key,
    TRIM(cust_firstname) AS cust_firstname,
    TRIM(cust_lastname) AS cust_lastname,
    CASE 
        WHEN UPPER(TRIM(cust_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cust_marital_status)) = 'M' THEN 'Married'
        ELSE 'Unknown'
    END AS cust_marital_status,  
    CASE 
        WHEN UPPER(TRIM(cust_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cust_gndr)) = 'M' THEN 'Male'
        ELSE 'Unknown'
    END AS cust_gndr,
    cust_create_date
FROM (
    SELECT *,  
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cust_create_date DESC) AS latest_record_flag
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) AS to_use
WHERE latest_record_flag = 1;
