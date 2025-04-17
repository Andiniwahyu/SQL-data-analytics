/*------------------------------------------------------------
	ANALYZE DATA FROM VIEW: Customer Report           
------------------------------------------------------------*/
SELECT * FROM gold.report_customers;
/* 1. Total sales and average order value per customer segment */
SELECT
	customer_segment,
	COUNT(customer_number) AS total_customers,
	SUM(total_sales) AS total_sales,
	ROUND(AVG(avg_order_value),2) AS avg_order_value
FROM gold.report_customers
GROUP BY customer_segment;

/* 2. Total sales and customer count per age group */
SELECT
	age_group,
	COUNT(customer_number) AS total_customers,
	SUM(total_sales) AS total_sales
FROM gold.report_customers
GROUP BY age_group;

/* 3. Identify high-value customers (total sales > X) */
SELECT
	customer_number,
	customer_name,
	customer_segment,
	total_sales,
	avg_monthly_spend
FROM gold.report_customers
WHERE total_sales > 5000
ORDER BY total_sales DESC;

/* 4. Average lifespan per segment */
SELECT
	customer_segment,
	ROUND(AVG(lifespan), 1) AS avg_lifespan_months
FROM gold.report_customers
GROUP BY customer_segment;


/*------------------------------------------------------------
	ANALYZE DATA FROM VIEW: Product Report           
------------------------------------------------------------*/
SELECT * FROM gold.report_products;
/* 1. Total revenue and quantity by product segment */
SELECT
	product_segment,
	COUNT(DISTINCT product_key) AS total_products,
	SUM(total_sales) AS total_sales,
	SUM(total_quantity) AS total_quantity_sold
FROM gold.report_products
GROUP BY product_segment;

/* 2. Average monthly revenue per product category */
SELECT
	category,
	ROUND(AVG(avg_monthly_revenue), 2) AS avg_monthly_revenue
FROM gold.report_products
GROUP BY category
ORDER BY avg_monthly_revenue DESC;

/* 3. Top 10 products by average order revenue (AOR) */
SELECT
	product_name,
	avg_order_revenue
FROM gold.report_products
ORDER BY avg_order_revenue DESC
LIMIT 10;

/* 4. Top selling products by category */
WITH ranked_products AS
(
SELECT
	category,
	product_name,
	total_sales,
	RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rank_in_category
FROM gold.report_products
	)
SELECT *
FROM ranked_products
WHERE rank_in_category <= 5;


