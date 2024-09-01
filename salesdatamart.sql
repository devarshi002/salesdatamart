CREATE DATABASE IF NOT EXISTS salesDataMart;
USE salesDataMart;

create table if not exists sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_pct FLOAT(11, 9),
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT(2, 1)
);


-- --------------------------------------------------------------------------------------------------------------------------------
-- ---------------Feature Engineering ----------------------------------------
-- time_of_day

SELECT 
    time,
    (CASE 
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales;

alter table sales add column time_of_day varchar(20);


update sales set time_of_day = (CASE 
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
  END);

-- day_name
select
    date,
    dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);
update sales set day_name = dayname(date);

select day_name from sales;

-- month_name

select
    date,
    monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales set month_name = monthname(date);


SELECT * FROM salesdatamart.sales;



-- -----------------------------------------------------------------------------
-- ----------------Generic ----------------------------------------------------

-- How many unique city does the data have ?
 
 select 
 count(distinct(city)) as unique_city
 from sales;
 
 -- in which city is each branch?
 
 select
    branch,
    city
from sales
group by branch, city;
 
 -- What is the total sales revenue for each branch?
 select 
 branch,
 sum(total) as total_revenue
 from sales
 group by branch;
 
 -- Which branch has the highest average unit price of products sold?
 
SELECT 
    branch,
    AVG(unit_price) AS average_unit_price
FROM sales
group by branch
order by average_unit_price desc;

-- What is the total quantity of products sold by each branch?
select
   branch,
   sum(quantity) as total_quantity
   from sales
   group by branch;
   
-- How many transactions were made by each customer type?
 select 
 customer_type,
 count(invoice_id) as transaction_count
 from sales
 group by customer_type;
 
 -- What is the average rating given by customers for each branch?
select 
branch,
avg(rating) as avg_rating
from sales 
group by branch;

-- Which product line generates the highest total sales revenue?
 select 
 distinct(product_line),
 sum(total) as high_total_sales_revenue
 from sales
 group by product_line
 order by high_total_sales_revenue;
 
 -- What is the distribution of sales across different days of the week?
 select 
 day_name,
 sum(total) as total_sales
 from sales
 group by day_name;
 
 
 -- What is the total VAT collected per city?
 select
 city,
 sum(VAT) as total_vat
 from sales
 group by city;
 
 -- Which payment method is most frequently used?
 select
 payment_method,
 count(invoice_id) as transcation_count
 from sales
 group by payment_method
 order by transcation_count desc;
 
 -- What is the gross margin percentage for each product line?
 select 
 product_line,
 avg(gross_margin_pct) as avg_gross_m_perc
 from sales
 group by product_line;
 
 
 
 -- -----------------------------------------------------------------------------------------------------------
 -- ----------------------------------product -----------------------------------------------------------------
 
 -- How many unique product lines does the data have?
 select 
 distinct(product_line) as unique_product_line
 from sales;
 
 -- What is the most common payment method?
 select
 payment_method,
 count(payment_method) as count_of_pay
 from sales
 group by payment_method
 order by count_of_pay desc;
 
 -- What is the most selling product line?
 select 
 product_line,
 count(product_line) as cnt
 from sales 
 group by product_line
 order by cnt desc;
 
 
 -- What is the total revenue by month?
 select 
 month_name as month,
 sum(total) as total_revenue
 from sales
 group by month
 order by total_revenue desc;
 
 -- What month had the largest COGS?
 select
 month_name as month,
 sum(cogs) as largest_cogs
 from sales
 group by month
 order by largest_cogs desc;
 
 -- What product line had the largest revenue?
 select
 product_line,
 sum(total) as largest_revenue
 from sales 
 group by product_line
 order by largest_revenue desc;
 
 -- What is the city with the largest revenue?
 select
 distinct(city) as city,
 sum(total) as larg_rev
 from sales 
 group by city
 order by larg_rev desc;
 
 
 -- What product line had the largest VAT?
 select 
 product_line,
 sum(VAT) as largest_vat
 from sales
 group by product_line
 order by largest_vat desc;
 
 -- Which branch sold more products than average product sold?
 select
 branch,
 sum(quantity) as qty
 from sales 
 group by branch
 having sum(quantity) > (select avg(quantity) from sales);
 
 -- What is the most common product line by gender?
 select 
 gender,
 product_line,
 count(gender) as total_cnt
 from sales 
 group by gender, product_line
 order by total_cnt desc;
 
 
 SELECT * FROM salesdatamart.sales;