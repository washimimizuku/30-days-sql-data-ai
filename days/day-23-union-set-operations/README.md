# Day 23: UNION and Set Operations

## 📖 Learning Objectives

By the end of today, you will:
- Master UNION and UNION ALL for combining query results
- Learn INTERSECT and EXCEPT for set operations
- Understand when to use each operation
- Combine data from multiple tables
- Build complex analytical queries

---

## 📚 Theory (15 minutes)

### Set Operations Overview

Set operations combine results from multiple SELECT statements.

**Requirements:**
- Same number of columns in each SELECT
- Compatible data types in corresponding columns
- Column names from first SELECT are used

### UNION - Combine and Remove Duplicates

```sql
-- Combine customers from two regions
SELECT customer_name, city FROM customers_east
UNION
SELECT customer_name, city FROM customers_west;
```

Removes duplicate rows automatically.

### UNION ALL - Combine and Keep Duplicates

```sql
-- Combine all orders (keep duplicates)
SELECT order_id, customer_id, total FROM orders_2023
UNION ALL
SELECT order_id, customer_id, total FROM orders_2024;
```

Faster than UNION (no duplicate removal).

### INTERSECT - Find Common Rows

```sql
-- Customers who are also employees
SELECT email FROM customers
INTERSECT
SELECT email FROM employees;
```

Returns only rows that appear in both queries.

### EXCEPT - Find Difference

```sql
-- Customers who are NOT employees
SELECT email FROM customers
EXCEPT
SELECT email FROM employees;
```

Returns rows from first query that don't appear in second.

---

## 🎯 Real-World Use Cases

### Combine Historical Data
```sql
-- All orders from multiple years
SELECT order_id, order_date, total FROM orders_2022
UNION ALL
SELECT order_id, order_date, total FROM orders_2023
UNION ALL
SELECT order_id, order_date, total FROM orders_2024;
```

### Find Overlapping Customers
```sql
-- Customers in both email and phone lists
SELECT customer_id FROM email_subscribers
INTERSECT
SELECT customer_id FROM sms_subscribers;
```

### Identify Gaps
```sql
-- Products in catalog but not in inventory
SELECT product_id FROM product_catalog
EXCEPT
SELECT product_id FROM inventory;
```

### Create Unified View
```sql
-- All contacts (employees + customers)
SELECT name, email, 'Employee' as type FROM employees
UNION
SELECT name, email, 'Customer' as type FROM customers;
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

```bash
python setup.py
```

Tables: `employees_2023`, `employees_2024`, `customers_east`, `customers_west`, `products_online`, `products_store`

### Exercises

Complete 20 exercises in `exercise.sql`:

1. **UNION** (10 min) - Combine tables, remove duplicates
2. **UNION ALL** (10 min) - Combine with duplicates, performance
3. **INTERSECT** (10 min) - Find common records
4. **EXCEPT** (5 min) - Find differences
5. **Complex Combinations** (5 min) - Multiple operations, CTEs

---

## 💡 Key Patterns & Best Practices

### When to Use Each Operation

| Operation | Use When | Performance |
|-----------|----------|-------------|
| UNION | Need unique combined results | Slower (removes duplicates) |
| UNION ALL | Keep all rows, duplicates OK | Faster |
| INTERSECT | Find common records | Medium |
| EXCEPT | Find differences | Medium |

### Common Patterns

**Combine partitioned tables:**
```sql
SELECT * FROM sales_q1
UNION ALL
SELECT * FROM sales_q2
UNION ALL
SELECT * FROM sales_q3
UNION ALL
SELECT * FROM sales_q4;
```

**Add type indicator:**
```sql
SELECT id, name, 'Active' as status FROM active_users
UNION ALL
SELECT id, name, 'Inactive' as status FROM inactive_users;
```

**Find missing records:**
```sql
SELECT product_id FROM expected_products
EXCEPT
SELECT product_id FROM received_products;
```

### Best Practices

1. **Use UNION ALL when possible** - Faster if duplicates don't matter
2. **Match column count and types** - Required for set operations
3. **Use meaningful column names** - From first SELECT
4. **Consider indexes** - On columns used in operations
5. **Test with LIMIT first** - Verify results before full query

### Common Mistakes

❌ **Different column counts:**
```sql
SELECT name, email FROM table1
UNION
SELECT name FROM table2;  -- Error!
```

✅ **Match column counts:**
```sql
SELECT name, email FROM table1
UNION
SELECT name, NULL as email FROM table2;
```

❌ **Using UNION when UNION ALL works:**
```sql
-- Slower (unnecessary duplicate removal)
SELECT * FROM orders_2023
UNION
SELECT * FROM orders_2024;
```

✅ **Use UNION ALL for partitioned data:**
```sql
-- Faster (no duplicates expected)
SELECT * FROM orders_2023
UNION ALL
SELECT * FROM orders_2024;
```

---

## ✅ Quiz

Test your knowledge in `quiz.md`!

---

## 🚀 Next Steps

Tomorrow: Indexes and Performance - Optimizing query speed.
