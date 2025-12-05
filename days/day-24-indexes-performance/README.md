# Day 24: Indexes and Performance Basics

## Learning Objectives
- Understand how indexes improve query performance
- Learn when and how to create indexes
- Master different index types
- Analyze query performance with EXPLAIN
- Identify performance bottlenecks
- Apply indexing best practices

## Theory (15 minutes)

### What are Indexes?

An index is a data structure that improves the speed of data retrieval operations. Think of it like a book's index - instead of reading every page to find a topic, you look it up in the index.

**Without index:** Database scans every row (full table scan)
**With index:** Database jumps directly to relevant rows

### How Indexes Work

**Example without index:**
```sql
-- Find customer by email (scans all 1,000,000 rows)
SELECT * FROM customers WHERE email = 'john@example.com';
-- Execution time: 500ms
```

**Example with index:**
```sql
-- Create index
CREATE INDEX idx_customers_email ON customers(email);

-- Same query (uses index, scans ~1 row)
SELECT * FROM customers WHERE email = 'john@example.com';
-- Execution time: 5ms (100x faster!)
```

### Creating Indexes

**Basic syntax:**
```sql
CREATE INDEX index_name ON table_name(column_name);
```

**Examples:**
```sql
-- Single column index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Multi-column index (composite)
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- Unique index (enforces uniqueness)
CREATE UNIQUE INDEX idx_customers_email ON customers(email);
```

### When to Use Indexes

**✅ Create indexes on:**
- Columns in WHERE clauses
- Columns in JOIN conditions
- Columns in ORDER BY
- Columns in GROUP BY
- Foreign key columns
- Columns frequently searched

**❌ Don't index:**
- Small tables (< 1000 rows)
- Columns with low cardinality (few unique values)
- Columns rarely queried
- Columns frequently updated
- Very wide columns (long text)

### Index Types

**1. B-Tree Index (Default)**
- Most common type
- Good for equality and range queries
- Automatically created for PRIMARY KEY

```sql
CREATE INDEX idx_orders_date ON orders(order_date);

-- Works well for:
WHERE order_date = '2024-01-15'
WHERE order_date > '2024-01-01'
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
```

**2. Unique Index**
- Enforces uniqueness
- Slightly faster than regular index

```sql
CREATE UNIQUE INDEX idx_users_email ON users(email);
```

**3. Composite Index (Multi-column)**
- Index on multiple columns
- Order matters!

```sql
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);

-- Efficient for:
WHERE customer_id = 123 AND order_date = '2024-01-15'
WHERE customer_id = 123  -- Uses first column

-- NOT efficient for:
WHERE order_date = '2024-01-15'  -- Doesn't use first column
```

### Composite Index Column Order

**Rule:** Most selective column first, or most frequently queried column first.

```sql
-- Good: customer_id first (more selective, frequently queried)
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);

-- Less optimal: date first
CREATE INDEX idx_orders_date_cust ON orders(order_date, customer_id);
```

### EXPLAIN Command

Use EXPLAIN to see query execution plan:

```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;
```

**Output shows:**
- Whether index is used
- Estimated rows scanned
- Join methods
- Sort operations

**Example output:**
```
SEQ_SCAN (orders)  -- Bad: Full table scan
INDEX_SCAN (idx_orders_customer_id)  -- Good: Using index
```

### EXPLAIN ANALYZE

Shows actual execution statistics:

```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;
```

**Shows:**
- Actual execution time
- Rows actually scanned
- Memory used

### Index Performance Impact

**Query performance:**
```sql
-- Without index: 1000ms (scans 1M rows)
SELECT * FROM orders WHERE customer_id = 123;

-- With index: 10ms (scans 100 rows)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
SELECT * FROM orders WHERE customer_id = 123;
```

**Write performance:**
```sql
-- Indexes slow down writes
INSERT INTO orders VALUES (...);  -- Must update index
UPDATE orders SET status = 'shipped';  -- Must update index
DELETE FROM orders WHERE id = 123;  -- Must update index
```

**Trade-off:** Faster reads, slower writes

### Covering Indexes

Index that contains all columns needed by query:

```sql
-- Query needs: customer_id, order_date, total
CREATE INDEX idx_orders_covering ON orders(customer_id, order_date, total);

-- This query doesn't need to access table at all!
SELECT order_date, total 
FROM orders 
WHERE customer_id = 123;
```

### Index Maintenance

