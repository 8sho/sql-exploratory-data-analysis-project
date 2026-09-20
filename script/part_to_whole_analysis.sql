
-- which category contributes most to overall sales 

WITH category_sales as(
select
product_cat,
SUM(price) as total_sales
from GOLD.facts_sales f
LEFT JOIN GOLD.dim_products p
on     f.product_key = p.product_key
group by product_cat)

select
product_cat,
total_sales,
SUM(total_Sales) over() as overall_sales,
CONCAT(ROUND((CAST(total_sales as float)/SUM(total_Sales) over() )*100 ,2) , '%')as percentage_Sales
from category_sales
