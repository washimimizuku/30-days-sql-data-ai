-- Day 25: Query Optimization - Solutions
-- Database: day25.db

-- ============================================================================
-- PART 1: USING EXPLAIN (Easy)
-- ============================================================================

-- Exercise 1: Basic EXPLAIN
EXPLAIN SELECT * FROM orders WHERE customer_id = 100;

-- Expected: SEQ_SCAN (full table scan) if no index exists
-- Shows the database will scan all rows


-- Exercise 2: EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 100;

-- Shows actual execution time and rows scanned
-- Example output: Run Time: 0.050s, Rows: ~10


-- Exercise 3: Compare Plans
-- Before index:
EXPLAIN SELECT * FROM orders WHERE customer_id = 100;
-- Output: SEQ_SCAN (full table scan)

-- Create index:
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- After index:
EXPLAIN SELECT * FROM orders WHERE customer_id = 100;
-- Output: INDEX_SCAN using idx_orders_customer_id
-- Much faster - only scans matching rows


-- ============================================================================
-- PART 2: FILTER OPTIMIZATION (Medium)
-- ============================================================================

-- Exercise 4: WHERE vs HAVING
-- Optimized version:
SELECT customer_id, COUNT(*) as order_count
FROM orders
WHERE customer_id = 100
GROUP BY customer_id;

-- Explanation: WHERE filters before grouping (processes fewer rows)
-- HAVING filters after grouping (processes all rows first)


-- Exercise 5: Early Filtering
-- Optimized version:
SELECT c.customer_name, COUNT(o.id) as order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE c.city = 'Seattle'
GROUP BY c.customer_name;

-- Explanation: WHERE filters customers before JOIN
-- Reduces number of rows to join


-- Exercise 6: Date Filter Optimization
-- Optimized version:
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2025-01-01';

-- Explanation: Avoids YEAR() function which prevents index usage
-- Range comparison can use index on order_date


-- ============================================================================
-- PART 3: SELECT OPTIMIZATION (Easy)
-- ============================================================================

-- Exercise 7: Avoid SELECT *
-- Optimized version:
SELECT id, order_date, total 
FROM orders 
WHERE customer_id = 100;

-- Explanation: Selects only needed columns
-- Reduces data transfer and memory usage


-- Exercise 8: Column Reduction
-- Optimized version:
SELECT 
    c.customer_name,
    o.order_date,
    p.product_name,
    oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.customer_id = 100;

-- Explanation: Selects only 4 needed columns instead of all columns
-- Significantly reduces data transfer


-- ============================================================================
-- PART 4: JOIN OPTIMIZATION (Medium-Hard)
-- ============================================================================

-- Exercise 9: EXISTS vs IN
-- Optimized version:
SELECT * FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.id 
      AND o.status = 'completed'
);

-- Explanation: EXISTS stops at first match per customer
-- IN builds entire result set before checking


-- Exercise 10: Optimize JOIN Order
-- Indexes needed:
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);

-- Or composite index:
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- Query (same, but now uses indexes):
SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE c.city = 'Seattle'
  AND o.order_date >= '2024-01-01';


-- Exercise 11: Remove Unnecessary JOIN
-- If you only need customers with orders:
SELECT c.customer_name, COUNT(*) as order_count
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id)
GROUP BY c.customer_name;

-- Or keep JOIN but it's fine:
SELECT c.customer_name, COUNT(o.id) as order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;


-- ============================================================================
-- PART 5: SUBQUERY OPTIMIZATION (Hard)
-- ============================================================================

-- Exercise 12: Avoid Correlated Subquery
-- Optimized version:
SELECT 
    c.customer_name,
    COUNT(o.id) as order_count
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;

-- Explanation: JOIN is evaluated once
-- Correlated subquery runs for every customer row


