/* ============================================================================
   STORED PROCEDURE : silver.load_silver
   PURPOSE          : Cleans, transforms, and loads data from the Bronze Layer 
                      to the Silver Layer in the data warehouse.
                      Ensures consistency, standardization, and deduplication. 

     NOTES:
   - Each Silver table is truncated before new data is inserted to prevent duplicates.
   - Business rules are applied (e.g., date formatting, null handling, standard labels).
   - Procedure can be run repeatedly to refresh Silver Layer from Bronze.

   USAGE:
   EXEC silver.load_silver;
============================================================================ */
CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    -- ==========================================
    -- DATA CLEANING & TRANSFORMATION PROCESS
    -- Transfers cleaned data from BRONZE → SILVER
    -- ==========================================

    -- 1️. Customer Info
    PRINT '>> Truncating Table: silver.crm_cust_info'
    TRUNCATE TABLE silver.crm_cust_info;

    PRINT '>> Inserting data into: silver.crm_cust_info'
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


    -- 2️.Product Info
    PRINT '>> Truncating Table: silver.crm_prd_info'
    TRUNCATE TABLE silver.crm_prd_info;

    PRINT '>> Inserting data into: silver.crm_prd_info'
    INSERT INTO silver.crm_prd_info (
        prd_id,
        prd_key,
        cat_id,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT 
        prd_id,
        SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
        prd_nm,
        ISNULL(prd_cost, 0) AS prd_cost,
        CASE UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'N/A'
        END AS prd_line,
        prd_start_dt,
        DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
    FROM bronze.crm_prd_info;


    -- 3️. Sales Details
    PRINT '>> Truncating Table: silver.crm_sales_details'
    TRUNCATE TABLE silver.crm_sales_details;

    PRINT '>> Inserting data into: silver.crm_sales_details'
    INSERT INTO silver.crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
             ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END AS sls_order_dt,
        CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
             ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END AS sls_ship_dt,
        CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
             ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END AS sls_due_dt,
        CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
             THEN sls_quantity * ABS(sls_price)
             ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE WHEN sls_price IS NULL OR sls_price <= 0
             THEN sls_sales / NULLIF(sls_quantity, 0)
             ELSE sls_price
        END AS sls_price
    FROM bronze.crm_sales_details;


    -- 4️. ERP Customer 
    PRINT '>> Truncating Table: silver.erp_cust_az12'
    TRUNCATE TABLE silver.erp_cust_az12;

    PRINT '>> Inserting data into: silver.erp_cust_az12'
    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT 
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
             ELSE cid
        END AS cid,
        CASE WHEN bdate > GETDATE() THEN NULL
             ELSE bdate
        END AS bdate,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'N/A'
        END AS gen
    FROM bronze.erp_cust_az12;


    -- 5️. ERP Location
    PRINT '>> Truncating Table: silver.erp_loc_a101'
    TRUNCATE TABLE silver.erp_loc_a101;

    PRINT '>> Inserting data into: silver.erp_loc_a101'
    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT 
        REPLACE(cid, '-', '') AS cid,
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'N/A'
            ELSE TRIM(cntry)
        END AS cntry
    FROM bronze.erp_loc_a101;


    -- 6️. ERP Product Categories
    PRINT '>> Truncating Table: silver.erp_px_cat_g1v2'
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    PRINT '>> Inserting data into: silver.erp_px_cat_g1v2'
    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT * FROM bronze.erp_px_cat_g1v2;

END;
