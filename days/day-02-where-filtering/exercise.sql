-- Day 2: WHERE Clause and Filtering
-- Practice exercises for filtering data

-- ============================================
-- Exercise 1: Basic WHERE Conditions (10 min)
-- ============================================

-- 1.1: Find all employees with salary greater than 70000
-- TODO: Write your query
-- Expected columns: name, department, salary
-- Order by salary descending


-- 1.2: Find all employees in the 'Engineering' department
-- TODO: Write your query
-- Expected columns: name, position, salary


-- 1.3: Find all employees hired after '2022-01-01'
-- TODO: Write your query
-- Expected columns: name, hire_date, department


-- 1.4: Find all employees with salary less than or equal to 60000
-- TODO: Write your query
-- Expected columns: name, salary, city


-- 1.5: Find all products with price exactly 50.00
-- TODO: Write your query
-- Expected columns: product_name, category, price


-- ============================================
-- Exercise 2: Logical Operators (10 min)
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


-- 2.5: Find products in 'Electronics' category with price < 100
-- TODO: Use AND operator
-- Expected columns: product_name, price, stock_quantity


-- 2.6: Find employees in 'New York' or 'London' with salary > 80000
-- TODO: Combine city and salary conditions
-- Expected columns: name, city, salary


-- ============================================
-- Exercise 3: IN Operator (10 min)
-- ============================================

-- 3.1: Find employees in cities: 'New York', 'London', 'Tokyo'
-- TODO: Use IN operator
-- Expected columns: name, city, department


-- 3.2: Find employees in departments: 'Engineering', 'Sales', 'Marketing'
-- TODO: Use IN operator
-- Expected columns: name, department, position


-- 3.3: Find employees NOT in cities: 'Paris', 'Berlin'
-- TODO: Use NOT IN operator
-- Expected columns: name, city


-- 3.4: Find products in categories: 'Electronics', 'Books', 'Clothing'
-- TODO: Use IN operator
-- Expected columns: product_name, category, price


-- 3.5: Find customers in countries: 'USA', 'UK', 'Canada'
-- TODO: Use IN operator
-- Expected columns: first_name, last_name, country


-- ============================================
-- Exercise 4: BETWEEN Operator (10 min)
-- ============================================

-- 4.1: Find employees with salary between 50000 and 80000 (inclusive)
-- TODO: Use BETWEEN operator
-- Expected columns: name, salary, department


-- 4.2: Find employees hired between '2020-01-01' and '2022-12-31'
-- TODO: Use BETWEEN with dates
-- Expected columns: name, hire_date, department


-- 4.3: Find products with price between 10 and 50
-- TODO: Use BETWEEN operator
-- Expected columns: product_name, category, price


-- 4.4: Find employees with salary NOT between 40000 and 60000
-- TODO: Use NOT BETWEEN
-- Expected columns: name, salary


-- 4.5: Find products with stock_quantity between 50 and 150
-- TODO: Use BETWEEN operator
-- Expected columns: product_name, stock_quantity, category


-- ============================================
-- Exercise 5: LIKE Operator (10 min)
-- ============================================

-- 5.1: Find employees whose name starts with 'J'
-- TODO: Use LIKE with % wildcard
-- Expected columns: name, department


-- 5.2: Find employees whose email ends with '@company.com'
-- TODO: Use LIKE with % wildcard
-- Expected columns: name, email


-- 5.3: Find employees whose name contains 'son'
-- TODO: Use LIKE with % on both sides
-- Expected columns: name


-- 5.4: Find products with product_code exactly 7 characters long
-- TODO: Use LIKE with _ wildcards (7 underscores)
-- Expected columns: product_name, product_code


-- 5.5: Find employees whose name does NOT start with 'A'
-- TODO: Use NOT LIKE
-- Expected columns: name, department


-- 5.6: Find products whose name contains 'Laptop' or 'Phone'
-- TODO: Use LIKE with OR
-- Expected columns: product_name, category, price


-- ============================================
-- Exercise 6: IS NULL (5 min)
-- ============================================

-- 6.1: Find employees with no phone number (NULL)
-- TODO: Use IS NULL
-- Expected columns: name, email, phone


-- 6.2: Find employees with an email address (NOT NULL)
-- TODO: Use IS NOT NULL
-- Expected columns: name, email, department


-- 6.3: Find products with no description (NULL)
-- TODO: Use IS NULL
-- Expected columns: product_name, category, description


-- 6.4: Find customers with no email (NULL)
-- TODO: Use IS NULL
-- Expected columns: first_name, last_name, city


-- ============================================
-- Exercise 7: Complex Conditions (10 min)
-- ============================================

-- 7.1: Find employees in 'Engineering' or 'Sales', with salary > 70000, hired after '2021-01-01'
-- TODO: Combine multiple conditions with proper parentheses
-- Expected columns: name, department, salary, hire_date


-- 7.2: Find employees whose name starts with 'J' or 'M', in cities 'New York' or 'London'
-- TODO: Use LIKE with OR, and IN for cities
-- Expected columns: name, city, department


-- 7.3: Find products with price between 20 and 100, category in ('Electronics', 'Books'), 
--      and description NOT NULL
-- TODO: Combine BETWEEN, IN, and IS NOT NULL
-- Expected columns: product_name, category, price, description


-- 7.4: Find active employees in 'Engineering', 'Sales', or 'Marketing' departments,
--      with salary > 60000, hired before '2023-01-01'
-- TODO: Combine multiple conditions
-- Expected columns: name, department, salary, hire_date, is_active


-- 7.5: Find products in 'Electronics' or 'Clothing' categories,
--      with price < 200, stock > 50, and available
-- TODO: Combine multiple conditions
-- Expected columns: product_name, category, price, stock_quantity


-- ============================================
-- Exercise 8: Counting with WHERE (5 min)
-- ============================================

-- 8.1: Count how many employees have salary > 80000
-- TODO: Use COUNT(*) with WHERE
-- Expected: Single number


-- 8.2: Count how many products are in 'Electronics' category
-- TODO: Use COUNT(*) with WHERE
-- Expected: Single number


-- 8.3: Count how many employees were hired in 2022
-- TODO: Use COUNT(*) with BETWEEN on dates
-- Expected: Single number


-- 8.4: Count how many customers are premium members
-- TODO: Use COUNT(*) with WHERE on boolean
-- Expected: Single number


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Find employees with salary in top 25% (> 90000) OR in 'Engineering' with > 70000
-- Hint: Use OR with grouped conditions


-- BONUS 2: Find products that are either:
--          - Electronics under $100, OR
--          - Books under $30, OR
--          - Clothing under $50
-- Hint: Use multiple OR conditions with AND


-- BONUS 3: Find employees whose name has exactly 2 words (first and last name)
-- Hint: Use LIKE with space and wildcards


-- BONUS 4: Find all inactive employees who were hired before 2020 and have salary > 70000
-- Hint: Combine is_active, hire_date, and salary conditions