**View indexes:**
```sql
-- DuckDB
PRAGMA show_tables;
SELECT * FROM duckdb_indexes();

-- Check index usage
PRAGMA database_size;
```

**Drop unused indexes:**
```sql
DROP INDEX idx_orders_old;
```

**Rebuild indexes (if needed):**
```sql
-- DuckDB handles this automatically
-- Some databases require: REINDEX
```

### Common Performance Issues

**Issue 1: Missing Index**
```sql
-- Slow: Full table scan
SELECT * FROM orders WHERE customer_id = 123;

-- Fix: Add index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

**Issue 2: Function on Indexed Column**
```sql
-- Doesn't use index
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- Uses index
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2025-01-01';
```

**Issue 3: OR Conditions**
```sql
-- May not use indexes efficiently
SELECT * FROM orders 
WHERE customer_id = 123 OR status = 'pending';

-- Better: Use UNION
SELECT * FROM orders WHERE customer_id = 123
UNION
SELECT * FROM orders WHERE status = 'pending';
```

**Issue 4: Leading Wildcards**
```sql
-- Doesn't use index
SELECT * FROM customers WHERE email LIKE '%@gmail.com';

-- Uses index
SELECT * FROM customers WHERE email LIKE 'john%';
```

### Best Practices

1. **Index foreign keys** - Always index JOIN columns
2. **Index WHERE columns** - Columns frequently filtered
3. **Composite indexes** - For multi-column queries
4. **Monitor query performance** - Use EXPLAIN regularly
5. **Don't over-index** - Each index has overhead
6. **Consider cardinality** - High cardinality = better index
7. **Index ORDER BY columns** - Avoid sorting
8. **Test with real data** - Performance varies with data size

### Practical Example: E-commerce Optimization

```sql
-- Orders table (1M rows)
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,  -- Automatic index
    customer_id INTEGER,
    order_date DATE,
    status VARCHAR,
    total DECIMAL
);

-- Essential indexes
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(status);

-- Composite index for common query
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);

-- Covering index for dashboard
CREATE INDEX idx_orders_dashboard ON orders(order_date, status, total);
```

**Query optimization:**
```sql
-- Before: 2000ms (full scan)
SELECT * FROM orders 
WHERE customer_id = 123 
  AND order_date >= '2024-01-01';

-- After: 15ms (uses idx_orders_cust_date)
-- Same query, 133x faster!
```

### Practical Example: Customer Search

```sql
-- Customers table
CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    email VARCHAR UNIQUE,  -- Automatic unique index
    name VARCHAR,
    city VARCHAR,
    registration_date DATE
);

-- Indexes for common searches
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_customers_reg_date ON customers(registration_date);

-- Composite for filtered reports
CREATE INDEX idx_customers_city_date ON customers(city, registration_date);
```

### Query Patterns and Indexes

**Pattern 1: Equality Search**
```sql
-- Needs index on customer_id
SELECT * FROM orders WHERE customer_id = 123;
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

**Pattern 2: Range Search**
```sql
-- Needs index on order_date
SELECT * FROM orders WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';
CREATE INDEX idx_orders_date ON orders(order_date);
```

**Pattern 3: JOIN**
```sql
-- Needs indexes on both JOIN columns
SELECT * FROM orders o
JOIN customers c ON o.customer_id = c.id;

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
-- customers.id already indexed (PRIMARY KEY)
```

**Pattern 4: ORDER BY**
```sql
-- Needs index on order_date to avoid sorting
SELECT * FROM orders ORDER BY order_date DESC LIMIT 10;
CREATE INDEX idx_orders_date ON orders(order_date);
```

**Pattern 5: GROUP BY**
```sql
-- Needs index on category for efficient grouping
SELECT category, COUNT(*) FROM products GROUP BY category;
CREATE INDEX idx_products_category ON products(category);
```

### Monitoring Performance

**Check query execution time:**
```sql
.timer on
SELECT * FROM orders WHERE customer_id = 123;
-- Shows execution time
```

**Analyze query plan:**
```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;
-- Shows if index is used
```

**Compare before/after:**
```sql
-- Before index
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;
-- Note: execution time

-- Create index
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- After index
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;
-- Compare: should be much faster
```

### Common Mistakes

**Mistake 1: Too many indexes**
```sql
-- Bad: 10 indexes on one table
-- Each INSERT/UPDATE/DELETE updates all indexes
-- Slows down writes significantly
```

