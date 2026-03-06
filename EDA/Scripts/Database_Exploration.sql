
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA NOT IN ('mysql','performance_schema','information_schema','sys');

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA NOT IN ('mysql','performance_schema','information_schema','sys') 
AND TABLE_NAME = 'dim_customers';