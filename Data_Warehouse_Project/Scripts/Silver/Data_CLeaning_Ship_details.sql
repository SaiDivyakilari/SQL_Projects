Select * from bronze.crm_sales_details;
/* Prd_key and cust_id should match with the prd_key and cust_id with other tables*/
/*checking if the product key are present in crm_prd_info table*/

select * from bronze.crm_sales_details 
where sls_prd_key NOT IN (select prd_key from silver.crm_prd_info); -- All the pro_keys are present in crm_prd_info

select * from bronze.crm_sales_details 
where sls_cust_id NOT IN (select cst_id from silver.crm_cust_info); -- All the cst_id's are present in cmr_cust_info

-- Changing the type of Date column
SELECT CAST(sls_order_dt as Date) as sls_order_dt
FROM bronze.crm_sales_details;

-- Checking for invalid Dates
Select sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0;

-- Changing 0 values to NULL
/* since it is already in date format we don't check for length(sls_order_dt) != 8*/
 
select NULLIF(sls_order_dt,0) as sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 OR sls_order_dt > '2050-01-01' OR sls_order_dt < '1900-01-01';

/* if the Date is given as INT type first we need to cast it as VARCHAR and then to date*/
SELECT 
CASE 
	WHEN sls_order_dt <= 0 THEN NULL 
    ELSE CAST(sls_order_dt as DATE)
END as sls_order_dt
FROM bronze.crm_sales_details;

-- Invalid date orders
-- order date should be less than ship date and due date
SELECT sls_order_dt,sls_ship_dt,sls_due_dt
FROM crm_sales_details
where sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt ; -- there are no records 

/*
=============================================================================
Check for Data Consistency
Business Rules :
sales = Quantity * Price
-No negative, Zeroes or NULL values are allowed

Data issues like these 
SOL 1: will be fixed direct in source system
SOL 2 : Data is fixed in data warehouse
===============================================================================
*/

SELECT sls_sales,sls_quantity,sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR sls_sales <= 0 OR 
sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price;

SELECT 
CASE 
	When sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_sales = sls_quantity * ABS(sls_price)
    ELSE ABS(sls_sales)
END as sls_sales,
sls_quantity,sls_price
FROM bronze.crm_sales_details;

SELECT 
CASE 
	when sls_price <= 0 OR sls_price IS NULL THEN sls_price = sls_sales / NULLIF(sls_quantity,0)
    ELSE ABS(sls_price)
END as sls_price
FROM bronze.crm_sales_details;

