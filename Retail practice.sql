-- SQL Retail Sales Analysis - P1

CREATE DATABASE sql_project_p2;

 --USE DATABASE retail_sales; 
 
-- Create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
			(
				transactions_id	 INT PRIMARY KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	TEXT,
				age	INT,
				category VARCHAR (15),	
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs FLOAT,	
				total_sale FLOAT

			);	

		SELECT * FROM retail_sales
		LIMIT 10;

		SELECT 
			COUNT (*) 
		FROM retail_sales;

-- Data cleaning
SELECT * FROM retail_sales 
WHERE  transactions_id IS NULL;

SELECT * FROM retail_sales 
WHERE  sale_date IS NULL;

--write a single code to see where there is null in all the columns
SELECT * FROM retail_sales 
WHERE  
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- delete

DELETE FROM retail_sales 
WHERE  
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Data exploration

-- How many sales do we have?
SELECT COUNT (*) as total_sale FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales;

-- How many unique category do we have?
SELECT DISTINCT category FROM retail_sales;

--Data Analysis  & Business Key Problems & Answers
-- Q1 Write an SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'

-- Q2 Write an SQL query to retrieve all transactions where the category is 'clothing and the quantity 
-- sold is more than 3 in the month of Nov-2022 '

-- step 1  where quantity is for November 2022
SELECT 
	category,
	SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
GROUP BY 1

-- Q2's answer

SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantiy >= 4
	
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the  'Beauty' category.
SELECT 
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--Q.5 Write a query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales 
WHERE  total_sale >1000

-- Q.6 Write a query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 1	

--Q.7 Write a query to calculate the average sale for each month. Find out the best selling month in each year.

SELECT 
	year,
	month,
	avg_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank =1

--ORDER BY 1, 3 DESC

-- Q.8 Write a querY to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id,
	SUM(total_sale)as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9 Write a query to find the number of unique customers who purchased items for each category.
SELECT 
	category,
	COUNT(distinct customer_id) as tcount_unique_customers
FROM retail_sales
GROUP BY category

-- Q. 10 Write a query to create each shift and number of orders  ( Example Morning <=12, Afternoon Between 12 & 17, Evening > 17)
WITH hourly_sale
AS
(
select *,
	 CASE
	 	WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

--End of project.



SELECT EXTRACT (HOUR FROM CURRENT_TIME)