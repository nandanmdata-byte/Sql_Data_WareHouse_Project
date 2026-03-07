/*
=================================================================================

Gold Layer | Quality Checks

=================================================================================

Purpose:
    The purpose of this script is to perform quality checks in order to validate the integrity, consistency, 
    and accuracy of the Gold Layer.
    These checks ensure:
    - the uniqueness of surrogate keys in dimension tables.
    - the referential integrity between fact and dimension tables.
    - the validation of relationships in the data model for analytical purposes.

Usage Notes:
    - If any discrepancies are found during the checks, investigate and resolve immediately
      for smooth performance.

=================================================================================
*/

-- ==============================================================================
-- Quality checking : gold.dim_customers
-- ==============================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ==============================================================================
-- Quality checking : gold.dim_products
-- ==============================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Quality checking : gold.fact_sales
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Expectation : no results
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
