-- Day 2: WHERE Clause and Filtering
-- Practice exercises for filtering data
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: Basic WHERE Conditions (8 min)
-- ============================================

-- 1.1: Find all employees with salary greater than 70000
-- TODO: Write your query
-- Expected columns: name, department, salary


-- 1.2: Find all employees in the 'Engineering' department
-- TODO: Write your query
-- Expected columns: name, position, salary


-- 1.3: Find all employees hired after '2022-01-01'
-- TODO: Write your query
-- Expected columns: name, hire_date, department


-- 1.4: Find all products with price exactly 50.00
-- TODO: Write your query
-- Expected columns: product_name, category, price


-- ============================================
-- Exercise 2: Logical Operators (8 min)
-- ============================================

-- 2.1: Find employees in 'Engineering' with salary > 75000
-- TODO: Use AND operator
-- Expected columns: name, position, salary


-- 2.2: Find employees in either 'Sales' or 'Marketing' departments
-- TODO: Use OR operator
-- Expected columns: name, department, city


-- 2.3: Find employees NOT in the 'HR' department
-- TODO: Use NOT operator or != 
-- Expected columns: name, department


-- 2.4: Find employees in 'Engineering' OR 'Sales' with salary > 70000
-- TODO: Use parentheses to group conditions correctly
-- Expected columns: name, department, salary


-- ============================================
-- Exercise 3: IN and BETWEEN Operators (8 min)
-- ============================================

-- 3.1: Find employees in cities: 'New York', 'London', 'Tokyo'
-- TODO: Use IN operator
-- Expected columns: name, city, department


-- 3.2: Find products in categories: 'Electronics', 'Books', 'Clothing'
-- TODO: Use IN operator
-- Expected columns: product_name, category, price


-- 3.3: Find employees with salary between 50000 and 80000 (inclusive)
-- TODO: Use BETWEEN operator
-- Expected columns: name, salary, department


-- 3.4: Find employees hired between '2020-01-01' and '2022-12-31'
-- TODO: Use BETWEEN with dates
-- Expected columns: name, hire_date, department


-- ============================================
-- Exercise 4: LIKE Operator (8 min)
-- ============================================

-- 4.1: Find employees whose name starts with 'J'
-- TODO: Use LIKE with % wildcard
-- Expected columns: name, department


-- 4.2: Find employees whose email ends with '@company.com'
-- TODO: Use LIKE with % wildcard
-- Expected columns: name, email


-- 4.3: Find employees whose name contains 'son'
-- TODO: Use LIKE with % on both sides
-- Expected columns: name


-- 4.4: Find products with product_code exactly 7 characters long
-- TODO: Use LIKE with _ wildcards (7 underscores)
-- Expected columns: product_name, product_code


-- ============================================
-- Exercise 5: IS NULL (4 min)
-- ============================================

-- 5.1: Find employees with no phone number (NULL)
-- TODO: Use IS NULL
-- Expected columns: name, email, phone


-- 5.2: Find employees with an email address (NOT NULL)
-- TODO: Use IS NOT NULL
-- Expected columns: name, email, department


-- ============================================
-- Exercise 6: Complex Conditions (8 min)
-- ============================================

-- 6.1: Find employees in 'Engineering' or 'Sales', with salary > 70000, hired after '2021-01-01'
-- TODO: Combine multiple conditions with proper parentheses
-- Expected columns: name, department, salary, hire_date


-- 6.2: Find employees whose name starts with 'J' or 'M', in cities 'New York' or 'London'
-- TODO: Use LIKE with OR, and IN for cities
-- Expected columns: name, city, department


-- 6.3: Find products with price between 20 and 100, category in ('Electronics', 'Books'), 
--      and description NOT NULL
-- TODO: Combine BETWEEN, IN, and IS NOT NULL
-- Expected columns: product_name, category, price, description


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Find employees with salary in top 25% (> 90000) OR in 'Engineering' with > 70000
-- Hint: Use OR with grouped conditions


-- BONUS 2: Find products that are either:
--          - Electronics under $100, OR
--          - Books under $30, OR
--          - Clothing under $50
-- Hint: Use multiple OR conditions with AND


-- BONUS 3: Count how many employees have salary > 80000
-- Hint: Use COUNT(*) with WHERE