**Mistake 2: Wrong column order in composite index**
```sql
-- Query: WHERE customer_id = 123 AND order_date = '2024-01-01'
-- Bad: date first
CREATE INDEX idx ON orders(order_date, customer_id);
-- Good: customer_id first (more selective)
CREATE INDEX idx ON orders(customer_id, order_date);
```

**Mistake 3: Indexing low-cardinality columns**
```sql
-- Bad: Only 2-3 unique values
CREATE INDEX idx_orders_status ON orders(status);
-- Better: Use in composite index
CREATE INDEX idx ON orders(customer_id, status);
```

**Mistake 4: Not using indexes**
```sql
-- Index exists but not used
CREATE INDEX idx_orders_date ON orders(order_date);
-- This doesn't use the index:
SELECT * FROM orders WHERE YEAR(order_date) = 2024;
-- This does:
SELECT * FROM orders WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01';
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day24.db` with large tables (100K+ rows) for performance testing.

### Database Schema

**orders** table (100,000 rows):
- id, customer_id, order_date, status, total

**customers** table (10,000 rows):
- id, customer_name, email, city, state

**products** table (1,000 rows):
- id, product_name, category, price

**order_items** table (300,000 rows):
- id, order_id, product_id, quantity, price

### Part 1: Understanding Performance (Easy)

### Exercise 1: Measure Query Time (Easy)
Run this query and note the execution time:
```sql
SELECT * FROM orders WHERE customer_id = 5000;
```

Then create an index and run again:
```sql
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
SELECT * FROM orders WHERE customer_id = 5000;
```

**Task:** Document the time difference.

### Exercise 2: Use EXPLAIN (Easy)
Write a query to find all orders for a specific customer, then use EXPLAIN to see the execution plan.

**Expected:** See whether an index is used

### Exercise 3: Full Table Scan (Easy)
Write a query that will cause a full table scan (no index can help).

**Hint:** Query without WHERE, or WHERE on non-indexed column

### Part 2: Creating Indexes (Medium)

### Exercise 4: Single Column Index (Easy)
Create an index on the `email` column of the customers table.

**Expected:** CREATE INDEX statement

### Exercise 5: Composite Index (Medium)
Create a composite index on orders table for customer_id and order_date.

**Expected:** CREATE INDEX with two columns

### Exercise 6: Unique Index (Easy)
Create a unique index on the email column to prevent duplicate emails.

**Expected:** CREATE UNIQUE INDEX statement

### Exercise 7: Index for JOIN (Medium)
Identify which columns need indexes for this query to run efficiently:
```sql
SELECT o.*, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.order_date >= '2024-01-01';
```

Create the necessary indexes.

### Exercise 8: Index for ORDER BY (Medium)
Create an index to optimize this query:
```sql
SELECT * FROM orders 
ORDER BY order_date DESC 
LIMIT 100;
```

### Part 3: Analyzing Performance (Medium-Hard)

### Exercise 9: Compare Performance (Medium)
Write a query to find orders in a date range. Measure performance before and after creating an index.

**Task:** Document execution times

### Exercise 10: Identify Missing Index (Medium)
This query is slow:
```sql
SELECT * FROM order_items WHERE product_id = 500;
```

Identify what index is needed and create it.

### Exercise 11: Composite Index Order (Hard)
You have these two queries:
```sql
-- Query A
SELECT * FROM orders WHERE customer_id = 100 AND status = 'completed';

-- Query B  
SELECT * FROM orders WHERE status = 'completed' AND customer_id = 100;
```

Create ONE composite index that optimizes both queries. Explain your column order choice.

### Exercise 12: Covering Index (Hard)
Create a covering index for this query so it doesn't need to access the table:
```sql
SELECT customer_id, order_date, total
FROM orders
WHERE customer_id = 100;
```

### Part 4: Index Optimization (Hard)

### Exercise 13: Function on Column (Medium)
This query doesn't use the index on order_date:
```sql
SELECT * FROM orders WHERE YEAR(order_date) = 2024;
```

Rewrite it to use the index.

### Exercise 14: Leading Wildcard (Medium)
This query can't use an index:
```sql
SELECT * FROM customers WHERE email LIKE '%@gmail.com';
```

Explain why and suggest an alternative approach.

### Exercise 15: OR vs UNION (Hard)
Compare performance of these two approaches:
```sql
-- Approach A
SELECT * FROM orders WHERE customer_id = 100 OR status = 'pending';

-- Approach B
SELECT * FROM orders WHERE customer_id = 100
UNION
SELECT * FROM orders WHERE status = 'pending';
```

Which is faster and why?

