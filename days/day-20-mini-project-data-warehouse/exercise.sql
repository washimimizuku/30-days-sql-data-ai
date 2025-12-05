-- Day 20: Mini Project - Data Warehouse Analytics
-- Complete these 20 business intelligence queries

-- ============================================
-- Part 1: Dimensional Analysis (5 questions)
-- ============================================

-- Q1: Sales by Category and Region
-- Show total sales, transaction count, and average transaction value
-- by product category and store region
-- TODO: Write your query
-- Expected columns: category, region, total_sales, transaction_count, avg_transaction_value


-- Q2: Top 10 Products by Revenue
-- Find the top 10 products by total revenue
-- Show product name, category, brand, quantity sold, revenue, and profit margin
-- TODO: Write your query
-- Expected columns: product_name, category, brand, total_quantity, total_revenue, profit_margin


-- Q3: Customer Segmentation Analysis
-- Analyze customers by segment (VIP, Premium, Standard)
-- Show count, total revenue, avg revenue per customer, avg transaction value, total transactions
-- TODO: Write your query
-- Expected columns: segment, customer_count, total_revenue, avg_revenue_per_customer, avg_transaction_value, total_transactions


-- Q4: Store Performance Ranking
-- Rank stores by revenue within each region
-- Show region, store name, revenue, rank in region, percentage of region's revenue
-- TODO: Write your query
-- Expected columns: region, store_name, revenue, rank_in_region, pct_of_region_revenue


-- Q5: Regional Market Share
-- Calculate each region's market share percentage and rank by revenue
-- TODO: Write your query
-- Expected columns: region, total_revenue, market_share_pct, rank


-- ============================================
-- Part 2: Time-Series Analysis (5 questions)
-- ============================================

-- Q6: Monthly Revenue Trend
-- Calculate monthly revenue for past 12 months with month-over-month growth
-- Show month, revenue, previous month revenue, absolute growth, percentage growth
-- TODO: Write your query
-- Expected columns: month, revenue, prev_month_revenue, growth, growth_pct


-- Q7: Year-over-Year Comparison
-- Compare this year's monthly revenue to last year's
-- Show month, this year revenue, last year revenue, YoY growth percentage
-- TODO: Write your query
-- Expected columns: month, this_year_revenue, last_year_revenue, yoy_growth_pct


-- Q8: Quarterly Performance Pivot
-- Create a pivot showing quarterly revenue by region
-- Rows: regions, Columns: Q1, Q2, Q3, Q4
-- TODO: Write your query
-- Expected columns: region, q1_revenue, q2_revenue, q3_revenue, q4_revenue


-- Q9: Daily Revenue Moving Average
-- Calculate 7-day and 30-day moving averages of daily revenue for last 90 days
-- Show date, daily revenue, 7-day MA, 30-day MA, trend indicator
-- TODO: Write your query
-- Expected columns: date, daily_revenue, ma_7, ma_30, trend


-- Q10: Seasonal Pattern Analysis
-- Analyze sales patterns by season and day of week
-- Show season, day of week, average daily revenue, total transactions, peak indicator
-- TODO: Write your query
-- Expected columns: season, day_of_week, avg_daily_revenue, total_transactions, is_peak


-- ============================================
-- Part 3: Customer Analytics (5 questions)
-- ============================================

-- Q11: Customer Lifetime Value
-- Calculate CLV for top 20 customers
-- Show customer name, first purchase, last purchase, total transactions, revenue, AOV, lifetime days
-- TODO: Write your query
-- Expected columns: customer_name, first_purchase, last_purchase, total_transactions, total_revenue, avg_order_value, lifetime_days


-- Q12: Customer Cohort Analysis
-- Group customers by registration month, analyze revenue and retention
-- Show cohort month, customers in cohort, total revenue, avg revenue per customer, retention rate
-- TODO: Write your query
-- Expected columns: cohort_month, customers_in_cohort, total_revenue, avg_revenue_per_customer, retention_rate


-- Q13: RFM Segmentation
-- Perform RFM (Recency, Frequency, Monetary) analysis
-- Calculate recency, frequency, and monetary scores (1-5)
-- Assign RFM segment (Champions, Loyal, At Risk, etc.)
-- TODO: Write your query
-- Expected columns: customer_name, recency_score, frequency_score, monetary_score, rfm_segment


-- Q14: Customer Churn Prediction
-- Identify at-risk customers: previously active (3+ purchases), no purchase in 60+ days
-- Show customer name, last purchase date, days since last purchase, total lifetime value
-- TODO: Write your query
-- Expected columns: customer_name, last_purchase_date, days_since_last_purchase, total_lifetime_value, churn_risk


-- Q15: Customer Purchase Frequency
-- Analyze average days between purchases for each customer
-- Show customer name, total purchases, avg days between purchases, purchase pattern
-- TODO: Write your query
-- Expected columns: customer_name, total_purchases, avg_days_between, purchase_pattern


-- ============================================
-- Part 4: Product Analytics (5 questions)
-- ============================================

-- Q16: Product Performance Matrix
-- Classify products into 2x2 matrix:
-- Star (high revenue + margin), Cash Cow, Question Mark, Dog
-- Show counts and total revenue for each quadrant
-- TODO: Write your query
-- Expected columns: product_type, product_count, total_revenue


-- Q17: Product Sales Trend
-- Compare last 30 days vs previous 30 days sales by category
-- Identify growing, declining, or stable trends
-- TODO: Write your query
-- Expected columns: category, last_30_days, previous_30_days, trend


-- Q18: Cross-Sell Analysis
-- Find product pairs frequently bought together (minimum 10 co-purchases)
-- Show product 1, product 2, times bought together
-- TODO: Write your query
-- Expected columns: product1_name, product2_name, times_bought_together


-- Q19: Pareto Analysis (80/20 Rule)
-- Identify products generating 80% of revenue
-- Show product name, revenue, cumulative revenue, cumulative percentage, pareto group
-- TODO: Write your query
-- Expected columns: product_name, revenue, cumulative_revenue, cumulative_pct, pareto_group


-- Q20: Slow-Moving Products
-- Identify products with low sales velocity (< 5 sales in last 90 days)
-- Show product name, category, total sales last 90 days, avg days between sales
-- TODO: Write your query
-- Expected columns: product_name, category, sales_last_90_days, avg_days_between_sales, recommendation

