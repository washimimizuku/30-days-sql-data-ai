-- Day 16: Window Functions - ROW_NUMBER, RANK, DENSE_RANK
-- Practice exercises for window functions

-- ============================================
-- Exercise 1: Basic ROW_NUMBER (5 min)
-- ============================================

-- 1.1: Assign row numbers to all employees ordered by salary (highest first)
-- TODO: Write your query
-- Expected columns: name, department, salary, row_num


-- 1.2: Assign row numbers ordered by hire_date (earliest first)
-- TODO: Write your query
-- Expected columns: name, hire_date, row_num


-- 1.3: Assign row numbers ordered by name alphabetically
-- TODO: Write your query
-- Expected columns: name, row_num


-- 1.4: Number employees within each department (reset numbering per department)
-- TODO: Write your query
-- Expected columns: name, department, salary, dept_row_num


-- ============================================
-- Exercise 2: RANK vs DENSE_RANK (10 min)
-- ============================================

-- 2.1: Show the difference between ROW_NUMBER, RANK, and DENSE_RANK
-- TODO: Write a single query showing all three functions
-- Order by salary descending
-- Expected columns: name, salary, row_num, rank, dense_rank


-- 2.2: Rank employees by salary within each department
-- TODO: Use RANK() with PARTITION BY
-- Expected columns: name, department, salary, dept_rank


-- 2.3: Find employees who share the same salary rank
-- TODO: Use RANK() and filter for ranks that appear more than once
-- Hint: Use a CTE


-- ============================================
-- Exercise 3: PARTITION BY Mastery (10 min)
-- ============================================

-- 3.1: Rank employees within each department by salary
-- TODO: Write your query
-- Expected columns: name, department, salary, rank_in_dept


-- 3.2: Assign row numbers to products within each category
-- TODO: Order by price descending within each category
-- Expected columns: product_name, category, price, row_num


-- 3.3: Rank salespeople within each region by total sales
-- TODO: Write your query
-- Expected columns: salesperson_name, region, total_sales, region_rank


-- 3.4: Number orders for each customer by order date
-- TODO: Most recent order should be #1
-- Expected columns: customer_name, order_date, order_amount, order_number


-- ============================================
-- Exercise 4: Top N per Group (10 min)
-- ============================================

-- 4.1: Find the top 3 highest-paid employees in each department
-- TODO: Use ROW_NUMBER() with PARTITION BY and filter with CTE
-- Expected columns: name, department, salary, rank_in_dept


-- 4.2: Find the top 2 best-selling products in each category
-- TODO: Use total quantity sold
-- Expected columns: category, product_name, total_quantity, rank_in_category


-- 4.3: Get the 5 most recent orders for each customer
-- TODO: Order by order_date descending
-- Expected columns: customer_name, order_date, order_amount, order_rank


-- 4.4: Find the highest and lowest paid employee in each department
-- TODO: Use window functions to identify both in one query
-- Hint: Use RANK() for highest and another window function for lowest


-- ============================================
-- Exercise 5: Advanced Patterns (5 min)
-- ============================================

-- 5.1: Divide employees into 4 salary quartiles
-- TODO: Use NTILE(4)
-- Expected columns: name, salary, salary_quartile


-- 5.2: Calculate the percentile rank of each employee's salary
-- TODO: Use PERCENT_RANK()
-- Expected columns: name, salary, percentile_rank


-- 5.3: Find duplicate emails and number each occurrence
-- TODO: Use ROW_NUMBER() PARTITION BY email
-- Expected columns: name, email, hire_date, occurrence_number


-- 5.4: Find gaps in order IDs
-- TODO: Use ROW_NUMBER() to find missing sequential IDs
-- Expected: List of missing order IDs


-- 5.5: Create a sales leaderboard showing all three ranking methods
-- TODO: Show ROW_NUMBER, RANK, and DENSE_RANK for total sales
-- Expected columns: salesperson_name, total_sales, row_num, rank, dense_rank


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Find the median salary for each department
-- Hint: Use NTILE(2) or PERCENT_RANK()


-- BONUS 2: Identify the top 10% of earners in the company
-- Hint: Use PERCENT_RANK() or NTILE(10)


-- BONUS 3: Find employees whose salary is above their department average
-- Hint: Combine window functions with WHERE clause using CTE


-- BONUS 4: Create a running rank that resets each month
-- TODO: Rank orders within each month by amount
-- Expected columns: order_date, order_amount, month, rank_in_month
