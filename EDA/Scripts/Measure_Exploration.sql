USE EDA;

-- Find the total sales
SELECT SUM(sales_amount) as total_sales
FROM fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) as items_sold
FROM fact_sales;

-- Find the average of selling price
SELECT AVG(price) as average_price
FROM fact_sales;

-- Find the total number of orders
SELECT COUNT(order_number) as number_of_sales 
FROM fact_sales; -- 60398 ( same customer might order different things which same order number)

SELECT COUNT(DISTINCT order_number) as number_of_sales 
FROM fact_sales; -- 27659

-- Find total number of products
SELECT COUNT(product_key) as total_products 
FROM dim_products; -- 295

SELECT COUNT( DISTINCT product_key) as total_products 
FROM dim_products; -- 295

-- Find total number of customers
SELECT COUNT(customer_number) as total_customers 
FROM dim_customers;

--  Find the total number of customers that has placed order
SELECT COUNT( DISTINCT customer_key) as total_customers
FROm fact_sales;

-- Generate a report of all those metrics
-- In MySQL, INT is usually written as SIGNED when using CAST().
SELECT 'Total Sales' as measure_name, SUM(sales_amount) as measure_value FROM fact_sales
UNION ALL
SELECT 'Total Quantity' as measure_name ,SUM(quantity) as measure_value FROM fact_sales
UNION ALL
SELECT 'Average price' as measure_name ,CAST(AVG(price) as SIGNED) as measure_value FROM fact_sales
UNION ALL
SELECT 'Total Nr Orders' as measure_name ,COUNT(DISTINCT order_number) as measure_value FROM fact_sales
UNION ALL
SELECT 'Total Nr Products' as measure_name ,COUNT(product_name) as measure_value FROM dim_products
UNION ALL 
SELECT 'Total Nr Customers' as measure_name ,COUNT(customer_key) as measure_value FROM dim_customers;
