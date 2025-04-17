/*======================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
=======================
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

DROP DATABASE IF EXISTS datawarehouseanalytics;
CREATE DATABASE datawarehouseanalytics;

-- 1. Create Schema
CREATE SCHEMA gold;

-- 2. Create Table dim_customers
CREATE TABLE gold.dim_customers (
    customer_key INT PRIMARY KEY,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

-- 3. Create Table dim_products
CREATE TABLE gold.dim_products (
    product_key INT PRIMARY KEY,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

-- 4. Create Table fact_sales
CREATE TABLE gold.fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity SMALLINT,
    price INT,
    FOREIGN KEY (product_key) REFERENCES gold.dim_products(product_key),
    FOREIGN KEY (customer_key) REFERENCES gold.dim_customers(customer_key)
);

-- 5. Delete Data Before Import (If you want to restart)
TRUNCATE TABLE gold.dim_products CASCADE;
TRUNCATE TABLE gold.fact_sales, gold.dim_customers CASCADE;

-- 6. Import Data from CSV (Change the path according to the file location on your computer)
COPY gold.dim_customers
FROM '/Users/mac/Downloads/sql-data-analytics-project/datasets/csv-files/gold.dim_customers.csv'  -- Adjust the CSV file path
DELIMITER ','
CSV HEADER;

COPY gold.dim_products
FROM '/Users/mac/Downloads/sql-data-analytics-project/datasets/csv-files/gold.dim_products.csv'  -- Adjust the CSV file path
DELIMITER ','
CSV HEADER;

COPY gold.fact_sales
FROM '/Users/mac/Downloads/sql-data-analytics-project/datasets/csv-files/gold.fact_sales.csv'  -- Adjust the CSV file path
DELIMITER ','
CSV HEADER;