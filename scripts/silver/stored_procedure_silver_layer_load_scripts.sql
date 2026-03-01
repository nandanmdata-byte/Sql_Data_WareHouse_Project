
/*
===================================================================

| STORED PROCEDURE : LOADING SILVER LAYER | 

===================================================================

Objective: 
	This loading script load data from the bronze layer to the silver layer, after ensuring data quality and consistency.

Note : 
	This procedure doesn't use any parameters and it doesn't return any values.


WARNING!:
	1. This script is intended to be run after the bronze layer has been successfully loaded and validated.
	2. This script first TRUNCATE the target silver tables in order to avoid duplicate records and then load the data.
	3. Always backup your data before running any load scripts.
	4. Ensure that the source (bronze) and target (silver) tables are properly defined and have the necessary columns.
	5. Validate the data in the bronze layer before loading it into the silver layer to avoid data quality issues.

*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '===================================================================';
		PRINT 'Loading the silver layer tables...';
		PRINT '===================================================================';


		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading CRM tables...';
		PRINT '-------------------------------------------------------------------';

		-- Loading silver.crm_cust_info
		SET @start_time = GETDATE();
		PRINT '>> Truncating the target table : silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Loading data into silver.crm_cust_info from bronze.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			cst_id, 
			cst_key, 
			cst_firstname, 
			cst_lastname, 
			cst_marital_status, 
			cst_gndr, 
			cst_create_date)

		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			-- Normalize and handle invalid data
			CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' 
				 WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' 
				 ELSE 'Unknown' 
			END AS cst_marital_status,

			CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
				 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' 
				 ELSE 'Unknown' 
			END AS cst_gndr,
			cst_create_date
		FROM (
			SELECT 
			*,
			-- Filtering out rows without value or duplicates and allowing only valid data
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
			FROM bronze.crm_cust_info 
			WHERE  cst_id IS NOT NULL
		)t 
		WHERE flag_last = 1; 
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		-- Loading silver.crm_prd_info
		SET @start_time = GETDATE();
		PRINT '>> Truncating the target table : silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Loading data into silver.crm_prd_info from bronze.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id, 
			cat_id,
			prd_key, 
			prd_nm, 
			prd_cost, 
			prd_line, 
			prd_start_dt, 
			prd_end_dt
		)

		SELECT
			prd_id,
			-- Extracting Category ID from the first 5 characters of the composite prd_key
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, 
			-- Extracting Product Key
			SUBSTRING(prd_key, 7, LEN(prd_key) ) AS prd_key,   
			prd_nm,
			ISNULL(prd_cost,0) AS prd_cost,
			-- Map product line codes to descriptive values
			CASE UPPER(TRIM(prd_line))
				 WHEN 'M' THEN 'Mountain'
				 WHEN 'R' THEN 'Road'
				 WHEN 'S' THEN 'Other Sales' 
				 WHEN 'T' THEN 'Touring' 
				 ELSE 'Unknown' 
			END AS prd_line,  
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			-- Calculate end date as one day before the next start date for the same product key
			CAST(
				LEAD(prd_start_dt) OVER ( PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE
				) AS prd_end_dt  
		FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		-- Loading silver.crm_sales_details
		SET @start_time = GETDATE();
		PRINT '>> Truncating the target table : silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Loading data into silver.crm_sales_details from bronze.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sls_ord_num ,
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
			-- handling invalid data
			CASE 
				WHEN sls_order_dt = 0 or LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST ( CAST( sls_order_dt AS VARCHAR ) AS DATE )
			END AS sls_order_dt,
			CASE 
				WHEN sls_ship_dt = 0 or LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST ( CAST( sls_ship_dt AS VARCHAR ) AS DATE )
			END AS sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 or LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST ( CAST( sls_due_dt AS VARCHAR ) AS DATE )
			END AS sls_due_dt,
			-- Recalculate data if the original data is incorrect or missing
			CASE 
				WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) 
				THEN sls_quantity * ABS(sls_price) 
				ELSE sls_sales
			END AS sls_sales,  
			sls_quantity,
			CASE 
				WHEN sls_price <= 0 OR sls_price IS NULL 
				THEN ABS(sls_sales)/NULLIF(sls_quantity,0)
				ELSE sls_price
			END AS sls_price 
		FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';


		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading ERP tables...';
		PRINT '-------------------------------------------------------------------';

		-- Loading silver.erp_cust_az12
		SET @start_time = GETDATE();
		PRINT '>> Truncating the target table : silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Loading data into silver.erp_cust_az12 from bronze.erp_cust_az12';
		-- Data Cleaning: Removing prefixes, handling future dates, and normalizing gender
		INSERT INTO silver.erp_cust_az12 (
			cid, 
			bdate, 
			gen
		)

		SELECT
			-- Remove 'NAS' prefix to align with 'cst_key' column format in silver.crm_cust_info table
			CASE  
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
				ELSE cid
			END AS cid,
			-- Rule: Future birthdates are invalid; set to NULL for data integrity
			CASE 
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate,
	
			CASE  
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				ELSE 'Unknown'
			END AS gen 
		FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		-- Loading silver.erp_loc_a101
		SET @start_time = GETDATE();
		PRINT '>> Truncating the target table : silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Loading data into silver.erp_loc_a101 from bronze.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
			cid, 
			cntry
		)

		SELECT
			REPLACE (cid, '-', '') AS cid, 
			-- Normalize and handle missing values or blank country codes
			CASE 
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
				ELSE TRIM(cntry)
			END AS cntry 
		FROM bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		-- Loading silver.erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>> Truncating the target table : silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Loading data into silver.erp_px_cat_g1v2 from bronze.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (
			id, 
			cat, 
			subcat, 
			maintenance
		)

		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT '---------------------';

		SET @batch_end_time = GETDATE();
		PRINT '===================================================================';
		PRINT 'Silver layer loading completed successfully!';
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


EXEC silver.load_silver