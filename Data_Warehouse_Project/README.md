
# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics using MySQL.

---
##  Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into the MySQL database without transformation.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
##  Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**:Extracting, transforming, and loading data from source systems into MySQL warehouse layers.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

---

##  Important Links & Tools:

**Datasets**: Access project datasets (CSV files).
**MySQL Server**: Database engine used to host the data warehouse.
**MySQL Workbench**: GUI tool for database management, query execution, and modeling.
**Git Repository**: Version control and collaboration platform.

##  Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using MySQL to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  

##  Repository Structure
SQL_Projects/
└── Data_Warehouse_Projects/
    │
    ├── README.md
    │
    ├── datasets/
    │   ├── source_crm/
    │   │   ├── cust_info.xlsx
    │   │   ├── prd_info.xlsx
    │   │   └── sales_details.xlsx
    │   │
    │   └── source_erp/
    │       ├── CUST_AZ12.xlsx
    │       ├── LOC_A101.xlsx
    │       └── PX_CAT_G1V2.xlsx
    │
    └── scripts/
        ├── bronze/
        ├── silver/
        └── gold/


##  License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.


