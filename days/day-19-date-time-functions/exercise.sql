-- Day 19: Date and Time Functions
-- Practice exercises

-- ============================================
-- Part 1: Basic Date Functions (10 min)
-- ============================================

-- 1.1: Extract year, month, and day from order dates
-- TODO: Write your query
-- Expected columns: order_id, order_date, year, month, day


-- 1.2: Show orders with days since order date
-- TODO: Write your query
-- Expected columns: order_id, order_date, days_ago
-- Hint: CURRENT_DATE - order_date


-- 1.3: Show orders with day of week (0=Sunday, 6=Saturday)
-- TODO: Write your query
-- Expected columns: order_id, order_date, day_of_week, day_name
-- Hint: Use EXTRACT(DOW ...) and CASE for day name


-- 1.4: Group orders by quarter and show counts
-- TODO: Write your query
-- Expected columns: year, quarter, order_count, total_revenue


-- 1.5: Show orders with week number
-- TODO: Write your query
-- Expected columns: order_id, order_date, week_number
-- Hint: EXTRACT(WEEK FROM order_date)


-- ============================================
-- Part 2: Date Arithmetic (10 min)
-- ============================================

-- 2.1: Show order date plus 7 days, 30 days, and 1 year
-- TODO: Write your query
-- Expected columns: order_id, order_date, plus_7_days, plus_30_days, plus_1_year


-- 2.2: Find orders from the last 30 days
-- TODO: Write your query
-- Expected columns: order_id, order_date, total
-- Hint: WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'


-- 2.3: Find all orders from the current month
-- TODO: Write your query
-- Expected columns: order_id, order_date, total
-- Hint: DATE_TRUNC('month', CURRENT_DATE)


-- 2.4: Calculate customer age from birth_date
-- TODO: Write your query
-- Expected columns: customer_name, birth_date, age_years
-- Hint: (CURRENT_DATE - birth_date) / 365


-- 2.5: Calculate days since customer registration
-- TODO: Write your query
-- Expected columns: customer_name, registration_date, days_since_registration


-- ============================================
-- Part 3: DATE_TRUNC and Grouping (10 min)
-- ============================================

-- 3.1: Calculate revenue by month
-- TODO: Write your query
-- Expected columns: month, order_count, total_revenue
-- Hint: GROUP BY DATE_TRUNC('month', order_date)


-- 3.2: Show order counts by week
-- TODO: Write your query
-- Expected columns: week_start, order_count
-- Hint: DATE_TRUNC('week', order_date)


-- 3.3: Show revenue by year and quarter
-- TODO: Write your query
-- Expected columns: year, quarter, revenue


-- 3.4: Calculate average daily revenue for each month
-- TODO: Write your query
-- Expected columns: month, total_revenue, days_with_orders, avg_daily_revenue
-- Hint: Count distinct order dates per month


-- ============================================
-- Part 4: Time-Based Filtering (5 min)
-- ============================================

-- 4.1: Find customers who registered in the last 90 days
-- TODO: Write your query
-- Expected columns: customer_name, registration_date, days_ago


-- 4.2: Find customers who haven't ordered in 6+ months
-- TODO: Write your query
-- Expected columns: customer_name, last_order_date, days_since_last_order
-- Hint: Check last_order_date IS NOT NULL


-- 4.3: Categorize orders by season and count them
-- TODO: Write your query
-- Expected columns: season, order_count, total_revenue
-- Hint: Use CASE with EXTRACT(MONTH ...) - Winter: 12,1,2; Spring: 3,4,5; Summer: 6,7,8; Fall: 9,10,11


-- 4.4: Show orders placed on weekdays only (Monday-Friday)
-- TODO: Write your query
-- Expected columns: order_id, order_date, day_name
-- Hint: EXTRACT(DOW ...) NOT IN (0, 6)


-- ============================================
-- Part 5: Advanced Analysis (5 min)
-- ============================================

-- 5.1: Segment customers by tenure
-- TODO: Write your query
-- New: < 3 months, Recent: 3-12 months, Established: 1-3 years, Veteran: 3+ years
-- Expected columns: tenure_segment, customer_count


-- 5.2: Create monthly registration cohorts and show their order counts
-- TODO: Write your query
-- Expected columns: cohort_month, customers_in_cohort, total_orders, orders_per_customer
-- Hint: GROUP BY DATE_TRUNC('month', registration_date), then join with orders


-- 5.3: Calculate event duration in days
-- TODO: Write your query
-- Expected columns: event_name, start_date, end_date, duration_days


-- 5.4: Analyze orders by time of day (Morning: 6-11, Afternoon: 12-17, Evening: 18-21, Night: 22-5)
-- TODO: Write your query
-- Expected columns: time_period, order_count, avg_order_value
-- Hint: EXTRACT(HOUR FROM order_timestamp)

