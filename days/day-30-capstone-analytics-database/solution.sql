-- Day 30: Capstone Project - Complete Analytics Database Solutions
-- Database: day30.db

-- ============================================
-- Part 1: Business Intelligence Queries (30 min)
-- ============================================

-- Challenge 1: Sales Performance Dashboard

-- 1.1: Calculate key metrics
SELECT 
    SUM(total_amount) as total_revenue,
    COUNT(*) as total_orders,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    COUNT(DISTINCT customer_id) as total_customers
FROM orders;


-- 1.2: Revenue by category
SELECT 
    c.category_name,
    SUM(oi.quantity * oi.unit_price) as revenue,
    COUNT(DISTINCT oi.order_id) as order_count,
    ROUND(AVG(o.total_amount), 2) as avg_order_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY c.category_name
ORDER BY revenue DESC;


-- 1.3: Top 10 customers by total spend
SELECT 
    cu.customer_name,
    cu.email,
    SUM(o.total_amount) as total_spent,
    COUNT(o.order_id) as order_count
FROM customers cu
JOIN orders o ON cu.customer_id = o.customer_id
GROUP BY cu.customer_name, cu.email
ORDER BY total_spent DESC
LIMIT 10;


-- 1.4: Monthly sales trends for 2023
SELECT 
    MONTH(order_date) as month,
    MONTHNAME(order_date) as month_name,
    SUM(total_amount) as revenue,
    COUNT(*) as orders,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM orders
WHERE YEAR(order_date) = 2023
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month;


-- 1.5: Best performing stores
SELECT 
    s.store_name,
    s.city,
    s.region,
    SUM(o.total_amount) as revenue,
    COUNT(o.order_id) as order_count
FROM stores s
JOIN orders o ON s.store_id = o.store_id
GROUP BY s.store_name, s.city, s.region
ORDER BY revenue DESC;


-- Challenge 2: Customer Analytics

-- 2.1: Customer segmentation analysis
SELECT 
    customer_segment,
    COUNT(*) as customer_count,
    ROUND(AVG(lifetime_value), 2) as avg_lifetime_value
FROM customers
GROUP BY customer_segment
ORDER BY avg_lifetime_value DESC;


-- 2.2: Customer lifetime value distribution
WITH customer_ltv AS (
    SELECT 
        cu.customer_id,
        cu.customer_name,
        SUM(o.total_amount) as lifetime_value
    FROM customers cu
    LEFT JOIN orders o ON cu.customer_id = o.customer_id
    GROUP BY cu.customer_id, cu.customer_name
)
SELECT 
    CASE 
        WHEN lifetime_value > 2000 THEN 'High'
        WHEN lifetime_value >= 500 THEN 'Medium'
        ELSE 'Low'
    END as value_tier,
    COUNT(*) as customer_count,
    SUM(lifetime_value) as total_revenue
FROM customer_ltv
GROUP BY value_tier
ORDER BY total_revenue DESC;


-- 2.3: Repeat purchase rate
WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(*) as order_count
    FROM orders
    GROUP BY customer_id
)
SELECT 
    COUNT(CASE WHEN order_count > 1 THEN 1 END) as repeat_customer_count,
    COUNT(*) as total_customers,
    ROUND(COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0 / COUNT(*), 2) as repeat_rate_pct
FROM customer_orders;


-- 2.4: Customer acquisition by month
SELECT 
    DATE_TRUNC('month', registration_date) as registration_month,
    COUNT(*) as new_customers
FROM customers
GROUP BY DATE_TRUNC('month', registration_date)
ORDER BY registration_month;


-- 2.5: Inactive customers
WITH last_purchase AS (
    SELECT 
        customer_id,
        MAX(order_date) as last_purchase_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    c.customer_name,
    c.email,
    lp.last_purchase_date,
    DATEDIFF('day', lp.last_purchase_date, CURRENT_DATE) as days_since_purchase
FROM customers c
JOIN last_purchase lp ON c.customer_id = lp.customer_id
WHERE DATEDIFF('day', lp.last_purchase_date, CURRENT_DATE) > 180
ORDER BY days_since_purchase DESC;


-- Challenge 3: Product Analytics

-- 3.1: Best-selling products by revenue
SELECT 
    p.product_name,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) as revenue,
    SUM(oi.quantity) as quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_name, c.category_name
