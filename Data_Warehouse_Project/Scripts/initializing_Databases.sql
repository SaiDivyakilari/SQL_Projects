
/*
============================================
Create DataBase
============================================
Script purpose :
			This script create a Database named Data_Warehouse. Initially we drop the database if it already exists and then create
            a new database. We also create three databases 'Bronze','Silver','Gold' while checking if these databases exists or not
Warning :
		Running this script will delete the entire database if exists, all the data inside teh databse will get deleted
*/
            

DROP DATABASE IF EXISTS Data_Warehouse;
Create DATABASE Data_Warehouse;
USE Data_Warehouse;

-- In MySQL Schema=Database (wheras in SQL Server, inside the database we create Schemas which holds the tables of their own)
/*A schema is a logical container within a database used to organize objects such as tables, views, and procedures. 
It helps manage structure, security, and naming within a database.*/


CREATE SCHEMA Bronze;
CREATE DATABASE Silver;
CREATE DATABASE IF NOT EXISTS GOLD;
