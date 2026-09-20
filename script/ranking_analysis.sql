
--  1 -which 5 products generate the highest revenue ?
select TOP 5
p.product_name,
SUM(f.sales) as total_revenue
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_name
order by  total_revenue DESC

-- 2 - what are the 5 worst-performing products in terms of sales ?
select TOP 5
p.product_name,
SUM(f.sales) as total_revenue
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_name
order by  total_revenue 

-- 3 - best sub-categories 
select TOP 5
p.product_sub_cat,
SUM(f.sales) as total_revenue
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_sub_cat
order by  total_revenue DESC

-- 5.4 - worst sub-categories
select TOP 5
p.product_sub_cat,
SUM(f.sales) as total_revenue
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_sub_cat
order by  total_revenue 

-- solving the same tasks using window functions 
-- 1.1 - 
select
*
from(
select 
p.product_name,
SUM(f.sales) as total_revenue,
ROW_NUMBER() OVER( order by SUM(f.sales) DESC ) as rank_products
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_name) t
where rank_products <=5 

-- 1.2 -
select
*
from(
select 
p.product_name,
SUM(f.sales) as total_revenue,
ROW_NUMBER() OVER( order by SUM(f.sales) ) as rank_products
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_name) t
where rank_products <=5

-- 1.3- 
select
*
from(
select 
p.product_sub_cat,
SUM(f.sales) as total_revenue,
ROW_NUMBER() OVER ( order by SUM(f.sales) DESC) as rank_sub_cat
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_sub_cat) t
where rank_sub_cat <=5

-- 1.4 - 
select
*
from(
select 
p.product_sub_cat,
SUM(f.sales) as total_revenue,
ROW_NUMBER() OVER ( order by SUM(f.sales) ) as rank_sub_cat
from gold.facts_sales f
left join gold.dim_products p
on     f.product_key = p.product_key
GROUP BY p.product_sub_cat) t
where rank_sub_cat <=5

-- find the top 10 customers who have generated the highest revenue 
select TOP 10
c.customer_key,
SUM(f.sales) as total_revenue
from gold.facts_sales f
left join gold.dim_customers c
on     f.customer_key = c.customer_key
GROUP BY c.customer_key
order by  total_revenue DESC


-- top 3 customers with the fewer orders placed 
select TOP 3
c.customer_key,
COUNT( DISTINCT order_number) as total_orders
from gold.facts_sales f
left join gold.dim_customers c
on     f.customer_key = c.customer_key
GROUP BY c.customer_key
order by  total_orders 
