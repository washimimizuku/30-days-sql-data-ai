# Day 25: Query Optimization and EXPLAIN

## Learning Objectives
- Master query optimization techniques
- Use EXPLAIN to analyze query execution plans
- Identify and fix performance bottlenecks
- Write efficient SQL queries
- Understand query execution order
- Apply optimization best practices

## Theory (15 minutes)

### What is Query Optimization?

Query optimization is the process of improving query performance by:
- Reducing execution time
- Minimizing resource usage (CPU, memory, I/O)
- Choosing efficient execution plans

**Goal:** Get the same results faster with fewer resources.

### SQL Query Execution Order

Understanding execution order helps write better queries:

```
1. FROM/JOIN     - Get tables and join them
2. WHERE         - Filter rows
3. GROUP BY      - Group rows
4. HAVING        - Filter groups
5. SELECT        - Choose columns
6. DISTINCT      - Remove duplicates
7. ORDER BY      - Sort results
8. LIMIT/OFFSET  - Restrict rows returned
```

**Why it matters:** Filtering early (WHERE) is faster than filtering late (HAVING on large groups).

### Using EXPLAIN

EXPLAIN shows how the database will execute your query:

```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;
```

**Output shows:**
- Scan type (SEQ_SCAN, INDEX_SCAN)
- Estimated rows
- Join methods
- Sort operations
- Filter conditions

**Example output:**
```
┌─────────────────────────────┐
│         QUERY PLAN          │
├─────────────────────────────┤
│ INDEX_SCAN (orders)         │
│ Index: idx_customer_id      │
│ Estimated Rows: 10          │
└─────────────────────────────┘
```

### EXPLAIN ANALYZE

Shows actual execution statistics:

```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;
```

**Shows:**
- Actual execution time
- Actual rows processed
- Memory used
- Comparison of estimated vs actual

### Optimization Technique 1: Filter Early

**Bad - Filter after aggregation:**
```sql
SELECT customer_id, COUNT(*) as order_count
FROM orders
GROUP BY customer_id
HAVING customer_id = 123;
-- Processes all customers, then filters
```

**Good - Filter before aggregation:**
```sql
SELECT customer_id, COUNT(*) as order_count
FROM orders
WHERE customer_id = 123
GROUP BY customer_id;
-- Processes only customer 123
```

### Optimization Technique 2: Use Indexes

**Bad - No index:**
```sql
SELECT * FROM orders WHERE customer_id = 123;
-- Full table scan: 1,000,000 rows
```

**Good - With index:**
```sql
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
SELECT * FROM orders WHERE customer_id = 123;
-- Index scan: ~100 rows
```

### Optimization Technique 3: Avoid SELECT *

**Bad - Select all columns:**
```sql
SELECT * FROM orders WHERE customer_id = 123;
-- Transfers all columns (unnecessary data)
```

**Good - Select only needed columns:**
```sql
SELECT id, order_date, total FROM orders WHERE customer_id = 123;
-- Transfers only 3 columns
```

### Optimization Technique 4: Use EXISTS Instead of IN

**Bad - IN with subquery:**
```sql
SELECT * FROM customers
WHERE id IN (SELECT customer_id FROM orders);
-- Subquery may return large result set
```

**Good - EXISTS:**
```sql
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
-- Stops at first match per customer
```

### Optimization Technique 5: Avoid Functions on Indexed Columns

**Bad - Function prevents index use:**
```sql
SELECT * FROM orders WHERE YEAR(order_date) = 2024;
-- Can't use index on order_date
```

**Good - Rewrite to use index:**
```sql
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2025-01-01';
-- Uses index on order_date
```

### Optimization Technique 6: Use LIMIT

**Bad - Return all rows:**
```sql
SELECT * FROM orders ORDER BY order_date DESC;
-- Returns 1,000,000 rows
```

**Good - Limit results:**
```sql
SELECT * FROM orders ORDER BY order_date DESC LIMIT 100;
-- Returns 100 rows, stops early
```

### Optimization Technique 7: Optimize JOINs

**Bad - JOIN then filter:**
```sql
SELECT o.*, c.*
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE c.city = 'Seattle';
-- Joins all orders, then filters
```

