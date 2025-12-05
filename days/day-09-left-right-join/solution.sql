-- Day 9: LEFT and RIGHT JOIN - Solutions

-- ============================================
-- Exercise 1: Basic LEFT JOIN
-- ============================================

-- 1.1: All customers with order count
SELECT 
    c.customer_name,
    COUNT(o.id) as order_count
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;

-- 1.2: All products with total quantity sold
SELECT 
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) as total_quantity_sold
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name;

-- 1.3: All employees with department name
SELECT 
    e.name,
    e.salary,
    COALESCE(d.department_name, 'No Department') as department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;


-- ============================================
-- Exercise 2: Finding Unmatched Records
-- ============================================

-- 2.1: Customers who never ordered
SELECT 
    c.customer_name,
    c.email,
    c.registration_date
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- 2.2: Products never ordered
SELECT 
    p.product_name,
    p.category,
    p.price
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.id IS NULL;

-- 2.3: Employees without departments
SELECT 
    e.name,
    e.salary,
    e.hire_date
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id
WHERE d.id IS NULL;

-- 2.4: Departments without employees
SELECT 
    d.department_name,
    d.location,
    d.budget
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id
WHERE e.id IS NULL;


-- ============================================
-- Exercise 3: LEFT JOIN with Aggregates
-- ============================================

-- 3.1: All customers with total spent
SELECT 
    c.customer_name,
    COALESCE(SUM(o.total), 0) as total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;

-- 3.2: All departments with employee count
SELECT 
    d.department_name,
    COUNT(e.id) as employee_count
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.department_name;

-- 3.3: All products with times ordered
SELECT 
    p.product_name,
    COUNT(oi.id) as times_ordered
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name;


-- ============================================
-- Exercise 4: Customer Analysis
-- ============================================

-- 4.1: Customer order statistics
SELECT 
    c.customer_name,
    COUNT(o.id) as order_count,
    COALESCE(SUM(o.total), 0) as total_spent,
    ROUND(COALESCE(AVG(o.total), 0), 2) as avg_order_value,
    MAX(o.order_date) as last_order_date
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;

-- 4.2: Inactive customers (registered >365 days ago, never ordered)
SELECT 
    c.customer_name,
    c.registration_date,
    CURRENT_DATE - c.registration_date as days_since_registration
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL
  AND CURRENT_DATE - c.registration_date > 365;


-- ============================================
-- Exercise 5: Product Analysis
-- ============================================

-- 5.1: Products by category with sales statistics
SELECT 
    p.category,
    COUNT(DISTINCT p.id) as total_products,
    COUNT(DISTINCT CASE WHEN oi.id IS NOT NULL THEN p.id END) as products_sold,
    COUNT(DISTINCT CASE WHEN oi.id IS NULL THEN p.id END) as products_never_sold
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.category;

-- 5.2: Products with low stock or never sold
SELECT 
    p.product_name,
    p.stock,
    COUNT(oi.id) as times_ordered
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name, p.stock
HAVING p.stock < 20 OR COUNT(oi.id) = 0;


-- ============================================
-- Exercise 6: Multiple LEFT JOINs
-- ============================================

-- 6.1: Customers with order and item counts
SELECT 
    c.customer_name,
    COUNT(DISTINCT o.id) as order_count,
    COALESCE(SUM(oi.quantity), 0) as total_items
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY c.customer_name;

-- 6.2: Employees with department and location
SELECT 
    e.name,
    COALESCE(d.department_name, 'Unknown') as department_name,
    COALESCE(d.location, 'Unknown') as location
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Customer segmentation
SELECT 
    c.customer_name,
    COALESCE(SUM(o.total), 0) as total_spent,
    CASE 
        WHEN SUM(o.total) IS NULL THEN 'No Orders'
        WHEN SUM(o.total) > 1000 THEN 'High Value'
        WHEN SUM(o.total) >= 100 THEN 'Medium'
        ELSE 'Low'
    END as segment
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;

-- BONUS 2: Complete product report
SELECT 
    p.product_name,
    p.stock,
    COALESCE(SUM(oi.quantity), 0) as quantity_sold,
    COALESCE(SUM(oi.quantity * oi.price), 0) as revenue,
    CASE 
        WHEN COUNT(oi.id) = 0 THEN 'Never Sold'
        WHEN p.stock < 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END as status
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name, p.stock;

-- BONUS 3: Department budget analysis
SELECT 
    d.department_name,
    COALESCE(SUM(e.salary), 0) as total_salaries,
    d.budget,
    d.budget - COALESCE(SUM(e.salary), 0) as remaining,
    CASE 
        WHEN COUNT(e.id) = 0 THEN 'No Employees'
        WHEN SUM(e.salary) > d.budget THEN 'Over Budget'
        ELSE 'Under Budget'
    END as status
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
GROUP BY d.department_name, d.budget;
