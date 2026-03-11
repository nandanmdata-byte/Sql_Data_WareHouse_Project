
# **Data Dictionary for Gold Layer**

<br>

## Overview
The **Gold Layer** provides a business-level data representation structured for **analytics** and **reporting**, utilizing **dimension** and **fact** tables to track key performance metrics.

### 1. gold.dim_customers
  -	**Purpose:** Contains comprehensive customer records enriched with demographic and geographic attributes.
  -	**Columns:** 

<br>

|Column Name	     |Data Type	                     |Description                                                                      |
|:---              |:---                           |:---                                                                             |
|customer_key	     |INT	                           |Unique Surrogate Key for each customer in the dimension table.                   |
|customer_id	     |INT                         	 |Unique numerical identifier assigned to each customer.                           |
|customer_number	 |NVARCHAR(50)	                 |Alphanumeric identifier for the customer, used for tracking and referencing.     |
|first_name	       |NVARCHAR(50)                 	 |First name of the customer, as per system records.                               |
|last_name	       |NVARCHAR(50)	                 |Last name or family name of the customer.                                        |
|country	         |NVARCHAR(50)		               |Country of residence of the customer(e.g., ‘Germany’).                           |
|marital_status	   |NVARCHAR(50)		               |The marital status of the customer (e.g., ‘Married, ‘Single, ‘Unknown’).         |
|gender	           |NVARCHAR(50)	                 |The gender of the customer (e.g., ‘Male’, ‘Female’, ‘Unknown’).                  |
|birth_date	       |DATE		                       |The date of birth of customer, in the format YYYY-MM-DD (e.g., !969-07-09).      |
|create_date	     |DATE	                         |The date when the customer record was created in the system.                     |
---


### 2. gold.dim_products
-	**Purpose:** Contains information about the products and their attributes.
-	**Columns:**

<br>

|Column Name	      |Data Type	               |Description                                                                                           |
|:---               |:---                      |:---                                                                                                  |
|product_key	      |INT	                     |Unique Surrogate Key for each product in the dimension table.                                         |
|product_id	        |INT	                     |Unique numerical identifier assigned to each product.                                                 |
|product_number   	|NVARCHAR(50)	             |A structured alphanumerical code for representing the product, used for categorization or inventory.  |
|product_name	      |NVARCHAR(50)	             |Descriptive name of the product, that includes details about type, color, and size.                   |
|category_id	      |NVARCHAR(50)	             |A unique identifier for product’s category, linking to it’s high – level classification.              |
|category	          |NVARCHAR(50)              |Broad classification of product (e.g., Bikes, Clothing) to group related items.                       |
|subcategory	      |NVARCHAR(50)	             |A more detailed classification of product within the category, such as the product type.              |
|maintenance	      |NVARCHAR(50)	             |Mentions if the product requires maintenance (e.g., ‘Yes’, ‘No’)                                      |
|product_cost	      |INT	                     |The cost  of the product (Monetary)                                                                   |
|product_line     	|NVARCHAR(50)	             |The specific product line or series to which the product actually belongs (e.g., Touring, Road).      |
|start_date	        |DATE	                     |The date when the product became available for sale or use.                                           |
---

<br>

### 3. gold.facts_sales
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:** 

<br>

|Column Name	    |Data Type	                   |Description                                                                                         |
|:---             |:---                          |:---                                                                                                |     
|order_number	    |NVARCHAR(50)	                 |Unique alphanumeric identifier for each sales order (e.g., ‘SO63684’).                              |
|product_key	    |INT	                         |Surrogate Key linking the order to the product dimension table.                                     |
|customer_key	    |INT	                         |Surrogate Key linking the order to the customer dimension table.                                    |
|order_date	      |DATE	                         |The date when the order was placed.                                                                 |
|shipping_date	  |DATE	                         |The date when the order was shipped to customer.                                                    |
|due_date       	|DATE	                         |The date when the order payment was due.                                                            |
|sales_amount	    |INT	                         |The total monetary value of sale for the line item, in whole currency units (e.g., 25).             |
|quantity	        |INT	                         |Number of units of products ordered for the line item (e.g., 2).                                    |
|price	          |INT	                         |The price per unit of the product for line item, in whole currency units (e.g., 25).                |
---

<br>


