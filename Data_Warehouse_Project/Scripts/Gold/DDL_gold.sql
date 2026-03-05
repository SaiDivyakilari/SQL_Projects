

/*
A view is a saved SQL query that acts like a virtual table —
it has no data of its own, it just stores the query and runs it when you call it.
*/
USE gold;

DROP VIEW IF EXISTS gold.dim_customers;
CREATE VIEW gold.dim_customers as
/*
-- This is a Dimension table since it holds descriptive info
-- we need a primary key for the dimension table
we need to generate a primary key in data warehouse which is 
Surrogate key - System generated unique identifier assigned to each record in table
used only to join table
*/
	SELECT
		ROW_NUMBER() OVER (ORDER BY ci.cst_id) as customer_key, -- Surrogate key
		ci.cst_id as customer_id,
		ci.cst_key as customer_number,
		ci.cst_firstname as first_name,
		ci.cst_lastname as last_name ,
		cl.cntry as country,
		ci.cst_marital_status as marital_status,
		CASE 
			WHEN ci.cst_gender != 'n/a' THEN cst_gender -- CRM is the Master key
			ELSE COALESCE(ca.gen, 'n/a') 
		END as gender,
		ca.bdate as birthdate,
		ci.cst_create_date as  create_date
		FROM silver.crm_cust_info as ci
		LEFT JOIN silver.erp_cust_az12 as ca
		ON 			ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 as cl
		ON 			ci.cst_key = cl.cid;

SELECT * from gold.dim_customers; -- we can get the date from the view 



-- check for duplicates using prd_key
-- This is a Dimension table so create a primary key i.e surrogate key

DROP VIEW IF EXISTS gold.dim_products;
CREATE VIEW gold.dim_products as 
SELECT
	ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt , pd.prd_key) as product_number,
	pd.prd_id as product_id,
	pd.prd_key as product_key,
	pd.prd_nm as product_name,
    pd.cat_id as category_id,
	pc.cat as category,
    pc.subcat as subcategory,
	pc.maintenance,
    pd.prd_cost as product_cost,
    pd.prd_line as product_line,
    pd.prd_start_dt as start_date
FROM silver.crm_prd_info as pd
LEFT JOIN  silver.erp_px_cat_g1v2 as pc -- we are using left join since CRM data is master data
ON 			pd.cat_id = pc.id
WHERE pd.prd_end_dt IS NULL; -- getting only the current data (removing the historic data)

SELECT * FROM gold.dim_products;

-- This is a Fact table( it has Keys, Dates,Measures)
-- Use the dimension's surrogate key instead of ID to easily connect facts with dimensions
DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales as
SELECT
	sd.sls_ord_num as order_number,
    pr.product_number,
    cd.customer_key,
    sd.sls_ship_dt as shipping_date,
    sd.sls_order_dt as order_date,
    sd.sls_due_dt as due_date,
    sd.sls_sales as sales,
    sd.sls_quantity as quantity,
    sd.sls_price as price
FROM silver.crm_sales_details as sd
LEFT JOIN gold.dim_products as pr
ON sd.sls_prd_key = pr.product_key
LEFT JOIN gold.dim_customers as cd
ON sd.sls_cust_id = cd.customer_id;

SELECT * FROM gold.fact_sales;

-- Fact check : check if all the dimension tables can successfully join to the fact table
-- Foreign key constraint (Dimensions)
SELECT *
FROM gold.fact_sales as fs
LEFT JOIN gold.dim_customers as cd
ON fs.customer_key = cd.customer_key
WHERE cd.customer_key IS NULL; -- Zero records

SELECT * 
FROM gold.fact_sales as sf
LEFT JOIN gold.dim_products as pd
ON sf.product_number = pd.product_number
WHERE pd.product_number IS NULL; -- Zero records
