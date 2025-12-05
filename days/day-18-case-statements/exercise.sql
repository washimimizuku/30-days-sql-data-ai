-- Day 18: CASE Statements
-- Practice exercises

-- ============================================
-- Part 1: Basic CASE Statements (10 min)
-- ============================================

-- 1.1: Categorize products by price (Budget < $50, Mid-Range $50-$200, Premium > $200)
-- TODO: Write your query
-- Expected columns: product_name, price, price_category


-- 1.2: Show product availability (In Stock if stock > 0, Out of Stock if stock = 0)
-- TODO: Write your query
-- Expected columns: product_name, stock, availability


-- 1.3: Convert order status to descriptions
-- TODO: Write your query
-- pending → 'Processing', shipped → 'In Transit', delivered → 'Complete', cancelled → 'Cancelled'
-- Expected columns: order_id, status, status_description


-- 1.4: Categorize employees by salary (High >= $100k, Medium $60k-$99k, Low < $60k)
-- TODO: Write your query
-- Expected columns: name, salary, salary_band


-- 1.5: Categorize products by stock level
-- TODO: Write your query
-- Out of Stock: 0, Low Stock: 1-10, Adequate: 11-50, Well Stocked: > 50
-- Expected columns: product_name, stock, stock_status


-- ============================================
-- Part 2: CASE with Aggregations (10 min)
-- ============================================

-- 2.1: Count orders by status in one row
-- TODO: Write your query
-- Expected columns: total_orders, completed, pending, shipped, cancelled
-- Hint: COUNT(CASE WHEN status = 'completed' THEN 1 END)


-- 2.2: Calculate revenue by order status
-- TODO: Write your query
-- Expected columns: total_revenue, completed_revenue, pending_revenue, cancelled_revenue


-- 2.3: For each category, count products by stock status
-- TODO: Write your query
-- Expected columns: category, total_products, in_stock, out_of_stock, avg_in_stock_price


-- 2.4: Count employees by performance rating
-- TODO: Write your query
-- Outstanding >= 90, Good 70-89, Satisfactory 50-69, Needs Improvement < 50
-- Expected columns: outstanding, good, satisfactory, needs_improvement


-- 2.5: For each category, count products by price range
-- TODO: Write your query
-- Expected columns: category, budget_count, midrange_count, premium_count, total


-- ============================================
-- Part 3: Complex Categorization (10 min)
-- ============================================

-- 3.1: Segment customers based on order history
-- TODO: Write your query
-- VIP: 10+ orders AND $5000+ spent, Loyal: 5+ orders OR $2000+ spent, Regular: 1+ orders, New: 0 orders
-- Expected columns: customer_name, order_count, total_spent, segment
-- Hint: LEFT JOIN customers with aggregated orders


-- 3.2: Categorize products by profit margin percentage
-- TODO: Write your query
-- Excellent > 50%, Good 30-50%, Fair 15-30%, Poor < 15%
-- Expected columns: product_name, price, cost, profit_margin_pct, tier
-- Hint: profit_margin = (price - cost) / price * 100


-- 3.3: Calculate employee bonuses based on performance
-- TODO: Write your query
-- Outstanding (>= 90): 15% of salary, Good (70-89): 10%, Satisfactory (50-69): 5%, Below 50: 0
-- Expected columns: name, salary, performance_score, bonus_amount


-- 3.4: Calculate dynamic pricing based on stock levels
-- TODO: Write your query
-- Out of stock: price * 1.2, Low stock (< 10): price * 1.1, Overstock (> 100): price * 0.9, Normal: price
-- Expected columns: product_name, price, stock, dynamic_price, pricing_reason


-- ============================================
-- Part 4: Pivot Tables (5 min)
-- ============================================

-- 4.1: Create a pivot showing revenue by category and order status
-- TODO: Write your query
-- Expected columns: category, completed_revenue, pending_revenue, shipped_revenue, cancelled_revenue
-- Hint: Join products, order_items, orders; use SUM(CASE WHEN status = 'completed' THEN ...)


-- 4.2: Show count of products by category and stock status
-- TODO: Write your query
-- Expected columns: category, out_of_stock, low_stock, adequate, well_stocked
-- Hint: Use CASE in aggregation


-- ============================================
-- Part 5: Advanced Applications (5 min)
-- ============================================

-- 5.1: Nested CASE for advanced customer segmentation
-- TODO: Write your query
-- If never ordered: "Never Ordered"
-- If < 5 orders: "High Value New" if spent > $1000, else "Regular New"
-- If >= 5 orders: "VIP" if spent > $5000, "Loyal" if spent > $2000, else "Regular"
-- Expected columns: customer_name, order_count, total_spent, segment


-- 5.2: Use CASE in ORDER BY to sort products with custom logic
-- TODO: Write your query
-- Electronics first, Books second, Clothing third, Others last
-- Within each category, sort by price descending
-- Expected columns: product_name, category, price


-- 5.3: Use CASE in WHERE to filter with category-specific rules
-- TODO: Write your query
-- Electronics: price > $100, Books: price > $20, Clothing: price > $30, Others: price > $50
-- Expected columns: product_name, category, price


-- 5.4: Use CASE in GROUP BY to group by price tier
-- TODO: Write your query
-- Budget (< $50), Mid-Range ($50-$200), Premium (> $200)
-- Expected columns: price_tier, product_count, avg_price, total_value
-- Hint: Use same CASE expression in SELECT and GROUP BY

