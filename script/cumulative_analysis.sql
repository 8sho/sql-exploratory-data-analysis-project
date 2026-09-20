
-- calculate the total sales by month and running total of sales over time
	SELECT
	DATETRUNC(month , order_date) as order_month,
	SUM(sales) as total_sales 
	from GOLD.facts_sales
	where order_date IS NOT NULL
	group by DATETRUNC(month , order_date)
	order by DATETRUNC(month , order_date) -- this shows sales over each month but we want running sales over time and running avg in year
	                                       -- in order to this we have to use window functions 
    SELECT
	order_year,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY order_year ORDER BY order_year) as running_total_sales,
	AVG(total_avg) OVER (PARTITION BY order_year ORDER BY order_year) as running_avg_sales
	from
	(
	SELECT
	DATETRUNC(year , order_date) as order_year,
	SUM(sales) as total_sales,
	AVG(sales) as total_avg
	from GOLD.facts_sales
	where order_date IS NOT NULL
	group by DATETRUNC(year , order_date)
	) t
