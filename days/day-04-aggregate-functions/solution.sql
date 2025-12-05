-- Day 4: Aggregate Functions - Solutions

-- ============================================
-- Exercise 1: COUNT
-- ============================================

-- 1.1: Count total number of employees
SELECT COUNT(*) as total_employees
FROM employees;

-- 1.2: Count employees with non-NULL email addresses
SELECT COUNT(email) as employees_with_email
FROM employees;

-- 1.3: Count unique cities where employees are located
SELECT COUNT(DISTINCT city) as unique_cities
FROM employees;

-- 1.4: Count employees in the 'Engineering' department
SELECT COUNT(*) as engineering_count
FROM employees
WHERE department = 'Engineering';

-- 1.5: Count orders with status 'Delivered'
SELECT COUNT(*) as delivered_orders
FROM orders
WHERE status = 'Delivered';


-- ============================================
-- Exercise 2: SUM
-- ============================================

-- 2.1: Calculate total payroll (sum of all salaries)
SELECT SUM(salary) as total_payroll
FROM employees;

-- 2.2: Calculate total sales amount from orders
SELECT SUM(total) as total_sales
FROM orders;

-- 2.3: Calculate total quantity of products in inventory
SELECT SUM(stock_quantity) as total_inventory
FROM products;

-- 2.4: Calculate total refund amount (where type = 'refund')
SELECT SUM(amount) as total_refunds
FROM transactions
WHERE type = 'refund';

-- 2.5: Calculate sum of salaries for 'Sales' department
SELECT SUM(salary) as sales_payroll
FROM employees
WHERE department = 'Sales';


-- ============================================
-- Exercise 3: AVG
-- ============================================

-- 3.1: Calculate average salary across all employees
SELECT ROUND(AVG(salary), 2) as average_salary
FROM employees;

-- 3.2: Calculate average order value
SELECT ROUND(AVG(total), 2) as avg_order_value
FROM orders;

-- 3.3: Calculate average product price
SELECT ROUND(AVG(price), 2) as avg_product_price
FROM products;

-- 3.4: Calculate average salary in 'Engineering' department
SELECT ROUND(AVG(salary), 2) as eng_avg_salary
FROM employees
WHERE department = 'Engineering';

-- 3.5: Calculate average age of employees
SELECT ROUND(AVG(age), 1) as avg_age
FROM employees;


-- ============================================
-- Exercise 4: MIN and MAX
-- ============================================

-- 4.1: Find the lowest and highest salary
SELECT 
    MIN(salary) as lowest_salary,
    MAX(salary) as highest_salary
FROM employees;

-- 4.2: Find the earliest and latest hire date
SELECT 
    MIN(hire_date) as earliest_hire,
    MAX(hire_date) as latest_hire
FROM employees;

-- 4.3: Find the cheapest and most expensive product
SELECT 
    MIN(price) as cheapest_product,
    MAX(price) as most_expensive_product
FROM products;

-- 4.4: Find the minimum and maximum order total
SELECT 
    MIN(total) as smallest_order,
    MAX(total) as largest_order
FROM orders;

-- 4.5: Find alphabetically first and last employee name
SELECT 
    MIN(name) as first_alphabetically,
    MAX(name) as last_alphabetically
FROM employees;


-- ============================================
-- Exercise 5: Multiple Aggregates
-- ============================================

-- 5.1: Show count, sum, avg, min, max of salaries
SELECT 
    COUNT(*) as employee_count,
    SUM(salary) as total_payroll,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees;

-- 5.2: Show order statistics (count, total, average, min, max)
SELECT 
    COUNT(*) as order_count,
    SUM(total) as total_revenue,
    ROUND(AVG(total), 2) as avg_order,
    MIN(total) as min_order,
    MAX(total) as max_order
FROM orders;

-- 5.3: Show product statistics (count, avg price, min price, max price)
SELECT 
    COUNT(*) as product_count,
    ROUND(AVG(price), 2) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM products;

-- 5.4: Show sales statistics (count, total amount, avg amount)
SELECT 
    COUNT(*) as sales_count,
    SUM(total_amount) as total_sales,
    ROUND(AVG(total_amount), 2) as avg_sale
FROM sales;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Calculate the salary range (difference between max and min)
SELECT 
    MAX(salary) - MIN(salary) as salary_range,
    MIN(salary) as lowest,
    MAX(salary) as highest
FROM employees;

-- BONUS 2: Find the average order value for orders over $1000
SELECT ROUND(AVG(total), 2) as avg_large_order
FROM orders
WHERE total > 1000;

-- BONUS 3: Count how many unique customers have placed orders
SELECT COUNT(DISTINCT customer_id) as unique_customers
FROM orders;

-- BONUS 4: Calculate total profit from products (assuming all are sold once)
SELECT 
    SUM(price - cost) as total_potential_profit,
    ROUND(AVG(price - cost), 2) as avg_profit_per_product
FROM products;
