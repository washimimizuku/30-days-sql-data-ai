-- Day 6: HAVING Clause - Solutions

-- ============================================
-- Exercise 1: HAVING with COUNT
-- ============================================

-- 1.1: Find departments with more than 15 employees
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 15;

-- 1.2: Find customers with more than 5 orders
SELECT customer_id, COUNT(*) as order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5;

-- 1.3: Find categories with fewer than 10 products
SELECT category, COUNT(*) as product_count
FROM products
GROUP BY category
HAVING COUNT(*) < 10;

-- 1.4: Find cities with at least 20 employees
SELECT city, COUNT(*) as employee_count
FROM employees
GROUP BY city
HAVING COUNT(*) >= 20;


-- ============================================
-- Exercise 2: HAVING with SUM
-- ============================================

-- 2.1: Find departments with total payroll over $1,000,000
SELECT department, SUM(salary) as total_payroll
FROM employees
GROUP BY department
HAVING SUM(salary) > 1000000;

-- 2.2: Find customers who spent more than $10,000
SELECT customer_id, SUM(total) as total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total) > 10000;

-- 2.3: Find products with total sales over 500 units
SELECT product_id, SUM(quantity) as total_quantity
FROM sales
GROUP BY product_id
HAVING SUM(quantity) > 500;

-- 2.4: Find categories with total price sum over $50,000
SELECT category, SUM(price) as total_value
FROM products
GROUP BY category
HAVING SUM(price) > 50000;


-- ============================================
-- Exercise 3: HAVING with AVG
-- ============================================

-- 3.1: Find departments with average salary above $80,000
SELECT department, ROUND(AVG(salary), 2) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 80000;

-- 3.2: Find categories with average price over $200
SELECT category, ROUND(AVG(price), 2) as avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 200;

-- 3.3: Find customers with average order value over $500
SELECT customer_id, ROUND(AVG(total), 2) as avg_order_value
FROM orders
GROUP BY customer_id
HAVING AVG(total) > 500;

-- 3.4: Find categories with average rating above 4.5
SELECT category, ROUND(AVG(rating), 2) as avg_rating
FROM products
GROUP BY category
HAVING AVG(rating) > 4.5;


-- ============================================
-- Exercise 4: HAVING with MIN and MAX
-- ============================================

-- 4.1: Find departments where minimum salary is above $50,000
SELECT department, MIN(salary) as min_salary
FROM employees
GROUP BY department
HAVING MIN(salary) > 50000;

-- 4.2: Find categories where maximum price is over $1000
SELECT category, MAX(price) as max_price
FROM products
GROUP BY category
HAVING MAX(price) > 1000;

-- 4.3: Find departments where salary range is over $80,000
SELECT 
    department,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    MAX(salary) - MIN(salary) as salary_range
FROM employees
GROUP BY department
HAVING MAX(salary) - MIN(salary) > 80000;


-- ============================================
-- Exercise 5: WHERE vs HAVING
-- ============================================

-- 5.1: Count active employees per department, only departments with > 10 active
SELECT department, COUNT(*) as active_count
FROM employees
WHERE is_active = TRUE
GROUP BY department
HAVING COUNT(*) > 10;

-- 5.2: Average salary per city for employees hired after 2020, only cities with avg > $75,000
SELECT city, ROUND(AVG(salary), 2) as avg_salary
FROM employees
WHERE hire_date > '2020-12-31'
GROUP BY city
HAVING AVG(salary) > 75000;

-- 5.3: Total sales per product in 2024, only products with sales > $20,000
SELECT product_id, SUM(amount) as total_sales_2024
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY product_id
HAVING SUM(amount) > 20000;


-- ============================================
-- Exercise 6: Multiple Conditions in HAVING
-- ============================================

-- 6.1: Departments with > 15 employees AND average salary > $75,000
SELECT 
    department,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 15 AND AVG(salary) > 75000;

-- 6.2: Categories with > 20 products OR average price > $300
SELECT 
    category,
    COUNT(*) as product_count,
    ROUND(AVG(price), 2) as avg_price
FROM products
GROUP BY category
HAVING COUNT(*) > 20 OR AVG(price) > 300;

-- 6.3: Customers with > 8 orders AND total spent > $8000
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_spent
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 8 AND SUM(total) > 8000;


-- ============================================
-- Exercise 7: Complete Queries
-- ============================================

-- 7.1: Active employees by department
SELECT 
    department,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department
HAVING COUNT(*) > 10 AND AVG(salary) > 70000
ORDER BY avg_salary DESC;

-- 7.2: 2024 sales by product
SELECT 
    product_id,
    SUM(quantity) as total_quantity,
    SUM(amount) as total_revenue
FROM sales
WHERE sale_date >= '2024-01-01'
GROUP BY product_id
HAVING SUM(quantity) > 200
ORDER BY total_revenue DESC;

-- 7.3: Customer analysis
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_spent,
    ROUND(AVG(total), 2) as avg_order_value
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY total_spent DESC;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Departments with high salary range
SELECT 
    department,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    MAX(salary) - MIN(salary) as salary_range
FROM employees
GROUP BY department
HAVING MAX(salary) - MIN(salary) > 100000
ORDER BY salary_range DESC;

-- BONUS 2: Categories with high price variance
SELECT 
    category,
    ROUND(AVG(price), 2) as avg_price,
    MAX(price) as max_price,
    ROUND(MAX(price) / AVG(price), 2) as price_ratio
FROM products
GROUP BY category
HAVING MAX(price) > 5 * AVG(price)
ORDER BY price_ratio DESC;

-- BONUS 3: High-spending customers
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_spent,
    ROUND(AVG(total), 2) as avg_order,
    ROUND(SUM(total) / AVG(total), 2) as spending_ratio
FROM orders
GROUP BY customer_id
HAVING SUM(total) > 15 * AVG(total)
ORDER BY total_spent DESC;
