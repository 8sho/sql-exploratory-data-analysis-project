
-- segment products into cost ranges and count how many products fall into each category

WITH product_segments as(
select
product_id,
product_name,
product_cost,
CASE WHEN product_cost < 100 THEN 'below 100'
     WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'above 1000'
END as cost_range
from GOLD.dim_products)

select
cost_range,
COUNT(product_id) as total_products
from product_segments
group by cost_range
order by total_products DESC


-- group customers into three segments based on their spending behaviour
-- vip :      at least 12 months of history and spending of more than 5000 euros
-- regular :  at least 12 months of history and spending is >= 5000 euros
-- new :      lifespan less than 12 months

with customer_spending as (
select 
c.customer_key,
SUM(f.price) as total_spending,
MIN(f.order_date) as first_order,
MAX(f.order_date) as last_order,
DATEDIFF(month , MIN(f.order_date) , MAX(f.order_date)) as lifespan
from GOLD.facts_sales f
LEFT JOIN  GOLD.dim_customers c
ON  f.customer_key = c.customer_key
GROUP BY c.customer_key
)
select
customer_segment,
COUNT(customer_key) as total_customers
FROM(
select 
customer_key,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'REGULAR'
	 ELSE 'NEW'
END customer_segment 
from customer_spending) t
GROUP BY customer_segment
order by total_customers DESC
