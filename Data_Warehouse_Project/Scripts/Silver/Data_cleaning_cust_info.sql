-- Check for Null Values or Duplicates in Primary key
USE bronze;

SELECT * FROM crm_cust_info;

/* Checking for NULL values */
SELECT cst_id, count(*) as count_cst_id
FROM crm_cust_info
GROUP BY cst_id
HAVING count(*) > 1 OR cst_id IS NULL;

/*
======================================================
After executing above query we got
29433,29449,29466,29473,29483
these have duplicate values and there are 4 Null values
======================================================
*/

/* We used ranking function to give row_numbers to all the rows and
- Assign row numbers within each cst_id group (latest record gets row_num = 1)
 -- Keep only the most recent record per cst_id */

SELECT *
FROM (
		SELECT *,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as row_num
		FROM crm_cust_info 
        WHERE cst_id > 0)t # every derived query must have alias so we put t
WHERE row_num = 1;

/*Checking for unwanted spaces in first and last names (we can check for all the string values)*/
/* check if the orginal name is euqual to name after removing trailing spaces*/

SELECT cst_firstname
FROM crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

/* we can also update the string columns*/
UPDATE crm_cust_info
SET cst_firstname = trim(cst_firstname),
	cst_lastname = trim(cst_lastname);

/* So while selecting the columns we select by trimming the spaces*/
SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	cst_marital_status,
	cst_gender,
	cst_create_date
FROM (
		SELECT *,
				row_number() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_num
		FROM crm_cust_info
        WHERE cst_id <> 0) t
	WHERE row_num = 1;

/* Checking for any unique values Data Standardization and Consistency*/
SELECT DISTINCT cst_gender
FROM crm_cust_info;

UPDATE crm_cust_info
SET cst_gender = 
		CASE 
			WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
            ELSE 'n/a'
		END;
   
SELECT DISTINCT cst_marital_status
FROM crm_cust_info;

UPDATE crm_cust_info
SET cst_marital_status = 
	CASE
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
	END;



            




