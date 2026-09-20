
-- find the date of the first and last order

select 
MIN(order_date) first_order_date , 
MAX(order_date) last_order_date 
from gold.facts_sales

-- how many years of sales are available 

select
DATEDIFF( year , MIN(order_date) , MAX(order_date)) as order_range_years,
DATEDIFF( month , MIN(order_date) , MAX(order_date)) as order_range_months,
DATEDIFF( day , MIN(order_date) , MAX(order_date)) as order_range_days
from gold.facts_sales

-- find the youngest and the oldest customer

select
MIN(birth_date) oldest_customer ,
DATEDIFF( year , MIN(birth_date) , GETDATE()) as oldest_age,
DATEDIFF( year , MAX(birth_date) , GETDATE()) as youngest_age,
MAX(birth_date) youngest_customer
from gold.dim_customers
