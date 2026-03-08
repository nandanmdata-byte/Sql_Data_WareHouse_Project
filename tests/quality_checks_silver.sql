/*
==============================================================================================================

Data Quality Checks | Silver Layer

==============================================================================================================

Purpose:
	This script validates data integrity and ensures standardization across the Silver Schema. 
	It executes a series of quality gates to identify:
	-- Integrity Violations: NULL values or duplicates in Primary Keys.
	-- Formatting Issues: Leading/trailing whitespaces in string attributes.
	-- Logic Errors: Out-of-range dates or chronological inconsistencies between related fields.
	-- Standardization: Discrepancies in data formats and cross-field consistency.
Usage:
	-- Execution: Run this script after the Silver layer data load.
	-- Action: Any records flagged during these checks must be investigated and solved to maintain data quality.
==============================================================================================================
*/

-- ===========================================================================================================
-- Checking 'silver.crm_cust_info'
-- ===========================================================================================================


-- Check for Duplicates or NULLs in Primary Key
-- Expectation: No Results

SELECT 
	cst_id,
	COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING cst_id IS NULL OR COUNT(*) > 1;

-- Data Qualty Check - Check for Unwanted space in string values
-- Expectation: No Results

SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

SELECT 
	cst_firstname 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT 
	cst_lastname 
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Data Standardization (or Normalization) & Consistency

SELECT DISTINCT 
	cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT 
	cst_marital_status
FROM silver.crm_cust_info;

-- ===========================================================================================================
-- Checking 'silver.crm_prd_info'
-- ===========================================================================================================

-- Check for NULLs and Duplicates in Primary Key
-- Expectation: no results

SELECT 
	prd_id,
	COUNT(*) AS count
FROm silver.crm_prd_info
GROUP BY prd_id
HAVING prd_id IS NULL OR COUNT(*) > 1;

-- Check for unwanted spaces
-- Expectation : No results

SELECT 
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm  != TRIM(prd_nm);

-- Check for NULLs or negative numbers
-- Expectation : No results

SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Data Standardization & Consistency Checks
-- Expectation : Unique and clear data

SELECT DISTINCT 
	prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
-- Expectation : No results

SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;
 
-- ===========================================================================================================
-- Checking 'silver.crm_sales_details'
-- ===========================================================================================================

-- Check for unwanted spaces
-- Expectation : No results

SELECT 
	sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num  != TRIM(sls_ord_num);

-- Check for NULLs
-- Expectation : No results

SELECT 
	*
FROM silver.crm_sales_details
WHERE sls_due_dt IS NULL;

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results

SELECT 
	*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check for Invalid Dates
-- Expectation: No Invalid Dates

SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;



-- Check Data Consistency: 1) Sales = Quantity * Price
--					       2) Negative, zeroes, NULLs are not allowed 
-- Expectation: No Results


SELECT DISTINCT
	sls_sales,
	sls_quantity, 
	sls_price
FROM silver.crm_sales_details
WHERE  sls_sales != sls_quantity * sls_price 
	OR sls_sales <= 0 
	OR sls_quantity <= 0
	OR sls_price <= 0
	OR sls_sales  IS NULL
	OR sls_quantity IS NULL
	OR sls_price IS NULL
ORDER BY sls_sales, sls_quantity, sls_price;

/* Additional Notes :  
			Sales , Quantity , Price Data validation rules
			#1 : If Sales is -ve , zero or NULL, derive it using Quantity and Price
			#2 : If Price is zero or NULL, calculate it using Sales and Quantity
			#3 : If Price is -ve, convert it to a positive value 
*/

-- ===========================================================================================================
-- Checking 'silver.erp_cust_az12'
-- ===========================================================================================================


-- Identify Out_of_Range Dates 
-- Expectation: Birthdates less than 1924-01-01 and greater than today
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Data Standardization & Consistency
-- Expectation : Unique values

SELECT DISTINCT 
	gen
FROM silver.erp_cust_az12;

-- ===========================================================================================================
-- Checking 'silver.erp_loc_a101'
-- ===========================================================================================================

-- Data Standardization & Consistency

SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ===========================================================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ===========================================================================================================

-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT 
	*
FROM silver.erp_px_cat_g1v2
WHERE  TRIM(cat) != cat 
	OR TRIM(subcat) != subcat 
	OR TRIM(maintenance) != maintenance;

-- Data Standardization & Consistency check

SELECT DISTINCT
	cat 
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT 
	subcat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT 
	maintenance 
FROM silver.erp_px_cat_g1v2;




