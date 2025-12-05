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

-- 1.4: Find all employees with salary less than or equal to 60000
SELECT name, salary, city
FROM employees
WHERE salary <= 60000;

-- 1.5: Find all products with price exactly 50.00
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

-- 2.5: Find products in 'Electronics' category with price < 100
SELECT product_name, price, stock_quantity
FROM products
WHERE category = 'Electronics' 
  AND price < 100;

-- 2.6: Find employees in 'New York' or 'London' with salary > 80000
SELECT name, city, salary
FROM employees
WHERE (city = 'New York' OR city = 'London')
  AND salary > 80000;


-- ============================================
-- Exercise 3: IN Operator
-- ============================================

-- 3.1: Find employees in cities: 'New York', 'London', 'Tokyo'
SELECT name, city, department
FROM employees
WHERE city IN ('New York', 'London', 'Tokyo');

-- 3.2: Find employees in departments: 'Engineering', 'Sales', 'Marketing'
SELECT name, department, position
FROM employees
WHERE department IN ('Engineering', 'Sales', 'Marketing');

-- 3.3: Find employees NOT in cities: 'Paris', 'Berlin'
SELECT name, city
FROM employees
WHERE city NOT IN ('Paris', 'Berlin');

-- 3.4: Find products in categories: 'Electronics', 'Books', 'Clothing'
SELECT product_name, category, price
FROM products
WHERE category IN ('Electronics', 'Books', 'Clothing');

-- 3.5: Find customers in countries: 'USA', 'UK', 'Canada'
SELECT first_name, last_name, country
FROM customers
WHERE country IN ('USA', 'UK', 'Canada');


-- ============================================
-- Exercise 4: BETWEEN Operator
-- ============================================

-- 4.1: Find employees with salary between 50000 and 80000 (inclusive)
SELECT name, salary, department
FROM employees
WHERE salary BETWEEN 50000 AND 80000;

-- 4.2: Find employees hired between '2020-01-01' and '2022-12-31'
SELECT name, hire_date, department
FROM employees
WHERE hire_date BETWEEN '2020-01-01' AND '2022-12-31';

-- 4.3: Find products with price between 10 and 50
SELECT product_name, category, price
FROM products
WHERE price BETWEEN 10 AND 50;

-- 4.4: Find employees with salary NOT between 40000 and 60000
SELECT name, salary
FROM employees
WHERE salary NOT BETWEEN 40000 AND 60000;

-- 4.5: Find products with stock_quantity between 50 and 150
SELECT product_name, stock_quantity, category
FROM products
WHERE stock_quantity BETWEEN 50 AND 150;


-- ============================================
-- Exercise 5: LIKE Operator
-- ============================================

-- 5.1: Find employees whose name starts with 'J'
SELECT name, department
FROM employees
WHERE name LIKE 'J%';

-- 5.2: Find employees whose email ends with '@company.com'
SELECT name, email
FROM employees
WHERE email LIKE '%@company.com';

-- 5.3: Find employees whose name contains 'son'
SELECT name
FROM employees
WHERE name LIKE '%son%';

-- 5.4: Find products with product_code exactly 7 characters long
SELECT product_name, product_code
FROM products
WHERE product_code LIKE '_______';

-- 5.5: Find employees whose name does NOT start with 'A'
SELECT name, department
FROM employees
WHERE name NOT LIKE 'A%';

-- 5.6: Find products whose name contains 'Laptop' or 'Phone'
SELECT product_name, category, price
FROM products
WHERE product_name LIKE '%Laptop%' 
   OR product_name LIKE '%Phone%';


-- ============================================
-- Exercise 6: IS NULL
-- ============================================

-- 6.1: Find employees with no phone number (NULL)
SELECT name, email, phone
FROM employees
WHERE phone IS NULL;

-- 6.2: Find employees with an email address (NOT NULL)
SELECT name, email, department
FROM employees
WHERE email IS NOT NULL;

-- 6.3: Find products with no description (NULL)
SELECT product_name, category, description
FROM products
WHERE description IS NULL;

-- 6.4: Find customers with no email (NULL)
SELECT first_name, last_name, city
FROM customers
WHERE email IS NULL;


-- ============================================
-- Exercise 7: Complex Conditions
-- ============================================

-- 7.1: Find employees in 'Engineering' or 'Sales', with salary > 70000, hired after '2021-01-01'
SELECT name, department, salary, hire_date
FROM employees
WHERE (department = 'Engineering' OR department = 'Sales')
  AND salary > 70000
  AND hire_date > '2021-01-01';

-- 7.2: Find employees whose name starts with 'J' or 'M', in cities 'New York' or 'London'
SELECT name, city, department
FROM employees
WHERE (name LIKE 'J%' OR name LIKE 'M%')
  AND city IN ('New York', 'London');

-- 7.3: Find products with price between 20 and 100, category in ('Electronics', 'Books'), 
--      and description NOT NULL
SELECT product_name, category, price, description
FROM products
WHERE price BETWEEN 20 AND 100
  AND category IN ('Electronics', 'Books')
  AND description IS NOT NULL;

-- 7.4: Find active employees in 'Engineering', 'Sales', or 'Marketing' departments,
--      with salary > 60000, hired before '2023-01-01'
SELECT name, department, salary, hire_date, is_active
FROM employees
WHERE is_active = TRUE
  AND department IN ('Engineering', 'Sales', 'Marketing')
  AND salary > 60000
  AND hire_date < '2023-01-01';

-- 7.5: Find products in 'Electronics' or 'Clothing' categories,
--      with price < 200, stock > 50, and available
SELECT product_name, category, price, stock_quantity
FROM products
WHERE category IN ('Electronics', 'Clothing')
  AND price < 200
  AND stock_quantity > 50
  AND is_available = TRUE;


-- ============================================
-- Exercise 8: Counting with WHERE
-- ============================================

-- 8.1: Count how many employees have salary > 80000
SELECT COUNT(*) as high_earners
FROM employees
WHERE salary > 80000;

-- 8.2: Count how many products are in 'Electronics' category
SELECT COUNT(*) as electronics_count
FROM products
WHERE category = 'Electronics';

-- 8.3: Count how many employees were hired in 2022
SELECT COUNT(*) as hired_2022
FROM employees
WHERE hire_date BETWEEN '2022-01-01' AND '2022-12-31';

-- 8.4: Count how many customers are premium members
SELECT COUNT(*) as premium_customers
FROM customers
WHERE is_premium = TRUE;


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

-- BONUS 3: Find employees whose name has exactly 2 words (first and last name)
SELECT name
FROM employees
WHERE name LIKE '% %'
  AND name NOT LIKE '% % %';

-- BONUS 4: Find all inactive employees who were hired before 2020 and have salary > 70000
SELECT name, hire_date, salary, is_active
FROM employees
WHERE is_active = FALSE
  AND hire_date < '2020-01-01'
  AND salary > 70000;
