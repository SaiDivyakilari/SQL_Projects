-- Unique countries from the customer dimension table
USE EDA;
SELECT DISTINCT(country) 
FROM dim_customers;

-- Unique categories from product dimension table
SELECT DISTINCT category
FROM dim_products;

SELECT DISTINCT category,subcategory,product_name
FROM dim_products;