# Day 16: Window Functions - ROW_NUMBER, RANK, DENSE_RANK

## 📖 Learning Objectives

By the end of today, you will:
- Understand what window functions are and why they're powerful
- Master ROW_NUMBER(), RANK(), and DENSE_RANK()
- Apply PARTITION BY to create groups within window functions
- Solve real-world problems like "top N per group"

---

## 📚 Theory (15 minutes)

### What are Window Functions?

Window functions perform calculations across rows WITHOUT collapsing them like GROUP BY does.

**Key Difference:**
```sql
-- GROUP BY: Collapses rows
SELECT department, AVG(salary) FROM employees GROUP BY department;
-- Result: One row per department

-- Window Function: Keeps all rows
SELECT name, department, salary,
    AVG(salary) OVER (PARTITION BY department) as dept_avg
FROM employees;
-- Result: All rows, with department average added
```

### ROW_NUMBER() - Unique Sequential Numbers

```sql
SELECT name, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
FROM employees;
```

Result: `1, 2, 3, 4, 5...` (always unique)

### RANK() - Ranks with Gaps

```sql
SELECT name, salary,
    RANK() OVER (ORDER BY salary DESC) as rank
FROM employees;
```

With ties: `1, 2, 2, 4, 5...` (skips rank 3)

### DENSE_RANK() - Ranks without Gaps

```sql
SELECT name, salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank
FROM employees;
```

With ties: `1, 2, 2, 3, 4...` (no gaps)

### PARTITION BY - Group and Apply

```sql
-- Rank employees within each department
SELECT name, department, salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;
```

Creates separate rankings for each department.

### Syntax

```sql
function_name() OVER (
    [PARTITION BY column1, ...]
    [ORDER BY column1 [ASC|DESC], ...]
)
```

---

## 🎯 Real-World Use Cases

### Top N per Group
```sql
-- Top 3 products in each category
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) as rn
    FROM products
)
SELECT * FROM ranked WHERE rn <= 3;
```

### Pagination
```sql
-- Get page 2 (rows 11-20)
WITH numbered AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY product_name) as rn
    FROM products
)
SELECT * FROM numbered WHERE rn BETWEEN 11 AND 20;
```

### Duplicate Detection
```sql
-- Number duplicate emails
SELECT email, name, 
    ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_date) as occurrence
FROM users;
```

### Leaderboard with Ties
```sql
SELECT name, sales,
    RANK() OVER (ORDER BY sales DESC) as rank,
    DENSE_RANK() OVER (ORDER BY sales DESC) as dense_rank
FROM sales_summary;
-- Shows: rank=1,1,3 vs dense_rank=1,1,2
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

```bash
python setup.py
```

Tables: `employees`, `sales`, `products`, `orders`

### Exercises

Complete 20 exercises in `exercise.sql`:

1. **Basic ROW_NUMBER** (5 min) - Sequential numbering with different orderings
2. **RANK vs DENSE_RANK** (10 min) - Compare all three ranking functions
3. **PARTITION BY** (10 min) - Rank within groups
4. **Top N per Group** (10 min) - Find top earners, products, orders per category
5. **Advanced Patterns** (5 min) - NTILE, PERCENT_RANK, duplicate detection

---

## 💡 Key Patterns & Best Practices

### When to Use Each Function

| Function | Use When |
|----------|----------|
| ROW_NUMBER() | Need unique numbers, pagination, top N per group |
| RANK() | Show ties with same rank, OK with gaps (1,2,2,4) |
| DENSE_RANK() | Show ties with same rank, NO gaps (1,2,2,3) |
| NTILE(n) | Divide into equal groups (quartiles, deciles) |
| PERCENT_RANK() | Calculate percentiles (returns 0-1) |

### Common Patterns

**Top N per Group:**
```sql
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) as rn
    FROM employees
)
SELECT * FROM ranked WHERE rn <= 3;
```

**Deduplication:**
```sql
WITH numbered AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_date) as rn
    FROM users
)
DELETE FROM users WHERE id IN (SELECT id FROM numbered WHERE rn > 1);
```

**Gap Detection:**
```sql
WITH numbered AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) as expected
    FROM orders
)
SELECT * FROM numbered WHERE id != expected;
```

### Common Mistakes

❌ **Using WHERE with window functions:**
```sql
-- WRONG
SELECT name, ROW_NUMBER() OVER (ORDER BY salary) as rn
FROM employees WHERE rn <= 5;  -- ERROR!
```

✅ **Use CTE instead:**
```sql
WITH numbered AS (
    SELECT name, ROW_NUMBER() OVER (ORDER BY salary) as rn FROM employees
)
SELECT * FROM numbered WHERE rn <= 5;
```

❌ **Forgetting ORDER BY:**
```sql
ROW_NUMBER() OVER ()  -- Arbitrary order!
```

✅ **Always specify ORDER BY:**
```sql
ROW_NUMBER() OVER (ORDER BY salary DESC)
```

---

## ✅ Quiz

Test your knowledge in `quiz.md`!

---

## 🚀 Next Steps

Tomorrow: Advanced Window Functions - LAG, LEAD, and moving aggregates.
