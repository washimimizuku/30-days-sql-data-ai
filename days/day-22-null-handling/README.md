# Day 22: NULL Handling and Data Manipulation

## 📖 Learning Objectives

By the end of today, you will:
- Master NULL handling (IS NULL, IS NOT NULL, COALESCE, NULLIF)
- Learn data manipulation (INSERT, UPDATE, DELETE)
- Handle missing data correctly
- Safely modify database records
- Use transactions for data integrity

---

## 📚 Theory (15 minutes)

### NULL Handling

**What is NULL?**
NULL represents missing or unknown data. It's NOT zero, empty string, or false.

```sql
-- NULL is not equal to anything, even itself
SELECT NULL = NULL;  -- Returns NULL (not TRUE!)

-- Must use IS NULL
SELECT * FROM employees WHERE email IS NULL;
SELECT * FROM employees WHERE email IS NOT NULL;
```

**COALESCE - Return First Non-NULL Value**
```sql
-- Provide default for NULL
SELECT name, COALESCE(phone, email, 'No contact') as contact FROM employees;
SELECT name, COALESCE(salary, 0) as salary FROM employees;
```

**NULLIF - Return NULL if Values Match**
```sql
-- Avoid division by zero
SELECT total_sales / NULLIF(order_count, 0) as avg_order_value FROM sales;

-- Replace empty strings with NULL
SELECT NULLIF(email, '') as email FROM employees;
```

**NULL in Calculations**
```sql
-- NULL in arithmetic returns NULL
SELECT 10 + NULL;  -- Returns NULL

-- Handle NULLs in calculations
SELECT salary + COALESCE(bonus, 0) as total_comp FROM employees;
```

**NULL in Aggregates**
```sql
-- Aggregates ignore NULL (except COUNT(*))
SELECT 
    COUNT(*) as total_rows,           -- Counts all rows
    COUNT(email) as rows_with_email,  -- Counts non-NULL emails
    AVG(salary) as avg_salary         -- Ignores NULL salaries
FROM employees;
```

### Data Manipulation (DML)

**INSERT - Adding Data**
```sql
-- Single row
INSERT INTO employees (id, name, email, salary)
VALUES (1, 'John Doe', 'john@example.com', 75000);

-- Multiple rows
INSERT INTO employees (id, name, email, salary)
VALUES 
    (2, 'Jane Smith', 'jane@example.com', 80000),
    (3, 'Bob Johnson', 'bob@example.com', 70000);

-- From SELECT
INSERT INTO high_earners
SELECT * FROM employees WHERE salary > 100000;
```

**UPDATE - Modifying Data**
```sql
-- Update single column
UPDATE employees SET salary = 80000 WHERE id = 1;

-- Update multiple columns
UPDATE employees
SET salary = 85000, email = 'new@example.com'
WHERE id = 2;

-- Update with calculation
UPDATE employees SET salary = salary * 1.10 WHERE department = 'Engineering';

-- Update with CASE
UPDATE employees
SET salary = salary * CASE department
    WHEN 'Engineering' THEN 1.15
    WHEN 'Sales' THEN 1.12
    ELSE 1.05
END;
```

**DELETE - Removing Data**
```sql
-- Delete specific rows
DELETE FROM employees WHERE id = 1;

-- Delete with condition
DELETE FROM employees WHERE hire_date < '2020-01-01' AND is_active = FALSE;

-- Delete with subquery
DELETE FROM employees
WHERE department_id IN (SELECT id FROM departments WHERE status = 'closed');
```

**Transactions for Safety**
```sql
BEGIN;
UPDATE employees SET salary = salary * 1.10 WHERE department = 'Engineering';
-- Check results
SELECT * FROM employees WHERE department = 'Engineering';
COMMIT;  -- or ROLLBACK if wrong
```

---

## 🎯 Real-World Use Cases

### Handle Missing Contact Info
```sql
SELECT 
    name,
    COALESCE(phone, email, 'No contact') as contact_method,
    CASE 
        WHEN phone IS NOT NULL THEN 'Phone'
        WHEN email IS NOT NULL THEN 'Email'
        ELSE 'None'
    END as contact_type
FROM customers;
```

### Safe Division
```sql
SELECT 
    product_name,
    total_revenue,
    total_orders,
    total_revenue / NULLIF(total_orders, 0) as avg_order_value
FROM product_stats;
```

### Data Migration
```sql
BEGIN;
-- Archive old records
INSERT INTO employees_archive SELECT * FROM employees WHERE hire_date < '2020-01-01';
-- Delete archived records
DELETE FROM employees WHERE hire_date < '2020-01-01';
COMMIT;
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

```bash
python setup.py
```

Tables: `employees`, `products`, `orders` (with NULL values for practice)

### Exercises

Complete 20 exercises in `exercise.sql`:

1. **NULL Handling** (10 min) - IS NULL, COALESCE, NULLIF, aggregates with NULL
2. **INSERT Operations** (10 min) - Single, multiple, from SELECT
3. **UPDATE Operations** (10 min) - Simple updates, calculations, CASE
4. **DELETE Operations** (5 min) - Conditional deletes, subqueries
5. **Transactions** (5 min) - Safe data manipulation with BEGIN/COMMIT/ROLLBACK

---

## 💡 Key Patterns & Best Practices

### NULL Handling Patterns

**Provide defaults:**
```sql
COALESCE(column, default_value)
```

**Check for NULL:**
```sql
WHERE column IS NULL
WHERE column IS NOT NULL
```

**Safe division:**
```sql
numerator / NULLIF(denominator, 0)
```

### DML Best Practices

**Always use WHERE with UPDATE/DELETE:**
```sql
-- ❌ Wrong - updates ALL rows!
UPDATE employees SET salary = 100000;

-- ✅ Correct
UPDATE employees SET salary = 100000 WHERE id = 1;
```

**Test with SELECT first:**
```sql
-- Test what will be affected
SELECT * FROM employees WHERE department = 'Sales';
-- Then update
UPDATE employees SET salary = salary * 1.10 WHERE department = 'Sales';
```

**Use transactions for important changes:**
```sql
BEGIN;
DELETE FROM orders WHERE status = 'cancelled';
SELECT COUNT(*) FROM orders;  -- Verify
COMMIT;  -- or ROLLBACK
```

### Common Mistakes

❌ **Using = NULL:**
```sql
WHERE email = NULL  -- Wrong!
```

✅ **Use IS NULL:**
```sql
WHERE email IS NULL
```

❌ **Forgetting WHERE clause:**
```sql
DELETE FROM employees;  -- Deletes ALL rows!
```

✅ **Always use WHERE:**
```sql
DELETE FROM employees WHERE id = 1;
```

---

## ✅ Quiz

Test your knowledge in `quiz.md`!

---

## 🚀 Next Steps

Tomorrow: UNION and Set Operations - Combining query results.
