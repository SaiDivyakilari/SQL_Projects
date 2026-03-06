#  SQL Exploratory Data Analysis (EDA) Project

##  Overview

This project performs a comprehensive **Exploratory Data Analysis (EDA)** on a sales data warehouse using MySQL. The data was sourced from a **Data Warehouse project** built across Bronze → Silver → Gold layers, and this EDA queries the clean Gold layer to extract meaningful business insights.

---

##  Data Source

The dataset originates from a **Data Warehouse pipeline** with the following architecture:

```
Bronze Layer  →  Silver Layer  →  Gold Layer
(Raw Data)       (Cleaned Data)    (Business-Ready)
```

The Gold layer exposes three core tables used in this analysis:

| Table | Description |
|---|---|
| `gold.dim_customers` | Customer dimension — demographics, country, birthdate |
| `gold.dim_products` | Product dimension — category, subcategory, cost, product line |
| `gold.fact_sales` | Sales fact table — orders, revenue, quantity, dates |

---

##  Project Structure

```
 SQL-EDA-Project
 ┣ 📄 DDL_EDA.sql               # Database setup, table creation, data loading procedure
 ┣ 📄 Database_Exploration.sql  # Schema exploration using INFORMATION_SCHEMA
 ┣ 📄 Dimension_Exploration.sql # Exploring unique values in dimension tables
 ┣ 📄 Measure_Exploration.sql   # Key business metrics (sales, orders, customers)
 ┣ 📄 Date_Exploration.sql      # Date ranges, sales years, customer ages
 ┣ 📄 Magnitude_Analysis.sql    # Aggregations by country, gender, category
 ┣ 📄 Ranking_Analysis.sql      # Top/bottom products and customers by revenue
 ┗ 📄 README.md
```

---

##  Analysis Performed

### 1. Database Exploration
- Explored schema metadata using `INFORMATION_SCHEMA`
- Identified all tables and columns in the EDA database

### 2. Dimension Exploration
- Unique countries from customer dimension
- Unique product categories, subcategories, and product names

### 3. Measure Exploration
- Total sales revenue
- Total items sold
- Average selling price
- Total number of orders (distinct)
- Total number of products and customers
- Combined metrics report using `UNION ALL`

### 4. Date Exploration
- First and last order dates
- Total years and months of sales data using `TIMESTAMPDIFF()`
- Oldest and youngest customer ages using `CURDATE()`

### 5. Magnitude Analysis
- Total customers by country and gender
- Total products by category
- Average cost per category
- Total revenue by category and customer
- Distribution of sold items across countries

### 6. Ranking Analysis
- Top 5 products by highest revenue (using `ROW_NUMBER()` + CTE)
- Bottom 5 worst-performing products
- Top 10 customers by revenue (using `RANK()` + CTE)
- 3 customers with fewest orders

---

##  Key SQL Concepts Used

| Concept | Usage |
|---|---|
| `TIMESTAMPDIFF()` | Calculating date differences in years/months |
| `Window Functions` | `RANK()`, `ROW_NUMBER()` for ranking analysis |
| `CTEs` | Clean, readable multi-step queries |
| `UNION ALL` | Combining metrics into a single report |
| `GROUP BY` + `HAVING` | Aggregations with filters |
| `LEFT JOIN` | Combining fact and dimension tables |
| `INFORMATION_SCHEMA` | Database/schema metadata exploration |
| `Stored Procedure` | Automated data loading with `CALL load_eda()` |

---

##  Setup & Usage

### Prerequisites
- MySQL Workbench or any MySQL 8.0+ client
- Access to the Gold layer tables from the Data Warehouse project

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/your-username/sql-eda-project.git
```

2. **Run DDL script first** to create the EDA database and load data
```sql
SOURCE DDL_EDA.sql;
```

3. **Run analysis scripts** in any order
```sql
SOURCE Measure_Exploration.sql;
SOURCE Date_Exploration.sql;
-- etc.
```

---

##  Sample Insights

- Sales data spans **3+ years** (2010 to 2014)
- Customers are spread across multiple countries including **United States, Australia, Canada, United Kingdom, France, and Germany**
- Products are organized across multiple **categories and subcategories**
- Top customers and products identified by revenue using window functions

---

##  Related Project

This EDA is built on top of a **Data Warehouse project** that handles:
- Raw data ingestion into the Bronze layer
- Data cleaning and transformation into the Silver layer  
- Business-ready star schema in the Gold layer

---


**Your Name**  
[GitHub](https://github.com/your-username) · [LinkedIn](https://linkedin.com/in/your-profile)
