
-- analyze the yearly performnace of products by comparing each product's sales to both its avg sales performance and previous year's sales
-- as this is a bit complex and we have to use CTE or subqueries we will be using CTE in this scenario

WITH yearly_product_sales AS (
SELECT 
YEAR(f.order_date) as order_year,
p.product_name ,
SUM(f.sales) as current_sales
from GOLD.facts_sales f
LEFT JOIN GOLD.dim_products p 
ON    f.product_key = p.product_key
where f.order_date IS NOT NULL
GROUP BY YEAR(f.order_date),
p.product_name
)

SELECT          
order_year,
product_name,
current_sales,
AVG(current_sales) OVER( PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) OVER( PARTITION BY product_name) as diff_avg,      -- comparing product's sale to avg sale 
CASE WHEN current_sales - AVG(current_sales) OVER( PARTITION BY product_name) > 0 THEN 'above avg'
     WHEN current_sales - AVG(current_sales) OVER( PARTITION BY product_name) < 0 THEN 'below avg'
	 ELSE 'avg'
END avg_change,
LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) as py_sales ,-- LAG gives the previous value
current_sales - LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) as diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) > 0 THEN 'INCREASE'
     WHEN current_sales - LAG(current_sales) OVER( PARTITION BY product_name ORDER BY order_year) < 0 THEN 'DECREASE'
	 ELSE 'SAME'
END py_change
from yearly_product_sales
order by product_name , order_year
