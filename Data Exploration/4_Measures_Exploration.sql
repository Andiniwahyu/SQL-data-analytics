/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Calculate the total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- How many items have been sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Calculate the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- Calculate the total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Calculate the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products;
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products;

-- Calculate the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Calculate the total number of customers who have placed a order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Generate a report that shows all key metrics
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Avg Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Num Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Num Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Num Customers', COUNT(DISTINCT customer_key) FROM gold.fact_sales;

