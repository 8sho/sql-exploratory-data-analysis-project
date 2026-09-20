
/* purpose
   this report consolidates key customer metrics and behaviour

   highlights.
   1. gathers essential fields such as names , age and transaction details
   2. segments customers into categories (vip , regular , new) and age groups
   3. aggregates customer level metrices
    . total orders
	.. total sales
	... total quantity purchased
	.... total products
   4. calculates valuable kpis
    . recency (months since last order)
	.. avg order value
	... avg monthly spend
*/

create view GOLD.report_customers as 
WITH base_query AS(
-- 1. - base query - retrieve the core columns from the tables 
SELECT
f.order_number,
f.product_key,
f.order_ship_date,
f.sales,
f.quantity,
c.customer_id,
c.customer_key,
CONCAT( c.customer_firstname, ' ' , c.customer_lastname) as customer_name,
DATEDIFF( year , c.birth_date , GETDATE()) as age,
c.customer_number
from GOLD.facts_sales f
LEFT JOIN GOLD.dim_customers c
ON  c.customer_key = f.customer_key
where order_date IS NOT NULL)

, customer_aggregation as (
--2 . customer aggregations - summarizes key matrices at the customer level
select 
		customer_key,
		customer_number,
		customer_name,
		age,
COUNT(DISTINCT order_number) as total_orders,
SUM(sales) as total_sales,
SUM(quantity) as total_quantity,
COUNT(DISTINCT product_key) as total_products,
MAX(order_ship_date) as last_order_date,
DATEDIFF( month , MIN(order_ship_date) , MAX(order_ship_date)) as LIFESPAN
from base_query
GROUP BY customer_key,
		 customer_number,
		 customer_name,
		 age )

select
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'under 20'
     WHEN age BETWEEN 20 AND 29 THEN '20-29'
	 WHEN age BETWEEN 30 AND 39 THEN '30-39'
	 WHEN age BETWEEN 40 AND 49 THEN '40-49'
	 ELSE '50 and above'
END age_group,
CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
END customer_segment ,
 last_order_date,
 DATEDIFF( MONTH , last_order_date , GETDATE()) as recency,
 total_orders,
 total_sales,
 total_quantity,
 total_products,
  LIFESPAN,
 -- compute avg order value
 CASE WHEN total_orders = 0 THEN 0
      ELSE total_sales/total_orders
 END as avg_order_value,
 -- compute avg monthly spend
 CASE WHEN lifespan = 0 THEN total_sales
      ELSE total_sales/lifespan
 END as avg_monthly_spend
from customer_aggregation
