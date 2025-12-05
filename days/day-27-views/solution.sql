-- Day 27: Views - Solutions
-- Database: day27.db

-- ============================================================================
-- PART 1: BASIC VIEWS (Easy)
-- ============================================================================

-- Exercise 1: Simple View
CREATE VIEW active_employees AS
SELECT id, name, email, department
FROM employees
WHERE is_active = TRUE;

-- Verify:
SELECT * FROM active_employees;


-- Exercise 2: Filtered View
CREATE VIEW high_earners AS
SELECT name, department, salary
FROM employees
WHERE salary > 80000;

-- Verify:
SELECT * FROM high_earners;


-- Exercise 3: Query a View
SELECT * FROM active_employees 
WHERE department = 'Sales';


-- Exercise 4: Drop and Recreate
DROP VIEW IF EXISTS high_earners;

CREATE VIEW high_earners AS
SELECT name, department, salary
FROM employees
WHERE salary > 90000;

-- Verify:
SELECT * FROM high_earners;


-- Exercise 5: View with Calculated Column
CREATE VIEW employee_tenure AS
SELECT 
    name,
    hire_date,
    YEAR(CURRENT_DATE) - YEAR(hire_date) as years_employed
FROM employees;

-- Verify:
SELECT * FROM employee_tenure ORDER BY years_employed DESC;


-- ============================================================================
-- PART 2: VIEWS WITH JOINS (Medium)
-- ============================================================================

-- Exercise 6: Simple JOIN View
CREATE VIEW employee_details AS
SELECT 
    e.name as employee_name,
    e.email,
    d.name as department_name,
    d.location
FROM employees e
JOIN departments d ON e.department = d.name;

-- Verify:
SELECT * FROM employee_details;


-- Exercise 7: Customer Orders View
CREATE VIEW customer_orders AS
SELECT 
    c.name as customer_name,
    o.order_date,
    o.total,
    o.status
FROM customers c
JOIN orders o ON c.id = o.customer_id;

-- Verify:
SELECT * FROM customer_orders;


-- Exercise 8: Order Details View
CREATE VIEW order_details AS
SELECT 
    o.id as order_id,
    c.name as customer_name,
    p.product_name,
    oi.quantity,
    oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;

-- Verify:
SELECT * FROM order_details LIMIT 10;


-- Exercise 9: Query JOIN View
SELECT * FROM customer_orders co
WHERE co.customer_name IN (
    SELECT name FROM customers WHERE city = 'Seattle'
);

-- Or with subquery in view:
SELECT co.* 
FROM customer_orders co
JOIN customers c ON co.customer_name = c.name
WHERE c.city = 'Seattle';


-- Exercise 10: Multi-Table View
CREATE VIEW order_summary AS
SELECT 
    c.name as customer_name,
    o.order_date,
    COUNT(oi.id) as product_count,
    o.total as order_total
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY c.name, o.order_date, o.total;

-- Verify:
SELECT * FROM order_summary;


-- ============================================================================
-- PART 3: AGGREGATE VIEWS (Medium-Hard)
-- ============================================================================

-- Exercise 11: Department Statistics
CREATE VIEW department_stats AS
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department;

-- Verify:
SELECT * FROM department_stats ORDER BY avg_salary DESC;


-- Exercise 12: Customer Summary
CREATE VIEW customer_summary AS
SELECT 
    c.id as customer_id,
    c.name as customer_name,
    COUNT(o.id) as order_count,
    SUM(o.total) as total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Verify:
SELECT * FROM customer_summary ORDER BY total_spent DESC;


-- Exercise 13: Product Performance
CREATE VIEW product_performance AS
SELECT 
    p.product_name,
    COUNT(oi.id) as times_ordered,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.quantity * oi.price) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name;

-- Verify:
SELECT * FROM product_performance 
ORDER BY total_revenue DESC 
LIMIT 10;


