-- Which 5 products generate the Highest revenue
USE EDA ;

/*
Problem 1 — PARTITION BY is wrong
You're partitioning by product_name which creates a separate rank for each product individually 
— so every product gets rank 1. You want to rank across all products, so remove the PARTITION BY.
Problem 2 — RANK() with GROUP BY
Window functions run after GROUP BY, so you need to wrap it in a subquery or CTE.
*/
/* 
=====================================================================================
SELECT
	pd.product_name,
    RANK() OVER (PARTITION BY pd.product_name ORDER BY SUM(sf.sales_amount)) as rank_number,
    SUM(sf.sales_amount) as total_revenue
FROM dim_products as pd
LEFT JOIN fact_sales as sf
ON pd.product_key = sf.product_key
GROUP BY pd.product_name
LIMIT 5;
===========================================================================================
*/

WITH revenue_summary AS(
		SELECT
			pd.product_name,
            sum(sf.sales_amount) as total_revenue
		FROM dim_products as pd
        LEFT JOIN fact_sales as sf
        ON pd.product_key = sf.product_key
        GROUP BY pd.product_name
        )
SELECT 
	product_name,
    total_revenue,
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) as rank_number
FROM revenue_summary
LIMIT 5;
    
-- What are 5 worst performing products in terms of sales

		SELECT
			pd.product_name,
            sum(sf.sales_amount) as total_revenue
		FROM dim_products as pd
        LEFT JOIN fact_sales as sf
        ON pd.product_key = sf.product_key
        GROUP BY pd.product_name
        HAVING sum(sf.sales_amount) > 0
        ORDER BY total_revenue
        LIMIT 5;
        
	-- similarly we can find for category and subcategory
    
    -- Find top 10 customers with highest revenue 

WITH cust_revenue AS(
	SELECT
		cd.customer_number,
        cd.first_name,
        cd.last_name,
        SUM(sf.sales_amount) as total_revenue
		FROM dim_customers as cd
        LEFT JOIN fact_sales as sf
        ON cd.customer_key = sf.customer_key
        GROUP BY cd.customer_number, cd.first_name,cd.last_name
        )
	
SELECT
	customer_number,
    first_name,
    last_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) as rank_number
FROM cust_revenue
LIMIT 10;

-- 3 least customers who places less orders
WITH cust_revenue AS(
	SELECT
		cd.customer_number,
        cd.first_name,
        cd.last_name,
        COUNT(DISTINCT sf.order_number) as total_orders
		FROM dim_customers as cd
        LEFT JOIN fact_sales as sf
        ON cd.customer_key = sf.customer_key
        GROUP BY cd.customer_number, cd.first_name,cd.last_name
        )
	
SELECT
	customer_number,
    first_name,
    last_name,
    total_orders,
    RANK() OVER (ORDER BY total_orders ASC) as rank_number
FROM cust_revenue
LIMIT 3;
        
    