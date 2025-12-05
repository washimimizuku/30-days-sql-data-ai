-- Day 13: Subqueries in WHERE - Solutions

-- ============================================
-- PART 1: SCALAR SUBQUERIES
-- ============================================

-- Exercise 1 Solution: Above Average Salary
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY salary DESC;


-- Exercise 2 Solution: Above Average Price
SELECT product_name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
)
ORDER BY price DESC;


-- Exercise 3 Solution: Above Average Order Total
SELECT id, customer_id, total
FROM orders
WHERE total > (
    SELECT AVG(total)
    FROM orders
)
ORDER BY total DESC;


-- Exercise 4 Solution: Oldest in Department
SELECT name, age, department_id
FROM employees
WHERE age > (
    SELECT MAX(age)
    FROM employees e
    JOIN departments d ON e.department_id = d.id
    WHERE d.department_name = 'Sales'
)
ORDER BY age DESC;


-- ============================================
-- PART 2: IN OPERATOR
-- ============================================

-- Exercise 5 Solution: Employees in New York Departments
SELECT name, department_id
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE city = 'New York'
)
ORDER BY name;


-- Exercise 6 Solution: Customers Who Have Ordered
SELECT customer_name
FROM customers
WHERE id IN (
    SELECT DISTINCT customer_id
    FROM orders
)
ORDER BY customer_name;


-- Exercise 7 Solution: Products That Have Been Ordered
SELECT product_name
FROM products
WHERE id IN (
    SELECT DISTINCT product_id
    FROM order_items
)
ORDER BY product_name;


-- Exercise 8 Solution: Customers Without Orders
SELECT customer_name
FROM customers
WHERE id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL
)
ORDER BY customer_name;


-- ============================================
-- PART 3: EXISTS OPERATOR
-- ============================================

-- Exercise 9 Solution: Employees Who Have Orders
SELECT name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.employee_id = e.id
)
ORDER BY name;


-- Exercise 10 Solution: Departments With Employees
SELECT department_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
)
ORDER BY department_name;


-- Exercise 11 Solution: Customers With Large Orders
SELECT customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
    AND o.total > 1000
)
ORDER BY customer_name;


-- Exercise 12 Solution: Products in Orders
SELECT product_name
FROM products p
WHERE EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.id
)
ORDER BY product_name;


-- ============================================
-- PART 4: NOT EXISTS OPERATOR
-- ============================================

-- Exercise 13 Solution: Employees Without Orders
SELECT name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.employee_id = e.id
)
ORDER BY name;


-- Exercise 14 Solution: Customers Without Orders
SELECT customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
)
ORDER BY customer_name;


-- Exercise 15 Solution: Products Never Ordered
SELECT product_name, category
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.id
)
ORDER BY category, product_name;


-- Exercise 16 Solution: Departments Without Employees
SELECT department_name, city
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
)
ORDER BY department_name;


-- ============================================
-- PART 5: ANY AND ALL OPERATORS
-- ============================================

-- Exercise 17 Solution: Salary Greater Than Any in Sales
SELECT name, salary, department_id
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees e
    JOIN departments d ON e.department_id = d.id
    WHERE d.department_name = 'Sales'
)
ORDER BY salary DESC;


-- Exercise 18 Solution: Salary Greater Than All in Sales
SELECT name, salary, department_id
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees e
    JOIN departments d ON e.department_id = d.id
    WHERE d.department_name = 'Sales'
)
ORDER BY salary DESC;


-- Exercise 19 Solution: Cheaper Than Any Electronics
SELECT product_name, price, category
FROM products
WHERE price < ANY (
    SELECT price
    FROM products
    WHERE category = 'Electronics'
)
AND category != 'Electronics'
ORDER BY price;


-- Exercise 20 Solution: More Expensive Than All Books
SELECT product_name, price, category
FROM products
WHERE price > ALL (
    SELECT price
    FROM products
    WHERE category = 'Books'
)
ORDER BY price DESC;
