-- Day 4: Aggregate Functions - COUNT, SUM, AVG, MIN, MAX
-- Practice exercises for aggregate functions
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: COUNT (8 min)
-- ============================================

-- 1.1: Count total number of employees
-- TODO: Write your query
-- Expected: Single number


-- 1.2: Count employees with non-NULL email addresses
-- TODO: Write your query
-- Hint: Use COUNT(email)


-- 1.3: Count unique cities where employees are located
-- TODO: Write your query
-- Hint: Use COUNT(DISTINCT city)


-- 1.4: Count employees in the 'Engineering' department
-- TODO: Write your query
-- Hint: Use WHERE clause


-- 1.5: Count orders with status 'Delivered'
-- TODO: Write your query


-- ============================================
-- Exercise 2: SUM (8 min)
-- ============================================

-- 2.1: Calculate total payroll (sum of all salaries)
-- TODO: Write your query
-- Expected: Single number


-- 2.2: Calculate total sales amount from orders
-- TODO: Write your query
-- Hint: SUM(total) from orders table


-- 2.3: Calculate total quantity of products in inventory
-- TODO: Write your query
-- Hint: SUM(stock_quantity) from products


-- 2.4: Calculate total refund amount (where type = 'refund')
-- TODO: Write your query
-- Hint: Use transactions table with WHERE


-- 2.5: Calculate sum of salaries for 'Sales' department
-- TODO: Write your query


-- ============================================
-- Exercise 3: AVG (8 min)
-- ============================================

-- 3.1: Calculate average salary across all employees
-- TODO: Write your query
-- Hint: Use ROUND(AVG(salary), 2) for cleaner output


-- 3.2: Calculate average order value
-- TODO: Write your query


-- 3.3: Calculate average product price
-- TODO: Write your query


-- 3.4: Calculate average salary in 'Engineering' department
-- TODO: Write your query


-- 3.5: Calculate average age of employees
-- TODO: Write your query


-- ============================================
-- Exercise 4: MIN and MAX (8 min)
-- ============================================

-- 4.1: Find the lowest and highest salary
-- TODO: Write your query showing both MIN and MAX


-- 4.2: Find the earliest and latest hire date
-- TODO: Write your query


-- 4.3: Find the cheapest and most expensive product
-- TODO: Write your query


-- 4.4: Find the minimum and maximum order total
-- TODO: Write your query


-- 4.5: Find alphabetically first and last employee name
-- TODO: Write your query
-- Hint: MIN and MAX work on strings too!


-- ============================================
-- Exercise 5: Multiple Aggregates (8 min)
-- ============================================

-- 5.1: Show count, sum, avg, min, max of salaries
-- TODO: Write your query with all 5 aggregate functions
-- Expected columns: employee_count, total_payroll, avg_salary, min_salary, max_salary


-- 5.2: Show order statistics (count, total, average, min, max)
-- TODO: Write your query
-- Expected columns: order_count, total_revenue, avg_order, min_order, max_order


-- 5.3: Show product statistics (count, avg price, min price, max price)
-- TODO: Write your query


-- 5.4: Show sales statistics (count, total amount, avg amount)
-- TODO: Write your query using sales table


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Calculate the salary range (difference between max and min)
-- Hint: MAX(salary) - MIN(salary)


-- BONUS 2: Find the average order value for orders over $1000
-- Hint: Use WHERE before aggregating


-- BONUS 3: Count how many unique customers have placed orders
-- Hint: Use COUNT(DISTINCT customer_id)


-- BONUS 4: Calculate total profit from products (assuming all are sold once)
-- Hint: SUM(price - cost) from products
