-- Day 2: WHERE Clause and Filtering - Solutions

-- ============================================
-- Exercise 1: Basic WHERE Conditions
-- ============================================

-- 1.1: Find all employees with salary greater than 70000
SELECT name, department, salary
FROM employees
WHERE salary > 70000
ORDER BY salary DESC;

-- 1.2: Find all employees in the 'Engineering' department
SELECT name, position, salary
FROM employees
WHERE department = 'Engineering';

-- 1.3: Find all employees hired after '2022-01-01'
SELECT name, hire_date, department
FROM employees
WHERE hire_date > '2022-01-01';

-- 1.4: Find all products with price exactly 50.00
SELECT product_name, category, price
FROM products
WHERE price = 50.00;


-- ============================================
-- Exercise 2: Logical Operators
-- ============================================

-- 2.1: Find employees in 'Engineering' with salary > 75000
SELECT name, position, salary
FROM employees
WHERE department = 'Engineering' 
  AND salary > 75000;

-- 2.2: Find employees in either 'Sales' or 'Marketing' departments
SELECT name, department, city
FROM employees
WHERE department = 'Sales' 
   OR department = 'Marketing';

-- 2.3: Find employees NOT in the 'HR' department
SELECT name, department
FROM employees
WHERE department != 'HR';
-- Alternative: WHERE NOT department = 'HR'

-- 2.4: Find employees in 'Engineering' OR 'Sales' with salary > 70000
SELECT name, department, salary
FROM employees
WHERE (department = 'Engineering' OR department = 'Sales')
  AND salary > 70000;


-- ============================================
-- Exercise 3: IN and BETWEEN Operators
-- ============================================

-- 3.1: Find employees in cities: 'New York', 'London', 'Tokyo'
SELECT name, city, department
FROM employees
WHERE city IN ('New York', 'London', 'Tokyo');

-- 3.2: Find products in categories: 'Electronics', 'Books', 'Clothing'
SELECT product_name, category, price
FROM products
WHERE category IN ('Electronics', 'Books', 'Clothing');

-- 3.3: Find employees with salary between 50000 and 80000 (inclusive)
SELECT name, salary, department
FROM employees
WHERE salary BETWEEN 50000 AND 80000;

-- 3.4: Find employees hired between '2020-01-01' and '2022-12-31'
SELECT name, hire_date, department
FROM employees
WHERE hire_date BETWEEN '2020-01-01' AND '2022-12-31';


-- ============================================
-- Exercise 4: LIKE Operator
-- ============================================

-- 4.1: Find employees whose name starts with 'J'
SELECT name, department
FROM employees
WHERE name LIKE 'J%';

-- 4.2: Find employees whose email ends with '@company.com'
SELECT name, email
FROM employees
WHERE email LIKE '%@company.com';

-- 4.3: Find employees whose name contains 'son'
SELECT name
FROM employees
WHERE name LIKE '%son%';

-- 4.4: Find products with product_code exactly 7 characters long
SELECT product_name, product_code
FROM products
WHERE product_code LIKE '_______';


-- ============================================
-- Exercise 5: IS NULL
-- ============================================

-- 5.1: Find employees with no phone number (NULL)
SELECT name, email, phone
FROM employees
WHERE phone IS NULL;

-- 5.2: Find employees with an email address (NOT NULL)
SELECT name, email, department
FROM employees
WHERE email IS NOT NULL;


-- ============================================
-- Exercise 6: Complex Conditions
-- ============================================

-- 6.1: Find employees in 'Engineering' or 'Sales', with salary > 70000, hired after '2021-01-01'
SELECT name, department, salary, hire_date
FROM employees
WHERE (department = 'Engineering' OR department = 'Sales')
  AND salary > 70000
  AND hire_date > '2021-01-01';

-- 6.2: Find employees whose name starts with 'J' or 'M', in cities 'New York' or 'London'
SELECT name, city, department
FROM employees
WHERE (name LIKE 'J%' OR name LIKE 'M%')
  AND city IN ('New York', 'London');

-- 6.3: Find products with price between 20 and 100, category in ('Electronics', 'Books'), 
--      and description NOT NULL
SELECT product_name, category, price, description
FROM products
WHERE price BETWEEN 20 AND 100
  AND category IN ('Electronics', 'Books')
  AND description IS NOT NULL;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Find employees with salary in top 25% (> 90000) OR in 'Engineering' with > 70000
SELECT name, department, salary
FROM employees
WHERE salary > 90000
   OR (department = 'Engineering' AND salary > 70000)
ORDER BY salary DESC;

-- BONUS 2: Find products that are either:
--          - Electronics under $100, OR
--          - Books under $30, OR
--          - Clothing under $50
SELECT product_name, category, price
FROM products
WHERE (category = 'Electronics' AND price < 100)
   OR (category = 'Books' AND price < 30)
   OR (category = 'Clothing' AND price < 50)
ORDER BY category, price;

-- BONUS 3: Count how many employees have salary > 80000
SELECT COUNT(*) as high_earners
FROM employees
WHERE salary > 80000;
