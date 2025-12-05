-- Day 14: Subqueries in FROM (Derived Tables)
-- Creating temporary result sets

-- Connect to database:
-- duckdb ../../data/databases/day14.db

-- ============================================
-- PART 1: BASIC DERIVED TABLES
-- ============================================

-- Exercise 1: Simple Derived Table (Easy)
-- Use a subquery to get department average salaries,
-- then filter for departments with average > 60000.
-- Expected columns: department, avg_salary



-- Exercise 2: Aggregate of Aggregates (Easy)
-- Find the average of department average salaries.
-- Expected columns: avg_of_dept_averages



-- Exercise 3: Filter Aggregated Results (Easy)
-- Find customers with more than 3 orders.
-- Use a subquery to count orders, then filter.
-- Expected columns: customer_name, order_count



-- Exercise 4: Add Calculated Column (Medium)
-- Get category sales totals, then add a column showing percentage of grand total.
-- Expected columns: category, category_total, percentage_of_total



-- Exercise 5: Categorize Aggregated Data (Medium)
-- Categorize departments by average salary:
-- High: > 80000, Medium: 60000-80000, Low: < 60000
-- Expected columns: department, avg_salary, pay_category



-- ============================================
-- PART 2: MULTI-LEVEL AGGREGATIONS
-- ============================================

-- Exercise 6: Top Spending Customers (Medium)
-- Find the top 10 customers by total spending.
-- Use a subquery to calculate totals.
-- Expected columns: customer_name, total_spent



-- Exercise 7: Above Average Departments (Medium)
-- Find departments where the average salary is above the company average.
-- Expected columns: department, dept_avg_salary, company_avg_salary, difference



-- Exercise 8: Monthly Revenue Analysis (Hard)
-- Show monthly revenue with previous month for comparison.
-- Expected columns: month, revenue, previous_month_revenue, growth



-- Exercise 9: Customer Lifetime Value Segments (Hard)
-- Segment customers by total spending:
-- VIP: > 5000, High: 1000-5000, Medium: 500-1000, Low: < 500
-- Show statistics for each segment.
-- Expected columns: segment, customer_count, avg_spending, total_revenue



-- ============================================
-- PART 3: MULTIPLE SUBQUERIES
-- ============================================

-- Exercise 10: Join Two Subqueries (Medium)
-- Join two subqueries:
-- 1. Customer order counts
-- 2. Customer product variety (distinct products bought)
-- Expected columns: customer_name, order_count, product_variety



-- Exercise 11: Compare Products to Category Average (Medium)
-- Show each product with its category's average price and the difference.
-- Expected columns: product_name, price, category_avg_price, difference



-- Exercise 12: Customer and Order Statistics (Hard)
-- Combine customer total spending with their order frequency.
-- Show customers with total_spent > 1000 AND order_count >= 3.
-- Expected columns: customer_name, total_spent, order_count, avg_order_value



-- ============================================
-- PART 4: RANKING AND FILTERING
-- ============================================

-- Exercise 13: Top 3 Products per Category (Medium)
-- Find the top 3 products by revenue in each category.
-- Expected columns: category, product_name, revenue, rank_in_category



-- Exercise 14: Top Customers per City (Hard)
-- Find the top 2 customers by spending in each city.
-- Expected columns: city, customer_name, total_spent, rank_in_city



-- Exercise 15: Products Above Category Median (Hard)
-- Find products priced above their category's median price.
-- Use PERCENTILE_CONT(0.5) for median.
-- Expected columns: product_name, category, price, category_median



-- ============================================
-- PART 5: COMPLEX BUSINESS LOGIC
-- ============================================

-- Exercise 16: Product Profitability Analysis (Hard)
-- Show products with revenue, cost, profit, and profit margin.
-- Rank by profit margin within category.
-- Expected columns: product_name, category, revenue, profit, profit_margin, rank_in_category



-- Exercise 17: Customer Purchase Patterns (Hard)
-- Analyze customer purchase patterns:
-- - Total orders
-- - Total spent
-- - Average order value
-- - Days since last order
-- Only include customers with at least 2 orders.
-- Expected columns: customer_name, order_count, total_spent, avg_order_value, days_since_last_order



-- ============================================
-- PART 6: PIVOTING AND RESHAPING
-- ============================================

-- Exercise 18: Monthly Sales Pivot (Medium)
-- Create a pivot showing categories as rows and months (1-3) as columns with revenue.
-- Expected columns: category, month_1_revenue, month_2_revenue, month_3_revenue



-- Exercise 19: Category Performance Matrix (Hard)
-- Create a matrix showing categories as rows and quarters as columns with revenue.
-- Expected columns: category, q1_revenue, q2_revenue, q3_revenue, q4_revenue



-- ============================================
-- PART 7: ADVANCED PATTERNS
-- ============================================

-- Exercise 20: Customer Segmentation Matrix (Very Hard)
-- Create a 2D segmentation:
-- - Segment by order frequency: High (>5), Medium (3-5), Low (<3)
-- - Segment by avg order value: High (>500), Medium (200-500), Low (<200)
-- Show count and total revenue for each combination.
-- Expected columns: frequency_segment, value_segment, customer_count, total_revenue
