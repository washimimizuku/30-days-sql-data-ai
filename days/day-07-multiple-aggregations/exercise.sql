-- Day 7: Multiple Aggregations
-- Practice exercises for combining multiple aggregate functions
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: Basic Multiple Aggregations (6 min)
-- ============================================

-- 1.1: Calculate for all products: count, sum of prices, avg price, min price, max price
-- TODO: Write your query
-- Expected columns: total_products, total_value, avg_price, min_price, max_price


-- 1.2: Calculate for all orders: count, total revenue, avg order value, min order, max order
-- TODO: Write your query
-- Expected columns: total_orders, total_revenue, avg_order_value, min_order, max_order


-- 1.3: Calculate for all employees: count, total salary, avg salary, min salary, max salary
-- TODO: Write your query
-- Expected columns: employee_count, total_payroll, avg_salary, min_salary, max_salary


-- ============================================
-- Exercise 2: Aggregations by Category (8 min)
-- ============================================

-- 2.1: For each product category: count, sum of prices, avg price
--      Order by total value DESC
-- TODO: Write your query
-- Expected columns: category, product_count, total_value, avg_price


-- 2.2: For each category: all five aggregates (count, sum, avg, min, max of prices)
--      Order by category name
-- TODO: Write your query
-- Expected columns: category, product_count, total_value, avg_price, min_price, max_price


-- 2.3: For each category: product count, total stock, inventory value (sum of price * stock)
-- TODO: Write your query
-- Expected columns: category, product_count, total_stock, inventory_value


-- ============================================
-- Exercise 3: Order Analysis (8 min)
-- ============================================

-- 3.1: For each order status: count, total revenue, avg order value
--      Order by total revenue DESC
-- TODO: Write your query
-- Expected columns: status, order_count, total_revenue, avg_order_value


-- 3.2: For each customer: order count, total spent, avg order value, min order, max order
--      Only customers with orders, order by total spent DESC
-- TODO: Write your query
-- Expected columns: customer_id, order_count, total_spent, avg_order_value, min_order, max_order


-- 3.3: For each city: customer count, order count, total revenue, avg order value
--      Order by total revenue DESC
-- TODO: Write your query
-- Hint: Join customers and orders tables
-- Expected columns: city, customer_count, order_count, total_revenue, avg_order_value


-- ============================================
-- Exercise 4: Department Statistics (6 min)
-- ============================================

-- 4.1: For each department: employee count, total salary, avg salary, min salary, max salary
--      Order by total salary DESC
-- TODO: Write your query
-- Expected columns: department, employee_count, total_salary, avg_salary, min_salary, max_salary


-- 4.2: For each department: total salary, total commission, total compensation
--      Order by total compensation DESC
-- TODO: Write your query
-- Hint: total_compensation = SUM(salary + commission)
-- Expected columns: department, total_salary, total_commission, total_compensation


-- ============================================
-- Exercise 5: Conditional Aggregations (6 min)
-- ============================================

-- 5.1: Count orders by status using CASE:
--      total orders, completed count, pending count, cancelled count
-- TODO: Write your query
-- Hint: COUNT(CASE WHEN status = 'completed' THEN 1 END)
-- Expected columns: total_orders, completed, pending, cancelled


-- 5.2: Calculate revenue by status using CASE:
--      total revenue, completed revenue, pending revenue
-- TODO: Write your query
-- Hint: SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END)
-- Expected columns: total_revenue, completed_revenue, pending_revenue


-- 5.3: Count products by price range using CASE:
--      total products, budget (<100), mid-range (100-300), premium (>300)
-- TODO: Write your query
-- Expected columns: total_products, budget_count, midrange_count, premium_count


-- ============================================
-- Exercise 6: Product Sales Performance (6 min)
-- ============================================

-- 6.1: For each product: times ordered, total quantity sold, total revenue
--      Only products with sales, order by revenue DESC
-- TODO: Write your query
-- Hint: Join products with order_items
-- Expected columns: product_name, times_ordered, total_quantity, total_revenue


-- 6.2: For each category: products sold (at least once), total quantity, total revenue
--      Order by revenue DESC
-- TODO: Write your query
-- Hint: Join products with order_items, group by category
-- Expected columns: category, products_sold, total_quantity, total_revenue


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Customer lifetime value analysis
-- For each customer: order count, total spent, avg order value, first order, last order
-- Only customers with 2+ orders, order by total spent DESC
-- Hint: Use MIN(order_date) and MAX(order_date)


-- BONUS 2: Product profitability
-- For each product: quantity sold, revenue, cost, profit, profit margin %
-- Only sold products, order by profit DESC
-- Hint: profit = SUM(quantity * (price - cost)), margin = profit / revenue * 100


-- BONUS 3: Complete business dashboard
-- Calculate: total products, total customers, total orders, total revenue,
--           avg order value, completed orders, pending orders
-- Hint: Use multiple aggregations in one query
