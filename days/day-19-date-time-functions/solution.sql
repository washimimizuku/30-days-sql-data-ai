-- Day 19: Date and Time Functions
-- Solutions

-- ============================================
-- Part 1: Basic Date Functions (10 min)
-- ============================================

-- 1.1: Extract year, month, and day from order dates
SELECT 
    order_id,
    order_date,
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    EXTRACT(DAY FROM order_date) as day
FROM orders
ORDER BY order_date
LIMIT 10;

-- 1.2: Show orders with days since order date
SELECT 
    order_id,
    order_date,
    CURRENT_DATE - order_date as days_ago
FROM orders
ORDER BY days_ago
LIMIT 10;

-- 1.3: Show orders with day of week
SELECT 
    order_id,
    order_date,
    EXTRACT(DOW FROM order_date) as day_of_week,
    CASE EXTRACT(DOW FROM order_date)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END as day_name
FROM orders
ORDER BY order_date
LIMIT 10;

-- 1.4: Group orders by quarter and show counts
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(QUARTER FROM order_date) as quarter,
    COUNT(*) as order_count,
    SUM(total) as total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY year, quarter
ORDER BY year, quarter;

-- 1.5: Show orders with week number
SELECT 
    order_id,
    order_date,
    EXTRACT(WEEK FROM order_date) as week_number
FROM orders
ORDER BY order_date
LIMIT 10;


-- ============================================
-- Part 2: Date Arithmetic (10 min)
-- ============================================

-- 2.1: Show order date plus 7 days, 30 days, and 1 year
SELECT 
    order_id,
    order_date,
    order_date + INTERVAL '7 days' as plus_7_days,
    order_date + INTERVAL '30 days' as plus_30_days,
    order_date + INTERVAL '1 year' as plus_1_year
FROM orders
ORDER BY order_date
LIMIT 10;

-- 2.2: Find orders from the last 30 days
SELECT 
    order_id,
    order_date,
    total
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY order_date DESC;

-- 2.3: Find all orders from the current month
SELECT 
    order_id,
    order_date,
    total
FROM orders
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', CURRENT_DATE)
ORDER BY order_date;

-- 2.4: Calculate customer age from birth_date
SELECT 
    customer_name,
    birth_date,
    (CURRENT_DATE - birth_date) / 365 as age_years
FROM customers
ORDER BY age_years DESC;

-- 2.5: Calculate days since customer registration
SELECT 
    customer_name,
    registration_date,
    CURRENT_DATE - registration_date as days_since_registration
FROM customers
ORDER BY days_since_registration DESC;


-- ============================================
-- Part 3: DATE_TRUNC and Grouping (10 min)
-- ============================================

-- 3.1: Calculate revenue by month
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(*) as order_count,
    SUM(total) as total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- 3.2: Show order counts by week
SELECT 
    DATE_TRUNC('week', order_date) as week_start,
    COUNT(*) as order_count
FROM orders
GROUP BY DATE_TRUNC('week', order_date)
ORDER BY week_start;

-- 3.3: Show revenue by year and quarter
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(QUARTER FROM order_date) as quarter,
    SUM(total) as revenue
FROM orders
WHERE status = 'completed'
GROUP BY year, quarter
ORDER BY year, quarter;

-- 3.4: Calculate average daily revenue for each month
SELECT 
    DATE_TRUNC('month', order_date) as month,
    SUM(total) as total_revenue,
    COUNT(DISTINCT order_date) as days_with_orders,
    ROUND(SUM(total) / COUNT(DISTINCT order_date), 2) as avg_daily_revenue
FROM orders
WHERE status = 'completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;


-- ============================================
-- Part 4: Time-Based Filtering (5 min)
-- ============================================

-- 4.1: Find customers who registered in the last 90 days
SELECT 
    customer_name,
    registration_date,
    CURRENT_DATE - registration_date as days_ago
FROM customers
WHERE registration_date >= CURRENT_DATE - INTERVAL '90 days'
ORDER BY registration_date DESC;

-- 4.2: Find customers who haven't ordered in 6+ months
SELECT 
    customer_name,
    last_order_date,
    CURRENT_DATE - last_order_date as days_since_last_order
FROM customers
WHERE last_order_date IS NOT NULL
  AND last_order_date < CURRENT_DATE - INTERVAL '6 months'
ORDER BY days_since_last_order DESC;

-- 4.3: Categorize orders by season and count them
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM order_date) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM order_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM order_date) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
    END as season,
    COUNT(*) as order_count,
    SUM(total) as total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY season
ORDER BY 
    CASE season
        WHEN 'Winter' THEN 1
        WHEN 'Spring' THEN 2
        WHEN 'Summer' THEN 3
        ELSE 4
    END;

-- 4.4: Show orders placed on weekdays only (Monday-Friday)
SELECT 
    order_id,
    order_date,
    CASE EXTRACT(DOW FROM order_date)
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
    END as day_name
FROM orders
WHERE EXTRACT(DOW FROM order_date) NOT IN (0, 6)
ORDER BY order_date
LIMIT 20;


-- ============================================
-- Part 5: Advanced Analysis (5 min)
-- ============================================

-- 5.1: Segment customers by tenure
SELECT 
    CASE 
        WHEN registration_date >= CURRENT_DATE - INTERVAL '3 months' THEN 'New'
        WHEN registration_date >= CURRENT_DATE - INTERVAL '1 year' THEN 'Recent'
        WHEN registration_date >= CURRENT_DATE - INTERVAL '3 years' THEN 'Established'
        ELSE 'Veteran'
    END as tenure_segment,
    COUNT(*) as customer_count
FROM customers
GROUP BY tenure_segment
ORDER BY 
    CASE tenure_segment
        WHEN 'New' THEN 1
        WHEN 'Recent' THEN 2
        WHEN 'Established' THEN 3
        ELSE 4
    END;

-- 5.2: Create monthly registration cohorts and show their order counts
SELECT 
    DATE_TRUNC('month', c.registration_date) as cohort_month,
    COUNT(DISTINCT c.customer_id) as customers_in_cohort,
    COUNT(o.order_id) as total_orders,
    ROUND(COUNT(o.order_id) * 1.0 / COUNT(DISTINCT c.customer_id), 2) as orders_per_customer
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY DATE_TRUNC('month', c.registration_date)
ORDER BY cohort_month;

-- 5.3: Calculate event duration in days
SELECT 
    event_name,
    start_date,
    end_date,
    end_date - start_date as duration_days
FROM events
ORDER BY duration_days DESC;

-- 5.4: Analyze orders by time of day
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_timestamp) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_timestamp) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM order_timestamp) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END as time_period,
    COUNT(*) as order_count,
    ROUND(AVG(total), 2) as avg_order_value
FROM orders
WHERE status = 'completed'
GROUP BY time_period
ORDER BY 
    CASE time_period
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
        ELSE 4
    END;