**Good - Filter then JOIN:**
```sql
SELECT o.*, c.*
FROM orders o
JOIN (SELECT * FROM customers WHERE city = 'Seattle') c
  ON o.customer_id = c.id;
-- Filters customers first, smaller JOIN
```

**Even better - Let optimizer handle it:**
```sql
-- Modern databases optimize this automatically
SELECT o.*, c.*
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE c.city = 'Seattle';
```

### Optimization Technique 8: Use CTEs for Readability

**Bad - Nested subqueries:**
```sql
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT customer_id, SUM(total) as total_spent
        FROM orders
        GROUP BY customer_id
    ) WHERE total_spent > 1000
) WHERE customer_id > 100;
-- Hard to read and optimize
```

**Good - CTEs:**
```sql
WITH customer_totals AS (
    SELECT customer_id, SUM(total) as total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_totals
WHERE total_spent > 1000
  AND customer_id > 100;
-- Clear, optimizer can optimize each step
```

### Optimization Technique 9: Avoid DISTINCT When Possible

**Bad - DISTINCT to fix duplicates:**
```sql
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.id = o.customer_id;
-- Removes duplicates after JOIN (expensive)
```

**Good - Prevent duplicates:**
```sql
SELECT c.customer_name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
-- No duplicates to remove
```

### Optimization Technique 10: Use UNION ALL Instead of UNION

**Bad - UNION removes duplicates:**
```sql
SELECT customer_id FROM orders WHERE status = 'pending'
UNION
SELECT customer_id FROM orders WHERE status = 'shipped';
-- Removes duplicates (expensive sort/dedup)
```

**Good - UNION ALL (if duplicates OK):**
```sql
SELECT customer_id FROM orders WHERE status = 'pending'
UNION ALL
SELECT customer_id FROM orders WHERE status = 'shipped';
-- No deduplication needed
```

### Optimization Technique 11: Optimize Aggregations

**Bad - Aggregate all, filter after:**
```sql
SELECT category, COUNT(*) as count
FROM products
GROUP BY category
HAVING COUNT(*) > 100;
-- Aggregates all categories
```

**Good - Filter first if possible:**
```sql
-- If you can filter rows before grouping:
SELECT category, COUNT(*) as count
FROM products
WHERE price > 0  -- Filter rows first
GROUP BY category
HAVING COUNT(*) > 100;
```

### Optimization Technique 12: Batch Operations

**Bad - Row-by-row:**
```sql
-- In application code:
for each customer:
    UPDATE customers SET last_login = NOW() WHERE id = customer_id;
-- 1000 queries for 1000 customers
```

**Good - Batch update:**
```sql
UPDATE customers 
SET last_login = NOW() 
WHERE id IN (1, 2, 3, ..., 1000);
-- 1 query for 1000 customers
```

### Common Performance Anti-Patterns

**Anti-Pattern 1: N+1 Query Problem**
```sql
-- Get orders
SELECT * FROM orders;

-- Then for each order, get customer (in loop)
SELECT * FROM customers WHERE id = ?;
-- Results in 1 + N queries
```

**Solution - JOIN:**
```sql
SELECT o.*, c.*
FROM orders o
JOIN customers c ON o.customer_id = c.id;
-- 1 query total
```

**Anti-Pattern 2: Correlated Subqueries**
```sql
-- Runs subquery for EACH row
SELECT 
    customer_name,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count
FROM customers c;
```

**Solution - JOIN or window function:**
```sql
SELECT 
    c.customer_name,
    COUNT(o.id) as order_count
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;
```

**Anti-Pattern 3: Implicit Type Conversion**
```sql
-- customer_id is INTEGER, but comparing to string
SELECT * FROM orders WHERE customer_id = '123';
-- Forces type conversion, can't use index efficiently
```

**Solution - Use correct type:**
```sql
SELECT * FROM orders WHERE customer_id = 123;
```

### Practical Example: Before and After

**Before optimization:**
```sql
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE YEAR(o.order_date) = 2024
  AND c.city IN (SELECT city FROM stores)
ORDER BY c.customer_name;
-- Execution time: 5000ms
```

