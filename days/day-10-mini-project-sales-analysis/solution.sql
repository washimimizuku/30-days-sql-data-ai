-- Day 10: Mini Project - Sales Analysis - Solutions

-- ============================================
-- Part 1: Basic Sales Metrics
-- ============================================

-- Question 1: Total Revenue
SELECT SUM(total) as total_revenue
FROM orders
WHERE status = 'completed';

-- Question 2: Order Statistics
SELECT 
    COUNT(*) as total_orders,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_orders,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_orders,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled_orders
FROM orders;

-- Question 3: Top 10 Customers
SELECT 
    c.customer_name,
    c.email,
    SUM(o.total) as total_spent
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_name, c.email
ORDER BY total_spent DESC
LIMIT 10;

-- Question 4: Monthly Revenue Trend
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    SUM(total) as revenue
FROM orders
WHERE status = 'completed'
GROUP BY year, month
ORDER BY year, month;


-- ============================================
-- Part 2: Product Analysis
-- ============================================

-- Question 5: Best Selling Products
SELECT 
    p.product_name,
    c.category_name,
    SUM(oi.quantity) as quantity_sold,
    SUM(oi.quantity * oi.price) as revenue
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.id
INNER JOIN categories c ON p.category_id = c.id
INNER JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY p.product_name, c.category_name
ORDER BY quantity_sold DESC
LIMIT 10;

-- Question 6: Products Never Sold
SELECT 
    p.product_name,
    c.category_name,
    p.price,
    p.stock
FROM products p
INNER JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.id IS NULL;

-- Question 7: Category Performance
SELECT 
    c.category_name,
    COUNT(DISTINCT p.id) as product_count,
    COALESCE(SUM(oi.quantity), 0) as total_quantity_sold,
    COALESCE(SUM(oi.quantity * oi.price), 0) as total_revenue,
    ROUND(AVG(p.price), 2) as avg_price
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'completed'
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- Question 8: Low Stock Alert
SELECT 
    p.product_name,
    c.category_name,
    p.stock,
    COUNT(oi.id) as times_ordered
FROM products p
INNER JOIN categories c ON p.category_id = c.id
INNER JOIN order_items oi ON p.id = oi.product_id
WHERE p.stock < 10
GROUP BY p.product_name, c.category_name, p.stock
HAVING COUNT(oi.id) > 0
ORDER BY p.stock ASC;


-- ============================================
-- Part 3: Customer Insights
-- ============================================

-- Question 9: Customer Segmentation
SELECT 
    segment,
    COUNT(*) as customer_count,
    SUM(total_spent) as total_revenue
FROM (
    SELECT 
        c.id,
        COALESCE(SUM(o.total), 0) as total_spent,
        CASE 
            WHEN COALESCE(SUM(o.total), 0) > 1000 THEN 'High Value'
            WHEN COALESCE(SUM(o.total), 0) >= 500 THEN 'Medium Value'
            ELSE 'Low Value'
        END as segment
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id AND o.status = 'completed'
    GROUP BY c.id
) segments
GROUP BY segment
ORDER BY total_revenue DESC;

-- Question 10: Inactive Customers
SELECT 
    c.customer_name,
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL
  AND CURRENT_DATE - c.registration_date > 180;

-- Question 11: Customer Lifetime Value
SELECT 
    c.customer_name,
    COUNT(o.id) as total_orders,
    SUM(o.total) as total_spent,
    ROUND(AVG(o.total), 2) as avg_order_value,
    MIN(o.order_date) as first_order_date,
    MAX(o.order_date) as last_order_date,
    MAX(o.order_date) - MIN(o.order_date) as days_as_customer
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 20;

-- Question 12: Repeat Customer Rate
SELECT 
    COUNT(DISTINCT customer_id) as total_customers_with_orders,
    COUNT(DISTINCT CASE WHEN order_count >= 2 THEN customer_id END) as repeat_customers,
    ROUND(COUNT(DISTINCT CASE WHEN order_count >= 2 THEN customer_id END) * 100.0 / 
          COUNT(DISTINCT customer_id), 2) as repeat_rate_percentage
FROM (
    SELECT customer_id, COUNT(*) as order_count
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
) customer_orders;


-- ============================================
-- Part 4: Geographic Analysis
-- ============================================

-- Question 13: Sales by City
SELECT 
    c.city,
    COUNT(DISTINCT c.id) as customer_count,
    COUNT(o.id) as order_count,
    COALESCE(SUM(o.total), 0) as total_revenue,
    ROUND(COALESCE(AVG(o.total), 0), 2) as avg_order_value
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id AND o.status = 'completed'
GROUP BY c.city
ORDER BY total_revenue DESC;

-- Question 14: Top City by Category
SELECT 
    c.category_name,
    city,
    revenue
FROM (
    SELECT 
        cat.category_name,
        cust.city,
        SUM(oi.quantity * oi.price) as revenue,
        ROW_NUMBER() OVER (PARTITION BY cat.category_name ORDER BY SUM(oi.quantity * oi.price) DESC) as rn
    FROM order_items oi
    INNER JOIN products p ON oi.product_id = p.id
    INNER JOIN categories cat ON p.category_id = cat.id
    INNER JOIN orders o ON oi.order_id = o.id
    INNER JOIN customers cust ON o.customer_id = cust.id
    WHERE o.status = 'completed'
    GROUP BY cat.category_name, cust.city
) ranked
WHERE rn = 1;

