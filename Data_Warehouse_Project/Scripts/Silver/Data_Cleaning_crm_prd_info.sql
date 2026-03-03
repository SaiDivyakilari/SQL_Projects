USE bronze;
select * from crm_prd_info;

-- Checking for duplicates in prd_id Primary key column
SELECT prd_id,Count(*) as duplicate_id
FROM crm_prd_info
GROUP BY prd_id
HAVING count(*) > 1 OR prd_id IS NULL; -- there are no duplicate values

-- Deriving new columns
-- Getting the category id from the prd_key column this is we need to get similar as cat cplumn in erp_px_cat_g1v2 table
SELECT prd_key,SUBSTRING(prd_key,1,5) as cat_id
FROM crm_prd_info; -- since cat_id column is not present in DDL add this column to DDL

-- Replacing - to _ in cat column
SELECT prd_key, REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id
FROM crm_prd_info;

-- Extracting next part from the prd_key
SELECT prd_key, SUBSTRING(prd_key,7,length(prd_key)) as prd_key
FROM crm_prd_info
WHERE SUBSTRING(prd_key,7,length(prd_key)) NOT IN (
														SELECT sls_prd_key FROM crm_sales_details);
                                                        

-- Checking for unwanted spaces in product name column
SELECT prd_id, prd_nm
FROM crm_prd_info
WHERE prd_nm != TRIM(prd_nm); -- there are no unwanted spaces

-- Checking for NULL values in Cost column
SELECT prd_cost
FROM crm_prd_info
WHERE prd_cost < 0 or prd_cost IS NULL; -- there are no NULL values 

-- If there are NULL values then
SELECT prd_id,
		IFNULL(prd_cost,0) as prd_cost
FROM crm_prd_info;

-- Data Normalization for prd_line column
SELECT DISTINCT(prd_line) FROM crm_prd_info;
SELECT prd_id,
		CASE UPPER(TRIM(prd_line))
			WHEN 'R' THEN 'Road'
			WHEN 'M' THEN 'Mountain'
            WHEN 'S' THEN 'Other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'n/a'
		END as prd_line
FROM crm_prd_info;

-- Checking for Invalid Date orders
SELECT *
FROM crm_prd_info
WHERE prd_start_dt > prd_end_dt; -- start date should be less than the end date, but there are so many records which largest start date

/*
========================================================================================================================
In such cases :
Sol 1: 
1. we can switch start date and end date
 At the same time the ending date of first record in that group should be less than the start date of next record.
and Start date cannot be null.

Sol 2 :
1.Derive end date from the start date
Consider start date 
END date of current record = Start date of the next record - 1
Last records End date will be NULL

Try these techniques with one or two exampples
===========================================================================================================================
*/
/*
===========================================================================================
Data Enrichment : Add new, relevant data to enhance the dataset for analysis
==========================================================================================
*/

SELECT prd_id,prd_key,prd_nm,prd_start_dt,prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)- INTERVAL 1 DAY as prd_end_dt_test
FROM crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509');

-- Converting into Date instead of Datetime
SELECT prd_id,prd_key,prd_nm,
CAST(prd_start_dt as DATE) as prd_start_dt
FROM crm_prd_info;

SELECT * from silver.crm_prd_info;