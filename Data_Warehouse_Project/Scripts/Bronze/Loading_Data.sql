
SHOW VARIABLES LIKE 'local_infile';
USE bronze;

/* 
Bulk inserting data into the tables
Here we are performing full load 
Truncate and Insert

We cannot create Stored procedure here because LOAD DATA LOCAL INFILE is not allowed in stored procedures
because Stored procedures executed on Server and LOCAL INFILE reads files from the client machine
MYSQL blocks this combination
*/

TRUNCATE TABLE crm_cust_info;
LOAD DATA LOCAL INFILE 'C:/Users/kilar/OneDrive/Desktop/SQl Projects/Data Warehouse Project/datasets/source_crm/cust_info_csv.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(cst_id, cst_key, cst_firstname, cst_lastname,
 cst_marital_status, cst_gender, @cst_create_date)
SET cst_create_date = STR_TO_DATE(@cst_create_date, '%m/%d/%Y');

/*
=======================================================================================
-- STR_TO_DATE()
-- Converts a string into a DATE/DATETIME value using a specified format pattern.
-- Used when loading text-based dates (like from CSV/Excel) into DATE columns.

-- Example:
-- STR_TO_DATE('02/23/2026', '%m/%d/%Y')
-- Converts '02/23/2026' → 2026-02-23

-- @variable (User-Defined Variable in LOAD DATA)
-- The @ symbol creates a temporary variable.
-- Used to first capture raw text from a file before transforming it.
-- Commonly used in LOAD DATA to clean/convert values before inserting into table columns.

-- Example:
-- @cst_create_date captures raw string from CSV
-- Then converted using STR_TO_DATE before storing in DATE column
==================================================================================================
*/

TRUNCATE TABLE crm_prd_info;
LOAD DATA LOCAL INFILE 'C:/Users/kilar/OneDrive/Desktop/SQl Projects/Data Warehouse Project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt);

TRUNCATE TABLE crm_sales_details;
LOAD DATA LOCAL INFILE 'C:/Users/kilar/OneDrive/Desktop/SQl Projects/Data Warehouse Project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price);

TRUNCATE TABLE erp_cust_az12;
LOAD DATA LOCAL INFILE 'C:/Users/kilar/OneDrive/Desktop/SQl Projects/Data Warehouse Project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(cid,bdate,gen);

TRUNCATE TABLE erp_loc_a101;
LOAD DATA LOCAL INFILE 'C:/Users/kilar/OneDrive/Desktop/SQl Projects/Data Warehouse Project/datasets/source_erp/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(cid,cntry);

TRUNCATE TABLE erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE 'C:/Users/kilar/OneDrive/Desktop/SQl Projects/Data Warehouse Project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id,cat,subcat,maintenance);
