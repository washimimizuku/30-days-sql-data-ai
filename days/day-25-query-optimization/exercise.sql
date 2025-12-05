-- Day 25: Query Optimization - Exercises
-- Database: day25.db

-- ============================================================================
-- PART 1: USING EXPLAIN (Easy)
-- ============================================================================

-- Exercise 1: Basic EXPLAIN
-- Run EXPLAIN on this query and identify the scan type
EXPLAIN SELECT * FROM orders WHERE customer_id = 100;

-- Task: Is it using an index or full table scan?


-- Exercise 2: EXPLAIN ANALYZE
-- Run EXPLAIN ANALYZE and note the execution time
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 100;

-- Task: Document the actual time and rows scanned


-- Exercise 3: Compare Plans
-- Compare EXPLAIN output before and after creating an index
-- Before:
EXPLAIN SELECT * FROM orders WHERE customer_id = 100;

-- Create index:
-- CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- After:
-- EXPLAIN SELECT * FROM orders WHERE customer_id = 100;

-- Task: Describe the difference


-- ============================================================================
-- PART 2: FILTER OPTIMIZATION (Medium)
-- ============================================================================

-- Exercise 4: WHERE vs HAVING
-- Optimize this query by moving the filter
SELECT customer_id, COUNT(*) as order_count
FROM orders
GROUP BY customer_id
HAVING customer_id = 100;

-- Task: Rewrite using WHERE instead of HAVING


-- Exercise 5: Early Filtering
-- Optimize this query to filter earlier
SELECT c.customer_name, COUNT(o.id) as order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name, c.city
HAVING c.city = 'Seattle';

-- Task: Move city filter to WHERE clause


-- Exercise 6: Date Filter Optimization
-- Rewrite this query to use an index on order_date
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- Task: Rewrite without function on indexed column


-- ============================================================================
-- PART 3: SELECT OPTIMIZATION (Easy)
-- ============================================================================

-- Exercise 7: Avoid SELECT *
-- Optimize this query to select only needed columns
SELECT * FROM orders WHERE customer_id = 100;

-- Assume you only need: id, order_date, total


-- Exercise 8: Column Reduction
-- This query selects unnecessary columns
SELECT o.*, c.*, p.*
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.customer_id = 100;

-- Optimize to select only: customer_name, order_date, product_name, quantity


-- ============================================================================
-- PART 4: JOIN OPTIMIZATION (Medium-Hard)
-- ============================================================================

-- Exercise 9: EXISTS vs IN
-- Rewrite using EXISTS for better performance
SELECT * FROM customers
WHERE id IN (SELECT customer_id FROM orders WHERE status = 'completed');


-- Exercise 10: Optimize JOIN Order
-- This query joins large tables - add appropriate indexes
SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE c.city = 'Seattle'
  AND o.order_date >= '2024-01-01';

-- Task: List indexes needed and create them


-- Exercise 11: Remove Unnecessary JOIN
-- Rewrite using EXISTS if you only need customers with orders
SELECT c.customer_name, COUNT(o.id)
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;


-- ============================================================================
-- PART 5: SUBQUERY OPTIMIZATION (Hard)
-- ============================================================================

-- Exercise 12: Avoid Correlated Subquery
-- Rewrite this correlated subquery
SELECT 
    c.customer_name,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count
FROM customers c;

-- Task: Use JOIN instead


-- Exercise 13: Flatten Nested Subqueries
-- Rewrite using CTEs
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT customer_id, SUM(total) as total_spent
        FROM orders
        WHERE status = 'completed'
        GROUP BY customer_id
    ) WHERE total_spent > 1000
) WHERE customer_id > 100;


-- Exercise 14: Optimize Subquery in SELECT
-- Optimize this query with subquery in SELECT
SELECT 
    p.product_name,
    p.price,
    (SELECT AVG(price) FROM products WHERE category = p.category) as category_avg
FROM products p;

-- Task: Rewrite using window function


-- ============================================================================
-- PART 6: ADVANCED OPTIMIZATION (Hard)
-- ============================================================================

-- Exercise 15: UNION vs UNION ALL
-- Determine if UNION ALL can be used
SELECT customer_id FROM orders WHERE status = 'pending'
UNION
SELECT customer_id FROM orders WHERE status = 'shipped';

-- Task: Can this be UNION ALL? Why or why not?


-- Exercise 16: Add LIMIT
-- This query returns too many rows
SELECT * FROM orders ORDER BY order_date DESC;

-- Task: Add LIMIT to return only top 100


-- Exercise 17: Optimize Dashboard Query
-- Optimize this dashboard query
SELECT 
    COUNT(*) as total_orders,
    SUM(total) as total_revenue,
    AVG(total) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
WHERE order_date >= '2024-01-01';

-- Task: Add indexes, verify with EXPLAIN


-- Exercise 18: Optimize Report Query
-- Optimize this complex report
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

-- Task: Identify all optimizations needed


-- Exercise 19: Fix N+1 Problem
-- Write a single query to replace this N+1 pattern:
-- Query 1: SELECT * FROM orders LIMIT 100;
-- Then for each order: SELECT * FROM customers WHERE id = ?;

-- Task: Write a single query with JOIN


-- Exercise 20: Full Query Optimization
-- Optimize every aspect of this query
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE YEAR(o.order_date) = 2024
  AND c.city = 'Seattle'
ORDER BY c.customer_name;

-- Task: 
-- 1. Rewrite query
-- 2. Add indexes
-- 3. Use EXPLAIN to verify
