-- Day 24: Indexes and Performance - Exercises
-- Database: day24.db

-- ============================================================================
-- PART 1: UNDERSTANDING PERFORMANCE (Easy)
-- ============================================================================

-- Exercise 1: Measure Query Time
-- Run this query WITHOUT index and note the time
-- Then create index and run again to compare
SELECT * FROM orders WHERE customer_id = 5000;

-- Create index:
-- CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Run query again and compare time


-- Exercise 2: Use EXPLAIN
-- Write a query to find all orders for customer_id = 1000
-- Use EXPLAIN to see the execution plan


-- Exercise 3: Full Table Scan
-- Write a query that will cause a full table scan
-- Hint: Query all rows or use non-indexed column


-- ============================================================================
-- PART 2: CREATING INDEXES (Medium)
-- ============================================================================

-- Exercise 4: Single Column Index
-- Create an index on the email column of customers table


-- Exercise 5: Composite Index
-- Create a composite index on orders(customer_id, order_date)


-- Exercise 6: Unique Index
-- Create a unique index on customers.email to prevent duplicates


-- Exercise 7: Index for JOIN
-- Identify and create indexes needed for this query:
-- SELECT o.*, c.customer_name
-- FROM orders o
-- JOIN customers c ON o.customer_id = c.id
-- WHERE o.order_date >= '2024-01-01';


-- Exercise 8: Index for ORDER BY
-- Create an index to optimize this query:
-- SELECT * FROM orders ORDER BY order_date DESC LIMIT 100;


-- ============================================================================
-- PART 3: ANALYZING PERFORMANCE (Medium-Hard)
-- ============================================================================

-- Exercise 9: Compare Performance
-- Find orders in date range '2024-01-01' to '2024-12-31'
-- Measure before and after creating index


-- Exercise 10: Identify Missing Index
-- This query is slow - what index is needed?
SELECT * FROM order_items WHERE product_id = 500;

-- Create the missing index:


-- Exercise 11: Composite Index Order
-- Create ONE composite index for both queries:
-- Query A: WHERE customer_id = 100 AND status = 'completed'
-- Query B: WHERE status = 'completed' AND customer_id = 100
-- Explain your column order choice


-- Exercise 12: Covering Index
-- Create a covering index so this query doesn't access the table:
-- SELECT customer_id, order_date, total
-- FROM orders
-- WHERE customer_id = 100;


-- ============================================================================
-- PART 4: INDEX OPTIMIZATION (Hard)
-- ============================================================================

-- Exercise 13: Function on Column
-- This query doesn't use index on order_date:
-- SELECT * FROM orders WHERE YEAR(order_date) = 2024;
-- Rewrite to use the index:


-- Exercise 14: Leading Wildcard
-- This query can't use an index:
-- SELECT * FROM customers WHERE email LIKE '%@gmail.com';
-- Explain why and suggest alternative


-- Exercise 15: OR vs UNION
-- Compare these approaches and explain which is faster:
-- Approach A:
SELECT * FROM orders WHERE customer_id = 100 OR status = 'pending';

-- Approach B:
SELECT * FROM orders WHERE customer_id = 100
UNION
SELECT * FROM orders WHERE status = 'pending';


-- ============================================================================
-- PART 5: REAL-WORLD SCENARIOS (Hard)
-- ============================================================================

-- Exercise 16: E-commerce Optimization
-- Design optimal indexing strategy for these queries:
-- 1. Find orders by customer
-- 2. Find orders by date range
-- 3. Find orders by customer and date
-- 4. Find orders by status
-- Create minimum indexes for maximum benefit


-- Exercise 17: Search Optimization
-- Create indexes for customer search feature:
-- - Search by email (exact match)
-- - Search by city
-- - Search by city and registration date
-- - Sort by registration date


-- Exercise 18: JOIN Performance
-- Optimize this query with appropriate indexes:
SELECT 
    c.customer_name,
    COUNT(o.id) as order_count,
    SUM(o.total) as total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE c.city = 'Seattle'
  AND o.order_date >= '2024-01-01'
GROUP BY c.customer_name;

-- List all indexes needed:


-- Exercise 19: Aggregation Performance
-- This query is slow - what index would help?
SELECT 
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price
FROM products
GROUP BY category;

-- Create the index:


-- Exercise 20: Complex Query Optimization
-- Optimize this complex query with all necessary indexes:
SELECT 
    c.customer_name,
    o.order_date,
    p.product_name,
    oi.quantity
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE c.city = 'New York'
  AND o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND p.category = 'Electronics'
ORDER BY o.order_date DESC;

-- Create all necessary indexes:
