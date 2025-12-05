-- Day 12: Self Joins - Solutions

-- ============================================
-- PART 1: EMPLOYEE-MANAGER RELATIONSHIPS
-- ============================================

-- Exercise 1 Solution: Employees with Managers
SELECT 
    e.name as employee_name,
    m.name as manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id
ORDER BY e.name;


-- Exercise 2 Solution: Count Direct Reports
SELECT 
    m.name as manager_name,
    COUNT(e.id) as direct_reports
FROM employees m
JOIN employees e ON m.id = e.manager_id
GROUP BY m.name
ORDER BY direct_reports DESC;


-- Exercise 3 Solution: Employees Without Managers
SELECT 
    name,
    salary,
    hire_date
FROM employees
WHERE manager_id IS NULL;


-- Exercise 4 Solution: Manager's Manager
SELECT 
    e.name as employee_name,
    m1.name as manager_name,
    m2.name as manager_of_manager
FROM employees e
LEFT JOIN employees m1 ON e.manager_id = m1.id
LEFT JOIN employees m2 ON m1.manager_id = m2.id
ORDER BY e.name;


-- Exercise 5 Solution: Employees Earning More Than Manager
SELECT 
    e.name as employee_name,
    e.salary as employee_salary,
    m.name as manager_name,
    m.salary as manager_salary,
    e.salary - m.salary as difference
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > m.salary
ORDER BY difference DESC;


-- Exercise 6 Solution: Same Department Colleagues
SELECT 
    e1.name as employee1,
    e2.name as employee2,
    e1.department_id
FROM employees e1
JOIN employees e2 ON e1.department_id = e2.department_id
WHERE e1.id < e2.id
ORDER BY e1.department_id, e1.name;


-- Exercise 7 Solution: Salary Comparison
SELECT 
    e.name,
    e.salary,
    ROUND(AVG(e2.salary), 2) as dept_avg_salary,
    ROUND(e.salary - AVG(e2.salary), 2) as difference_from_avg
FROM employees e
JOIN employees e2 ON e.department_id = e2.department_id
GROUP BY e.id, e.name, e.salary
ORDER BY difference_from_avg DESC;


-- ============================================
-- PART 2: PRODUCT COMPARISONS
-- ============================================

-- Exercise 8 Solution: Products in Same Category
SELECT 
    p1.product_name as product1,
    p2.product_name as product2,
    p1.category
FROM products p1
JOIN products p2 ON p1.category = p2.category
WHERE p1.id < p2.id
ORDER BY p1.category, p1.product_name;


-- Exercise 9 Solution: Similar Priced Products
SELECT 
    p1.product_name as product1,
    p1.price as price1,
    p2.product_name as product2,
    p2.price as price2,
    ROUND(ABS(p1.price - p2.price), 2) as price_difference
FROM products p1
JOIN products p2 ON p1.id < p2.id
WHERE ABS(p1.price - p2.price) <= 10
ORDER BY price_difference;


-- Exercise 10 Solution: Product Price Comparison
SELECT 
    p.product_name,
    p.price,
    ROUND(AVG(p2.price), 2) as category_avg_price,
    ROUND((p.price - AVG(p2.price)) / AVG(p2.price) * 100, 2) as pct_difference
FROM products p
JOIN products p2 ON p.category = p2.category
GROUP BY p.id, p.product_name, p.price
ORDER BY pct_difference DESC;


-- Exercise 11 Solution: Product Profit Margin Comparison
SELECT 
    p.product_name,
    ROUND((p.price - p.cost) / p.price * 100, 2) as profit_margin,
    ROUND(AVG((p2.price - p2.cost) / p2.price * 100), 2) as category_avg_margin,
    ROUND((p.price - p.cost) / p.price * 100 - AVG((p2.price - p2.cost) / p2.price * 100), 2) as difference
