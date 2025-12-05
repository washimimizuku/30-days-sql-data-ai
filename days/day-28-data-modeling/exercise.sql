-- Day 28: Data Modeling - Star Schema
-- Practice exercises for dimensional modeling and analytics

-- ============================================
-- Exercise 1: Explore the Star Schema (5 min)
-- ============================================

-- 1.1: Show all tables in the database
-- TODO: Use SHOW TABLES
-- Expected: fact_sales and 4 dimension tables


-- 1.2: Describe the structure of fact_sales
-- TODO: Use DESCRIBE or PRAGMA table_info
-- Expected: Columns with data types and keys


-- 1.3: Count rows in each table
-- TODO: Count rows in fact_sales, dim_date, dim_customer, dim_product, dim_store
-- Expected: Row counts for each table


-- 1.4: Show sample data from fact_sales with all dimensions
-- TODO: Join fact_sales with all dimension tables
-- Expected columns: sale_id, date, customer_name, product_name, store_name, total_amount
-- Limit to 10 rows


-- ============================================
-- Exercise 2: Basic Dimensional Queries (10 min)
-- ============================================

-- 2.1: Calculate total revenue by category
-- TODO: Join fact_sales with dim_product, group by category
-- Expected columns: category, total_revenue, transaction_count
-- Order by revenue descending


-- 2.2: Find top 10 customers by total spend
-- TODO: Join with dim_customer, aggregate by customer
-- Expected columns: customer_name, total_spent, order_count
-- Limit to top 10


-- 2.3: Show monthly sales trends for 2024
-- TODO: Join with dim_date, filter for 2024, group by month
-- Expected columns: month_name, revenue, transaction_count
-- Order by month


-- 2.4: Calculate revenue by store region
-- TODO: Join with dim_store, group by region
-- Expected columns: region, revenue, store_count, avg_revenue_per_store


-- 2.5: Find best-selling products by quantity
-- TODO: Join with dim_product, sum quantity
-- Expected columns: product_name, category, total_quantity_sold
-- Top 10 products


-- ============================================
-- Exercise 3: Time-Series Analysis (10 min)
-- ============================================

-- 3.1: Calculate revenue by quarter
-- TODO: Use dim_date quarter field, group by year and quarter
-- Expected columns: year, quarter, revenue, profit
-- Order by year, quarter


-- 3.2: Compare sales between weekdays and weekends
-- TODO: Use dim_date is_weekend field
-- Expected columns: day_type (Weekend/Weekday), revenue, avg_transaction_value


-- 3.3: Find the best performing month
-- TODO: Group by year and month, find highest revenue month
-- Expected: Single row with best month


-- 3.4: Calculate year-over-year growth
-- TODO: Compare 2024 vs 2023 revenue
-- Hint: Use conditional aggregation or CTEs
-- Expected columns: year, revenue, yoy_growth_pct


-- 3.5: Identify seasonal patterns
-- TODO: Calculate average revenue by month across all years
-- Expected columns: month_name, avg_monthly_revenue
-- Order by month


-- ============================================
-- Exercise 4: Advanced Analytics (10 min)
-- ============================================

-- 4.1: Calculate profit margin by category
-- TODO: Calculate profit margin percentage by product category
-- Expected columns: category, revenue, profit, profit_margin_pct
-- Order by profit_margin descending


-- 4.2: Find customer segments by lifetime value
-- TODO: Segment customers into High/Medium/Low value tiers
-- Hint: Use CASE statement with percentiles or fixed thresholds
-- Expected columns: segment, customer_count, avg_lifetime_value


-- 4.3: Analyze discount impact on sales
-- TODO: Compare transactions with vs without discounts
-- Expected columns: has_discount, transaction_count, avg_discount, avg_total_amount


-- 4.4: Calculate store performance metrics
-- TODO: For each store, calculate revenue, profit, transactions
-- Expected columns: store_name, city, revenue, profit, transaction_count, avg_transaction
-- Order by revenue descending


-- 4.5: Identify cross-selling opportunities
-- TODO: Find products frequently bought together
-- Hint: Self-join fact_sales on customer_id and date_id
-- Expected: Product pairs with purchase frequency


-- ============================================
-- Exercise 5: Star Schema Benefits (5 min)
-- ============================================

-- 5.1: Write a query joining all dimensions
-- TODO: Create a complete denormalized view
-- Expected: All fact measures with all dimension attributes
-- Limit to 20 rows


-- 5.2: Calculate running totals by date
-- TODO: Use window functions to calculate cumulative revenue
-- Expected columns: date, daily_revenue, running_total
-- Order by date


-- 5.3: Rank products within categories
-- TODO: Use RANK() or ROW_NUMBER() to rank products by revenue within each category
-- Expected columns: category, product_name, revenue, rank_in_category


-- 5.4: Create a sales dashboard query
-- TODO: Create a single query with key metrics:
--       - Total revenue, profit, transactions
--       - Top category, top customer, top store
--       - Average transaction value
-- Expected: One row with all dashboard metrics


-- 5.5: Compare query performance
-- TODO: Write the same query two ways:
--       1. Using star schema (fact + dimensions)
--       2. Using a fully denormalized approach
-- Measure which is easier to write and understand


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Create a sales summary table
-- TODO: CREATE TABLE sales_summary AS SELECT ...
-- Aggregate sales by date, category, and region


-- BONUS 2: Implement a slowly changing dimension
-- TODO: Add effective_date and end_date to dim_customer
-- Show how to track customer address changes over time


-- BONUS 3: Calculate customer cohort analysis
-- TODO: Group customers by registration month
-- Calculate retention and revenue by cohort


-- BONUS 4: Build a product recommendation query
-- TODO: Find "customers who bought X also bought Y"
-- Use self-joins on fact_sales
