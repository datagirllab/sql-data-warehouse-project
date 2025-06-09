/*
===========================================
  SCRIPT NAME: Clean & Prepare CRM Sales Data
  PURPOSE: Identify and fix invalid values in bronze.crm_sales_details table 
           before inserting into Silver Layer
  DATA SOURCE: bronze.crm_sales_details
  TARGET LAYER: Silver Layer
===========================================

🔍 OVERVIEW:
- This script identifies bad records in the CRM sales data.
- The cleaned and corrected records are prepared for insertion into the Silver Layer.
*/-- Data Cleaning & Transformation from BRONZE Layer: crm_sales_details to silver.crm_sales_details

-- Goal: Clean incorrect or inconsistent data before loading into the Silver Layer.

-- 1.Clean and Format Date Columns (Order Date, Ship Date, Due Date):
--     • If the date is '0' or not exactly 8 digits (i.e., not in 'YYYYMMDD' format), set it to NULL.
--     • Otherwise, cast the 8-digit integer to VARCHAR, then to DATE.

-- 2. Handle Sales Values (sls_sales):
--     • If sls_sales is NULL, zero, or not equal to Quantity × Price,
--         → Derive it as: sls_sales = sls_quantity × ABS(sls_price)
--     • Otherwise, keep the original value.

-- 3. Retain sls_quantity as-is:
--     • Quantity is assumed to be clean based on earlier observation.

-- 4. Handle Price Values (sls_price):
--    If sls_price is NULL, zero, or negative,
--    Calculate it as: sls_price = sls_sales ÷ sls_quantity
--    (uses NULLIF to avoid division by zero).
--    Otherwise, retain the original sls_price value.

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8  THEN NULL
ELSE CAST(CAST (sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8  THEN NULL
ELSE CAST(CAST (sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8  THEN NULL
ELSE CAST(CAST (sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
     THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <=0 
     THEN sls_sales/ NULLIF (sls_quantity,0) 
	 ELSE sls_price
END AS sls_price
FROM BRONZE.crm_sales_details 


-- Final Insertion: Cleaned Data from BRONZE → SILVER Layer (crm_sales_details)
-- Ensures only accurate and standardized data is loaded into silver.crm_sales_details.

INSERT INTO silver.crm_sales_details
(   sls_ord_num,
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
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8  THEN NULL
ELSE CAST(CAST (sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8  THEN NULL
ELSE CAST(CAST (sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8  THEN NULL
ELSE CAST(CAST (sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
     THEN sls_quantity * ABS(sls_price)
	 ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <=0 
     THEN sls_sales/ NULLIF (sls_quantity,0) 
	 ELSE sls_price
END AS sls_price
FROM BRONZE.crm_sales_details 
