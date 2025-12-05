-- Day 3: ORDER BY and LIMIT
-- Practice exercises for sorting and limiting results
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: Basic ORDER BY (8 min)
-- ============================================

-- 1.1: Sort employees by salary (lowest to highest)
-- TODO: Write your query
-- Expected columns: name, department, salary


-- 1.2: Sort employees by name alphabetically
-- TODO: Write your query
-- Expected columns: name, department


-- 1.3: Sort employees by hire_date (oldest first)
-- TODO: Write your query
-- Expected columns: name, hire_date, department


-- 1.4: Sort products by price (highest to lowest)
-- TODO: Write your query
-- Expected columns: product_name, category, price


-- ============================================
-- Exercise 2: ASC and DESC (8 min)
-- ============================================

-- 2.1: Sort employees by salary DESC (highest paid first)
-- TODO: Write your query
-- Expected columns: name, position, salary


-- 2.2: Sort employees by hire_date DESC (most recent first)
-- TODO: Write your query
-- Expected columns: name, hire_date, department


-- 2.3: Sort products by product_name ASC (A to Z)
-- TODO: Write your query
-- Expected columns: product_name, category, price


-- 2.4: Sort orders by total DESC (largest orders first)
-- TODO: Write your query
-- Expected columns: customer_name, order_date, total


-- ============================================
-- Exercise 3: Multiple Column Sorting (8 min)
-- ============================================

-- 3.1: Sort by department ASC, then salary DESC within each department
-- TODO: Write your query
-- Expected columns: department, name, salary


-- 3.2: Sort by city ASC, then name ASC within each city
-- TODO: Write your query
-- Expected columns: city, name, department


-- 3.3: Sort products by category ASC, then price DESC within each category
-- TODO: Write your query
-- Expected columns: category, product_name, price


-- 3.4: Sort orders by order_date DESC, then customer_name ASC
-- TODO: Write your query
-- Expected columns: order_date, customer_name, total


-- ============================================
-- Exercise 4: LIMIT (8 min)
-- ============================================

-- 4.1: Get top 5 highest paid employees
-- TODO: Write your query
-- Expected columns: name, salary, department


-- 4.2: Get 10 most expensive products
-- TODO: Write your query
-- Expected columns: product_name, price, category


-- 4.3: Get 3 most recent orders
-- TODO: Write your query
-- Expected columns: customer_name, order_date, total


-- 4.4: Get first 20 employees alphabetically
-- TODO: Write your query
-- Expected columns: name, department


-- ============================================
-- Exercise 5: OFFSET and Pagination (8 min)
-- ============================================

-- 5.1: Get employees 11-20 when sorted by name (page 2, 10 per page)
-- TODO: Write your query using LIMIT and OFFSET
-- Expected columns: name, department, salary


-- 5.2: Get products 21-30 when sorted by price DESC (page 3, 10 per page)
-- TODO: Write your query using LIMIT and OFFSET
-- Expected columns: product_name, price, category


-- 5.3: Get orders 6-10 when sorted by date DESC (page 2, 5 per page)
-- TODO: Write your query using LIMIT and OFFSET
-- Expected columns: customer_name, order_date, total


-- 5.4: Get customers 26-50 sorted by total_purchases DESC (page 2, 25 per page)
-- TODO: Write your query using LIMIT and OFFSET
-- Expected columns: first_name, last_name, total_purchases


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Top 10 customers by total purchases with their cities
-- Hint: Sort by total_purchases DESC and limit to 10


-- BONUS 2: Get the 5 lowest rated products that are in stock
-- Hint: Filter stock_quantity > 0, sort by rating ASC, limit 5


-- BONUS 3: Create a leaderboard showing top 15 employees by salary,
--          grouped by department (show department, name, salary)
-- Hint: Sort by department ASC, then salary DESC, limit 15
