-- Day 28: Data Modeling - Star Schema Solutions
-- Database: day28.db

-- ============================================
-- Exercise 1: Explore the Star Schema (5 min)
-- ============================================

-- 1.1: Show all tables in the database
SHOW TABLES;
-- Expected: fact_sales, dim_date, dim_customer, dim_product, dim_store


-- 1.2: Describe the structure of fact_sales
DESCRIBE fact_sales;
-- Or: PRAGMA table_info(fact_sales);


-- 1.3: Count rows in each table
SELECT 'fact_sales' as table_name, COUNT(*) as row_count FROM fact_sales
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_store', COUNT(*) FROM dim_store;


-- 1.4: Show sample data from fact_sales with all dimensions
SELECT 
    f.sale_id,
    d.date,
    c.customer_name,
    p.product_name,
    s.store_name,
    f.quantity,
    f.total_amount
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_customer c ON f.customer_id = c.customer_id
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_store s ON f.store_id = s.store_id
LIMIT 10;


-- ============================================
-- Exercise 2: Basic Dimensional Queries (10 min)
-- ============================================

-- 2.1: Calculate total revenue by category
SELECT 
    p.category,
    SUM(f.total_amount) as total_revenue,
    COUNT(*) as transaction_count
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- 2.2: Find top 10 customers by total spend
SELECT 
    c.customer_name,
    c.city,
    c.segment,
    SUM(f.total_amount) as total_spent,
    COUNT(*) as order_count
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_name, c.city, c.segment
ORDER BY total_spent DESC
LIMIT 10;


-- 2.3: Show monthly sales trends for 2024
SELECT 
    d.month,
    d.month_name,
    SUM(f.total_amount) as revenue,
    COUNT(*) as transaction_count
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
WHERE d.year = 2024
GROUP BY d.month, d.month_name
ORDER BY d.month;


-- 2.4: Calculate revenue by store region
SELECT 
    s.region,
    SUM(f.total_amount) as revenue,
    COUNT(DISTINCT s.store_id) as store_count,
    ROUND(SUM(f.total_amount) / COUNT(DISTINCT s.store_id), 2) as avg_revenue_per_store
FROM fact_sales f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.region
ORDER BY revenue DESC;


-- 2.5: Find best-selling products by quantity
SELECT 
    p.product_name,
    p.category,
    SUM(f.quantity) as total_quantity_sold,
    SUM(f.total_amount) as total_revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- ============================================
-- Exercise 3: Time-Series Analysis (10 min)
-- ============================================

-- 3.1: Calculate revenue by quarter
SELECT 
    d.year,
    d.quarter,
    SUM(f.total_amount) as revenue,
    SUM(f.profit_amount) as profit,
    COUNT(*) as transaction_count
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.quarter
ORDER BY d.year, d.quarter;


-- 3.2: Compare sales between weekdays and weekends
SELECT 
    CASE WHEN d.is_weekend THEN 'Weekend' ELSE 'Weekday' END as day_type,
    SUM(f.total_amount) as revenue,
    COUNT(*) as transaction_count,
    ROUND(AVG(f.total_amount), 2) as avg_transaction_value
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.is_weekend;


-- 3.3: Find the best performing month
SELECT 
    d.year,
    d.month,
    d.month_name,
    SUM(f.total_amount) as revenue
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY revenue DESC
LIMIT 1;


-- 3.4: Calculate year-over-year growth
WITH yearly_revenue AS (
    SELECT 
        d.year,
        SUM(f.total_amount) as revenue
    FROM fact_sales f
    JOIN dim_date d ON f.date_id = d.date_id
    GROUP BY d.year
)
SELECT 
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) as prev_year_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY year)) / LAG(revenue) OVER (ORDER BY year) * 100, 2) as yoy_growth_pct
FROM yearly_revenue
ORDER BY year;


-- 3.5: Identify seasonal patterns
SELECT 
    d.month,
    d.month_name,
    ROUND(AVG(f.total_amount), 2) as avg_monthly_revenue,
    COUNT(*) as total_transactions
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.month, d.month_name
ORDER BY d.month;


-- ============================================
-- Exercise 4: Advanced Analytics (10 min)
-- ============================================

