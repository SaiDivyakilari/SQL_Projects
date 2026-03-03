/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL Silver.load_silver();
===============================================================================
*/

/*
================================================================================
Data Standardization and Normalization : Maps coded values to meaningful, user friendly descriptions
=================================================================================
*/

USE Silver;

DROP PROCEDURE IF EXISTS load_silver; -- Dropping if the procedure exists


DELIMITER $$

CREATE PROCEDURE load_silver() -- Creating a procedure
BEGIN

    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE batch_start_time DATETIME;
    DECLARE batch_end_time DATETIME;
	
    -- Starting the loading process into Silver layer
    SET batch_start_time = CURRENT_TIMESTAMP();
    
    -- Loading crm_cust_info  table into silver layer
    SET start_time = CURRENT_TIMESTAMP();

    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gender,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname, -- Removing the unwanted spaces
        TRIM(cst_lastname) AS cst_lastname, -- Removing  the unwanted spaces to ensure Data Consistency
        CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            ELSE 'n/a'
        END AS cst_marital_status, -- Normalize marital status values to readable format
        CASE
            WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
            ELSE 'n/a'
        END AS cst_gender, -- Normalize gender values to readable format 
        cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY cst_id 
                   ORDER BY cst_create_date DESC
               ) AS row_num
        FROM bronze.crm_cust_info
        WHERE cst_id > 0
    ) t
    WHERE t.row_num = 1; -- Removing duplicates and selecting most recent records

    SET end_time = CURRENT_TIMESTAMP(); -- ending the loading of cust info table
    
    SELECT 
		CONCAT( 'Time Taken for crm_cust_info table to load into Silver layer : ', TIMESTAMPDIFF(SECOND,end_time,start_time),' Seconds')
        as messages;
	
    -- Loading data into  silver.crm_prod_info 
    SET start_time = CURRENT_TIMESTAMP();
    
    TRUNCATE TABLE silver.crm_prd_info;
    
    INSERT INTO crm_prd_info(
		prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt)
	SELECT 
		prd_id,
        REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
        SUBSTRING(prd_key,7,LENGTH(prd_key)) as prd_key,
        TRIM(prd_nm) as prd_nm,
        IFNULL(prd_cost,0) as prd_cost,
        CASE TRIM(UPPER(prd_line))
				WHEN 'R' THEN 'Road'
				WHEN 'M' THEN 'Mountain'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
		END as prd_line,
        CAST(prd_start_dt as DATE) as prd_start_dt,
        CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL 1 DAY as DATE) as prd_end_dt
	FROM bronze.crm_prd_info;
    
    SET end_time = CURRENT_TIMESTAMP();
    
    SELECT
		CONCAT('Time taken to load Prdo_info cleaned data into silver layer : ',
				TIMESTAMPDIFF(SECOND,end_time,start_time),' Seconds') as messages;
	
    -- Inserting the data into silver.crm_sales_details
    
    SET start_time = current_timestamp();
    
    TRUNCATE TABLE silver.crm_sales_details;
    INSERT INTO silver.crm_sales_details(
		sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price)
	
    SELECT 
		sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE 
			WHEN sls_order_dt <= 0 THEN NULL
            ELSE CAST(sls_order_dt as DATE) 
		END as sls_order_dt,
        CASE
			WHEN sls_ship_dt <= 0 THEN NULL 
            ELSE CAST(sls_ship_dt as DATE)
		END as sls_ship_dt,
        CASE
			WHEN sls_due_dt <= 0 THEN NULL
            ELSE CAST(sls_due_dt AS DATE)
		END AS sls_due_dt,
        CASE
			WHEN sls_sales <= 0 OR sls_sales IS NULL  OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_sales = sls_quantity * ABS(sls_price)
            ELSE ABS(sls_sales)
		END AS sls_sales,
        sls_quantity,
        CASE
			WHEN sls_price <= 0 OR sls_price IS NULL 
				THEN sls_price = sls_sales / NULLIF(sls_quantity,0)
			ELSE ABS(sls_price)
		END AS sls_price
    FROM bronze.crm_sales_details;
    
    SET end_time = CURRENT_TIMESTAMP();
    
    SELECT 
		CONCAT('Time taken for cleaned data to load into silver.crm_sales_details : ',
				TIMESTAMPDIFF(SECOND,start_time,end_time),' Second') as messages;
	
    -- Insert into silver.erp_cust_az12 table
    
	SET start_time = CURRENT_TIMESTAMP();
    
    TRUNCATE TABLE silver.erp_cust_az12;
    INSERT INTO silver.erp_cust_az12(
		cid,
        bdate,
        gen)
    SELECT 
		CASE
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid)) -- Remove 'NAS' prefix if present
            ELSE cid
		END as cid,
        CASE
			WHEN bdate > CURDATE() THEN NULL
            ELSE bdate -- if birthdate is greater than todays date then we are making it t0 null
		END as bdate,  
		CASE
			WHEN gen LIKE '%F%' THEN 'Female'
			WHEN gen LIKE '%M%' THEN 'Male'
			ELSE 'n/a'
		END as gen
	FROM bronze.erp_cust_az12;
	
    SET end_time = current_timestamp();
	
    SELECT 
		CONCAT('Time taken for loading cleaned data into silver.erp_cust_az12 : ',
				TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') as messages;
	
    -- Inserting data into silver.erp_loc_a101
    -- \r is a carriage return character — it's an invisible control character with no visible appearance.
    TRUNCATE TABLE silver.erp_loc_a101;
    
    INSERT INTO silver.erp_loc_a101(
		cid,
		cntry)
    SELECT
		REPLACE(cid,'-','') as cid,
		CASE  
			WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
			WHEN UPPER(TRIM(REPLACE(cntry, '\r', ''))) LIKE 'US%' THEN 'United States'
			WHEN UPPER(TRIM(REPLACE(cntry, '\r', ''))) = 'DE' THEN 'Germany'
			ELSE TRIM(REPLACE(cntry, '\r', ''))
		END AS cntry_cleaned
	FROM bronze.erp_loc_a101;
    
    SET end_time = current_timestamp();
    
	SELECT 
		CONCAT('Time taken for loading cleaned data into silver.erp_cust_az12 : ',
				TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') as messages;
	
    -- Insert into table silver.erp_px_cat_g1v2
    SET start_time = CURRENT_TIMESTAMP();
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    
    INSERT INTO silver.erp_px_cat_g1v2(
		id,
        cat,
        subcat,
        maintenance)
	SELECT 
		id,
        TRIM(cat) as cat,
        TRIM(subcat) as subcat,
        CASE
			WHEN UPPER(TRIM(REPLACE(maintenance,'\r',''))) = 'YES' THEN 'Yes'
            ELSE TRIM(maintenance)
		END as maintenance
	FROM bronze.erp_px_cat_g1v2;
    
    SET end_time = CURRENT_TIMESTAMP();
	SELECT 
		CONCAT('Time taken for loading cleaned data into silver.erp_px_cat_g1v2 : ',
				TIMESTAMPDIFF(SECOND,start_time,end_time),' seconds') as messages;
                
    SET batch_end_time = CURRENT_TIMESTAMP();
    SELECT 
		CONCAT('Time taken for loading cleaned data into silver Database : ',
				TIMESTAMPDIFF(SECOND,batch_start_time,batch_end_time),' seconds') as messages;
    
END $$

DELIMITER ;
				
CALL load_silver();





							
                
            
        