### Part 5: Real-World Scenarios (Hard)

### Exercise 16: E-commerce Optimization (Hard)
You have an orders table with these common queries:
1. Find orders by customer
2. Find orders by date range
3. Find orders by customer and date
4. Find orders by status

Design an optimal indexing strategy (minimum indexes for maximum benefit).

### Exercise 17: Search Optimization (Hard)
Create indexes to optimize a customer search feature that allows:
- Search by email (exact match)
- Search by city
- Search by city and registration date
- Sort by registration date

### Exercise 18: JOIN Performance (Hard)
Optimize this query with appropriate indexes:
```sql
SELECT 
    c.customer_name,
    COUNT(o.id) as order_count,
    SUM(o.total) as total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE c.city = 'Seattle'
  AND o.order_date >= '2024-01-01'
GROUP BY c.customer_name;
```

List all indexes needed.

### Exercise 19: Aggregation Performance (Hard)
This query is slow:
```sql
SELECT 
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price
FROM products
GROUP BY category;
```

What index would help? Create it and explain why.

### Exercise 20: Complex Query Optimization (Very Hard)
Optimize this complex query:
```sql
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
```

Identify all indexes needed and create them.

### Part 6: Index Maintenance (Medium)

### Exercise 21: View Indexes (Easy)
Write a query to list all indexes in the database.

**Hint:** Use DuckDB system tables

### Exercise 22: Drop Unused Index (Easy)
Drop an index that you created earlier.

**Expected:** DROP INDEX statement

### Exercise 23: Index Size (Medium)
Estimate the storage overhead of indexes on the orders table.

**Hint:** Consider number of rows and indexed columns

### Part 7: Advanced Concepts (Hard)

### Exercise 24: Cardinality Analysis (Medium)
Calculate the cardinality (number of unique values) for these columns:
- orders.status
- orders.customer_id
- customers.city

Which columns are good candidates for indexes?

### Exercise 25: Index Selectivity (Hard)
Write a query to calculate the selectivity of the status column:
```
Selectivity = (Unique values / Total rows)
```

Is this a good index candidate?

### Exercise 26: Partial Index Simulation (Hard)
DuckDB doesn't support partial indexes, but simulate the concept:
Create an index that would be useful for finding only 'pending' orders.

**Hint:** Consider a filtered view or materialized approach

### Exercise 27: Index vs Full Scan (Hard)
For a table with 1000 rows, when might a full table scan be faster than using an index?

**Task:** Explain scenarios and test with queries

### Exercise 28: Multi-Column Query Optimization (Very Hard)
You have these queries running frequently:
```sql
-- Query 1: 40% of traffic
SELECT * FROM orders WHERE customer_id = ? AND order_date = ?;

-- Query 2: 30% of traffic
SELECT * FROM orders WHERE customer_id = ?;

-- Query 3: 20% of traffic
SELECT * FROM orders WHERE order_date = ?;

-- Query 4: 10% of traffic
SELECT * FROM orders WHERE status = ?;
```

Design an optimal indexing strategy considering query frequency.

### Exercise 29: Performance Benchmarking (Very Hard)
Create a benchmark comparing:
1. No indexes
2. Single column indexes
3. Composite indexes
4. Covering indexes

For this query:
```sql
SELECT customer_id, order_date, total
FROM orders
WHERE customer_id BETWEEN 1000 AND 2000
  AND order_date >= '2024-01-01'
ORDER BY order_date;
```

### Exercise 30: Complete Optimization Strategy (Very Hard)
Given a complete e-commerce schema, design a comprehensive indexing strategy:
- Identify top 10 most common queries
- Design indexes for each
- Minimize index count
- Document trade-offs
- Estimate performance improvements

**Deliverable:** Complete indexing plan with rationale

## Key Takeaways

- **Indexes speed up reads** - Dramatically faster queries
- **Indexes slow down writes** - INSERT/UPDATE/DELETE must update indexes
- **Index WHERE columns** - Columns in WHERE, JOIN, ORDER BY
- **Composite indexes** - Multiple columns, order matters
- **Use EXPLAIN** - Verify indexes are being used
- **Don't over-index** - Each index has overhead
- **High cardinality** - More unique values = better index
- **Covering indexes** - Include all needed columns
- **Avoid functions on indexed columns** - Prevents index usage
- **Monitor performance** - Measure before and after
- **Foreign keys need indexes** - Always index JOIN columns
- **Balance read vs write performance** - Consider workload

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 25
