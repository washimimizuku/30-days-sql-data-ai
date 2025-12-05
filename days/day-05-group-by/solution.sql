-- Day 5: GROUP BY Basics - Solutions

-- ============================================
-- Exercise 1: GROUP BY with COUNT
-- ============================================

-- 1.1: Count employees in each department
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- 1.2: Count products in each category
SELECT category, COUNT(*) as product_count
FROM products
GROUP BY category;

-- 1.3: Count orders per customer
SELECT customer_id, COUNT(*) as order_count
FROM orders
GROUP BY customer_id;

-- 1.4: Count employees in each city
SELECT city, COUNT(*) as employee_count
FROM employees
GROUP BY city;


-- ============================================
-- Exercise 2: GROUP BY with SUM
-- ============================================

-- 2.1: Calculate total payroll per department
SELECT department, SUM(salary) as total_payroll
FROM employees
GROUP BY department;

-- 2.2: Calculate total sales amount per product
SELECT product_name, SUM(amount) as total_sales
FROM sales
GROUP BY product_name;

-- 2.3: Calculate total revenue per customer
SELECT customer_id, SUM(total) as total_revenue
FROM orders
GROUP BY customer_id;

-- 2.4: Calculate total quantity sold per region
SELECT region, SUM(quantity) as total_quantity
FROM sales
GROUP BY region;


-- ============================================
-- Exercise 3: GROUP BY with AVG
-- ============================================

-- 3.1: Calculate average salary per department
SELECT department, ROUND(AVG(salary), 2) as avg_salary
FROM employees
GROUP BY department;

-- 3.2: Calculate average price per category
SELECT category, ROUND(AVG(price), 2) as avg_price
FROM products
GROUP BY category;

-- 3.3: Calculate average order value per customer
SELECT customer_id, ROUND(AVG(total), 2) as avg_order_value
FROM orders
GROUP BY customer_id;

-- 3.4: Calculate average age per department
SELECT department, ROUND(AVG(age), 1) as avg_age
FROM employees
GROUP BY department;


-- ============================================
-- Exercise 4: GROUP BY with MIN and MAX
-- ============================================

-- 4.1: Find lowest and highest salary in each department
SELECT 
    department,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department;

-- 4.2: Find cheapest and most expensive product in each category
SELECT 
    category,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM products
GROUP BY category;

-- 4.3: Find earliest and latest hire date per department
SELECT 
    department,
    MIN(hire_date) as earliest_hire,
    MAX(hire_date) as latest_hire
FROM employees
GROUP BY department;

-- 4.4: Find smallest and largest order per customer
SELECT 
    customer_id,
    MIN(total) as min_order,
    MAX(total) as max_order
FROM orders
GROUP BY customer_id;


-- ============================================
-- Exercise 5: Multiple Aggregates
-- ============================================

-- 5.1: For each department: count, avg salary, min salary, max salary
SELECT 
    department,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department;

-- 5.2: For each category: count products, avg price, total inventory value
SELECT 
    category,
    COUNT(*) as product_count,
    ROUND(AVG(price), 2) as avg_price,
    SUM(price * quantity) as total_value
FROM products
GROUP BY category;

-- 5.3: For each customer: count orders, total spent, avg order value
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_spent,
    ROUND(AVG(total), 2) as avg_order_value
FROM orders
GROUP BY customer_id;


-- ============================================
-- Exercise 6: GROUP BY Multiple Columns
-- ============================================

-- 6.1: Count employees by department AND city
SELECT 
    department,
    city,
    COUNT(*) as employee_count
FROM employees
GROUP BY department, city;

-- 6.2: Sum sales by product AND region
SELECT 
    product_name,
    region,
    SUM(amount) as total_sales
FROM sales
GROUP BY product_name, region;

-- 6.3: Average salary by department AND job_title
SELECT 
    department,
    job_title,
    ROUND(AVG(salary), 2) as avg_salary
FROM employees
GROUP BY department, job_title;


-- ============================================
-- Exercise 7: GROUP BY with WHERE
-- ============================================

-- 7.1: Average salary per department (only active employees)
SELECT 
    department,
    ROUND(AVG(salary), 2) as avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department;

-- 7.2: Total sales per product (only sales from 2024)
SELECT 
    product_name,
    SUM(amount) as total_sales_2024
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY product_name;

-- 7.3: Count employees per city (only hired after 2020)
SELECT 
    city,
    COUNT(*) as employee_count
FROM employees
WHERE hire_date > '2020-12-31'
GROUP BY city;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Department report with all statistics
SELECT 
    department,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    SUM(salary) as total_payroll,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department
ORDER BY total_payroll DESC;

-- BONUS 2: Product performance by category
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(quantity) as total_sold,
    ROUND(AVG(price), 2) as avg_price
FROM products
GROUP BY category
ORDER BY total_sold DESC;

-- BONUS 3: Customer analysis - top 10 customers
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_spent,
    ROUND(AVG(total), 2) as avg_order_value
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;
