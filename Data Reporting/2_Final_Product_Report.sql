/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report summarizes key product metrics and behaviors.

Highlights:
    1. Collects important details such as product name, category, subcategory, and cost.
    2. Categorizes products by revenue to identify High, Mid, and Low Performers.
    3. Aggregates product-level metrics:
       - total number of orders
       - total sales
       - total quantity sold
       - total unique customers 
       - product lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (how many months since the product was last sold)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
/*------------------------------------------------------------
	Create Report: gold.report_products
------------------------------------------------------------*/

CREATE VIEW gold.report_products AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
WITH base_query AS 
(
SELECT
	s.order_number,
	s.customer_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	p.product_key,
	p.product_number,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL  -- only consider valid sales dates
)

/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
, product_aggregations AS
(
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
	(EXTRACT(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date))) * 12 +
  (EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date))) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM base_query
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date)) * 12 +
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date)) AS recency,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	-- Average Order Revenue (AOR)
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END AS avg_monthly_revenue
	
FROM product_aggregations 