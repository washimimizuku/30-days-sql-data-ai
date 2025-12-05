# Day 24: Indexes and Performance Basics

## Learning Objectives
- Understand how indexes improve query performance
- Learn when and how to create indexes
- Master different index types
- Analyze query performance with EXPLAIN
- Apply indexing best practices

## Theory (15 minutes)

### What are Indexes?

An index is a data structure that improves the speed of data retrieval. Think of it like a book's index - instead of reading every page, you look it up directly.

**Without index:** Database scans every row (full table scan)  
**With index:** Database jumps directly to relevant rows

```sql
-- Without index: scans all 1,000,000 rows (500ms)
SELECT * FROM customers WHERE email = 'john@example.com';

-- Create index
CREATE INDEX idx_customers_email ON customers(email);

-- With index: scans ~1 row (5ms) - 100x faster!
SELECT * FROM customers WHERE email = 'john@example.com';
```

### Creating Indexes

**Basic syntax:**
```sql
CREATE INDEX index_name ON table_name(column_name);

-- Single column
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Multi-column (composite)
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- Unique index
CREATE UNIQUE INDEX idx_customers_email ON customers(email);
```

### When to Use Indexes

**✅ Create indexes on:**
- Columns in WHERE clauses
- Columns in JOIN conditions
- Columns in ORDER BY and GROUP BY
- Foreign key columns

**❌ Don't index:**
- Small tables (< 1000 rows)
- Columns with low cardinality (few unique values)
- Columns rarely queried
- Columns frequently updated

### Index Types

**1. B-Tree Index (Default)**
```sql
CREATE INDEX idx_orders_date ON orders(order_date);

-- Works well for:
WHERE order_date = '2024-01-15'
WHERE order_date > '2024-01-01'
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
```

**2. Unique Index**
```sql
CREATE UNIQUE INDEX idx_users_email ON users(email);
```

**3. Composite Index**
```sql
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);

-- Efficient for:
WHERE customer_id = 123 AND order_date = '2024-01-15'
WHERE customer_id = 123  -- Uses first column

-- NOT efficient for:
WHERE order_date = '2024-01-15'  -- Doesn't use first column
```

### Composite Index Column Order

**Rule:** Most selective column first (highest cardinality).

```sql
-- Good: customer_id first (10,000 unique values)
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);

-- Less optimal: date first (365 unique values)
CREATE INDEX idx_orders_date_cust ON orders(order_date, customer_id);
```

### EXPLAIN Command

```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;

-- Output shows:
-- SEQ_SCAN (orders)  -- Bad: Full table scan
-- INDEX_SCAN (idx_orders_customer_id)  -- Good: Using index
```

### Performance Impact

**Query performance:**
```sql
-- Without index: 1000ms (scans 1M rows)
SELECT * FROM orders WHERE customer_id = 123;

-- With index: 10ms (scans 100 rows)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

**Write performance:**
```sql
-- Indexes slow down writes
INSERT INTO orders VALUES (...);  -- Must update index
UPDATE orders SET status = 'shipped';  -- Must update index
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

### Common Performance Issues

**Issue 1: Function on Indexed Column**
```sql
-- Doesn't use index
SELECT * FROM orders WHERE YEAR(order_date) = 2024;

-- Uses index
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND order_date < '2025-01-01';
```

**Issue 2: Leading Wildcards**
```sql
-- Doesn't use index
SELECT * FROM customers WHERE email LIKE '%@gmail.com';

-- Uses index
SELECT * FROM customers WHERE email LIKE 'john%';
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

### Best Practices

1. **Index foreign keys** - Always index JOIN columns
2. **Index WHERE columns** - Columns frequently filtered
3. **Composite indexes** - For multi-column queries
4. **Monitor with EXPLAIN** - Verify indexes are used
5. **Don't over-index** - Each index has overhead
6. **Consider cardinality** - High cardinality = better index
7. **Test with real data** - Performance varies with data size

### Practical Example

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

-- Composite for common query
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);

-- Before: 2000ms (full scan)
SELECT * FROM orders 
WHERE customer_id = 123 
  AND order_date >= '2024-01-01';

-- After: 15ms (uses idx_orders_cust_date) - 133x faster!
```

### Common Mistakes

**1. Too many indexes** - Slows down writes significantly  
**2. Wrong column order** - Put most selective column first  
**3. Indexing low-cardinality columns** - Not effective alone  
**4. Not using indexes** - Functions prevent index usage

## Exercises (40 minutes)

### Setup
```bash
python setup.py
```

Creates `day24.db` with:
- **customers** (10,000 rows): id, customer_name, email, city, state, registration_date
- **orders** (100,000 rows): id, customer_id, order_date, status, total
- **products** (1,000 rows): id, product_name, category, price
- **order_items** (300,000 rows): id, order_id, product_id, quantity, price

### Instructions

Complete 20 exercises in `exercise.sql`:

**Part 1: Understanding Performance (1-3)** - Measure query time, use EXPLAIN  
**Part 2: Creating Indexes (4-8)** - Single, composite, unique indexes  
**Part 3: Analyzing Performance (9-12)** - Compare before/after, covering indexes  
**Part 4: Index Optimization (13-15)** - Avoid functions, wildcards, OR conditions  
**Part 5: Real-World Scenarios (16-20)** - E-commerce optimization, complex queries

Check `solution.sql` for complete solutions.

## Key Takeaways

- Indexes speed up reads but slow down writes
- Index columns in WHERE, JOIN, ORDER BY, GROUP BY
- Composite indexes: order matters (most selective first)
- Use EXPLAIN to verify index usage
- Avoid functions on indexed columns
- Don't over-index (balance read vs write performance)
- High cardinality columns make better indexes
- Covering indexes eliminate table access

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Performance Explained](https://use-the-index-luke.com/)

## Next Steps
- Complete the exercises
- Check your solutions
- Take the quiz in `quiz.md`
- Move to Day 25: Query Optimization
