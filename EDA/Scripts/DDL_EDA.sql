CREATE DATABASE EDA;

USE EDA;

DROP TABLE IF EXISTS eda.dim_customers;
CREATE TABLE eda.dim_customers(
	customer_key int,
	customer_id int,
	customer_number varchar(50),
	first_name varchar(50),
	last_name varchar(50),
	country varchar(50),
	marital_status varchar(50),
	gender varchar(50),
	birthdate date,
	create_date date
);

DROP TABLE IF EXISTS eda.dim_products;
CREATE TABLE eda.dim_products(
	product_key int ,
	product_id int ,
	product_number varchar(50) ,
	product_name varchar(50) ,
	category_id varchar(50) ,
	category varchar(50) ,
	subcategory varchar(50) ,
	maintenance varchar(50) ,
	cost int,
	product_line varchar(50),
	start_date date 
);

DROP TABLE IF EXISTS eda.fact_sales;
CREATE TABLE eda.fact_sales(
	order_number varchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity int,
	price int 
);

-- Loading data into tables

DROP  PROCEDURE IF EXISTS load_eda;
DELIMITER $$

CREATE PROCEDURE load_eda()
BEGIN
	TRUNCATE TABLE eda.dim_customers;
	INSERT INTO eda.dim_customers(
	customer_key,
	customer_id,
	customer_number,
	first_name,
	last_name,
	country,
	marital_status,
	gender,
	birthdate,
	create_date)
	SELECT * FROM gold.dim_customers;

	TRUNCATE TABLE eda.dim_products;
	INSERT INTO eda.dim_products(
	product_key,
	product_id,
	product_number,
	product_name,
	category_id,
	category,
	subcategory,
	maintenance,
	cost,
	product_line,
	start_date)
	SELECT * FROM gold.dim_products;

	TRUNCATE TABLE eda.fact_sales;
	INSERT INTO eda.fact_sales(
	order_number,
	product_key,
	customer_key,
	order_date,
	shipping_date,
	due_date,
	sales_amount,
	quantity,
	price)
	SELECT * FROM gold.fact_sales;

END $$
DELIMITER ;

CALL load_eda();

