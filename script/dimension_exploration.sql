
-- explore all the countries our customers come from 

select DISTINCT country from gold.dim_customers

-- explore all categories the major division

select DISTINCT product_cat , product_sub_cat , product_name from gold.dim_products
order by 1,2,3
