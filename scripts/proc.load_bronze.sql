/*
==========================================================
Stored Procedure: bronze.load_bronze
Purpose: Bulk insert raw data from CSVs into Bronze layer
Usage: Run to refresh Bronze tables with new source files.

This stored procedure does not accept any parameters 
or return any values.
==========================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN 
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
BEGIN TRY
    SET @batch_start_time = GETDATE();
    PRINT '=========================================================';
	PRINT 'loading bronze layer';
	PRINT '=========================================================';

	PRINT '---------------------------------------------------------';
	PRINT 'loading CRM tables';
	PRINT '---------------------------------------------------------';

	
	--BULK INSERT cust_info
	SET @start_time = GETDATE();
	PRINT '>>Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;

	PRINT '>> Inserting Data Into: bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info
    FROM 'C:\path\to\your\datasets\source_crm\cust_info.csv'
    WITH (
       FIRSTROW = 2,
	   FIELDTERMINATOR = ',',
       TABLOCK
	   );
	    SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


	--BULK INSERT prd_info
    SET @start_time = GETDATE();
	PRINT '>>Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

	PRINT '>> Inserting Data Into: bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\path\to\your\datasets\source_crm\prd_info.csv'
	WITH (
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
		 );
		 SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


	 --BULK INSERT sales_details
	 SET @start_time = GETDATE();
	 PRINT '>>Truncating Table: bronze.crm_sales_details';
	 TRUNCATE TABLE bronze.crm_sales_details;

	 PRINT '>> Inserting Data Into: bronze.crm_sales_details';
	 BULK INSERT bronze.crm_sales_details
	 FROM 'C:\path\to\your\datasets\source_crm\sales_details.csv'
	 WITH (
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
		 );
		 SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';



	PRINT '---------------------------------------------------------';         
	PRINT 'loading ERP tables';
	PRINT '---------------------------------------------------------';
	 
	--BULK INSERT cust_az12  
	SET @start_time = GETDATE();
	PRINT '>>Truncating Table: bronze.erp_cust_az12'; 
	TRUNCATE TABLE bronze.erp_cust_az12;

	PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\path\to\your\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
		 );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


	--BULK INSERT loc_a101
	SET @start_time = GETDATE();
	PRINT '>>Truncating Table: bronze.erp_loc_a101'; 
	TRUNCATE TABLE bronze.erp_loc_a101;

	PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\path\to\your\datasets\source_erp\LOC_A101.csv'
	WITH (
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
		 );
SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


	--BULK INSERT px_cat_g1v2
	SET @start_time = GETDATE();
	PRINT '>>Truncating Table: bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\path\to\your\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
		 FIRSTROW = 2,
		 FIELDTERMINATOR = ',',
		 TABLOCK
		 );
		 SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='

END TRY
BEGIN CATCH 
   PRINT 'Error ⚠️' + ERROR_MESSAGE();
END CATCH

END