**After optimization:**
```sql
-- 1. Add indexes
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_customers_city ON customers(city);

-- 2. Optimize query
SELECT c.*
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.id
      AND o.order_date >= '2024-01-01'
      AND o.order_date < '2025-01-01'
)
AND c.city IN (SELECT city FROM stores)
ORDER BY c.customer_name;
-- Execution time: 50ms (100x faster!)
```

**Optimizations applied:**
1. Added indexes
2. Removed DISTINCT (used EXISTS)
3. Rewrote date filter to use index
4. Used EXISTS instead of JOIN

### Query Optimization Checklist

**Before writing query:**
- [ ] Do I need all columns? (Avoid SELECT *)
- [ ] Can I filter early? (WHERE before GROUP BY)
- [ ] Are there indexes on filter/join columns?
- [ ] Do I need all rows? (Use LIMIT)

**After writing query:**
- [ ] Run EXPLAIN - is it using indexes?
- [ ] Are there full table scans?
- [ ] Can I rewrite to avoid functions on indexed columns?
- [ ] Is DISTINCT necessary?
- [ ] Can UNION be UNION ALL?

**For slow queries:**
- [ ] Check execution plan with EXPLAIN ANALYZE
- [ ] Add missing indexes
- [ ] Rewrite correlated subqueries
- [ ] Break into CTEs for clarity
- [ ] Consider denormalization for read-heavy queries

### Monitoring Query Performance

**Measure execution time:**
```sql
.timer on
SELECT * FROM orders WHERE customer_id = 123;
-- Shows: Run Time: real 0.005 user 0.003 sys 0.001
```

**Compare query plans:**
```sql
-- Before optimization
EXPLAIN ANALYZE SELECT ...;

-- After optimization
EXPLAIN ANALYZE SELECT ...;

-- Compare: rows scanned, execution time
```

### Best Practices Summary

1. **Index strategically** - WHERE, JOIN, ORDER BY columns
2. **Filter early** - WHERE before GROUP BY
3. **Select only needed columns** - Avoid SELECT *
4. **Use LIMIT** - Don't return unnecessary rows
5. **Avoid functions on indexed columns** - Prevents index use
6. **Use EXISTS over IN** - More efficient for existence checks
7. **Use UNION ALL** - When duplicates are OK
8. **Batch operations** - Avoid row-by-row processing
9. **Use CTEs** - For readability and optimization
10. **Monitor with EXPLAIN** - Verify optimization works
11. **Test with real data** - Performance varies with data size
12. **Profile regularly** - Find slow queries proactively

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day25.db` with large tables for optimization practice.

### Database Schema

**orders** table (100,000 rows):
- id, customer_id, order_date, status, total

**customers** table (10,000 rows):
- id, customer_name, email, city, state

**products** table (1,000 rows):
- id, product_name, category, price, cost

**order_items** table (300,000 rows):
- id, order_id, product_id, quantity, price

### Part 1: Using EXPLAIN (Easy)

### Exercise 1: Basic EXPLAIN (Easy)
Run EXPLAIN on this query and identify the scan type:
```sql
SELECT * FROM orders WHERE customer_id = 100;
```

**Task:** Is it using an index or full table scan?

### Exercise 2: EXPLAIN ANALYZE (Easy)
Run EXPLAIN ANALYZE on the same query and note the execution time.

**Task:** Document the actual time and rows scanned.

### Exercise 3: Compare Plans (Medium)
Compare EXPLAIN output before and after creating an index:
```sql
-- Before
EXPLAIN SELECT * FROM orders WHERE customer_id = 100;

