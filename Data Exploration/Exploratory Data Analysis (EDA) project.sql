/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Explore All Objects in the Database
SELECT * FROM information_schema.tables;

-- Explore All Columns in the Database
SELECT * FROM information_schema.columns
WHERE table_name = 'dim_customers';

-- Explore Entire Content from Each Table;
SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
SELECT * FROM gold.fact_sales;