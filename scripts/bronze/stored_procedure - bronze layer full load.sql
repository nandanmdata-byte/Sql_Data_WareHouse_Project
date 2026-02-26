
/* 
=====================================================================

| Stored Procedure: Loading bronze_layer | 

=====================================================================

Purpose : 
	This stored procedure uses the process of TRUNCATE & INSERT ( Full Load )
	for data ingestion directly from external CSV source files to the bronze layer tables without any transformation. 
	It follows the actions :
	- Truncate the bronze tables before loading data.
	- Use the `BULK INSERT` command to load data from csv Files to bronze tables.

Note : This procedure doesn't use any parameters and it doesn't return any values.

WARNING :
	The procedure uses the TRUNCATE TABLE command to clear existing data before loading new data.
	Proceed with precaution as once its executed, it cannot be rolled back. 

*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '===================================================================';
		PRINT 'Loading the bronze layer tables...';
		PRINT '===================================================================';


		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading CRM tables...';
		PRINT '-------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating the Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Loading data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\SQL_User\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating the Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Loading data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\SQL_User\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating the Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Loading data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\SQL_User\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';


		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading ERP tables...';
		PRINT '-------------------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating the Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Loading data into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\SQL_User\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating the Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Loading data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\SQL_User\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating the Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Loading data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\SQL_User\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';
		SET @batch_end_time = GETDATE();
		PRINT '===================================================================';
		PRINT 'Bronze layer loading completed successfully!';
		PRINT '   >> Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds.';
		PRINT '===================================================================';


	END TRY
	BEGIN CATCH
		PRINT '===================================================================';
		PRINT 'AN ERROR OCCURED DURING THE LOADING OF BRONZE LAYER!';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '===================================================================';
	END CATCH
END