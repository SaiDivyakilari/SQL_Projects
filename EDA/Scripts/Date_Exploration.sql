

-- Find the date of first and last order
SELECT 
	MIN(order_date) as first_order_date,
    MAX(order_date) as last_order_date
FROM gold.fact_sales;

-- How many years of sales are available
SELECT
	MIN(order_date) as first_order_date,
    MAX(order_date) as last_order_date,
	TIMESTAMPDIFF(YEAR,MIN(order_date),MAX(order_date)) as sales_years,
    TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_date)) as sales_month
FROM gold.fact_sales;

-- Finding the oldest and youngest customer from the table
SELECT
	MIN(birthdate) as oldest_customer,
    TIMESTAMPDIFF(YEAR,MIN(birthdate),CURDATE()) as oldest_customer_age,
    MAX(birthdate) as youngest_customer,
    TIMESTAMPDIFF(YEAR,MAX(birthdate),CURDATE()) as youngest_customer_age
FROM gold.dim_customers;