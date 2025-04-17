/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Analyze the yearly performance of products by comparing their sales to both 
the average sales performance of the product and the previous yeear's sales 
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

WITH yearly_product_sales AS
(
SELECT
EXTRACT(YEAR FROM s.order_date) AS order_year,
p.product_name,
SUM(sales_amount) AS current_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
GROUP BY order_year, p.product_name
) 

SELECT 
order_year,
product_name,
current_sales,
ROUND(AVG(current_sales) OVER (PARTITION BY product_name),0) AS avg_sales,
ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name),0) diff_avg,
CASE WHEN ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name),0) > 0 THEN 'Above Avg'
	 WHEN ROUND(current_sales - AVG(current_sales) OVER (PARTITION BY product_name),0) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END avg_change,
--Year-over-year analysis:
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No change'
END py_change
FROM
yearly_product_sales
ORDER BY product_name, order_year;