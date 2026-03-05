-- Joining crm_cust_info table, erp_cust_az12 and erp_loc_a101
-- Data validation checks : After joining the table ,check if any duplicates were introduced by the join logic
SELECT cst_id, COUNT(*)
FROM (
	SELECT 
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gender,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		cl.cntry
	FROM silver.crm_cust_info as ci
	LEFT JOIN silver.erp_cust_az12 as ca
	ON 		  ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 as cl
	ON 		  ci.cst_key = cl.cid ) t 
    
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check for Data Integration issues : there are two cols cst_gender and gen

SELECT DISTINCT 
	ci.cst_gender,
    ca.gen
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 as ca
ON 		  ci.cst_key = ca.cid;      

/* 
there are situations where one col value is male other one is female
In that case ask for the experst which is the master data : crm or erp

Master source for customer data is crm, crm are more accurate than erp
if crm valus is null then we get it from erp
there are cases when we join the table some of the erp values will be null since it is a Left join
In such cases give the gender value as null only 

COALESCE() is a SQL function that returns the first non-NULL value from a list of arguments.
*/

SELECT DISTINCT 
	ci.cst_gender,
    ca.gen,
    CASE 
		WHEN ci.cst_gender != 'n/a' THEN ci.cst_gender
        ELSE COALESCE(ca.gen,'n/a')
	END as new_gen
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 as ca
ON 		  ci.cst_key = ca.cid
ORDER BY cst_gender;

/* Give perper naming converntions and then proper order*/
/* check if this is a Fact or Dimension table*/