-- Create index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- After
EXPLAIN SELECT * FROM orders WHERE customer_id = 100;
```

**Task:** Describe the difference.

### Part 2: Filter Optimization (Medium)

### Exercise 4: WHERE vs HAVING (Easy)
Optimize this query by moving the filter:
```sql
SELECT customer_id, COUNT(*) as order_count
FROM orders
GROUP BY customer_id
HAVING customer_id = 100;
```

**Task:** Rewrite using WHERE instead of HAVING.

### Exercise 5: Early Filtering (Medium)
Optimize this query to filter earlier:
```sql
SELECT c.customer_name, COUNT(o.id) as order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name
HAVING c.city = 'Seattle';
```

**Task:** Move city filter to WHERE clause.

### Exercise 6: Date Filter Optimization (Medium)
Rewrite this query to use an index on order_date:
```sql
SELECT * FROM orders WHERE YEAR(order_date) = 2024;
```

**Task:** Rewrite without function on indexed column.

### Part 3: SELECT Optimization (Easy)

### Exercise 7: Avoid SELECT * (Easy)
Optimize this query to select only needed columns:
```sql
SELECT * FROM orders WHERE customer_id = 100;
```

Assume you only need: id, order_date, total

### Exercise 8: Column Reduction (Medium)
This query selects unnecessary columns:
```sql
SELECT o.*, c.*, p.*
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.customer_id = 100;
```

Optimize to select only: customer_name, order_date, product_name, quantity

### Part 4: JOIN Optimization (Medium-Hard)

### Exercise 9: EXISTS vs IN (Medium)
Rewrite using EXISTS for better performance:
```sql
SELECT * FROM customers
WHERE id IN (SELECT customer_id FROM orders WHERE status = 'completed');
```

### Exercise 10: Optimize JOIN Order (Hard)
This query joins large tables:
```sql
SELECT *
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE c.city = 'Seattle'
  AND o.order_date >= '2024-01-01';
```

Add appropriate indexes and verify with EXPLAIN.

### Exercise 11: Remove Unnecessary JOIN (Medium)
This query has an unnecessary JOIN:
```sql
SELECT c.customer_name, COUNT(o.id)
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;
```

Rewrite using EXISTS or a subquery if you only need customers with orders.

### Part 5: Aggregation Optimization (Medium)

### Exercise 12: Optimize GROUP BY (Medium)
Optimize this query:
```sql
SELECT category, COUNT(*), AVG(price)
FROM products
WHERE 1=1
GROUP BY category;
```

**Task:** Remove unnecessary WHERE clause, add useful filters.

### Exercise 13: Avoid Correlated Subquery (Hard)
Rewrite this correlated subquery:
```sql
SELECT 
    c.customer_name,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count
FROM customers c;
```

**Task:** Use JOIN or window function instead.

### Exercise 14: Optimize DISTINCT (Medium)
Remove unnecessary DISTINCT:
```sql
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'completed';
```

**Task:** Rewrite using EXISTS.

### Part 6: UNION Optimization (Easy)

### Exercise 15: UNION vs UNION ALL (Easy)
Determine if UNION ALL can be used:
```sql
SELECT customer_id FROM orders WHERE status = 'pending'
UNION
SELECT customer_id FROM orders WHERE status = 'shipped';
```

**Task:** Can this be UNION ALL? Why or why not?

### Exercise 16: Optimize UNION Query (Medium)
Optimize this query:
```sql
SELECT id, customer_name, 'customer' as type FROM customers WHERE city = 'Seattle'
UNION
SELECT id, name, 'employee' as type FROM employees WHERE city = 'Seattle';
```

**Task:** Ensure indexes exist for city filters.

### Part 7: Subquery Optimization (Hard)

### Exercise 17: Flatten Nested Subqueries (Hard)
Rewrite using CTEs:
```sql
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
```

### Exercise 18: Optimize Subquery in SELECT (Hard)
Optimize this query with subquery in SELECT:
```sql
SELECT 
    p.product_name,
    p.price,
    (SELECT AVG(price) FROM products WHERE category = p.category) as category_avg
FROM products p;
```

**Task:** Rewrite using window function or JOIN.

### Part 8: LIMIT Optimization (Easy)

### Exercise 19: Add LIMIT (Easy)
This query returns too many rows:
```sql
SELECT * FROM orders ORDER BY order_date DESC;
```

**Task:** Add LIMIT to return only top 100.

### Exercise 20: Optimize Top-N Query (Medium)
Optimize this top-N query:
```sql
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as rn
    FROM products
) WHERE rn <= 5;
```

**Task:** Ensure it's efficient, add indexes if needed.

### Part 9: Real-World Optimization (Hard)

### Exercise 21: Optimize Dashboard Query (Hard)
Optimize this dashboard query:
```sql
SELECT 
    COUNT(*) as total_orders,
    SUM(total) as total_revenue,
    AVG(total) as avg_order_value,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';
