
-- analyze sales performance over time 
   SELECT 
   YEAR (order_date) as order_year,
   SUM (sales) as total_sales
   from GOLD.facts_sales
   where YEAR (order_date) IS NOT NULL
   GROUP BY YEAR (order_date)
   order by YEAR (order_date)

-- analyze sales performance along with customers over time 
   SELECT 
   YEAR (order_date) as order_year,
   SUM (sales) as total_sales,
   COUNT (DISTINCT customer_key) as total_customers
   from GOLD.facts_sales
   where YEAR (order_date) IS NOT NULL
   GROUP BY YEAR (order_date)
   order by YEAR (order_date)
-- looking at the results we get high-level overview insights that helps with startegic decision making 
-- we can use datetrunc function to get months along with year in the same column

   SELECT 
   DATETRUNC (month , order_date) as order_year,
   SUM (sales) as total_sales,
   COUNT (DISTINCT customer_key) as total_customers
   from GOLD.facts_sales
   where YEAR (order_date) IS NOT NULL
   GROUP BY DATETRUNC (month , order_date)
   order by DATETRUNC (month , order_date)