ORDER BY revenue DESC
LIMIT 20;


-- 3.2: Products with low stock
SELECT 
    p.product_name,
    c.category_name,
    p.stock_quantity,
    p.reorder_level,
    (p.reorder_level - p.stock_quantity) as shortage
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.stock_quantity < p.reorder_level
ORDER BY shortage DESC;


-- 3.3: Average rating by category
SELECT 
    c.category_name,
    ROUND(AVG(r.rating), 2) as avg_rating,
    COUNT(r.review_id) as review_count
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN reviews r ON p.product_id = r.product_id
GROUP BY c.category_name
ORDER BY avg_rating DESC;


-- 3.4: Products with no reviews
SELECT 
    p.product_name,
    c.category_name,
    p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE r.review_id IS NULL
  AND p.is_active = TRUE
ORDER BY p.price DESC;


-- 3.5: Price vs rating correlation
WITH product_ratings AS (
    SELECT 
        p.product_id,
        p.price,
        AVG(r.rating) as avg_rating
    FROM products p
    LEFT JOIN reviews r ON p.product_id = r.product_id
    GROUP BY p.product_id, p.price
)
SELECT 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price <= 200 THEN 'Mid'
        ELSE 'Premium'
    END as price_tier,
    COUNT(*) as product_count,
    ROUND(AVG(avg_rating), 2) as avg_rating
FROM product_ratings
WHERE avg_rating IS NOT NULL
GROUP BY price_tier
ORDER BY price_tier;


-- ============================================
-- Part 2: Advanced Analytics (30 min)
-- ============================================

-- Challenge 4: Time-Series Analysis

-- 4.1: Year-over-year growth
WITH yearly_revenue AS (
    SELECT 
        YEAR(order_date) as year,
        SUM(total_amount) as revenue
    FROM orders
    GROUP BY YEAR(order_date)
)
SELECT 
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) as prev_year_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY year)) / LAG(revenue) OVER (ORDER BY year) * 100, 2) as yoy_growth_pct
FROM yearly_revenue
ORDER BY year;


-- 4.2: Month-over-month trends
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(total_amount) as revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as prev_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100, 2) as mom_change_pct
FROM monthly_revenue
ORDER BY month;


-- 4.3: Seasonal patterns
SELECT 
    MONTH(order_date) as month,
    MONTHNAME(order_date) as month_name,
    ROUND(AVG(total_amount), 2) as avg_monthly_revenue
FROM orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month;


-- 4.4: Day-of-week analysis
SELECT 
    DAYNAME(order_date) as day_of_week,
    DAYOFWEEK(order_date) as day_num,
    COUNT(*) as order_count,
    SUM(total_amount) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM orders
GROUP BY DAYNAME(order_date), DAYOFWEEK(order_date)
ORDER BY day_num;


-- 4.5: Moving averages
WITH daily_revenue AS (
    SELECT 
        DATE(order_date) as order_date,
        SUM(total_amount) as daily_revenue
    FROM orders
    GROUP BY DATE(order_date)
)
SELECT 
    order_date,
    daily_revenue,
    ROUND(AVG(daily_revenue) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) as moving_avg_7day
FROM daily_revenue
ORDER BY order_date;


-- Challenge 5: Cohort Analysis

-- 5.1: Customers by registration month cohort
SELECT 
    DATE_TRUNC('month', c.registration_date) as cohort_month,
    COUNT(DISTINCT c.customer_id) as customer_count,
    SUM(o.total_amount) as total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY DATE_TRUNC('month', c.registration_date)
ORDER BY cohort_month;


-- 5.2: Retention rates by cohort (simplified)
WITH cohorts AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', registration_date) as cohort_month
    FROM customers
),
cohort_orders AS (
    SELECT 
        c.cohort_month,
        o.customer_id,
        DATE_TRUNC('month', o.order_date) as order_month
    FROM cohorts c
    JOIN orders o ON c.customer_id = o.customer_id
)
SELECT 
    cohort_month,
    COUNT(DISTINCT CASE WHEN order_month = cohort_month THEN customer_id END) as month_0,
    COUNT(DISTINCT CASE WHEN order_month = cohort_month + INTERVAL '1 month' THEN customer_id END) as month_1,
    COUNT(DISTINCT CASE WHEN order_month = cohort_month + INTERVAL '2 months' THEN customer_id END) as month_2
