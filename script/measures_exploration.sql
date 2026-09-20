
-- find the total sales
select SUM(sales) as total_sales from gold.facts_sales

-- find how many items are sold 
select SUM(quantity) as total_quantity from gold.facts_sales

-- find the avg selling price 
select avg(price) as avg_price from gold.facts_sales

-- find the total no of products 
select COUNT(DISTINCT product_name) as total_products from gold.dim_products

-- find the total no of orders 
select COUNT(DISTINCT order_number) as total_orders from gold.facts_sales -- why distinct just to make sure there are no duplicates 

-- find the total no of customers
select COUNT(customer_key) as total_customers from gold.dim_customers

-- find the total no of customers that has placed an order
select COUNT(DISTINCT customer_key) as total_customers from gold.facts_sales

-- generate a report that shows all key matrices of our business

select 'Total Sales' as measure_name , SUM(sales) as measure_value from gold.facts_sales
UNION ALL 
select 'Total Quantity' as measure_name , SUM(quantity) as measure_value from gold.facts_sales
UNION ALL 
select 'Avg Price' as measure_name , AVG(price) as measure_value from gold.facts_sales
UNION ALL
select 'Total Products' as measure_name , COUNT(DISTINCT product_name) as measure_value from gold.dim_products
UNION ALL
select 'Total Orders' as measure_name , COUNT(DISTINCT order_number) as measure_value from gold.facts_sales
UNION ALL
select 'Total Customers who have placed an order' as measure_name , COUNT( DISTINCT customer_key) as measure_value from gold.dim_customers
