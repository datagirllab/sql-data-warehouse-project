/*
Script: EXTRACT RAW DATA TO BRONZE
This script truncates existing data and uses BULK INSERT to load fresh data from CSV files into the corresponding Bronze layer tables.
Note: The file paths in this script are placeholders. Replace <path_to_your_file> with the actual directory path where your CSV files are stored. Ensure the files are present in those locations before running the script.
*/


--BULK INSERT cust_info
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM '<path_to_your_file>\cust_info.csv'
WITH (
     FIRSTROW = 2,
	 FIELDTERMINATOR = ',',
     TABLOCK
	 );


--BULK INSERT prd_info
TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM '<path_to_your_file>\prd_info.csv'
WITH (
     FIRSTROW = 2,
	 FIELDTERMINATOR = ',',
     TABLOCK
	 );
 SELECT COUNT (* )FROM bronze.crm_prd_info
 SELECT * FROM bronze.crm_prd_info
 

 --BULK INSERT sales_details
 TRUNCATE TABLE bronze.crm_sales_details;
 BULK INSERT bronze.crm_sales_details
FROM '<path_to_your_file>\sales_details.csv'
WITH (
     FIRSTROW = 2,
	 FIELDTERMINATOR = ',',
     TABLOCK
	 );
SELECT * FROM bronze.crm_sales_details


--BULK INSERT cust_az12
TRUNCATE TABLE bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
FROM '<path_to_your_file>\CUST_AZ12.csv'
WITH (
     FIRSTROW = 2,
	 FIELDTERMINATOR = ',',
     TABLOCK
	 );
SELECT COUNT (*) FROM bronze.erp_cust_az12
SELECT * FROM bronze.erp_cust_az12


--BULK INSERT loc_a101
TRUNCATE TABLE bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
FROM '<path_to_your_file>\LOC_A101.csv'
WITH (
     FIRSTROW = 2,
	 FIELDTERMINATOR = ',',
     TABLOCK
	 );
SELECT * FROM bronze.erp_loc_a101
SELECT COUNT (*) FROM bronze.erp_loc_a101



--BULK INSERT px_cat_g1v2
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
FROM '<path_to_your_file>\PX_CAT_G1V2.csv'
WITH (
     FIRSTROW = 2,
	 FIELDTERMINATOR = ',',
     TABLOCK
	 );
SELECT * FROM bronze.erp_px_cat_g1v2
SELECT COUNT (*) FROM bronze.erp_px_cat_g1v2

