-- Day 14: Subqueries in FROM - Solutions

-- ============================================
-- PART 1: BASIC DERIVED TABLES
-- ============================================

-- Exercise 1 Solution: Simple Derived Table
SELECT department, avg_salary
FROM (
    SELECT 
        department,
        AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) AS dept_averages
WHERE avg_salary > 60000
ORDER BY avg_salary DESC;


-- Exercise 2 Solution: Aggregate of Aggregates
SELECT AVG(dept_avg_salary) as avg_of_dept_averages
FROM (
    SELECT 
        department,
        AVG(salary) as dept_avg_salary
    FROM employees
    GROUP BY department
) AS dept_averages;


-- Exercise 3 Solution: Filter Aggregated Results
SELECT customer_name, order_count
FROM (
    SELECT 
        c.customer_name,
        COUNT(o.id) as order_count
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
) AS customer_orders
WHERE order_count > 3
ORDER BY order_count DESC;


-- Exercise 4 Solution: Add Calculated Column
SELECT 
    category,
    category_total,
    ROUND(category_total * 100.0 / grand_total, 2) as percentage_of_total
FROM (
    SELECT 
        category,
        SUM(price * quantity) as category_total,
        (SELECT SUM(price * quantity) FROM order_items) as grand_total
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    GROUP BY category
) AS category_sales
ORDER BY percentage_of_total DESC;


-- Exercise 5 Solution: Categorize Aggregated Data
SELECT 
    department,
    avg_salary,
    CASE 
        WHEN avg_salary > 80000 THEN 'High'
        WHEN avg_salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END as pay_category
FROM (
    SELECT 
        department,
        AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) AS dept_averages
ORDER BY avg_salary DESC;


-- ============================================
-- PART 2: MULTI-LEVEL AGGREGATIONS
-- ============================================

-- Exercise 6 Solution: Top Spending Customers
SELECT customer_name, total_spent
FROM (
    SELECT 
        c.customer_name,
        SUM(o.total) as total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
) AS customer_spending
ORDER BY total_spent DESC
LIMIT 10;


-- Exercise 7 Solution: Above Average Departments
SELECT 
    department,
    dept_avg_salary,
    company_avg_salary,
    dept_avg_salary - company_avg_salary as difference
FROM (
    SELECT 
        department,
        AVG(salary) as dept_avg_salary,
        (SELECT AVG(salary) FROM employees) as company_avg_salary
    FROM employees
    GROUP BY department
) AS dept_comparison
WHERE dept_avg_salary > company_avg_salary
ORDER BY difference DESC;


-- Exercise 8 Solution: Monthly Revenue Analysis
SELECT 
    month,
    revenue,
    previous_month_revenue,
    revenue - previous_month_revenue as growth
FROM (
    SELECT 
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) as previous_month_revenue
    FROM (
        SELECT 
            DATE_TRUNC('month', order_date) as month,
            SUM(total) as revenue
        FROM orders
        WHERE status = 'completed'
        GROUP BY DATE_TRUNC('month', order_date)
    ) AS monthly_revenue
) AS revenue_with_previous
WHERE previous_month_revenue IS NOT NULL
ORDER BY month;


-- Exercise 9 Solution: Customer Lifetime Value Segments
SELECT 
    segment,
    COUNT(*) as customer_count,
    ROUND(AVG(total_spent), 2) as avg_spending,
    ROUND(SUM(total_spent), 2) as total_revenue
FROM (
    SELECT 
        customer_name,
        total_spent,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent >= 1000 THEN 'High'
            WHEN total_spent >= 500 THEN 'Medium'
            ELSE 'Low'
        END as segment
    FROM (
        SELECT 
            c.customer_name,
            COALESCE(SUM(o.total), 0) as total_spent
        FROM customers c
        LEFT JOIN orders o ON c.id = o.customer_id
        GROUP BY c.customer_name
    ) AS customer_totals
) AS customer_segments
GROUP BY segment
ORDER BY total_revenue DESC;


-- ============================================
-- PART 3: MULTIPLE SUBQUERIES
-- ============================================

-- Exercise 10 Solution: Join Two Subqueries
SELECT 
    oc.customer_name,
    oc.order_count,
    pv.product_variety
FROM (
    SELECT 
        c.customer_name,
        c.id as customer_id,
        COUNT(o.id) as order_count
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name, c.id
) AS oc
JOIN (
    SELECT 
        o.customer_id,
        COUNT(DISTINCT oi.product_id) as product_variety
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.customer_id
) AS pv ON oc.customer_id = pv.customer_id
ORDER BY oc.order_count DESC;


-- Exercise 11 Solution: Compare Products to Category Average
SELECT 
    p.product_name,
    p.price,
    ca.category_avg_price,
    ROUND(p.price - ca.category_avg_price, 2) as difference
FROM products p
JOIN (
    SELECT 
        category,
        AVG(price) as category_avg_price
    FROM products
    GROUP BY category
) AS ca ON p.category = ca.category
ORDER BY difference DESC;


-- Exercise 12 Solution: Customer and Order Statistics
SELECT 
    cs.customer_name,
    cs.total_spent,
    cs.order_count,
    ROUND(cs.total_spent / cs.order_count, 2) as avg_order_value
FROM (
    SELECT 
        c.customer_name,
        COUNT(o.id) as order_count,
        SUM(o.total) as total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
) AS cs
WHERE cs.total_spent > 1000 AND cs.order_count >= 3
ORDER BY cs.total_spent DESC;


