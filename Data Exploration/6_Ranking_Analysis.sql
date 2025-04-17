/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Top 10 Products By Total Sales
SELECT 
p.product_name,
SUM(s.sales_amount) AS total_sales,
category
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY 
p.product_key
ORDER BY total_sales DESC
LIMIT 10;

-- Bottom 5 Products By Sales
SELECT 
p.product_name,
SUM(s.sales_amount) AS total_sales,
category
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY 
p.product_key
ORDER BY total_sales
LIMIT 10;

-- Bottom 3 Categories by revenue
SELECT 
p.category,
SUM(s.sales_amount) AS revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY 
p.category
ORDER BY revenue DESC
LIMIT 3;
