-- Day 3: ORDER BY and LIMIT - Solutions

-- ============================================
-- Exercise 1: Basic ORDER BY
-- ============================================

-- 1.1: Sort employees by salary (lowest to highest)
SELECT name, department, salary
FROM employees
ORDER BY salary;
-- Default is ASC (ascending)

-- 1.2: Sort employees by name alphabetically
SELECT name, department
FROM employees
ORDER BY name;

-- 1.3: Sort employees by hire_date (oldest first)
SELECT name, hire_date, department
FROM employees
ORDER BY hire_date;

-- 1.4: Sort products by price (highest to lowest)
SELECT product_name, category, price
FROM products
ORDER BY price DESC;


-- ============================================
-- Exercise 2: ASC and DESC
-- ============================================

-- 2.1: Sort employees by salary DESC (highest paid first)
SELECT name, position, salary
FROM employees
ORDER BY salary DESC;

-- 2.2: Sort employees by hire_date DESC (most recent first)
SELECT name, hire_date, department
FROM employees
ORDER BY hire_date DESC;

-- 2.3: Sort products by product_name ASC (A to Z)
SELECT product_name, category, price
FROM products
ORDER BY product_name ASC;

-- 2.4: Sort orders by total DESC (largest orders first)
SELECT customer_name, order_date, total
FROM orders
ORDER BY total DESC;


-- ============================================
-- Exercise 3: Multiple Column Sorting
-- ============================================

-- 3.1: Sort by department ASC, then salary DESC within each department
SELECT department, name, salary
FROM employees
ORDER BY department ASC, salary DESC;

-- 3.2: Sort by city ASC, then name ASC within each city
SELECT city, name, department
FROM employees
ORDER BY city ASC, name ASC;

-- 3.3: Sort products by category ASC, then price DESC within each category
SELECT category, product_name, price
FROM products
ORDER BY category ASC, price DESC;

-- 3.4: Sort orders by order_date DESC, then customer_name ASC
SELECT order_date, customer_name, total
FROM orders
ORDER BY order_date DESC, customer_name ASC;


-- ============================================
-- Exercise 4: LIMIT
-- ============================================

-- 4.1: Get top 5 highest paid employees
SELECT name, salary, department
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- 4.2: Get 10 most expensive products
SELECT product_name, price, category
FROM products
ORDER BY price DESC
LIMIT 10;

-- 4.3: Get 3 most recent orders
SELECT customer_name, order_date, total
FROM orders
ORDER BY order_date DESC
LIMIT 3;

-- 4.4: Get first 20 employees alphabetically
SELECT name, department
FROM employees
ORDER BY name
LIMIT 20;


-- ============================================
-- Exercise 5: OFFSET and Pagination
-- ============================================

-- 5.1: Get employees 11-20 when sorted by name (page 2, 10 per page)
SELECT name, department, salary
FROM employees
ORDER BY name
LIMIT 10 OFFSET 10;
-- Formula: OFFSET = (page - 1) * page_size = (2 - 1) * 10 = 10

-- 5.2: Get products 21-30 when sorted by price DESC (page 3, 10 per page)
SELECT product_name, price, category
FROM products
ORDER BY price DESC
LIMIT 10 OFFSET 20;
-- Formula: OFFSET = (3 - 1) * 10 = 20

-- 5.3: Get orders 6-10 when sorted by date DESC (page 2, 5 per page)
SELECT customer_name, order_date, total
FROM orders
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;
-- Formula: OFFSET = (2 - 1) * 5 = 5

-- 5.4: Get customers 26-50 sorted by total_purchases DESC (page 2, 25 per page)
SELECT first_name, last_name, total_purchases
FROM customers
ORDER BY total_purchases DESC
LIMIT 25 OFFSET 25;
-- Formula: OFFSET = (2 - 1) * 25 = 25


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Top 10 customers by total purchases with their cities
SELECT first_name, last_name, city, total_purchases
FROM customers
ORDER BY total_purchases DESC
LIMIT 10;

-- BONUS 2: Get the 5 lowest rated products that are in stock
SELECT product_name, category, rating, stock_quantity
FROM products
WHERE stock_quantity > 0
ORDER BY rating ASC
LIMIT 5;

-- BONUS 3: Create a leaderboard showing top 15 employees by salary,
--          grouped by department
SELECT department, name, salary
FROM employees
ORDER BY department ASC, salary DESC
LIMIT 15;