-- 4.1: Calculate profit margin by category
SELECT 
    p.category,
    SUM(f.total_amount) as revenue,
    SUM(f.profit_amount) as profit,
    ROUND(SUM(f.profit_amount) / SUM(f.total_amount) * 100, 2) as profit_margin_pct
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY profit_margin_pct DESC;


-- 4.2: Find customer segments by lifetime value
WITH customer_ltv AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.segment,
        SUM(f.total_amount) as lifetime_value
    FROM fact_sales f
    JOIN dim_customer c ON f.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment
)
SELECT 
    CASE 
        WHEN lifetime_value > 5000 THEN 'High Value'
        WHEN lifetime_value > 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END as value_segment,
    COUNT(*) as customer_count,
    ROUND(AVG(lifetime_value), 2) as avg_lifetime_value,
    ROUND(SUM(lifetime_value), 2) as total_value
FROM customer_ltv
GROUP BY value_segment
ORDER BY avg_lifetime_value DESC;


-- 4.3: Analyze discount impact on sales
SELECT 
    CASE 
        WHEN f.discount_amount > 0 THEN 'With Discount'
        ELSE 'No Discount'
    END as has_discount,
    COUNT(*) as transaction_count,
    ROUND(AVG(f.discount_amount), 2) as avg_discount,
    ROUND(AVG(f.total_amount), 2) as avg_total_amount,
    ROUND(SUM(f.total_amount), 2) as total_revenue
FROM fact_sales f
GROUP BY has_discount;


-- 4.4: Calculate store performance metrics
SELECT 
    s.store_name,
    s.city,
    s.region,
    SUM(f.total_amount) as revenue,
    SUM(f.profit_amount) as profit,
    COUNT(*) as transaction_count,
    ROUND(AVG(f.total_amount), 2) as avg_transaction,
    ROUND(SUM(f.profit_amount) / SUM(f.total_amount) * 100, 2) as profit_margin_pct
FROM fact_sales f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.store_name, s.city, s.region
ORDER BY revenue DESC;


-- 4.5: Identify cross-selling opportunities
-- Find products frequently bought together
WITH product_pairs AS (
    SELECT 
        f1.product_id as product_a,
        f2.product_id as product_b,
        COUNT(*) as pair_count
    FROM fact_sales f1
    JOIN fact_sales f2 
        ON f1.customer_id = f2.customer_id 
        AND f1.date_id = f2.date_id
        AND f1.product_id < f2.product_id
    GROUP BY f1.product_id, f2.product_id
    HAVING COUNT(*) >= 3
)
SELECT 
    p1.product_name as product_a,
    p2.product_name as product_b,
    pp.pair_count
FROM product_pairs pp
JOIN dim_product p1 ON pp.product_a = p1.product_id
JOIN dim_product p2 ON pp.product_b = p2.product_id
ORDER BY pp.pair_count DESC
LIMIT 10;


-- ============================================
-- Exercise 5: Star Schema Benefits (5 min)
-- ============================================

-- 5.1: Write a query joining all dimensions
SELECT 
    f.sale_id,
    d.date,
    d.day_name,
    c.customer_name,
    c.city as customer_city,
    c.segment,
    p.product_name,
    p.category,
    s.store_name,
    s.region,
    f.quantity,
    f.unit_price,
    f.discount_amount,
    f.total_amount,
    f.profit_amount
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_customer c ON f.customer_id = c.customer_id
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_store s ON f.store_id = s.store_id
LIMIT 20;


-- 5.2: Calculate running totals by date
SELECT 
    d.date,
    SUM(f.total_amount) as daily_revenue,
    SUM(SUM(f.total_amount)) OVER (ORDER BY d.date) as running_total
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.date
ORDER BY d.date
LIMIT 30;


-- 5.3: Rank products within categories
SELECT 
    p.category,
    p.product_name,
    SUM(f.total_amount) as revenue,
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(f.total_amount) DESC) as rank_in_category
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, rank_in_category;


