
# **Sql Data Warehouse and Analytics Project**

Welcome to the **Sql Data Warehouse and Analytics Project** repository!  
A comprehensive portfolio project implementing a scalable data warehouse to transform raw data into strategic insights. This repository highlights professional-grade data engineering workflows, including schema design, data transformation, and advanced analytics.

<br>

## Project Requirements

### Data Warehouse Construction (Data Engineering)

#### Objective
Build a modern data warehouse using SQL Server to centralize sales data, streamlining analytical reporting to empower the business with advanced analytics and actionable insights.

#### Specifications

- **Data Sources**: Import raw datasets from two distinct source systems ( CRM and ERP ) provided in CSV format
- **Medallion Architecture**: Implement a structured data pipeline:
  - **Bronze**: Raw data ingestion.
  - **Silver**: Data cleansing, deduplication, and standardization.
  - **Gold**: Business-ready dimensional modeling.
- **Data Integrity**: Execute pre-analysis cleaning to resolve data type mismatches, missing values, and referential integrity issues.
- **Data Integration**: Ingest and consolidate datasets from both source systems into a single, user-friendly data model designed for analytical queries.
- **Project Scope**: This project focuses on current-state reporting; data historization is not required.
- **Documentation**: Maintain a proper, comprehensive technical documentation and schema diagrams to bridge the gap between technical logic and business needs.

<br>

---

### **Data Architecture & Pipeline**

The project follows a **Medallion Architecture** to ensure data quality and separation of concerns:

```text
[ Raw Data ]       [ Bronze Layer ]       [ Silver Layer ]       [ Gold Layer ]
 (CSV Files)  -->     (Staging)      -->  (Cleaned/Typed)  -->  (Star Schema)

      |                   |                      |                     |
   CRM & ERP        Raw Ingestion          Deduplication           Fact & Dim
    Sources                                 & Validation             Tables

```
<br>

---

### BI : Analytics & Reporting ( Data Analytics )

Leverage the **Gold Layer** to execute advanced SQL analytics, providing a clear view of business operations:
- **Customer behaviour**: Analyze purchasing patterns, retention rates, and high-value customer segments.
- **Product Performance**: Evaluate revenue contribution,  top-performing product categories/product lines etc.
- **Sales trends**: Compare year-over-year (YoY) growth and regional performance metrics.

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

<br>

## Tech Stack & Tools
- **Database Engine**: Microsoft SQL Server (Data Warehousing & Processing)
- **IDE / SQL Client**: SQL Server Management Studio (SSMS) & VS Code
- **Version Control**: Git & GitHub (Code management and documentation)
- **Project Management**: Notion (Task tracking and schema design)
- **Research & Documentation**: Google / Technical Documentation

<br>

## About me

Hello there. I'm Nandan M, an M.Sc. Physics graduate transitioning into Data Analytics. My background in physics has equipped me with strong analytical thinking and a passion for solving complex problems through data.
<br>

---

## **License**
This project is licensed under the **MIT License**. You are free to use, modify, and distribute this code for personal or commercial purposes. See the [LICENSE](LICENSE) file for more details.

<br>

## **Contact**
If you have any questions, feedback, suggestions or would like to discuss this project, feel free to reach out:

- **Email**: [nandan.m.data@gmail.com](mailto:nandan.m.data@gmail.com)

