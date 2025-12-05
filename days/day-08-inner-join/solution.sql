-- Day 8: INNER JOIN - Solutions

-- ============================================
-- Exercise 1: Basic INNER JOIN
-- ============================================

-- 1.1: Join employees with departments
SELECT 
    e.name,
    d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;

-- 1.2: Join products with categories
SELECT 
    p.product_name,
    c.category_name
FROM products p
INNER JOIN categories c
  ON p.category_id = c.id;

-- 1.3: Join orders with customers
SELECT 
    o.id as order_id,
    o.order_date,
    c.customer_name
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.id;

-- 1.4: Join employees with departments (with salary)
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;


-- ============================================
-- Exercise 2: Using Table Aliases
-- ============================================

-- 2.1: Employees with departments using aliases
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;

-- 2.2: Products with categories using aliases
SELECT 
    p.product_name,
    p.price,
    c.category_name
FROM products p
INNER JOIN categories c
  ON p.category_id = c.id;

-- 2.3: Orders with customers using aliases
SELECT 
    o.id,
    c.customer_name,
    o.total
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.id;


-- ============================================
-- Exercise 3: INNER JOIN with WHERE
-- ============================================

-- 3.1: Only Engineering department
SELECT 
    e.name,
    d.department_name,
    e.salary
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
WHERE d.department_name = 'Engineering';

-- 3.2: Products with price > 100
SELECT 
    p.product_name,
    c.category_name,
    p.price
FROM products p
INNER JOIN categories c
  ON p.category_id = c.id
WHERE p.price > 100;

-- 3.3: Orders from 2024
SELECT 
    o.id as order_id,
    c.customer_name,
    o.order_date,
    o.total
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.id
WHERE o.order_date >= '2024-01-01';

-- 3.4: Active employees with salary > 70000
SELECT 
    e.name,
    d.department_name,
    e.salary
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
WHERE e.is_active = TRUE
  AND e.salary > 70000;


-- ============================================
-- Exercise 4: Multiple Table JOINs
-- ============================================

-- 4.1: Employees → departments → locations
SELECT 
    e.name,
    d.department_name,
    l.city
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
INNER JOIN locations l
  ON d.location_id = l.id;

-- 4.2: Order_items → orders → customers
SELECT 
    o.id as order_id,
    c.customer_name,
    oi.product_id,
    oi.quantity
FROM order_items oi
INNER JOIN orders o
  ON oi.order_id = o.id
INNER JOIN customers c
  ON o.customer_id = c.id;

-- 4.3: Products in stock, ordered by price
SELECT 
    p.product_name,
    c.category_name,
    p.price
FROM products p
INNER JOIN categories c
  ON p.category_id = c.id
WHERE p.in_stock = TRUE
ORDER BY p.price DESC;


-- ============================================
-- Exercise 5: INNER JOIN with Aggregates
-- ============================================

-- 5.1: Count employees per department
SELECT 
    d.department_name,
    COUNT(e.id) as employee_count
FROM departments d
INNER JOIN employees e
  ON d.id = e.department_id
GROUP BY d.department_name;

-- 5.2: Total sales per customer
SELECT 
    c.customer_name,
    SUM(o.total) as total_spent
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id
GROUP BY c.customer_name;

-- 5.3: Count products per category
SELECT 
    c.category_name,
    COUNT(p.id) as product_count
FROM categories c
INNER JOIN products p
  ON c.id = p.category_id
GROUP BY c.category_name;


-- ============================================
-- Exercise 6: Complex Queries
-- ============================================

-- 6.1: Top 10 customers by spending
SELECT 
    c.customer_name,
    SUM(o.total) as total_spent
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- 6.2: Department report with location
SELECT 
    d.department_name,
    l.city,
    COUNT(e.id) as employee_count,
    ROUND(AVG(e.salary), 2) as avg_salary
FROM departments d
INNER JOIN locations l
  ON d.location_id = l.id
INNER JOIN employees e
  ON d.id = e.department_id
GROUP BY d.department_name, l.city;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Order details with full information
SELECT 
    c.customer_name,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.price
FROM order_items oi
INNER JOIN products p
  ON oi.product_id = p.id
INNER JOIN categories cat
  ON p.category_id = cat.id
INNER JOIN orders o
  ON oi.order_id = o.id
INNER JOIN customers c
  ON o.customer_id = c.id
ORDER BY c.customer_name;

-- BONUS 2: Employee directory with full details
SELECT 
    e.name,
    d.department_name,
    l.city,
    l.country,
    e.salary
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
INNER JOIN locations l
  ON d.location_id = l.id
WHERE e.is_active = TRUE
ORDER BY e.salary DESC;

-- BONUS 3: Product sales summary
SELECT 
    c.category_name,
    p.product_name,
    COUNT(oi.id) as times_ordered,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.quantity * oi.price) as total_revenue
FROM order_items oi
INNER JOIN products p
  ON oi.product_id = p.id
INNER JOIN categories c
  ON p.category_id = c.id
GROUP BY c.category_name, p.product_name
ORDER BY total_revenue DESC;