-- Exercise 14: Monthly Sales
CREATE VIEW monthly_sales AS
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(*) as order_count,
    SUM(total) as total_revenue,
    AVG(total) as avg_order_value
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

-- Verify:
SELECT * FROM monthly_sales ORDER BY month;


-- Exercise 15: Category Analysis
CREATE VIEW category_analysis AS
SELECT 
    p.category,
    COUNT(DISTINCT p.id) as product_count,
    AVG(p.price) as avg_price,
    SUM(oi.quantity * oi.price) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.category;

-- Verify:
SELECT * FROM category_analysis ORDER BY total_revenue DESC;


-- ============================================================================
-- PART 4: PRACTICAL VIEWS (Hard)
-- ============================================================================

-- Exercise 16: Security View
CREATE VIEW public_employees AS
SELECT id, name, email, department
FROM employees;
-- Note: salary is intentionally excluded for security

-- Verify:
SELECT * FROM public_employees;


-- Exercise 17: Dashboard View
CREATE VIEW sales_dashboard AS
SELECT 
    DATE(order_date) as date,
    COUNT(*) as orders,
    SUM(total) as revenue,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
GROUP BY DATE(order_date);

-- Verify:
SELECT * FROM sales_dashboard ORDER BY date DESC LIMIT 7;


-- Exercise 18: Customer Segmentation
CREATE VIEW customer_segments AS
SELECT 
    c.id,
    c.name,
    COALESCE(SUM(o.total), 0) as total_spent,
    CASE 
        WHEN COALESCE(SUM(o.total), 0) > 5000 THEN 'VIP'
        WHEN COALESCE(SUM(o.total), 0) > 2000 THEN 'Premium'
        WHEN COALESCE(SUM(o.total), 0) > 500 THEN 'Regular'
        ELSE 'New'
    END as segment
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- Verify:
SELECT segment, COUNT(*) as customer_count
FROM customer_segments
GROUP BY segment;


-- Exercise 19: Employee Directory
CREATE VIEW employee_directory AS
SELECT 
    e.name,
    e.email,
    e.department,
    d.location,
    YEAR(CURRENT_DATE) - YEAR(e.hire_date) as years_employed,
    CASE 
        WHEN e.is_active THEN 'Active'
        ELSE 'Inactive'
    END as status
FROM employees e
JOIN departments d ON e.department = d.name;

-- Verify:
SELECT * FROM employee_directory ORDER BY name;


-- Exercise 20: CREATE OR REPLACE
CREATE OR REPLACE VIEW sales_dashboard AS
SELECT 
    DATE(order_date) as date,
    COUNT(*) as orders,
    SUM(total) as revenue,
    COUNT(DISTINCT customer_id) as unique_customers,
    AVG(total) as avg_order_value
FROM orders
GROUP BY DATE(order_date);

-- Verify the updated view:
SELECT * FROM sales_dashboard ORDER BY date DESC LIMIT 7;


-- ============================================================================
-- BONUS: VIEW MANAGEMENT
-- ============================================================================

-- List all views (DuckDB specific)
SELECT * FROM duckdb_views();

-- Drop all created views
DROP VIEW IF EXISTS active_employees;
DROP VIEW IF EXISTS high_earners;
DROP VIEW IF EXISTS employee_tenure;
DROP VIEW IF EXISTS employee_details;
DROP VIEW IF EXISTS customer_orders;
DROP VIEW IF EXISTS order_details;
DROP VIEW IF EXISTS order_summary;
DROP VIEW IF EXISTS department_stats;
DROP VIEW IF EXISTS customer_summary;
DROP VIEW IF EXISTS product_performance;
DROP VIEW IF EXISTS monthly_sales;
DROP VIEW IF EXISTS category_analysis;
DROP VIEW IF EXISTS public_employees;
DROP VIEW IF EXISTS sales_dashboard;
DROP VIEW IF EXISTS customer_segments;
DROP VIEW IF EXISTS employee_directory;
