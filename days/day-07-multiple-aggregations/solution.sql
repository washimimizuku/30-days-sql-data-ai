-- Day 7: Multiple Aggregations - Solutions

-- ============================================
-- Exercise 1: Basic Multiple Aggregations
-- ============================================

-- 1.1: Calculate for all products
SELECT 
    COUNT(*) as total_products,
    SUM(price) as total_value,
    ROUND(AVG(price), 2) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM products;

-- 1.2: Calculate for all orders
SELECT 
    COUNT(*) as total_orders,
    SUM(total) as total_revenue,
    ROUND(AVG(total), 2) as avg_order_value,
    MIN(total) as min_order,
    MAX(total) as max_order
FROM orders;

-- 1.3: Calculate for all employees
SELECT 
    COUNT(*) as employee_count,
    SUM(salary) as total_payroll,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees;


-- ============================================
-- Exercise 2: Aggregations by Category
-- ============================================

-- 2.1: For each product category
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(price) as total_value,
    ROUND(AVG(price), 2) as avg_price
FROM products
GROUP BY category
ORDER BY total_value DESC;

-- 2.2: All five aggregates for each category
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(price) as total_value,
    ROUND(AVG(price), 2) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM products
GROUP BY category
ORDER BY category;

-- 2.3: Inventory analysis by category
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(stock) as total_stock,
    SUM(price * stock) as inventory_value
FROM products
GROUP BY category;


-- ============================================
-- Exercise 3: Order Analysis
-- ============================================

-- 3.1: For each order status
SELECT 
    status,
    COUNT(*) as order_count,
    SUM(total) as total_revenue,
    ROUND(AVG(total), 2) as avg_order_value
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- 3.2: For each customer
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_spent,
    ROUND(AVG(total), 2) as avg_order_value,
    MIN(total) as min_order,
    MAX(total) as max_order
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 3.3: For each city
SELECT 
    c.city,
    COUNT(DISTINCT c.id) as customer_count,
    COUNT(o.id) as order_count,
    SUM(o.total) as total_revenue,
    ROUND(AVG(o.total), 2) as avg_order_value
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- ============================================
-- Exercise 4: Department Statistics
-- ============================================

-- 4.1: For each department
SELECT 
    department,
    COUNT(*) as employee_count,
    SUM(salary) as total_salary,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department
ORDER BY total_salary DESC;

-- 4.2: Compensation by department
SELECT 
    department,
    SUM(salary) as total_salary,
    SUM(commission) as total_commission,
    SUM(salary + commission) as total_compensation
FROM employees
GROUP BY department
ORDER BY total_compensation DESC;


-- ============================================
-- Exercise 5: Conditional Aggregations
-- ============================================

-- 5.1: Count orders by status
SELECT 
    COUNT(*) as total_orders,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled
FROM orders;

-- 5.2: Revenue by status
SELECT 
    SUM(total) as total_revenue,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as completed_revenue,
    SUM(CASE WHEN status = 'pending' THEN total ELSE 0 END) as pending_revenue
FROM orders;

-- 5.3: Products by price range
SELECT 
    COUNT(*) as total_products,
    COUNT(CASE WHEN price < 100 THEN 1 END) as budget_count,
    COUNT(CASE WHEN price BETWEEN 100 AND 300 THEN 1 END) as midrange_count,
    COUNT(CASE WHEN price > 300 THEN 1 END) as premium_count
FROM products;


-- ============================================
-- Exercise 6: Product Sales Performance
-- ============================================

-- 6.1: For each product
SELECT 
    p.product_name,
    COUNT(oi.id) as times_ordered,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.quantity * oi.price) as total_revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 6.2: For each category
SELECT 
    p.category,
    COUNT(DISTINCT p.id) as products_sold,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.quantity * oi.price) as total_revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Customer lifetime value
SELECT 
    c.customer_name,
    COUNT(o.id) as order_count,
    SUM(o.total) as total_spent,
    ROUND(AVG(o.total), 2) as avg_order_value,
    MIN(o.order_date) as first_order,
    MAX(o.order_date) as last_order
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.id) >= 2
ORDER BY total_spent DESC;

-- BONUS 2: Product profitability
SELECT 
    p.product_name,
    SUM(oi.quantity) as quantity_sold,
    SUM(oi.quantity * oi.price) as revenue,
    SUM(oi.quantity * p.cost) as cost,
    SUM(oi.quantity * (oi.price - p.cost)) as profit,
    ROUND(SUM(oi.quantity * (oi.price - p.cost)) / SUM(oi.quantity * oi.price) * 100, 2) as profit_margin_pct
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.product_name
ORDER BY profit DESC;

-- BONUS 3: Business dashboard
SELECT 
    (SELECT COUNT(*) FROM products) as total_products,
    (SELECT COUNT(*) FROM customers) as total_customers,
    COUNT(*) as total_orders,
    SUM(total) as total_revenue,
    ROUND(AVG(total), 2) as avg_order_value,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_orders,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_orders
FROM orders;
