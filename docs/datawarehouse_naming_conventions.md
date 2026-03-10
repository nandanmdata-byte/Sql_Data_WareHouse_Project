
# **Naming Convensions**

The purpose of this document is to declare the naming conventions used for creating  schemas, columns, tables, views, and other objects in the data warehouse.

## **Table of Contents**

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Layer Rules](#bronze-layer-rules)
   - [Silver Layer Rules](#silver-layer-rules)
   - [Gold Layer Rules](#gold-layer-rules)
3. [Schemas](#schemas)
4. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
5. [Stored Procedure](#stored-procedure)

---

## **General Principles** 

- **Naming Conventions**: Use snake_case, with lowercase letters and underscores (`_`) to separate words. E.g.,'customer_key'.
- **Language**: Use ***English*** for all names.
- **Avoid Reserved Words**: Do not use SQL reserved words as object names.

## **Table Naming Conventions** 

### **Bronze Layer Rules** 
- All names in bronze layer must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**  
  - **`<sourcesystem>`:** Name of the source system (e.g., `crm`, `erp`).  
  - **`<entity>`:** Exact table name from the source system.  
  - **Example:** `crm_customer_info` → Customer information from the CRM system.

### **Silver Layer Rules**
- Same as bronze. All names in silver layer must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**  
  - **`<sourcesystem>`:** Name of the source system (e.g., `crm`, `erp`).  
  - **`<entity>`:** Exact table name from the source system.  
  - **Example:** `crm_sales_details` → Sales details from the CRM system.

### **Gold Layer Rules**
- All names must use meaningful, business-aligned names for tables ( must match with info inside the table ), starting with the table category prefix.
- **`<category>_<entity>`**  
  - **`<category>`:** Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).  
  - **`<entity>`:** Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).  
  - **Examples:**
    - `dim_customers` → Dimension table for customer data.  
    - `fact_sales` → Fact table containing sales transactions.  

#### **Glossary of Category Patterns**

| Pattern     | Meaning                           | Example(s)                              |
|-------------|-----------------------------------|-----------------------------------------|
| `dim_`      | Dimension table                   | `dim_customer`, `dim_product`           |
| `fact_`     | Fact table                        | `fact_sales`                            |
| `agg_`      | Aggregated table                  | `agg_customers`, `agg_sales_monthly`    |

## **Schemas**

Schemas are used to logically separate data layers and manage access control. Each object must reside in a schema named after its corresponding Medallion layer.- **`<layer>.<object_name>`**
  - **`<layer>`:** The specific data tier ( *bronze*, *silver*, or *gold* ).
  - **`<object_name>`:** The table or view name, following the layer-specific naming rules.  
  - **Examples:**
  
|Layer	      |Full Object Path	                  |Description                              |
|-------------|-----------------------------------|-----------------------------------------|
|Bronze	      |bronze.crm_sales_details	          |Raw sales data from the CRM system.      |
|Silver	      |silver.crm_sales	                  |Cleaned and standardized sales data.     |
|Gold	        |gold.fact_sales	                  |Business-ready fact table for reporting. |

## **Column Naming Conventions**

### **Surrogate Keys**  

- All primary keys in dimension tables must use the suffix `_key`.
- **`<table_name>_key`**  
  - **`<table_name>`:** Refers to the name of the table or entity the key belongs to.  
  - **`_key`:** A suffix indicating that this column is a surrogate key.  
  - **Example:** `customer_key` → Surrogate key in the `dim_customers` table.
  
### **Technical Columns**

- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- **`dwh_<column_name>`**  
  - **`dwh`:** Prefix exclusively for system-generated metadata.  
  - **`<column_name>`:** Descriptive name indicating the column's purpose.  
  - **Example:** `dwh_load_date` → System-generated column used to store the date when the record was loaded.
 
## **Stored Procedure**

- All stored procedures used for loading data must follow the naming pattern:
- **`load_<layer>`**.
  
  - **`<layer>`:** Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - **Example:** 
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.

