-- Step 1: Clean and insert data into silver.erp_loc_a101
-- Remove hyphens from Customer ID (cid) so it matches the cst_key in crm.cust_info
-- Standardize country (cntry) values:
--  'DE' → 'Germany'
--  'US' or 'USA' → 'United States'
--   Empty string or NULL → 'N/A'
--   All other values → keep as-is after trimming

PRINT '>> Truncating Table: silver.erp_loc_a101'
TRUNCATE TABLE silver.erp_loc_a101
PRINT '>> Inserting data into:silver.erp_loc_a101'

INSERT INTO silver.erp_loc_a101
(cid, cntry)
SELECT
REPLACE (cid , '-','') AS cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
     WHEN TRIM (cntry) = '' OR TRIM(cntry) IS NULL THEN 'N/A'
ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101

--Data validation — Check unique country values in the Silver Layer
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;