-- ============================================
-- PART 4: RANKING AND FILTERING
-- ============================================

-- Exercise 13 Solution: Top 3 Products per Category
SELECT category, product_name, revenue, rank_in_category
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.price) as revenue,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.price) DESC) as rank_in_category
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.category, p.product_name
) AS ranked_products
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;


-- Exercise 14 Solution: Top Customers per City
SELECT city, customer_name, total_spent, rank_in_city
FROM (
    SELECT 
        c.city,
        c.customer_name,
        SUM(o.total) as total_spent,
        ROW_NUMBER() OVER (PARTITION BY c.city ORDER BY SUM(o.total) DESC) as rank_in_city
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.city, c.customer_name
) AS ranked_customers
WHERE rank_in_city <= 2
ORDER BY city, rank_in_city;


-- Exercise 15 Solution: Products Above Category Median
SELECT 
    p.product_name,
    p.category,
    p.price,
    cm.category_median
FROM products p
JOIN (
    SELECT 
        category,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) as category_median
    FROM products
    GROUP BY category
) AS cm ON p.category = cm.category
WHERE p.price > cm.category_median
ORDER BY p.category, p.price DESC;


-- ============================================
-- PART 5: COMPLEX BUSINESS LOGIC
-- ============================================

-- Exercise 16 Solution: Product Profitability Analysis
SELECT 
    product_name,
    category,
    revenue,
    profit,
    profit_margin,
    rank_in_category
FROM (
    SELECT 
        p.product_name,
        p.category,
        SUM(oi.quantity * oi.price) as revenue,
        SUM(oi.quantity * (oi.price - p.cost)) as profit,
        ROUND(SUM(oi.quantity * (oi.price - p.cost)) * 100.0 / SUM(oi.quantity * oi.price), 2) as profit_margin,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * (oi.price - p.cost)) * 100.0 / SUM(oi.quantity * oi.price) DESC) as rank_in_category
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.product_name, p.category, p.cost
) AS product_profitability
ORDER BY category, rank_in_category;


-- Exercise 17 Solution: Customer Purchase Patterns
SELECT 
    customer_name,
    order_count,
    total_spent,
    avg_order_value,
    days_since_last_order
FROM (
    SELECT 
        c.customer_name,
        COUNT(o.id) as order_count,
        SUM(o.total) as total_spent,
        ROUND(AVG(o.total), 2) as avg_order_value,
        CURRENT_DATE - MAX(o.order_date) as days_since_last_order
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
) AS customer_patterns
WHERE order_count >= 2
ORDER BY total_spent DESC;


-- ============================================
-- PART 6: PIVOTING AND RESHAPING
-- ============================================

-- Exercise 18 Solution: Monthly Sales Pivot
SELECT 
    category,
    SUM(CASE WHEN month = 1 THEN revenue ELSE 0 END) as month_1_revenue,
    SUM(CASE WHEN month = 2 THEN revenue ELSE 0 END) as month_2_revenue,
    SUM(CASE WHEN month = 3 THEN revenue ELSE 0 END) as month_3_revenue
FROM (
    SELECT 
        p.category,
        EXTRACT(MONTH FROM o.order_date) as month,
        SUM(oi.quantity * oi.price) as revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    WHERE EXTRACT(MONTH FROM o.order_date) IN (1, 2, 3)
    GROUP BY p.category, EXTRACT(MONTH FROM o.order_date)
) AS monthly_sales
GROUP BY category
ORDER BY category;


-- Exercise 19 Solution: Category Performance Matrix
SELECT 
    category,
    SUM(CASE WHEN quarter = 1 THEN revenue ELSE 0 END) as q1_revenue,
    SUM(CASE WHEN quarter = 2 THEN revenue ELSE 0 END) as q2_revenue,
    SUM(CASE WHEN quarter = 3 THEN revenue ELSE 0 END) as q3_revenue,
    SUM(CASE WHEN quarter = 4 THEN revenue ELSE 0 END) as q4_revenue
FROM (
    SELECT 
        p.category,
        EXTRACT(QUARTER FROM o.order_date) as quarter,
        SUM(oi.quantity * oi.price) as revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    GROUP BY p.category, EXTRACT(QUARTER FROM o.order_date)
) AS quarterly_sales
GROUP BY category
ORDER BY category;


-- ============================================
-- PART 7: ADVANCED PATTERNS
-- ============================================

-- Exercise 20 Solution: Customer Segmentation Matrix
SELECT 
    frequency_segment,
    value_segment,
    COUNT(*) as customer_count,
    ROUND(SUM(total_spent), 2) as total_revenue
FROM (
    SELECT 
        customer_name,
        order_count,
        avg_order_value,
        total_spent,
        CASE 
            WHEN order_count > 5 THEN 'High'
            WHEN order_count >= 3 THEN 'Medium'
            ELSE 'Low'
        END as frequency_segment,
        CASE 
            WHEN avg_order_value > 500 THEN 'High'
            WHEN avg_order_value >= 200 THEN 'Medium'
            ELSE 'Low'
        END as value_segment
    FROM (
        SELECT 
            c.customer_name,
            COUNT(o.id) as order_count,
            AVG(o.total) as avg_order_value,
            SUM(o.total) as total_spent
        FROM customers c
        JOIN orders o ON c.id = o.customer_id
        GROUP BY c.customer_name
    ) AS customer_stats
) AS customer_segments
GROUP BY frequency_segment, value_segment
ORDER BY frequency_segment, value_segment;
