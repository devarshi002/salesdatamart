
---

# Sales Data Mart

## Overview

This project involves the creation and analysis of a `sales` database, referred to as `salesDataMart`. The database contains a table that records transactional data from various branches across different cities. This document provides a detailed breakdown of the table structure, feature engineering, and SQL queries used for data exploration and analysis.

## Database and Table Creation

### Database Creation
```sql
CREATE DATABASE IF NOT EXISTS salesDataMart;
USE salesDataMart;
```

### Table Structure

The `sales` table contains detailed records of sales transactions. Below is the SQL statement used to create the table:

```sql
CREATE TABLE IF NOT EXISTS sales (
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
```

### Column Descriptions

- **invoice_id**: The unique identifier for each transaction.
- **branch**: The branch where the sale was made.
- **city**: The city where the branch is located.
- **customer_type**: The type of customer (e.g., Member, Normal).
- **gender**: The gender of the customer.
- **product_line**: The product line of the sold product.
- **unit_price**: The price per unit of the product.
- **quantity**: The number of units sold.
- **VAT**: The amount of tax on the purchase.
- **total**: The total cost of the purchase including VAT.
- **date**: The date when the purchase was made.
- **time**: The time when the purchase was made.
- **payment_method**: The method of payment (e.g., Cash, Credit Card).
- **cogs**: Cost of Goods Sold.
- **gross_margin_pct**: The gross margin percentage.
- **gross_income**: The gross income from the sale.
- **rating**: The customer rating for the transaction.

## Feature Engineering

### Adding `time_of_day` Column

This column categorizes transactions based on the time of day.

```sql
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales SET time_of_day = (CASE 
    WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END);
```

### Adding `day_name` Column

This column captures the day of the week when the transaction occurred.

```sql
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales SET day_name = DAYNAME(date);
```

### Adding `month_name` Column

This column captures the month name when the transaction occurred.

```sql
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales SET month_name = MONTHNAME(date);
```

## Data Exploration and Analysis Queries

Below are some generic SQL queries used for data exploration and analysis:

### City and Branch Analysis

- **How many unique cities are present in the data?**
  ```sql
  SELECT COUNT(DISTINCT city) AS unique_city FROM sales;
  ```

- **Which city is each branch located in?**
  ```sql
  SELECT branch, city FROM sales GROUP BY branch, city;
  ```

### Sales and Revenue Analysis

- **What is the total sales revenue for each branch?**
  ```sql
  SELECT branch, SUM(total) AS total_revenue FROM sales GROUP BY branch;
  ```

- **Which branch has the highest average unit price of products sold?**
  ```sql
  SELECT branch, AVG(unit_price) AS average_unit_price FROM sales GROUP BY branch ORDER BY average_unit_price DESC LIMIT 1;
  ```

- **What is the total quantity of products sold by each branch?**
  ```sql
  SELECT branch, SUM(quantity) AS total_quantity FROM sales GROUP BY branch;
  ```

### Customer and Product Analysis

- **How many transactions were made by each customer type?**
  ```sql
  SELECT customer_type, COUNT(invoice_id) AS transaction_count FROM sales GROUP BY customer_type;
  ```

- **What is the average rating given by customers for each branch?**
  ```sql
  SELECT branch, AVG(rating) AS avg_rating FROM sales GROUP BY branch;
  ```

- **Which product line generates the highest total sales revenue?**
  ```sql
  SELECT product_line, SUM(total) AS total_revenue FROM sales GROUP BY product_line ORDER BY total_revenue DESC LIMIT 1;
  ```

### Temporal Analysis

- **What is the distribution of sales across different days of the week?**
  ```sql
  SELECT day_name, SUM(total) AS total_sales FROM sales GROUP BY day_name;
  ```

- **What is the total revenue by month?**
  ```sql
  SELECT month_name, SUM(total) AS total_revenue FROM sales GROUP BY month_name ORDER BY total_revenue DESC;
  ```

- **Which month had the largest Cost of Goods Sold (COGS)?**
  ```sql
  SELECT month_name, SUM(cogs) AS largest_cogs FROM sales GROUP BY month_name ORDER BY largest_cogs DESC LIMIT 1;
  ```

### Additional Product and Branch Analysis

- **Which branch sold more products than the average product sold?**
  ```sql
  SELECT branch, SUM(quantity) AS qty FROM sales GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);
  ```

- **What is the most common product line by gender?**
  ```sql
  SELECT gender, product_line, COUNT(product_line) AS total_count FROM sales GROUP BY gender, product_line ORDER BY total_count DESC;
  ```

## Conclusion

This project demonstrates how to create and analyze a sales data mart using SQL. By leveraging various SQL queries, one can extract meaningful insights related to sales performance, customer behavior, and product trends. This data can be pivotal for business decision-making and strategic planning.

--- 