-- Exercise 13: Flatten Nested Subqueries
-- Optimized version with CTEs:
WITH customer_totals AS (
    SELECT customer_id, SUM(total) as total_spent
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
high_spenders AS (
    SELECT * FROM customer_totals
    WHERE total_spent > 1000
)
SELECT * FROM high_spenders
WHERE customer_id > 100;

-- Explanation: CTEs are clearer and easier to optimize
-- Each step is explicit and can be optimized independently


-- Exercise 14: Optimize Subquery in SELECT
-- Optimized version with window function:
SELECT 
    product_name,
    price,
    AVG(price) OVER (PARTITION BY category) as category_avg
FROM products;

-- Explanation: Window function calculates average in single pass
-- Subquery in SELECT runs for every row


-- ============================================================================
-- PART 6: ADVANCED OPTIMIZATION (Hard)
-- ============================================================================

-- Exercise 15: UNION vs UNION ALL
-- Can use UNION ALL:
SELECT customer_id FROM orders WHERE status = 'pending'
UNION ALL
SELECT customer_id FROM orders WHERE status = 'shipped';

-- Explanation: 'pending' and 'shipped' are mutually exclusive
-- No duplicates possible, so UNION ALL is safe and faster


-- Exercise 16: Add LIMIT
-- Optimized version:
SELECT * FROM orders ORDER BY order_date DESC LIMIT 100;

-- Explanation: LIMIT stops processing after 100 rows
-- Much faster than returning all rows


-- Exercise 17: Optimize Dashboard Query
-- Add index:
CREATE INDEX idx_orders_date ON orders(order_date);

-- Query (same, but now uses index):
SELECT 
    COUNT(*) as total_orders,
    SUM(total) as total_revenue,
    AVG(total) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
WHERE order_date >= '2024-01-01';

-- Verify with:
EXPLAIN SELECT COUNT(*) FROM orders WHERE order_date >= '2024-01-01';


-- Exercise 18: Optimize Report Query
-- Indexes needed:
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_products_category ON products(category);

-- Optimized query (same structure, but with indexes):
SELECT 
    c.customer_name,
    COUNT(DISTINCT o.id) as order_count,
    SUM(oi.quantity * oi.price) as total_spent,
    COUNT(DISTINCT p.category) as categories_purchased
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.id
WHERE c.city = 'New York'
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Could also add LIMIT if not all customers needed:
-- LIMIT 100


-- Exercise 19: Fix N+1 Problem
-- Single query solution:
SELECT o.*, c.*
FROM orders o
JOIN customers c ON o.customer_id = c.id
LIMIT 100;

-- Explanation: Gets orders and customers in one query
-- Eliminates 100 additional queries


-- Exercise 20: Full Query Optimization
-- Step 1: Add indexes
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_customers_city ON customers(city);

-- Step 2: Optimized query
SELECT c.*
FROM customers c
WHERE c.city = 'Seattle'
  AND EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.id
      AND o.order_date >= '2024-01-01'
      AND o.order_date < '2025-01-01'
)
ORDER BY c.customer_name;

-- Step 3: Verify with EXPLAIN
EXPLAIN SELECT c.*
FROM customers c
WHERE c.city = 'Seattle'
  AND EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.id
      AND o.order_date >= '2024-01-01'
      AND o.order_date < '2025-01-01'
)
ORDER BY c.customer_name;

-- Optimizations applied:
-- 1. Removed DISTINCT (used EXISTS instead)
-- 2. Rewrote YEAR() to range comparison (uses index)
-- 3. Added composite index on orders(customer_id, order_date)
-- 4. Added index on customers(city)
-- 5. Moved city filter to WHERE (filters early)


-- ============================================================================
-- BONUS: PERFORMANCE COMPARISON
-- ============================================================================

-- Compare execution times:
.timer on

-- Before optimization:
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE YEAR(o.order_date) = 2024
  AND c.city = 'Seattle'
ORDER BY c.customer_name;

-- After optimization:
SELECT c.*
FROM customers c
WHERE c.city = 'Seattle'
  AND EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.id
      AND o.order_date >= '2024-01-01'
      AND o.order_date < '2025-01-01'
)
ORDER BY c.customer_name;

-- Expected: 10-100x performance improvement
