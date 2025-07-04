-- Clean,prepare and insert data from bronze.erp_cust_az12 for the Silver Layer
-- ------------------------------------------------------------------------

-- 1️. Clean the Customer ID (cid):
--    • If it starts with 'NAS', remove the prefix using SUBSTRING.
--    • Otherwise, keep it as it is.

-- 2️. Fix Birth Dates (bdate):
--    • If the birth date is in the future (greater than today), set it to NULL.
--    • Otherwise, keep the original date.

-- 3️. Standardize Gender (gen):
--    • If gen is 'F' or 'FEMALE', return 'Female'.
--    • If gen is 'M' or 'MALE', return 'Male'.
--    • For all other values, return 'N/A'.

PRINT '>> Truncating Table: silver.erp_cust_az12'
TRUNCATE TABLE silver.erp_cust_az12
PRINT '>> Inserting data into:silver.erp_cust_az12'

 INSERT INTO silver.erp_cust_az12 (cid, bdate,gen)
SELECT 
 CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid,4,LEN(cid))
 ELSE cid
 END cid,
 CASE WHEN bdate > getdate() THEN NULL
 ELSE bdate
 END AS bdate,
 CASE WHEN UPPER(TRIM(gen))  IN ('F', 'FEMALE') THEN 'Female' 
      WHEN UPPER(TRIM(gen))  IN ('M', 'MALE') THEN 'Male' 
 ELSE 'Unknown'
 END AS gen
 FROM bronze.erp_cust_az12;


 select * from silver.erp_cust_az12
