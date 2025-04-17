/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Segment products into cost ranges and count how many products fall into each segment
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

WITH product_segments AS
(
SELECT
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost BETWEEN 100 and 500 THEN '100-500'
	 WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END cost_range
FROM gold.dim_products
ORDER BY cost
)

SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*Group customers into segments based on their spending behavior:
	- VIP: customers with at least 12 months of history and spending more than 5000 euro
	- Regular: customers with at least 12 months of history and spending 5000 euro or less
	- New: customers with a lifespan less than 12 months
and find the total number of customers by each group*/
WITH customer_lifespan AS
(
SELECT 
c.customer_key,
SUM(s.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
(EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date))) * 12 +
  (EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date))) AS lifespan
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
customer_segment,
COUNT(customer_key) AS total_customers
FROM (
	SELECT 
	customer_key,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	 	 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	 	 ELSE 'New'
	END customer_segment
	FROM customer_lifespan) t
GROUP BY customer_segment
ORDER BY total_customers DESC;
