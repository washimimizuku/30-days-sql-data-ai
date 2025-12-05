-- Day 24: Indexes and Performance - Solutions
-- Database: day24.db

-- ============================================================================
-- PART 1: UNDERSTANDING PERFORMANCE (Easy)
-- ============================================================================

-- Exercise 1: Measure Query Time
-- Without index (slower):
SELECT * FROM orders WHERE customer_id = 5000;

-- Create index:
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- With index (much faster):
SELECT * FROM orders WHERE customer_id = 5000;

-- Expected: 10-100x performance improvement


-- Exercise 2: Use EXPLAIN
EXPLAIN SELECT * FROM orders WHERE customer_id = 1000;

-- Expected output shows:
-- - INDEX_SCAN if index exists
-- - SEQ_SCAN if no index (full table scan)


-- Exercise 3: Full Table Scan
-- Query all rows (no WHERE clause):
SELECT * FROM orders;

-- Or query on non-indexed column:
SELECT * FROM orders WHERE total > 100;

-- Both cause full table scan


-- ============================================================================
-- PART 2: CREATING INDEXES (Medium)
-- ============================================================================

-- Exercise 4: Single Column Index
CREATE INDEX idx_customers_email ON customers(email);


-- Exercise 5: Composite Index
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);


-- Exercise 6: Unique Index
CREATE UNIQUE INDEX idx_customers_email_unique ON customers(email);


-- Exercise 7: Index for JOIN
-- Need indexes on:
-- 1. orders.customer_id (for JOIN)
-- 2. orders.order_date (for WHERE)
-- 3. customers.id (already indexed as PRIMARY KEY)

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);

-- Or use composite index:
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);


-- Exercise 8: Index for ORDER BY
CREATE INDEX idx_orders_date ON orders(order_date);

-- This avoids sorting operation


-- ============================================================================
-- PART 3: ANALYZING PERFORMANCE (Medium-Hard)
-- ============================================================================

-- Exercise 9: Compare Performance
-- Before index:
SELECT * FROM orders 
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Create index:
CREATE INDEX idx_orders_date ON orders(order_date);

-- After index (much faster):
SELECT * FROM orders 
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31';


-- Exercise 10: Identify Missing Index
-- Missing index on product_id:
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Now query is fast:
SELECT * FROM order_items WHERE product_id = 500;


-- Exercise 11: Composite Index Order
-- Best: customer_id first (more selective, higher cardinality)
CREATE INDEX idx_orders_customer_status ON orders(customer_id, status);

-- Explanation:
-- - customer_id has 10,000 unique values (high cardinality)
-- - status has only 5 unique values (low cardinality)
-- - customer_id first makes index more selective
-- - Works for both queries since both include customer_id


-- Exercise 12: Covering Index
-- Include all columns needed by the query:
CREATE INDEX idx_orders_covering ON orders(customer_id, order_date, total);

-- Query doesn't need to access table (all data in index):
SELECT customer_id, order_date, total
FROM orders
WHERE customer_id = 100;


-- ============================================================================
-- PART 4: INDEX OPTIMIZATION (Hard)
-- ============================================================================

-- Exercise 13: Function on Column
-- Bad (doesn't use index):
-- SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- Good (uses index):
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2025-01-01';


-- Exercise 14: Leading Wildcard
-- This can't use index because wildcard is at start:
-- SELECT * FROM customers WHERE email LIKE '%@gmail.com';

-- Explanation:
-- - Index works left-to-right
-- - Leading wildcard prevents index usage
-- - Must scan all rows

-- Alternative approaches:
-- 1. Full-text search (if available)
-- 2. Separate domain column
-- 3. Reverse index on reversed email
-- 4. Accept full table scan for this query


-- Exercise 15: OR vs UNION
-- Approach A (may not use indexes efficiently):
SELECT * FROM orders WHERE customer_id = 100 OR status = 'pending';

-- Approach B (uses indexes better):
SELECT * FROM orders WHERE customer_id = 100
UNION
SELECT * FROM orders WHERE status = 'pending';

-- Explanation:
-- - UNION approach can use separate indexes for each part
-- - OR may cause full table scan
-- - UNION is usually faster with proper indexes
-- - Note: UNION removes duplicates (use UNION ALL if duplicates OK)


-- ============================================================================
-- PART 5: REAL-WORLD SCENARIOS (Hard)
-- ============================================================================

-- Exercise 16: E-commerce Optimization
-- Optimal strategy (3 indexes):

-- 1. Composite index for queries 1 & 3:
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
-- Handles: customer queries and customer+date queries

-- 2. Index for query 2:
CREATE INDEX idx_orders_date ON orders(order_date);
-- Handles: date range queries

-- 3. Index for query 4:
CREATE INDEX idx_orders_status ON orders(status);
-- Handles: status queries

-- Rationale:
-- - Composite index covers multiple use cases
-- - Minimal indexes for maximum benefit
-- - Balances read performance vs write overhead


-- Exercise 17: Search Optimization
-- Indexes needed:

-- 1. Email search (exact match):
CREATE UNIQUE INDEX idx_customers_email ON customers(email);

-- 2. City search:
CREATE INDEX idx_customers_city ON customers(city);

-- 3. City and registration date:
CREATE INDEX idx_customers_city_reg ON customers(city, registration_date);

-- 4. Sort by registration date (covered by #3 or separate):
CREATE INDEX idx_customers_reg_date ON customers(registration_date);

-- Optimized strategy (2 indexes):
CREATE UNIQUE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_city_reg ON customers(city, registration_date);
-- Composite index handles city, city+date, and can help with date sorting


-- Exercise 18: JOIN Performance
-- Indexes needed:

-- 1. customers.city (WHERE clause):
CREATE INDEX idx_customers_city ON customers(city);

-- 2. orders.customer_id (JOIN):
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- 3. orders.order_date (WHERE clause):
CREATE INDEX idx_orders_date ON orders(order_date);

-- Or composite:
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- customers.id already indexed (PRIMARY KEY)


-- Exercise 19: Aggregation Performance
-- Index on GROUP BY column:
CREATE INDEX idx_products_category ON products(category);

-- Explanation:
-- - Index helps with grouping operation
-- - Faster to group pre-sorted data
-- - Also helps if category is in WHERE clauses


-- Exercise 20: Complex Query Optimization
-- All necessary indexes:

-- 1. customers.city (WHERE):
CREATE INDEX idx_customers_city ON customers(city);

-- 2. orders.customer_id (JOIN):
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- 3. orders.order_date (WHERE and ORDER BY):
CREATE INDEX idx_orders_date ON orders(order_date);

-- 4. order_items.order_id (JOIN):
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- 5. order_items.product_id (JOIN):
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- 6. products.category (WHERE):
CREATE INDEX idx_products_category ON products(category);

-- Composite alternatives for better performance:
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);

-- Primary keys (customers.id, orders.id, products.id) already indexed


-- ============================================================================
-- BONUS: VERIFICATION QUERIES
-- ============================================================================

-- View all indexes:
SELECT * FROM duckdb_indexes();

-- Check table sizes:
SELECT 
    'customers' as table_name,
    COUNT(*) as row_count
FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;

-- Test query performance with EXPLAIN ANALYZE:
EXPLAIN ANALYZE 
SELECT c.customer_name, COUNT(o.id) as order_count
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE c.city = 'Seattle'
GROUP BY c.customer_name;