-- Question 15: State Performance
SELECT 
    c.state,
    COUNT(DISTINCT c.id) as customer_count,
    COUNT(o.id) as order_count,
    COALESCE(SUM(o.total), 0) as total_revenue,
    ROUND(COALESCE(SUM(o.total), 0) / COUNT(DISTINCT c.id), 2) as avg_revenue_per_customer
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id AND o.status = 'completed'
GROUP BY c.state
ORDER BY total_revenue DESC;


-- ============================================
-- Part 5: Advanced Analysis
-- ============================================

-- Question 16: Product Profitability
SELECT 
    p.product_name,
    SUM(oi.quantity) as quantity_sold,
    SUM(oi.quantity * oi.price) as revenue,
    SUM(oi.quantity * p.cost) as cost,
    SUM(oi.quantity * (oi.price - p.cost)) as profit,
    ROUND(SUM(oi.quantity * (oi.price - p.cost)) / SUM(oi.quantity * oi.price) * 100, 2) as profit_margin_pct
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.id
INNER JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY p.product_name
ORDER BY profit DESC
LIMIT 10;

-- Question 17: Order Size Analysis
SELECT 
    size_category,
    COUNT(*) as order_count,
    SUM(total) as total_revenue
FROM (
    SELECT 
        o.id,
        o.total,
        CASE 
            WHEN COUNT(oi.id) = 1 THEN '1 item'
            WHEN COUNT(oi.id) BETWEEN 2 AND 3 THEN '2-3 items'
            WHEN COUNT(oi.id) BETWEEN 4 AND 5 THEN '4-5 items'
            ELSE '6+ items'
        END as size_category
    FROM orders o
    INNER JOIN order_items oi ON o.id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.id, o.total
) order_sizes
GROUP BY size_category
ORDER BY 
    CASE size_category
        WHEN '1 item' THEN 1
        WHEN '2-3 items' THEN 2
        WHEN '4-5 items' THEN 3
        ELSE 4
    END;

-- Question 18: Customer Purchase Frequency
SELECT 
    c.customer_name,
    COUNT(o.id) as total_orders,
    MAX(o.order_date) - MIN(o.order_date) as days_between_first_last,
    ROUND((MAX(o.order_date) - MIN(o.order_date)) * 1.0 / (COUNT(o.id) - 1), 1) as avg_days_between_orders
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_name
HAVING COUNT(o.id) >= 2
ORDER BY total_orders DESC
LIMIT 15;

-- Question 19: Category Mix per Order
SELECT 
    ROUND(AVG(category_count), 2) as avg_categories_per_order
FROM (
    SELECT 
        o.id,
        COUNT(DISTINCT p.category_id) as category_count
    FROM orders o
    INNER JOIN order_items oi ON o.id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.id
    WHERE o.status = 'completed'
    GROUP BY o.id
) order_categories;

-- Question 20: Complete Business Dashboard
SELECT 
    (SELECT COUNT(*) FROM customers) as total_customers,
    (SELECT COUNT(DISTINCT customer_id) FROM orders WHERE status = 'completed') as active_customers,
    (SELECT COUNT(*) FROM products) as total_products,
    (SELECT COUNT(DISTINCT product_id) FROM order_items) as products_sold,
    (SELECT COUNT(*) FROM orders) as total_orders,
    (SELECT COUNT(*) FROM orders WHERE status = 'completed') as completed_orders,
    (SELECT ROUND(SUM(total), 2) FROM orders WHERE status = 'completed') as total_revenue,
    (SELECT ROUND(AVG(total), 2) FROM orders WHERE status = 'completed') as avg_order_value,
    (SELECT ROUND(SUM(oi.quantity * (oi.price - p.cost)), 2)
     FROM order_items oi
     INNER JOIN products p ON oi.product_id = p.id
     INNER JOIN orders o ON oi.order_id = o.id
     WHERE o.status = 'completed') as total_profit,
    (SELECT ROUND(SUM(oi.quantity * (oi.price - p.cost)) / SUM(oi.quantity * oi.price) * 100, 2)
     FROM order_items oi
     INNER JOIN products p ON oi.product_id = p.id
     INNER JOIN orders o ON oi.order_id = o.id
     WHERE o.status = 'completed') as profit_margin_pct;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Monthly Growth Rate
SELECT 
    year,
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY year, month) as prev_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY year, month)) / 
          LAG(revenue) OVER (ORDER BY year, month) * 100, 2) as growth_rate_pct
FROM (
    SELECT 
        EXTRACT(YEAR FROM order_date) as year,
        EXTRACT(MONTH FROM order_date) as month,
        SUM(total) as revenue
    FROM orders
    WHERE status = 'completed'
    GROUP BY year, month
) monthly_revenue
ORDER BY year, month;

-- BONUS 2: Customer Cohort Analysis
SELECT 
    EXTRACT(YEAR FROM registration_date) as cohort_year,
    EXTRACT(MONTH FROM registration_date) as cohort_month,
    COUNT(DISTINCT c.id) as customers_in_cohort,
    COALESCE(SUM(o.total), 0) as cohort_lifetime_value,
    ROUND(COALESCE(SUM(o.total), 0) / COUNT(DISTINCT c.id), 2) as avg_ltv_per_customer
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id AND o.status = 'completed'
GROUP BY cohort_year, cohort_month
ORDER BY cohort_year, cohort_month;

-- BONUS 3: Seasonal Trends
SELECT 
    season,
    COUNT(*) as order_count,
    SUM(total) as total_revenue,
    ROUND(AVG(total), 2) as avg_order_value
FROM (
    SELECT 
        *,
        CASE 
            WHEN EXTRACT(MONTH FROM order_date) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM order_date) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM order_date) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Fall'
        END as season
    FROM orders
    WHERE status = 'completed'
) seasonal_orders
GROUP BY season
ORDER BY total_revenue DESC;
