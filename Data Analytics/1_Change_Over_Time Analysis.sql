/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: EXTRACT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Change Over Years
SELECT
EXTRACT(YEAR FROM order_date) as order_year,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;

-- Changes Over Months on Specific Year
SELECT
EXTRACT(YEAR FROM order_date) as order_year,
EXTRACT(MONTH FROM order_date) as order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- or
SELECT
EXTRACT(MONTH FROM order_date) as order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL AND EXTRACT(YEAR FROM order_date) = 2011
GROUP BY order_month
ORDER BY order_month;


