-- Day 10: Mini Project - Sales Analysis
-- Complete these 20 business questions
-- Time: ~90 minutes (2 hours total with setup and review)

-- ============================================
-- Part 1: Basic Sales Metrics (10 min)
-- ============================================

-- Question 1: Total Revenue
-- Calculate the total revenue from all completed orders
-- TODO: Write your query
-- Expected: One row with total_revenue


-- Question 2: Order Statistics
-- Calculate: total orders, completed orders, pending orders, cancelled orders
-- TODO: Write your query
-- Hint: Use COUNT with CASE statements
-- Expected: One row with 4 columns


-- Question 3: Top 10 Customers
-- Find top 10 customers by total spending (completed orders only)
-- Show: customer_name, email, total_spent
-- TODO: Write your query
-- Expected: 10 rows, ordered by spending DESC


-- Question 4: Monthly Revenue Trend
-- Calculate total revenue by month for 2023
-- Show: year, month, revenue
-- TODO: Write your query
-- Hint: Use EXTRACT(YEAR FROM ...) and EXTRACT(MONTH FROM ...)
-- Expected: 12 rows


-- ============================================
-- Part 2: Product Analysis (10 min)
-- ============================================

-- Question 5: Best Selling Products
-- Find top 10 products by quantity sold
-- Show: product_name, category_name, quantity_sold, revenue
-- TODO: Write your query
-- Expected: 10 rows


-- Question 6: Products Never Sold
-- Find all products that have never been ordered
-- Show: product_name, category_name, price, stock
-- TODO: Write your query
-- Hint: Use LEFT JOIN with WHERE ... IS NULL
-- Expected: Variable rows


-- Question 7: Category Performance
-- For each category calculate: product_count, total_quantity_sold, total_revenue, avg_price
-- Order by revenue DESC
-- TODO: Write your query
-- Expected: 5 rows


-- Question 8: Low Stock Alert
-- Find products with stock < 10 that have been sold at least once
-- Show: product_name, category_name, stock, times_ordered
-- TODO: Write your query
-- Expected: Variable rows


-- ============================================
-- Part 3: Customer Insights (10 min)
-- ============================================

-- Question 9: Customer Segmentation
-- Segment customers by total spending:
-- High Value (>1000), Medium Value (500-1000), Low Value (<500)
-- Show: segment, customer_count, total_revenue
-- TODO: Write your query
-- Hint: Use CASE in subquery, then GROUP BY segment
-- Expected: 3 rows


-- Question 10: Inactive Customers
-- Find customers who registered >180 days ago but never placed an order
-- Show: customer_name, email, city, registration_date
-- TODO: Write your query
-- Expected: Variable rows


-- Question 11: Customer Lifetime Value
-- For each customer with orders, calculate:
-- total_orders, total_spent, avg_order_value, first_order_date, last_order_date, days_as_customer
-- Show top 20 by total_spent
-- TODO: Write your query
-- Expected: 20 rows


-- Question 12: Repeat Customer Rate
-- Calculate: total_customers_with_orders, repeat_customers (2+ orders), repeat_rate_percentage
-- TODO: Write your query
-- Hint: Use subqueries or COUNT with CASE
-- Expected: One row with 3 columns


-- ============================================
-- Part 4: Geographic Analysis (10 min)
-- ============================================

-- Question 13: Sales by City
-- For each city calculate: customer_count, order_count, total_revenue, avg_order_value
-- Order by revenue DESC
-- TODO: Write your query
-- Expected: 10 rows


-- Question 14: Top City by Category
-- For each category, find the city with highest sales
-- Show: category_name, city, revenue
-- TODO: Write your query
-- Hint: Use window functions or subqueries
-- Expected: 5 rows


-- Question 15: State Performance
-- For each state calculate: customer_count, order_count, total_revenue, avg_revenue_per_customer
-- Order by total_revenue DESC
-- TODO: Write your query
-- Expected: Variable rows (one per state)


-- ============================================
-- Part 5: Advanced Analysis (10 min)
-- ============================================

-- Question 16: Product Profitability
-- For each sold product calculate:
-- quantity_sold, revenue, cost, profit, profit_margin_pct
-- Show top 10 by profit
-- TODO: Write your query
-- Expected: 10 rows


-- Question 17: Order Size Analysis
-- Count orders by size: 1 item, 2-3 items, 4-5 items, 6+ items
-- Show: size_category, order_count, total_revenue
-- TODO: Write your query
-- Hint: Use subquery with CASE, then GROUP BY
-- Expected: 4 rows


-- Question 18: Customer Purchase Frequency
-- For customers with 2+ orders, calculate:
-- customer_name, total_orders, days_between_first_last, avg_days_between_orders
-- Show top 15 by order count
-- TODO: Write your query
-- Expected: 15 rows


-- Question 19: Category Mix per Order
-- Calculate the average number of different categories per order
-- TODO: Write your query
-- Hint: Use subquery with COUNT(DISTINCT category_id), then AVG
-- Expected: One row with avg_categories_per_order


-- Question 20: Complete Business Dashboard
-- Create dashboard with:
-- total_customers, active_customers, total_products, products_sold,
-- total_orders, completed_orders, total_revenue, avg_order_value,
-- total_profit, profit_margin_pct
-- TODO: Write your query
-- Hint: Use multiple subqueries or CTEs
-- Expected: One row with 10 columns


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Monthly Growth Rate
-- Calculate month-over-month revenue growth percentage


-- BONUS 2: Customer Cohort Analysis
-- Group customers by registration month, calculate their lifetime value


-- BONUS 3: Seasonal Trends
-- Analyze sales by season (Winter: Dec-Feb, Spring: Mar-May, Summer: Jun-Aug, Fall: Sep-Nov)
