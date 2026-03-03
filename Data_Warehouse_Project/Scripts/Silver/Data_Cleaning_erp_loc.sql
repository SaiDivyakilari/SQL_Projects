SELECT * from bronze.erp_loc_a101;
SELECT DISTINCT(cntry) from bronze.erp_loc_a101;

/*
============================================================
\r is a carriage return character — it's an invisible control character with no visible appearance.
============================================================
*/

SELECT 
    CASE  
        WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
        WHEN UPPER(TRIM(REPLACE(cntry, '\r', ''))) LIKE 'US%' THEN 'United States'
        WHEN UPPER(TRIM(REPLACE(cntry, '\r', ''))) = 'DE' THEN 'Germany'
        ELSE TRIM(REPLACE(cntry, '\r', ''))
    END AS cntry_cleaned
FROM bronze.erp_loc_a101;

SELECT
	REPLACE(cid,'-','') as cid
FROM bronze.erp_loc_a101;

SELECT DISTINCT(cntry) from silver.erp_loc_a101;
SELECT * from silver.erp_loc_a101;