FROM cohort_orders
GROUP BY cohort_month
ORDER BY cohort_month;


-- 5.3: Revenue by cohort over time
WITH cohorts AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', registration_date) as cohort_month
    FROM customers
)
SELECT 
    c.cohort_month,
    DATE_TRUNC('month', o.order_date) as order_month,
    SUM(o.total_amount) as revenue
FROM cohorts c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.cohort_month, DATE_TRUNC('month', o.order_date)
ORDER BY c.cohort_month, order_month;


-- 5.4: Time to second purchase
WITH customer_purchases AS (
    SELECT 
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as purchase_num
    FROM orders
),
first_two_purchases AS (
    SELECT 
        customer_id,
        MAX(CASE WHEN purchase_num = 1 THEN order_date END) as first_purchase,
        MAX(CASE WHEN purchase_num = 2 THEN order_date END) as second_purchase
    FROM customer_purchases
    WHERE purchase_num <= 2
    GROUP BY customer_id
    HAVING MAX(CASE WHEN purchase_num = 2 THEN order_date END) IS NOT NULL
)
SELECT 
    ROUND(AVG(DATEDIFF('day', first_purchase, second_purchase)), 1) as avg_days_to_second_purchase
FROM first_two_purchases;


-- Challenge 6: Employee Performance

-- 6.1: Sales by employee
SELECT 
    e.employee_name,
    e.position,
    s.store_name,
    SUM(o.total_amount) as total_sales,
    COUNT(o.order_id) as order_count
FROM employees e
JOIN stores s ON e.store_id = s.store_id
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_name, e.position, s.store_name
ORDER BY total_sales DESC;


-- 6.2: Top performing employees
SELECT 
    e.employee_name,
    e.position,
    s.store_name,
    s.city,
    m.employee_name as manager_name,
    SUM(o.total_amount) as total_revenue,
    COUNT(o.order_id) as order_count
FROM employees e
JOIN stores s ON e.store_id = s.store_id
LEFT JOIN employees m ON e.manager_id = m.employee_id
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_name, e.position, s.store_name, s.city, m.employee_name
ORDER BY total_revenue DESC
LIMIT 10;


-- 6.3: Employee productivity by store
SELECT 
    s.store_name,
    COUNT(DISTINCT e.employee_id) as employee_count,
    SUM(o.total_amount) as total_sales,
    ROUND(SUM(o.total_amount) / COUNT(DISTINCT e.employee_id), 2) as avg_sales_per_employee
FROM stores s
JOIN employees e ON s.store_id = e.store_id
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY s.store_name
ORDER BY avg_sales_per_employee DESC;


-- 6.4: Manager performance comparison
SELECT 
    m.employee_name as manager_name,
    s.store_name,
    COUNT(DISTINCT e.employee_id) as employee_count,
    SUM(o.total_amount) as total_revenue
FROM employees m
JOIN stores s ON m.store_id = s.store_id
JOIN employees e ON m.employee_id = e.manager_id
LEFT JOIN orders o ON e.employee_id = o.employee_id
WHERE m.position LIKE '%Manager%'
GROUP BY m.employee_name, s.store_name
ORDER BY total_revenue DESC;


-- ============================================
-- Part 3: Complex Business Questions (30 min)
-- ============================================

-- Challenge 7: Profitability Analysis

-- 7.1: Profit margin by category
SELECT 
    c.category_name,
    SUM(oi.quantity * oi.unit_price) as revenue,
    SUM(oi.quantity * p.cost) as cost,
    SUM(oi.quantity * (oi.unit_price - p.cost)) as profit,
    ROUND(SUM(oi.quantity * (oi.unit_price - p.cost)) / SUM(oi.quantity * oi.unit_price) * 100, 2) as profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY profit DESC;


-- 7.2: Most profitable products
SELECT 
    p.product_name,
    c.category_name,
    SUM(oi.quantity) as units_sold,
    SUM(oi.quantity * oi.unit_price) as revenue,
    SUM(oi.quantity * (oi.unit_price - p.cost)) as profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_name, c.category_name