FROM products p
JOIN products p2 ON p.category = p2.category
GROUP BY p.id, p.product_name, p.price, p.cost
ORDER BY difference DESC;


-- ============================================
-- PART 3: CUSTOMER RELATIONSHIPS
-- ============================================

-- Exercise 12 Solution: Customers in Same City
SELECT 
    c1.customer_name as customer1,
    c2.customer_name as customer2,
    c1.city
FROM customers c1
JOIN customers c2 ON c1.city = c2.city
WHERE c1.id < c2.id
ORDER BY c1.city, c1.customer_name;


-- Exercise 13 Solution: Customers in Same State
SELECT 
    c1.customer_name,
    c1.state,
    COUNT(c2.id) as other_customers_in_state
FROM customers c1
JOIN customers c2 ON c1.state = c2.state AND c1.id != c2.id
GROUP BY c1.customer_name, c1.state
ORDER BY other_customers_in_state DESC;


-- Exercise 14 Solution: Customer Registration Comparison
SELECT 
    c1.customer_name as customer1,
    c2.customer_name as customer2,
    c1.registration_date
FROM customers c1
JOIN customers c2 ON c1.registration_date = c2.registration_date
WHERE c1.id < c2.id
ORDER BY c1.registration_date;


-- ============================================
-- PART 4: ORDER SEQUENCES
-- ============================================

-- Exercise 15 Solution: Consecutive Orders
SELECT 
    o1.customer_id,
    o1.id as first_order_id,
    o1.order_date as first_order_date,
    o2.id as second_order_id,
    o2.order_date as second_order_date,
    o2.order_date - o1.order_date as days_between
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id AND o2.order_date > o1.order_date
ORDER BY o1.customer_id, o1.order_date
LIMIT 20;


-- Exercise 16 Solution: Quick Repeat Orders
SELECT 
    c.customer_name,
    o1.order_date as first_order_date,
    o2.order_date as second_order_date,
    o2.order_date - o1.order_date as days_between
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id 
    AND o2.order_date > o1.order_date
    AND o2.order_date - o1.order_date <= 7
JOIN customers c ON o1.customer_id = c.id
ORDER BY days_between, c.customer_name;


-- Exercise 17 Solution: Order Value Comparison
SELECT 
    o1.id as order_id,
    o1.total as order_total,
    ROUND(AVG(o2.total), 2) as customer_avg,
    ROUND(o1.total - AVG(o2.total), 2) as difference_from_avg
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id
GROUP BY o1.id, o1.total
ORDER BY difference_from_avg DESC
LIMIT 20;


-- ============================================
-- PART 5: PRODUCT RELATIONSHIPS
-- ============================================

-- Exercise 18 Solution: Products Bought Together
SELECT 
    p1.product_name as product1,
    p2.product_name as product2,
    COUNT(*) as times_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.id
JOIN products p2 ON oi2.product_id = p2.id
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(*) >= 3
ORDER BY times_together DESC;


-- Exercise 19 Solution: Frequently Bought Together
SELECT 
    p1.product_name as product1,
    p2.product_name as product2,
    COUNT(*) as times_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.id
JOIN products p2 ON oi2.product_id = p2.id
GROUP BY p1.product_name, p2.product_name
ORDER BY times_together DESC
LIMIT 10;


-- Exercise 20 Solution: Customers Who Bought Same Product
SELECT 
    c1.customer_name as customer1,
    c2.customer_name as customer2,
    p.product_name
FROM order_items oi1
JOIN order_items oi2 ON oi1.product_id = oi2.product_id
JOIN orders o1 ON oi1.order_id = o1.id
JOIN orders o2 ON oi2.order_id = o2.id
JOIN customers c1 ON o1.customer_id = c1.id
JOIN customers c2 ON o2.customer_id = c2.id
JOIN products p ON oi1.product_id = p.id
WHERE c1.id < c2.id
ORDER BY p.product_name, c1.customer_name
LIMIT 20;