```

**Task:** Add indexes, verify with EXPLAIN.

### Exercise 22: Optimize Report Query (Very Hard)
Optimize this complex report:
```sql
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
```

**Task:** Identify all optimizations needed.

### Exercise 23: Optimize Time-Series Query (Hard)
Optimize this time-series analysis:
```sql
SELECT 
    DATE_TRUNC('day', order_date) as day,
    COUNT(*) as order_count,
    SUM(total) as revenue
FROM orders
WHERE order_date >= '2024-01-01'
GROUP BY DATE_TRUNC('day', order_date)
ORDER BY day;
```

**Task:** Add appropriate indexes.

### Part 10: Anti-Pattern Fixes (Hard)

### Exercise 24: Fix N+1 Problem (Hard)
This code has N+1 problem:
```sql
-- Query 1: Get all orders
SELECT * FROM orders LIMIT 100;

-- Then for each order (in application):
-- Query 2: SELECT * FROM customers WHERE id = ?
```

**Task:** Write a single query to replace both.

### Exercise 25: Fix Implicit Conversion (Medium)
Fix the type mismatch:
```sql
SELECT * FROM orders WHERE customer_id = '123';
```

**Task:** Use correct type.

### Exercise 26: Optimize OR Conditions (Hard)
Optimize this query with OR:
```sql
SELECT * FROM orders 
WHERE customer_id = 100 OR status = 'pending';
```

**Task:** Consider UNION ALL approach, compare performance.

### Part 11: Index Strategy (Hard)

### Exercise 27: Design Index Strategy (Hard)
Given these queries, design optimal indexes:
```sql
-- Query 1 (50% of traffic)
SELECT * FROM orders WHERE customer_id = ? AND order_date >= ?;

-- Query 2 (30% of traffic)
SELECT * FROM orders WHERE status = ?;

-- Query 3 (20% of traffic)
SELECT * FROM orders WHERE order_date BETWEEN ? AND ?;
```

**Task:** List all indexes needed with rationale.

### Exercise 28: Covering Index (Hard)
Create a covering index for this query:
```sql
SELECT customer_id, order_date, total
FROM orders
WHERE customer_id = 100
ORDER BY order_date DESC;
```

**Task:** Index should include all needed columns.

### Part 12: Complete Optimization (Very Hard)

### Exercise 29: Full Query Optimization (Very Hard)
Optimize every aspect of this query:
```sql
SELECT DISTINCT *
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE YEAR(o.order_date) = 2024
  AND c.city IN (SELECT city FROM stores)
  AND p.category = 'Electronics'
ORDER BY c.customer_name;
```

**Task:** 
1. Rewrite query
2. Add indexes
3. Use EXPLAIN to verify
4. Document improvements

### Exercise 30: Performance Audit (Very Hard)
Perform a complete performance audit:
1. Identify the 5 slowest queries in the database
2. Analyze with EXPLAIN ANALYZE
3. Propose optimizations for each
4. Implement and measure improvements
5. Document before/after performance

**Deliverable:** Complete optimization report

## Key Takeaways

- **EXPLAIN shows execution plan** - Use it to verify optimizations
- **Filter early with WHERE** - Before GROUP BY and JOIN
- **Avoid SELECT *** - Select only needed columns
- **Use indexes strategically** - WHERE, JOIN, ORDER BY columns
- **EXISTS vs IN** - EXISTS is often faster
- **Avoid functions on indexed columns** - Prevents index use
- **Use UNION ALL** - When duplicates are acceptable
- **LIMIT reduces rows** - Stop processing early
- **CTEs improve readability** - And help optimizer
- **Batch operations** - Avoid row-by-row processing
- **Monitor performance** - Regular EXPLAIN ANALYZE
- **Test with real data** - Performance varies with data size

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 26