ORDER BY profit DESC
LIMIT 20;


-- 7.3: Profit by store and region
SELECT 
    s.region,
    s.store_name,
    SUM(oi.quantity * oi.unit_price) as revenue,
    SUM(oi.quantity * (oi.unit_price - p.cost)) as profit,
    ROUND(SUM(oi.quantity * (oi.unit_price - p.cost)) / SUM(oi.quantity * oi.unit_price) * 100, 2) as profit_margin_pct
FROM orders o
JOIN stores s ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY s.region, s.store_name
ORDER BY s.region, profit DESC;


-- 7.4: Impact of discounts on profitability
SELECT 
    CASE WHEN o.discount_amount > 0 THEN 'With Discount' ELSE 'No Discount' END as has_discount,
    COUNT(*) as order_count,
    ROUND(AVG(o.discount_amount / o.total_amount * 100), 2) as avg_discount_pct,
    ROUND(AVG((oi_profit.profit / oi_profit.revenue) * 100), 2) as avg_profit_margin
FROM orders o
JOIN (
    SELECT 
        order_id,
        SUM(quantity * unit_price) as revenue,
        SUM(quantity * (unit_price - p.cost)) as profit
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY order_id
) oi_profit ON o.order_id = oi_profit.order_id
GROUP BY has_discount;


-- Challenge 8: Inventory Management

-- 8.1: Products needing reorder
SELECT 
    p.product_name,
    c.category_name,
    p.stock_quantity,
    p.reorder_level,
    (p.reorder_level - p.stock_quantity) as shortage_amount
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.stock_quantity < p.reorder_level
ORDER BY shortage_amount DESC;


-- 8.2: Slow-moving inventory
WITH recent_sales AS (
    SELECT 
        oi.product_id,
        SUM(oi.quantity) as units_sold_90days
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY oi.product_id
)
SELECT 
    p.product_name,
    p.stock_quantity,
    COALESCE(rs.units_sold_90days, 0) as units_sold_90days
FROM products p
LEFT JOIN recent_sales rs ON p.product_id = rs.product_id
WHERE p.stock_quantity > 50
  AND COALESCE(rs.units_sold_90days, 0) < 10
ORDER BY p.stock_quantity DESC;


-- 8.3: Stock turnover rate
WITH category_sales AS (
    SELECT 
        p.category_id,
        SUM(oi.quantity) as total_units_sold
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category_id
),
category_stock AS (
    SELECT 
        category_id,
        AVG(stock_quantity) as avg_stock
    FROM products
    GROUP BY category_id
)
SELECT 
    c.category_name,
    cs.total_units_sold,
    ROUND(cst.avg_stock, 0) as avg_stock,
    ROUND(cs.total_units_sold / cst.avg_stock, 2) as turnover_rate
FROM categories c
JOIN category_sales cs ON c.category_id = cs.category_id
JOIN category_stock cst ON c.category_id = cst.category_id
ORDER BY turnover_rate DESC;


-- 8.4: Inventory value by category
SELECT 
    c.category_name,
    SUM(p.stock_quantity) as total_units,
    SUM(p.stock_quantity * p.cost) as inventory_value
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY inventory_value DESC;


-- Challenge 9: Customer Segmentation

-- 9.1: RFM Analysis
WITH customer_rfm AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        DATEDIFF('day', MAX(o.order_date), CURRENT_DATE) as recency_days,
        COUNT(o.order_id) as frequency,
        SUM(o.total_amount) as monetary_value
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    recency_days,
    frequency,
    ROUND(monetary_value, 2) as monetary_value
FROM customer_rfm
WHERE frequency > 0
ORDER BY monetary_value DESC
LIMIT 50;


-- 9.2: High-value customer identification
WITH customer_ltv AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.total_amount) as lifetime_value,
        PERCENT_RANK() OVER (ORDER BY SUM(o.total_amount)) as value_percentile
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    ROUND(lifetime_value, 2) as lifetime_value,
    ROUND(value_percentile * 100, 2) as value_percentile