-- 5.4: Create a sales dashboard query
SELECT 
    -- Overall metrics
    SUM(f.total_amount) as total_revenue,
    SUM(f.profit_amount) as total_profit,
    COUNT(*) as total_transactions,
    ROUND(AVG(f.total_amount), 2) as avg_transaction_value,
    
    -- Top performers
    (SELECT p.category FROM fact_sales f2 
     JOIN dim_product p ON f2.product_id = p.product_id 
     GROUP BY p.category ORDER BY SUM(f2.total_amount) DESC LIMIT 1) as top_category,
    
    (SELECT c.customer_name FROM fact_sales f2 
     JOIN dim_customer c ON f2.customer_id = c.customer_id 
     GROUP BY c.customer_name ORDER BY SUM(f2.total_amount) DESC LIMIT 1) as top_customer,
    
    (SELECT s.store_name FROM fact_sales f2 
     JOIN dim_store s ON f2.store_id = s.store_id 
     GROUP BY s.store_name ORDER BY SUM(f2.total_amount) DESC LIMIT 1) as top_store
FROM fact_sales f;


-- 5.5: Compare query performance
-- Star schema approach (clean and efficient)
SELECT 
    p.category,
    d.year,
    SUM(f.total_amount) as revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY p.category, d.year;

-- Note: Star schema is easier to write, understand, and maintain
-- All dimension attributes are pre-joined and denormalized


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Create a sales summary table
CREATE TABLE sales_summary AS
SELECT 
    d.date,
    p.category,
    s.region,
    SUM(f.total_amount) as revenue,
    SUM(f.profit_amount) as profit,
    COUNT(*) as transaction_count
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY d.date, p.category, s.region;

-- Verify
SELECT * FROM sales_summary LIMIT 10;


-- BONUS 2: Implement a slowly changing dimension
-- Add SCD Type 2 columns to dim_customer
ALTER TABLE dim_customer ADD COLUMN effective_date DATE DEFAULT '2023-01-01';
ALTER TABLE dim_customer ADD COLUMN end_date DATE DEFAULT '9999-12-31';
ALTER TABLE dim_customer ADD COLUMN is_current BOOLEAN DEFAULT TRUE;

-- Example: Track customer address change
-- When customer moves, insert new row with new address and dates
INSERT INTO dim_customer (
    customer_id, customer_name, email, city, state, segment,
    effective_date, end_date, is_current
)
SELECT 
    customer_id, customer_name, email, 
    'New City' as city, 'NC' as state, segment,
    '2024-06-01' as effective_date,
    '9999-12-31' as end_date,
    TRUE as is_current
FROM dim_customer
WHERE customer_id = 1 AND is_current = TRUE;

-- Update old row
UPDATE dim_customer 
SET end_date = '2024-05-31', is_current = FALSE
WHERE customer_id = 1 AND end_date = '9999-12-31' AND is_current = TRUE;


-- BONUS 3: Calculate customer cohort analysis
WITH customer_cohorts AS (
    SELECT 
        c.customer_id,
        DATE_TRUNC('month', c.registration_date) as cohort_month,
        DATE_TRUNC('month', d.date) as purchase_month
    FROM fact_sales f
    JOIN dim_customer c ON f.customer_id = c.customer_id
    JOIN dim_date d ON f.date_id = d.date_id
)
SELECT 
    cohort_month,
    COUNT(DISTINCT customer_id) as cohort_size,
    COUNT(DISTINCT CASE WHEN purchase_month = cohort_month THEN customer_id END) as month_0,
    COUNT(DISTINCT CASE WHEN purchase_month = cohort_month + INTERVAL '1 month' THEN customer_id END) as month_1,
    COUNT(DISTINCT CASE WHEN purchase_month = cohort_month + INTERVAL '2 months' THEN customer_id END) as month_2
FROM customer_cohorts
GROUP BY cohort_month
ORDER BY cohort_month;


-- BONUS 4: Build a product recommendation query
-- "Customers who bought X also bought Y"
WITH product_x_customers AS (
    SELECT DISTINCT customer_id
    FROM fact_sales
    WHERE product_id = 1  -- Replace with specific product
)
SELECT 
    p.product_name,
    p.category,
    COUNT(DISTINCT f.customer_id) as customer_count,
    ROUND(COUNT(DISTINCT f.customer_id) * 100.0 / (SELECT COUNT(*) FROM product_x_customers), 2) as pct_of_customers
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
WHERE f.customer_id IN (SELECT customer_id FROM product_x_customers)
  AND f.product_id != 1  -- Exclude the original product
GROUP BY p.product_name, p.category
ORDER BY customer_count DESC
LIMIT 10;
