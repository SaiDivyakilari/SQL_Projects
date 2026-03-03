SELECT * FROM bronze.erp_cust_az12;
SELECT DISTINCT(gen) from bronze.erp_cust_az12;

/*
==================================================
SUBSTRING(column_name, start_position, length)
==================================================
*/
select
	CASE  
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,length(cid))
        ELSE cid
	END as cid
FROM bronze.erp_cust_az12;

SELECT DISTINCT(gen) as gender from bronze.erp_cust_az12;

SELECT 
    CASE
        WHEN gen LIKE '%F%' THEN 'Female'
        WHEN gen LIKE '%M%' THEN 'Male'
        ELSE 'n/a'
    END as gen
FROM bronze.erp_cust_az12;


SELECT 
	CASE
		WHEN bdate > CURDATE() THEN NULL 
        ELSE bdate
	END as bdate
FROM bronze.erp_cust_az12;

SELECT * from silver.erp_cust_az12;