FROM customer_ltv
WHERE value_percentile >= 0.8
ORDER BY lifetime_value DESC;


-- 9.3: At-risk customers
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(o.total_amount) as lifetime_value,
        MAX(o.order_date) as last_order_date,
        DATEDIFF('day', MAX(o.order_date), CURRENT_DATE) as days_since_purchase
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    ROUND(lifetime_value, 2) as lifetime_value,
    days_since_purchase,
    last_order_date
FROM customer_metrics
WHERE lifetime_value > 1000
  AND days_since_purchase > 90
ORDER BY lifetime_value DESC;


-- 9.4: Customer personas
WITH customer_behavior AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) as order_count,
        AVG(o.total_amount) as avg_order_value
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    CASE 
        WHEN order_count >= 10 AND avg_order_value >= 200 THEN 'VIP'
        WHEN order_count >= 10 THEN 'Frequent Buyer'
        WHEN avg_order_value >= 200 THEN 'High Spender'
        WHEN order_count >= 3 THEN 'Regular'
        ELSE 'Occasional'
    END as persona,
    COUNT(*) as customer_count,
    ROUND(AVG(order_count * avg_order_value), 2) as avg_lifetime_value
FROM customer_behavior
WHERE order_count > 0
GROUP BY persona
ORDER BY avg_lifetime_value DESC;


-- ============================================
-- Part 4: Executive Summary (20 min)
-- ============================================

-- Challenge 10: Executive Dashboard

-- 10.1: Key Performance Indicators
WITH current_month AS (
    SELECT 
        SUM(total_amount) as revenue,
        COUNT(*) as orders
    FROM orders
    WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', CURRENT_DATE)
),
last_month AS (
    SELECT 
        SUM(total_amount) as revenue,
        COUNT(*) as orders
    FROM orders
    WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
)
SELECT 
    cm.revenue as current_month_revenue,
    lm.revenue as last_month_revenue,
    cm.orders as current_month_orders,
    lm.orders as last_month_orders,
    (SELECT ROUND(AVG(total_amount), 2) FROM orders) as avg_order_value,
    (SELECT COUNT(DISTINCT customer_id) FROM customers) as total_customers,
    (SELECT COUNT(DISTINCT customer_id) FROM orders WHERE order_date >= CURRENT_DATE - INTERVAL '30 days') as active_customers
FROM current_month cm, last_month lm;


-- 10.2: Top Performers
SELECT 'Product' as type, product_name as name, ROUND(revenue, 2) as value
FROM (
    SELECT p.product_name, SUM(oi.quantity * oi.unit_price) as revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_name
    ORDER BY revenue DESC
    LIMIT 3
)
UNION ALL
SELECT 'Customer', c.customer_name, ROUND(SUM(o.total_amount), 2)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY SUM(o.total_amount) DESC
LIMIT 3
UNION ALL
SELECT 'Store', s.store_name, ROUND(SUM(o.total_amount), 2)
FROM stores s
JOIN orders o ON s.store_id = o.store_id
GROUP BY s.store_name
ORDER BY SUM(o.total_amount) DESC
LIMIT 3;


-- 10.3: Growth Trends
WITH quarterly_metrics AS (
    SELECT 
        YEAR(order_date) as year,
        QUARTER(order_date) as quarter,
        SUM(total_amount) as revenue,
        COUNT(*) as orders
    FROM orders
    GROUP BY YEAR(order_date), QUARTER(order_date)
)
SELECT 
    year,
    quarter,
    revenue,
    orders,
    LAG(revenue) OVER (ORDER BY year, quarter) as prev_quarter_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY year, quarter)) / LAG(revenue) OVER (ORDER BY year, quarter) * 100, 2) as qoq_growth_pct
FROM quarterly_metrics
ORDER BY year, quarter;


-- 10.4: Areas of Concern
-- Low stock products
SELECT 'Low Stock' as concern_type, 
       p.product_name as item,
       CONCAT(p.stock_quantity, ' units (need ', p.reorder_level, ')') as details
FROM products p
WHERE p.stock_quantity < p.reorder_level
LIMIT 5

UNION ALL

-- Stores with declining sales
SELECT 'Declining Store',
       s.store_name,
       CONCAT(ROUND(recent.revenue - older.revenue, 2), ' decline')
