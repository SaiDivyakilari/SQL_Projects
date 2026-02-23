/* Creating Databases while checking if they are exists or not */

Create DATABASE Data_Warehouse;
USE Data_Warehouse;

-- In MySQL Schema=Database (wheras in SQL Server, inside the database we create Schemas which holds the tables of their own)
/*A schema is a logical container within a database used to organize objects such as tables, views, and procedures. 
It helps manage structure, security, and naming within a database.*/

CREATE SCHEMA Bronze;
CREATE DATABASE Silver;
CREATE DATABASE IF NOT EXISTS GOLD;
