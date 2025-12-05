-- Day 15: CTEs (Common Table Expressions)
-- WITH clause for readable queries

-- Connect to database:
-- duckdb ../../data/databases/day15.db

-- ============================================
-- PART 1: BASIC CTEs
-- ============================================

-- Exercise 1: Simple CTE (Easy)
-- Rewrite this as a CTE:
-- SELECT * FROM (SELECT department, AVG(salary) as avg_salary FROM employees GROUP BY department) WHERE avg_salary > 60000;
-- Expected columns: department, avg_salary



-- Exercise 2: CTE with Filtering (Easy)
-- Use a CTE to find customers who spent more than $1000 total.
-- Expected columns: customer_name, total_spent



-- Exercise 3: CTE for Readability (Easy)
-- Use a CTE to find products priced above their category average.
-- Expected columns: product_name, category, price, category_avg



-- ============================================
-- PART 2: MULTIPLE CTEs
-- ============================================

-- Exercise 4: Two CTEs (Medium)
-- Use two CTEs: 1) customer order counts, 2) customer total spending
-- Join them in main query.
-- Expected columns: customer_name, order_count, total_spent



-- Exercise 5: Three CTEs (Medium)
-- Use three CTEs: 1) monthly revenue, 2) add previous month (LAG), 3) calculate growth
-- Expected columns: month, revenue, prev_month_revenue, growth_pct



-- Exercise 6: CTEs Referencing CTEs (Medium)
-- CTE1: customer totals, CTE2: segment customers (ref CTE1), CTE3: aggregate by segment (ref CTE2)
-- Expected columns: segment, customer_count, avg_spending



-- Exercise 7: Complex CTE Chain (Hard)
-- 4 CTEs: 1) product sales, 2) profitability, 3) rankings, 4) category summaries
-- Expected columns: category, top_product, total_profit



-- ============================================
-- PART 3: CTEs FOR ANALYSIS
-- ============================================

-- Exercise 8: Customer Segmentation (Medium)
-- Use CTEs to segment customers by total spending:
-- VIP (>5000), High (1000-5000), Medium (500-1000), Low (<500)
-- Expected columns: customer_name, total_spent, segment



-- Exercise 9: Product Performance Dashboard (Hard)
-- Use CTEs to create dashboard: sales metrics, profitability, inventory status
-- Expected columns: product_name, units_sold, revenue, profit, stock_status



-- Exercise 10: Customer Lifetime Value (Hard)
-- Use CTEs to calculate: first/last purchase, total orders, total spent, avg order value
-- Expected columns: customer_name, total_spent, order_count, avg_order_value, lifespan_days



-- ============================================
-- PART 4: RANKING AND TOP-N
-- ============================================

-- Exercise 11: Top 3 per Category (Medium)
-- Use CTE with ROW_NUMBER() to find top 3 products by revenue in each category.
-- Expected columns: category, product_name, revenue, rank



-- Exercise 12: Top Customers per City (Medium)
-- Use CTEs to find top 2 customers by spending in each city.
-- Expected columns: city, customer_name, total_spent, rank_in_city



-- Exercise 13: Best and Worst Performers (Hard)
-- Use CTEs to find top 5 and bottom 5 products by profit. Combine with UNION.
-- Expected columns: product_name, profit, performance_type



-- ============================================
-- PART 5: RECURSIVE CTEs
-- ============================================

-- Exercise 14: Number Series (Easy)
-- Write recursive CTE to generate numbers 1 to 20.
-- Expected columns: n



-- Exercise 15: Date Series (Medium)
-- Write recursive CTE to generate all dates in January 2024.
-- Expected columns: date



-- Exercise 16: Organization Chart (Medium)
-- Write recursive CTE to show organization hierarchy with levels.
-- Expected columns: employee_name, level, path



-- Exercise 17: All Subordinates (Hard)
-- Write recursive CTE to show each manager with ALL subordinates (direct and indirect).
-- Expected columns: manager_name, subordinate_name, levels_below



-- ============================================
-- PART 6: COMPLEX BUSINESS LOGIC
-- ============================================

-- Exercise 18: Customer Churn Prediction (Hard)
-- Use CTEs to identify at-risk customers:
-- Calculate days since last order and avg days between orders.
-- Expected columns: customer_name, days_since_last_order, avg_days_between_orders, risk_level



-- Exercise 19: Inventory Reorder Report (Hard)
-- Use CTEs to create reorder report:
-- Calculate daily sales rate and days of stock remaining.
-- Expected columns: product_name, current_stock, daily_sales_rate, days_remaining, reorder_needed



-- Exercise 20: Sales Reconciliation (Hard)
-- Use CTEs to reconcile: sum of order totals vs sum of order_items totals.
-- Identify discrepancies.
-- Expected columns: order_id, order_total, items_total, difference
