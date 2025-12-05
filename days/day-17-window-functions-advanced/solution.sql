-- Day 17: Window Functions - LAG, LEAD, Moving Averages
-- Solutions

-- ============================================
-- Part 1: Basic LAG and LEAD (10 min)
-- ============================================

-- 1.1: Show each day's sales with the previous day's sales
SELECT 
    date,
    total,
    LAG(total) OVER (ORDER BY date) as prev_day_total
FROM daily_sales
ORDER BY date;

-- 1.2: Show each day's sales with the next day's sales
SELECT 
    date,
    total,
    LEAD(total) OVER (ORDER BY date) as next_day_total
FROM daily_sales
ORDER BY date;

-- 1.3: Calculate the change in sales from the previous day
SELECT 
    date,
    total,
    LAG(total) OVER (ORDER BY date) as prev_day_total,
    total - LAG(total) OVER (ORDER BY date) as change
FROM daily_sales
ORDER BY date;

-- 1.4: Calculate the percentage change from the previous day
SELECT 
    date,
    total,
    LAG(total) OVER (ORDER BY date) as prev_day_total,
    ROUND((total - LAG(total) OVER (ORDER BY date)) * 100.0 / 
          LAG(total) OVER (ORDER BY date), 2) as change_pct
FROM daily_sales
ORDER BY date;

-- 1.5: Compare each day's sales to the same day last week (7 days ago)
SELECT 
    date,
    total,
    LAG(total, 7) OVER (ORDER BY date) as last_week_total,
    total - LAG(total, 7) OVER (ORDER BY date) as wow_change
FROM daily_sales
ORDER BY date;


-- ============================================
-- Part 2: LAG/LEAD with PARTITION BY (10 min)
-- ============================================

-- 2.1: Show each customer's orders with their previous order date and amount
SELECT 
    c.customer_name,
    o.order_date,
    o.total,
    LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as prev_order_date,
    LAG(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as prev_order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, o.order_date;

-- 2.2: Calculate days between consecutive orders for each customer
SELECT 
    c.customer_name,
    o.order_date,
    LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as prev_order_date,
    o.order_date - LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as days_between
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, o.order_date;

-- 2.3: Show if each customer's order value is increasing or decreasing
SELECT 
    c.customer_name,
    o.order_date,
    o.total,
    LAG(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as prev_total,
    CASE 
        WHEN o.total > LAG(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) THEN 'Increasing'
        WHEN o.total < LAG(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) THEN 'Decreasing'
        WHEN LAG(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) IS NULL THEN 'First Order'
        ELSE 'Stable'
    END as trend
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, o.order_date;

-- 2.4: Compare each customer's order to their first order
SELECT 
    c.customer_name,
    o.order_date,
    o.total,
    FIRST_VALUE(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as first_order_total,
    o.total - FIRST_VALUE(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as difference_from_first
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, o.order_date;


-- ============================================
-- Part 3: Moving Averages (10 min)
-- ============================================

-- 3.1: Calculate a 7-day moving average of sales
SELECT 
    date,
    total,
    ROUND(AVG(total) OVER (
        ORDER BY date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) as ma_7
FROM daily_sales
ORDER BY date;

-- 3.2: Calculate 3-day, 7-day, and 30-day moving averages
SELECT 
    date,
    total,
    ROUND(AVG(total) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) as ma_3,
    ROUND(AVG(total) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as ma_7,
    ROUND(AVG(total) OVER (ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) as ma_30
FROM daily_sales
ORDER BY date;

-- 3.3: Calculate a 5-day centered moving average
SELECT 
    date,
    total,
    ROUND(AVG(total) OVER (
        ORDER BY date
        ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
    ), 2) as centered_ma_5
FROM daily_sales
ORDER BY date;

-- 3.4: Compare daily sales to its 7-day moving average
SELECT 
    date,
    total,
    ROUND(AVG(total) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as ma_7,
    ROUND(total - AVG(total) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as diff_from_ma,
    CASE 
        WHEN total > AVG(total) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) THEN 'Above MA'
        ELSE 'Below MA'
    END as above_or_below
FROM daily_sales
ORDER BY date;


-- ============================================
-- Part 4: Running Totals (5 min)
-- ============================================

-- 4.1: Calculate a running total of sales
SELECT 
    date,
    total,
    SUM(total) OVER (ORDER BY date) as running_total
FROM daily_sales
ORDER BY date;

-- 4.2: Calculate each customer's lifetime value (running total of orders)
SELECT 
    c.customer_name,
    o.order_date,
    o.total,
    SUM(o.total) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as lifetime_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, o.order_date;

-- 4.3: Show each day's sales as a percentage of the running total
SELECT 
    date,
    total,
    SUM(total) OVER (ORDER BY date) as running_total,
    ROUND(total * 100.0 / SUM(total) OVER (ORDER BY date), 2) as pct_of_running_total
FROM daily_sales
ORDER BY date;


-- ============================================
-- Part 5: Trend Analysis (5 min)
-- ============================================

-- 5.1: Identify days where sales have been increasing for 3 consecutive days
SELECT 
    date,
    total,
    CASE 
        WHEN total > LAG(total, 1) OVER (ORDER BY date) 
         AND LAG(total, 1) OVER (ORDER BY date) > LAG(total, 2) OVER (ORDER BY date)
        THEN 'Yes'
        ELSE 'No'
    END as is_uptrend
FROM daily_sales
ORDER BY date;

-- 5.2: Identify local peaks (days where sales are higher than both previous and next day)
SELECT 
    date,
    total,
    CASE 
        WHEN total > LAG(total) OVER (ORDER BY date) 
         AND total > LEAD(total) OVER (ORDER BY date)
        THEN 'Peak'
        ELSE 'Not Peak'
    END as is_peak
FROM daily_sales
ORDER BY date;

-- 5.3: Calculate daily stock returns (percentage change from previous close)
SELECT 
    date,
    symbol,
    close_price,
    LAG(close_price) OVER (PARTITION BY symbol ORDER BY date) as prev_close,
    ROUND((close_price - LAG(close_price) OVER (PARTITION BY symbol ORDER BY date)) * 100.0 / 
          LAG(close_price) OVER (PARTITION BY symbol ORDER BY date), 2) as daily_return_pct
FROM stock_prices
ORDER BY symbol, date;

-- 5.4: Show each stock's 7-day and 30-day moving averages
SELECT 
    date,
    symbol,
    close_price,
    ROUND(AVG(close_price) OVER (
        PARTITION BY symbol 
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) as ma_7,
    ROUND(AVG(close_price) OVER (
        PARTITION BY symbol 
        ORDER BY date 
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ), 2) as ma_30
FROM stock_prices
ORDER BY symbol, date;
