-- Day 17: Window Functions - LAG, LEAD, Moving Averages
-- Practice exercises

-- ============================================
-- Part 1: Basic LAG and LEAD (10 min)
-- ============================================

-- 1.1: Show each day's sales with the previous day's sales
-- TODO: Write your query
-- Expected columns: date, total, prev_day_total


-- 1.2: Show each day's sales with the next day's sales
-- TODO: Write your query
-- Expected columns: date, total, next_day_total


-- 1.3: Calculate the change in sales from the previous day
-- TODO: Write your query
-- Expected columns: date, total, prev_day_total, change


-- 1.4: Calculate the percentage change from the previous day
-- TODO: Write your query
-- Expected columns: date, total, prev_day_total, change_pct
-- Hint: (current - previous) * 100.0 / previous


-- 1.5: Compare each day's sales to the same day last week (7 days ago)
-- TODO: Write your query
-- Expected columns: date, total, last_week_total, wow_change


-- ============================================
-- Part 2: LAG/LEAD with PARTITION BY (10 min)
-- ============================================

-- 2.1: Show each customer's orders with their previous order date and amount
-- TODO: Write your query
-- Expected columns: customer_name, order_date, total, prev_order_date, prev_order_total
-- Hint: JOIN customers and orders, use PARTITION BY customer_id


-- 2.2: Calculate days between consecutive orders for each customer
-- TODO: Write your query
-- Expected columns: customer_name, order_date, prev_order_date, days_between


-- 2.3: Show if each customer's order value is increasing or decreasing
-- TODO: Write your query
-- Expected columns: customer_name, order_date, total, prev_total, trend
-- Hint: Use CASE to compare current vs previous


-- 2.4: Compare each customer's order to their first order
-- TODO: Write your query
-- Expected columns: customer_name, order_date, total, first_order_total, difference_from_first
-- Hint: Use FIRST_VALUE with PARTITION BY customer_id


-- ============================================
-- Part 3: Moving Averages (10 min)
-- ============================================

-- 3.1: Calculate a 7-day moving average of sales
-- TODO: Write your query
-- Expected columns: date, total, ma_7
-- Hint: AVG with ROWS BETWEEN 6 PRECEDING AND CURRENT ROW


-- 3.2: Calculate 3-day, 7-day, and 30-day moving averages
-- TODO: Write your query
-- Expected columns: date, total, ma_3, ma_7, ma_30


-- 3.3: Calculate a 5-day centered moving average
-- TODO: Write your query
-- Expected columns: date, total, centered_ma_5
-- Hint: ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING


-- 3.4: Compare daily sales to its 7-day moving average
-- TODO: Write your query
-- Expected columns: date, total, ma_7, diff_from_ma, above_or_below
-- Hint: Use CASE to determine if above or below MA


-- ============================================
-- Part 4: Running Totals (5 min)
-- ============================================

-- 4.1: Calculate a running total of sales
-- TODO: Write your query
-- Expected columns: date, total, running_total


-- 4.2: Calculate each customer's lifetime value (running total of orders)
-- TODO: Write your query
-- Expected columns: customer_name, order_date, total, lifetime_value
-- Hint: SUM with PARTITION BY customer_id


-- 4.3: Show each day's sales as a percentage of the running total
-- TODO: Write your query
-- Expected columns: date, total, running_total, pct_of_running_total


-- ============================================
-- Part 5: Trend Analysis (5 min)
-- ============================================

-- 5.1: Identify days where sales have been increasing for 3 consecutive days
-- TODO: Write your query
-- Expected columns: date, total, is_uptrend
-- Hint: Compare current with LAG(total, 1) and LAG(total, 2)


-- 5.2: Identify local peaks (days where sales are higher than both previous and next day)
-- TODO: Write your query
-- Expected columns: date, total, is_peak
-- Hint: Use both LAG and LEAD


-- 5.3: Calculate daily stock returns (percentage change from previous close)
-- TODO: Write your query on stock_prices table
-- Expected columns: date, symbol, close_price, prev_close, daily_return_pct
-- Hint: PARTITION BY symbol


-- 5.4: Show each stock's 7-day and 30-day moving averages
-- TODO: Write your query
-- Expected columns: date, symbol, close_price, ma_7, ma_30
-- Hint: PARTITION BY symbol

