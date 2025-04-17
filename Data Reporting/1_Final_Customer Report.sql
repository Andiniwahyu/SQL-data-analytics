/*
===============================================================================
Customer Report
===============================================================================
Purpose:
	- This report brings together important information about key customer metrics and behaviors
Highlights:
	1. Collects important details like customer names, ages, and their transaction history
	2. Aggregates key metrics for each customer:
		- number or orders
		- total sales
		- total items purchased
		- number of different products
		- lifespan (in months)
	3. Groups customers into categories (VIP, Regular, New) and by age group
	4. Calculates valuable KPIs:
		- Recency - how many months since their last order
		- Average Order Value - how much they usually spend per order
		- Average Monthly Spend - how much they spend on average each month
===============================================================================
*/

/*------------------------------------------------------------
	Create Report: gold.report_customers
------------------------------------------------------------*/
CREATE VIEW gold.report_customers AS
/*------------------------------------------------------------
	1) Base Query: selects core columns from tables           
------------------------------------------------------------*/
WITH base_query AS
(
SELECT 
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	EXTRACT(year FROM AGE(CURRENT_DATE, birthdate)) AS age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
)

/*--------------------------------------------------------------------------
	2) Customer Aggregations: summarizes key metrics at the customer lever          
----------------------------------------------------------------------------*/
, customer_aggregations AS
(
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	(EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date))) * 12 +
  (EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date))) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)

/*------------------------------------------------------------
	3) Final Query: Combines all customer results into one output        
------------------------------------------------------------*/
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		 WHEN age BETWEEN 20 and 29 THEN '20-29'
		 WHEN age BETWEEN 30 and 39 THEN '30-39'
		 WHEN age BETWEEN 40 and 49 THEN '40-49'
		 ELSE '50 and above'
	END age_group,
	CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	 	 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	 	 ELSE 'New'
	END customer_segment,
	last_order_date,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order_date)) * 12 +
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date)) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	lifespan,
	-- Calculate avg order value (AVO)
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders 
	END avg_order_value,
	-- Calculate avg monthly spend
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE ROUND(total_sales / lifespan, 0)
	END avg_monthly_spend
	
FROM customer_aggregations