FROM stores s
JOIN (
    SELECT store_id, SUM(total_amount) as revenue
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY store_id
) recent ON s.store_id = recent.store_id
JOIN (
    SELECT store_id, SUM(total_amount) as revenue
    FROM orders
    WHERE order_date BETWEEN CURRENT_DATE - INTERVAL '60 days' AND CURRENT_DATE - INTERVAL '30 days'
    GROUP BY store_id
) older ON s.store_id = older.store_id
WHERE recent.revenue < older.revenue
LIMIT 5

UNION ALL

-- High cancellation rate
SELECT 'High Cancellations',
       'Orders',
       CONCAT(COUNT(*), ' cancelled orders')
FROM orders
WHERE status = 'cancelled'
  AND order_date >= CURRENT_DATE - INTERVAL '30 days'
HAVING COUNT(*) > 10;


-- 10.5: Recommendations Query
-- Products to promote
SELECT 'Promote' as action,
       p.product_name as item,
       CONCAT('Rating: ', ROUND(AVG(r.rating), 1), ', Margin: ', ROUND((p.price - p.cost) / p.price * 100, 0), '%') as reason
FROM products p
JOIN reviews r ON p.product_id = r.product_id
WHERE p.is_active = TRUE
GROUP BY p.product_name, p.price, p.cost
HAVING AVG(r.rating) >= 4.0 AND (p.price - p.cost) / p.price > 0.3
LIMIT 5;


-- ============================================
-- BONUS: Advanced Challenges
-- ============================================

-- BONUS 1: Customer Lifetime Value Prediction
WITH first_3_months AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.registration_date,
        SUM(o.total_amount) as first_3mo_revenue,
        COUNT(o.order_id) as first_3mo_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_date <= c.registration_date + INTERVAL '90 days'
    GROUP BY c.customer_id, c.customer_name, c.registration_date
),
actual_ltv AS (
    SELECT 
        customer_id,
        SUM(total_amount) as actual_lifetime_value
    FROM orders
    GROUP BY customer_id
)
SELECT 
    f.customer_name,
    f.first_3mo_revenue,
    f.first_3mo_orders,
    ROUND(a.actual_lifetime_value, 2) as actual_ltv,
    ROUND(f.first_3mo_revenue * 4, 2) as predicted_ltv,
    ROUND(ABS(a.actual_lifetime_value - f.first_3mo_revenue * 4) / a.actual_lifetime_value * 100, 2) as prediction_error_pct
FROM first_3_months f
JOIN actual_ltv a ON f.customer_id = a.customer_id
WHERE DATEDIFF('day', f.registration_date, CURRENT_DATE) > 365
ORDER BY actual_ltv DESC
LIMIT 20;


-- BONUS 2: Product Recommendation Engine
WITH product_pairs AS (
    SELECT 
        oi1.product_id as product_a,
        oi2.product_id as product_b,
        COUNT(DISTINCT oi1.order_id) as times_bought_together
    FROM order_items oi1
    JOIN order_items oi2 ON oi1.order_id = oi2.order_id
    WHERE oi1.product_id < oi2.product_id
    GROUP BY oi1.product_id, oi2.product_id
    HAVING COUNT(DISTINCT oi1.order_id) >= 5
)
SELECT 
    p1.product_name as product_a,
    p2.product_name as product_b,
    pp.times_bought_together,
    ROUND(pp.times_bought_together * 100.0 / (
        SELECT COUNT(DISTINCT order_id) 
        FROM order_items 
        WHERE product_id = pp.product_a
    ), 2) as confidence_pct
FROM product_pairs pp
JOIN products p1 ON pp.product_a = p1.product_id
JOIN products p2 ON pp.product_b = p2.product_id
ORDER BY times_bought_together DESC
LIMIT 20;


