# Day 25: Query Optimization and EXPLAIN

## Learning Objectives
- Master query optimization techniques
- Use EXPLAIN to analyze query execution plans
- Identify and fix performance bottlenecks
- Write efficient SQL queries
- Apply optimization best practices

## Theory (15 minutes)

### What is Query Optimization?

Query optimization improves performance by:
- Reducing execution time
- Minimizing resource usage (CPU, memory, I/O)
- Choosing efficient execution plans

### SQL Query Execution Order

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

**Key insight:** Filtering early (WHERE) is faster than filtering late (HAVING).

### Using EXPLAIN

```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;

-- Shows:
-- - Scan type (SEQ_SCAN vs INDEX_SCAN)
-- - Estimated rows
-- - Join methods
-- - Filter conditions
```

**EXPLAIN ANALYZE** shows actual execution statistics:
```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;
-- Shows actual time and rows processed
```

### Top 10 Optimization Techniques

**1. Filter Early (WHERE vs HAVING)**
```sql
-- Bad: Filter after aggregation
SELECT customer_id, COUNT(*) 
FROM orders 
GROUP BY customer_id 
HAVING customer_id = 123;

-- Good: Filter before aggregation
SELECT customer_id, COUNT(*) 
FROM orders 
WHERE customer_id = 123 
GROUP BY customer_id;
```

**2. Use Indexes**
```sql
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
-- Transforms full table scan into index scan
```

**3. Avoid SELECT ***
```sql
-- Bad: Select all columns
SELECT * FROM orders WHERE customer_id = 123;

-- Good: Select only needed columns
SELECT id, order_date, total FROM orders WHERE customer_id = 123;
```

**4. Use EXISTS Instead of IN**
```sql
-- Bad: IN with subquery
SELECT * FROM customers
WHERE id IN (SELECT customer_id FROM orders);

-- Good: EXISTS (stops at first match)
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
```

**5. Avoid Functions on Indexed Columns**
```sql
-- Bad: Function prevents index use
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- Good: Rewrite to use index
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2025-01-01';
```

**6. Use LIMIT**
```sql
-- Bad: Return all rows
SELECT * FROM orders ORDER BY order_date DESC;

-- Good: Limit results
SELECT * FROM orders ORDER BY order_date DESC LIMIT 100;
```

**7. Use CTEs for Readability**
```sql
-- Bad: Nested subqueries
SELECT * FROM (
    SELECT * FROM (
        SELECT customer_id, SUM(total) as total_spent
        FROM orders GROUP BY customer_id
    ) WHERE total_spent > 1000
) WHERE customer_id > 100;

-- Good: CTEs
WITH customer_totals AS (
    SELECT customer_id, SUM(total) as total_spent
    FROM orders GROUP BY customer_id
)
SELECT * FROM customer_totals
WHERE total_spent > 1000 AND customer_id > 100;
```

**8. Use UNION ALL Instead of UNION**
```sql
-- Bad: UNION removes duplicates (expensive)
SELECT customer_id FROM orders WHERE status = 'pending'
UNION
SELECT customer_id FROM orders WHERE status = 'shipped';

-- Good: UNION ALL (if duplicates OK)
SELECT customer_id FROM orders WHERE status = 'pending'
UNION ALL
SELECT customer_id FROM orders WHERE status = 'shipped';
```

**9. Avoid Correlated Subqueries**
```sql
-- Bad: Runs subquery for EACH row
SELECT c.customer_name,
    (SELECT COUNT(*) FROM orders WHERE customer_id = c.id) as order_count
FROM customers c;

-- Good: Use JOIN
SELECT c.customer_name, COUNT(o.id) as order_count
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.customer_name;
```

**10. Batch Operations**
```sql
-- Bad: Row-by-row (1000 queries)
-- for each customer: UPDATE customers SET last_login = NOW() WHERE id = ?;

-- Good: Batch update (1 query)
UPDATE customers SET last_login = NOW() WHERE id IN (1, 2, 3, ..., 1000);
```

### Common Anti-Patterns

**N+1 Query Problem**
```sql
-- Bad: 1 + N queries
SELECT * FROM orders LIMIT 100;
-- Then for each: SELECT * FROM customers WHERE id = ?;

-- Good: 1 query with JOIN
SELECT o.*, c.* FROM orders o
JOIN customers c ON o.customer_id = c.id LIMIT 100;
```

**Implicit Type Conversion**
```sql
-- Bad: customer_id is INTEGER
SELECT * FROM orders WHERE customer_id = '123';

-- Good: Use correct type
SELECT * FROM orders WHERE customer_id = 123;
```

### Practical Example: Before and After

**Before optimization (5000ms):**
```sql
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE YEAR(o.order_date) = 2024
ORDER BY c.customer_name;
```

**After optimization (50ms - 100x faster!):**
```sql
-- Add indexes
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- Optimize query
SELECT c.*
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.customer_id = c.id
      AND o.order_date >= '2024-01-01'
      AND o.order_date < '2025-01-01'
)
ORDER BY c.customer_name;
```

**Changes:**
1. Added composite index
2. Removed DISTINCT (used EXISTS)
3. Rewrote date filter to use index

### Optimization Checklist

**Before writing:**
- [ ] Do I need all columns? (Avoid SELECT *)
- [ ] Can I filter early? (WHERE before GROUP BY)
- [ ] Are there indexes on filter/join columns?
- [ ] Do I need all rows? (Use LIMIT)

**After writing:**
- [ ] Run EXPLAIN - is it using indexes?
- [ ] Are there full table scans?
- [ ] Can I avoid functions on indexed columns?
- [ ] Is DISTINCT necessary?
- [ ] Can UNION be UNION ALL?

## Exercises (40 minutes)

### Setup
```bash
python setup.py
```

Creates `day25.db` with:
- **customers** (10,000 rows): id, customer_name, email, city, state
- **orders** (100,000 rows): id, customer_id, order_date, status, total
- **products** (1,000 rows): id, product_name, category, price, cost
- **order_items** (300,000 rows): id, order_id, product_id, quantity, price

### Instructions

Complete 20 exercises in `exercise.sql`:

**Part 1: Using EXPLAIN (1-3)** - Analyze query plans  
**Part 2: Filter Optimization (4-6)** - WHERE vs HAVING, early filtering  
**Part 3: SELECT Optimization (7-8)** - Avoid SELECT *  
**Part 4: JOIN Optimization (9-11)** - EXISTS vs IN, JOIN order  
**Part 5: Subquery Optimization (12-14)** - CTEs, correlated subqueries  
**Part 6: Advanced Optimization (15-20)** - UNION, LIMIT, complex queries

Check `solution.sql` for complete solutions.

## Key Takeaways

- Use EXPLAIN to verify optimizations
- Filter early with WHERE (before GROUP BY)
- Avoid SELECT * - select only needed columns
- Use indexes on WHERE, JOIN, ORDER BY columns
- EXISTS is often faster than IN
- Avoid functions on indexed columns
- Use UNION ALL when duplicates are OK
- LIMIT reduces rows processed
- CTEs improve readability and optimization
- Batch operations instead of row-by-row
- Monitor performance with EXPLAIN ANALYZE
- Test with real data sizes

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [Use The Index, Luke](https://use-the-index-luke.com/)

## Next Steps
- Complete the exercises
- Check your solutions
- Take the quiz in `quiz.md`
- Move to Day 26: Transactions and ACID