-- BONUS 3: Churn Prediction
WITH customer_activity AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.customer_segment,
        COUNT(o.order_id) as total_orders,
        SUM(o.total_amount) as lifetime_value,
        MAX(o.order_date) as last_order_date,
        DATEDIFF('day', MAX(o.order_date), CURRENT_DATE) as days_since_last_order,
        AVG(DATEDIFF('day', 
            LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date),
            o.order_date
        )) as avg_days_between_orders
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.customer_segment
)
SELECT 
    customer_name,
    customer_segment,
    total_orders,
    ROUND(lifetime_value, 2) as lifetime_value,
    days_since_last_order,
    ROUND(avg_days_between_orders, 0) as avg_days_between_orders,
    CASE 
        WHEN days_since_last_order > avg_days_between_orders * 2 THEN 'High Risk'
        WHEN days_since_last_order > avg_days_between_orders * 1.5 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as churn_risk
FROM customer_activity
WHERE total_orders > 0
  AND avg_days_between_orders IS NOT NULL
ORDER BY 
    CASE 
        WHEN days_since_last_order > avg_days_between_orders * 2 THEN 1
        WHEN days_since_last_order > avg_days_between_orders * 1.5 THEN 2
        ELSE 3
    END,
    lifetime_value DESC
LIMIT 50;


-- BONUS 4: Store Performance Scorecard
WITH store_metrics AS (
    SELECT 
        s.store_id,
        s.store_name,
        s.region,
        SUM(o.total_amount) as revenue,
        COUNT(o.order_id) as order_count,
        COUNT(DISTINCT o.customer_id) as unique_customers,
        AVG(o.total_amount) as avg_order_value,
        SUM(oi.quantity * (oi.unit_price - p.cost)) as profit,
        COUNT(DISTINCT e.employee_id) as employee_count
    FROM stores s
    LEFT JOIN orders o ON s.store_id = o.store_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN employees e ON s.store_id = e.store_id
    GROUP BY s.store_id, s.store_name, s.region
),
store_ranks AS (
    SELECT 
        *,
        PERCENT_RANK() OVER (ORDER BY revenue) as revenue_rank,
        PERCENT_RANK() OVER (ORDER BY profit) as profit_rank,
        PERCENT_RANK() OVER (ORDER BY unique_customers) as customer_rank,
        PERCENT_RANK() OVER (ORDER BY avg_order_value) as aov_rank
    FROM store_metrics
)
SELECT 
    store_name,
    region,
    ROUND(revenue, 2) as revenue,
    ROUND(profit, 2) as profit,
    order_count,
    unique_customers,
    ROUND(avg_order_value, 2) as avg_order_value,
    employee_count,
    ROUND((revenue_rank + profit_rank + customer_rank + aov_rank) / 4 * 100, 1) as overall_score
FROM store_ranks
ORDER BY overall_score DESC;


-- BONUS 5: Query Optimization Example
-- Before optimization (slow):
/*
SELECT 
    c.customer_name,
    p.product_name,
    o.order_date,
    oi.quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE c.customer_segment = 'Premium'
  AND YEAR(o.order_date) = 2023
  AND p.category_id IN (SELECT category_id FROM categories WHERE category_name = 'Electronics');
*/

-- After optimization (fast):
-- 1. Filter early with CTEs
-- 2. Use explicit joins
-- 3. Avoid subqueries in WHERE
WITH premium_customers AS (
    SELECT customer_id, customer_name
    FROM customers
    WHERE customer_segment = 'Premium'
),
electronics_products AS (
    SELECT p.product_id, p.product_name
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE c.category_name = 'Electronics'
),
filtered_orders AS (
    SELECT order_id, customer_id, order_date
    FROM orders
    WHERE YEAR(order_date) = 2023
)
SELECT 
    pc.customer_name,
    ep.product_name,
    fo.order_date,
    oi.quantity
FROM filtered_orders fo
JOIN premium_customers pc ON fo.customer_id = pc.customer_id
JOIN order_items oi ON fo.order_id = oi.order_id
JOIN electronics_products ep ON oi.product_id = ep.product_id;

-- Use EXPLAIN to compare:
-- EXPLAIN [query above]


-- ============================================
-- CONGRATULATIONS!
-- ============================================
-- You've completed the 30 Days of SQL Bootcamp!
-- You now have the skills to:
-- ✅ Write complex analytical queries
-- ✅ Optimize query performance
-- ✅ Design efficient database schemas
-- ✅ Extract business insights from data
-- ✅ Build comprehensive reports and dashboards
--
-- Keep practicing and building your SQL skills!
