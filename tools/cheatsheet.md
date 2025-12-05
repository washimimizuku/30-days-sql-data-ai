# SQL Quick Reference Cheatsheet
## 30 Days of SQL - Complete Reference

---

## 📖 Table of Contents
1. [Basic SELECT](#basic-select)
2. [WHERE Clause](#where-clause)
3. [ORDER BY & LIMIT](#order-by--limit)
4. [Aggregate Functions](#aggregate-functions)
5. [GROUP BY & HAVING](#group-by--having)
6. [JOINs](#joins)
7. [Subqueries](#subqueries)
8. [CTEs](#ctes-common-table-expressions)
9. [Window Functions](#window-functions)
10. [CASE Statements](#case-statements)
11. [Date/Time Functions](#datetime-functions)
12. [String Functions](#string-functions)
13. [NULL Handling](#null-handling)
14. [Set Operations](#set-operations-union)
15. [Indexes & Performance](#indexes--performance)
16. [Transactions](#transactions)
17. [Views](#views)
18. [JSON Functions](#json-functions)

---

## Basic SELECT

```sql
-- Select all columns
SELECT * FROM employees;

-- Select specific columns
SELECT name, salary FROM employees;

-- Select with alias
SELECT name AS employee_name, salary * 12 AS annual_salary FROM employees;

-- Select distinct values
SELECT DISTINCT department FROM employees;

-- Select with calculations
SELECT name, salary, salary * 0.1 AS tax FROM employees;
```

---

## WHERE Clause

```sql
-- Comparison operators
SELECT * FROM employees WHERE salary > 70000;
SELECT * FROM employees WHERE department = 'Sales';
SELECT * FROM employees WHERE age >= 18 AND age <= 65;

-- BETWEEN
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 100000;

-- IN
SELECT * FROM employees WHERE department IN ('Sales', 'Marketing', 'HR');

-- LIKE (pattern matching)
SELECT * FROM employees WHERE name LIKE 'A%';      -- Starts with A
SELECT * FROM employees WHERE email LIKE '%@gmail.com';  -- Ends with
SELECT * FROM employees WHERE name LIKE '%son%';   -- Contains

-- NOT
SELECT * FROM employees WHERE department NOT IN ('Sales', 'HR');
SELECT * FROM employees WHERE name NOT LIKE 'A%';

-- AND, OR
SELECT * FROM employees WHERE salary > 70000 AND department = 'Sales';
SELECT * FROM employees WHERE department = 'Sales' OR department = 'Marketing';
```

---

## ORDER BY & LIMIT

```sql
-- Order ascending (default)
SELECT * FROM employees ORDER BY salary;
SELECT * FROM employees ORDER BY salary ASC;

-- Order descending
SELECT * FROM employees ORDER BY salary DESC;

-- Multiple columns
SELECT * FROM employees ORDER BY department, salary DESC;

-- LIMIT (top N)
SELECT * FROM employees ORDER BY salary DESC LIMIT 10;

-- OFFSET (skip rows)
SELECT * FROM employees ORDER BY salary DESC LIMIT 10 OFFSET 20;
```

---

## Aggregate Functions

```sql
-- COUNT
SELECT COUNT(*) FROM employees;
SELECT COUNT(DISTINCT department) FROM employees;

-- SUM
SELECT SUM(salary) FROM employees;

-- AVG
SELECT AVG(salary) FROM employees;

-- MIN, MAX
SELECT MIN(salary), MAX(salary) FROM employees;

-- Multiple aggregates
SELECT 
    COUNT(*) as total_employees,
    AVG(salary) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees;
```

---

## GROUP BY & HAVING

```sql
-- GROUP BY
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- GROUP BY with multiple aggregates
SELECT 
    department,
    COUNT(*) as count,
    AVG(salary) as avg_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department;

-- HAVING (filter groups)
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000;

-- Multiple columns
SELECT department, job_title, COUNT(*)
FROM employees
GROUP BY department, job_title;
```

---

## JOINs

```sql
-- INNER JOIN (only matching rows)
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;

-- LEFT JOIN (all from left, matching from right)
SELECT c.name, o.order_date
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;

-- RIGHT JOIN (all from right, matching from left)
SELECT e.name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;

-- FULL OUTER JOIN (all from both)
SELECT e.name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;

-- CROSS JOIN (cartesian product)
SELECT p.name, c.color
FROM products p
CROSS JOIN colors c;

-- SELF JOIN
SELECT e1.name as employee, e2.name as manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.id;

-- Multiple JOINs
SELECT o.id, c.name, p.product_name
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;
```

---

## Subqueries

```sql
-- Subquery in WHERE
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Subquery with IN
SELECT name
FROM employees
WHERE department_id IN (
    SELECT id FROM departments WHERE location = 'Seattle'
);

-- Subquery in FROM
SELECT dept, avg_salary
FROM (
    SELECT department as dept, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) subquery
WHERE avg_salary > 70000;

-- Subquery in SELECT
SELECT 
    name,
    salary,
    (SELECT AVG(salary) FROM employees) as company_avg
FROM employees;

-- EXISTS
SELECT name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
);
```

---

## CTEs (Common Table Expressions)

```sql
-- Basic CTE
WITH high_earners AS (
    SELECT * FROM employees WHERE salary > 100000
)
SELECT * FROM high_earners;

-- Multiple CTEs
WITH 
sales_dept AS (
    SELECT * FROM employees WHERE department = 'Sales'
),
high_performers AS (
    SELECT * FROM sales_dept WHERE salary > 80000
)
SELECT * FROM high_performers;

-- Recursive CTE (organizational hierarchy)
WITH RECURSIVE org_chart AS (
    SELECT id, name, manager_id, 1 as level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.id, e.name, e.manager_id, oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT * FROM org_chart;
```

---

## Window Functions

```sql
-- ROW_NUMBER (unique sequential number)
SELECT 
    name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
FROM employees;

-- RANK (with gaps for ties)
SELECT 
    name,
    salary,
    RANK() OVER (ORDER BY salary DESC) as rank
FROM employees;

-- DENSE_RANK (no gaps for ties)
SELECT 
    name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank
FROM employees;

-- PARTITION BY (separate ranking per group)
SELECT 
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;

-- LAG (previous row value)
SELECT 
    order_date,
    revenue,
    LAG(revenue) OVER (ORDER BY order_date) as prev_revenue
FROM daily_sales;

-- LEAD (next row value)
SELECT 
    order_date,
    revenue,
    LEAD(revenue) OVER (ORDER BY order_date) as next_revenue
FROM daily_sales;

-- Running totals
SELECT 
    order_date,
    revenue,
    SUM(revenue) OVER (ORDER BY order_date) as running_total
FROM daily_sales;

-- Moving average
SELECT 
    order_date,
    revenue,
    AVG(revenue) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7day
FROM daily_sales;

-- NTILE (divide into N buckets)
SELECT 
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary) as quartile
FROM employees;
```

---

## CASE Statements

```sql
-- Simple CASE
SELECT 
    name,
    salary,
    CASE 
        WHEN salary > 100000 THEN 'High'
        WHEN salary > 60000 THEN 'Medium'
        ELSE 'Low'
    END as salary_band
FROM employees;

-- CASE in aggregation
SELECT 
    department,
    COUNT(CASE WHEN salary > 80000 THEN 1 END) as high_earners,
    COUNT(CASE WHEN salary <= 80000 THEN 1 END) as others
FROM employees
GROUP BY department;

-- CASE with multiple conditions
SELECT 
    name,
    CASE 
        WHEN salary > 100000 AND years_experience > 10 THEN 'Senior High'
        WHEN salary > 100000 THEN 'High Earner'
        WHEN years_experience > 10 THEN 'Experienced'
        ELSE 'Standard'
    END as category
FROM employees;
```

---

## Date/Time Functions

```sql
-- Current date/time
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;
SELECT CURRENT_TIMESTAMP;

-- Extract parts
SELECT 
    order_date,
    YEAR(order_date) as year,
    MONTH(order_date) as month,
    DAY(order_date) as day,
    DAYOFWEEK(order_date) as day_of_week,
    QUARTER(order_date) as quarter
FROM orders;

-- Date arithmetic
SELECT 
    order_date,
    order_date + INTERVAL '7 days' as week_later,
    order_date - INTERVAL '1 month' as month_ago
FROM orders;

-- Date difference
SELECT 
    order_date,
    DATEDIFF('day', order_date, CURRENT_DATE) as days_ago
FROM orders;

-- Date formatting
SELECT 
    order_date,
    STRFTIME(order_date, '%Y-%m-%d') as formatted_date,
    MONTHNAME(order_date) as month_name,
    DAYNAME(order_date) as day_name
FROM orders;

-- Date truncation
SELECT 
    DATE_TRUNC('month', order_date) as month,
    SUM(total) as monthly_revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date);
```

---

## String Functions

```sql
-- Concatenation
SELECT CONCAT(first_name, ' ', last_name) as full_name FROM employees;
SELECT first_name || ' ' || last_name as full_name FROM employees;

-- UPPER, LOWER
SELECT UPPER(name), LOWER(email) FROM employees;

-- TRIM
SELECT TRIM(name), LTRIM(name), RTRIM(name) FROM employees;

-- SUBSTRING
SELECT SUBSTRING(name, 1, 3) as first_3_chars FROM employees;

-- LENGTH
SELECT name, LENGTH(name) as name_length FROM employees;

-- REPLACE
SELECT REPLACE(email, '@old.com', '@new.com') FROM employees;

-- SPLIT_PART
SELECT SPLIT_PART(email, '@', 1) as username FROM employees;

-- POSITION
SELECT POSITION('@' IN email) as at_position FROM employees;

-- LEFT, RIGHT
SELECT LEFT(name, 5), RIGHT(name, 5) FROM employees;
```

---

## NULL Handling

```sql
-- IS NULL, IS NOT NULL
SELECT * FROM employees WHERE manager_id IS NULL;
SELECT * FROM employees WHERE email IS NOT NULL;

-- COALESCE (return first non-null)
SELECT name, COALESCE(phone, email, 'No contact') as contact FROM employees;

-- NULLIF (return NULL if equal)
SELECT NULLIF(column1, column2) FROM table;

-- IFNULL / NVL
SELECT name, IFNULL(bonus, 0) as bonus FROM employees;
```

---

## Set Operations (UNION)

```sql
-- UNION (removes duplicates)
SELECT name FROM employees_2023
UNION
SELECT name FROM employees_2024;

-- UNION ALL (keeps duplicates)
SELECT name FROM employees_2023
UNION ALL
SELECT name FROM employees_2024;

-- INTERSECT (common rows)
SELECT name FROM employees_2023
INTERSECT
SELECT name FROM employees_2024;

-- EXCEPT (in first but not second)
SELECT name FROM employees_2023
EXCEPT
SELECT name FROM employees_2024;
```

---

## Indexes & Performance

```sql
-- Create index
CREATE INDEX idx_employees_salary ON employees(salary);

-- Composite index
CREATE INDEX idx_employees_dept_salary ON employees(department, salary);

-- Unique index
CREATE UNIQUE INDEX idx_employees_email ON employees(email);

-- Drop index
DROP INDEX idx_employees_salary;

-- EXPLAIN (show query plan)
EXPLAIN SELECT * FROM employees WHERE salary > 70000;

-- EXPLAIN ANALYZE (show actual execution)
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 70000;
```

---

## Transactions

```sql
-- Basic transaction
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Transaction with rollback
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- Something went wrong
ROLLBACK;

-- Savepoints
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
SAVEPOINT sp1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
ROLLBACK TO sp1;  -- Undo second update only
COMMIT;
```

---

## Views

```sql
-- Create view
CREATE VIEW active_employees AS
SELECT id, name, email, department
FROM employees
WHERE is_active = TRUE;

-- Query view
SELECT * FROM active_employees;

-- Create or replace view
CREATE OR REPLACE VIEW active_employees AS
SELECT id, name, email, department, hire_date
FROM employees
WHERE is_active = TRUE;

-- Drop view
DROP VIEW active_employees;
DROP VIEW IF EXISTS active_employees;
```

---

## JSON Functions

```sql
-- Read JSON file
SELECT * FROM read_json_auto('data.json');

-- Extract JSON value (returns JSON)
SELECT data->'field' FROM table;

-- Extract JSON value (returns text)
SELECT data->>'field' FROM table;

-- Nested JSON
SELECT data->'user'->'profile'->>'name' FROM table;

-- JSON array length
SELECT json_array_length(data->'items') FROM table;

-- UNNEST JSON array
SELECT UNNEST(data->'items') FROM table;
```

---

## Query Optimization Tips

```sql
-- ✅ Use WHERE before GROUP BY
SELECT department, AVG(salary)
FROM employees
WHERE is_active = TRUE
GROUP BY department;

-- ✅ Select only needed columns
SELECT id, name FROM employees;  -- Not SELECT *

-- ✅ Use EXISTS instead of IN for large subqueries
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);

-- ✅ Use LIMIT for testing
SELECT * FROM large_table LIMIT 100;

-- ✅ Avoid functions on indexed columns
-- Bad: WHERE YEAR(order_date) = 2024
-- Good: WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'

-- ✅ Use UNION ALL instead of UNION when duplicates are OK
SELECT name FROM table1
UNION ALL
SELECT name FROM table2;
```

---

## Common Patterns

### Top N per Group
```sql
WITH ranked AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as rn
    FROM employees
)
SELECT * FROM ranked WHERE rn <= 3;
```

### Running Totals
```sql
SELECT 
    order_date,
    revenue,
    SUM(revenue) OVER (ORDER BY order_date) as running_total
FROM daily_sales;
```

### Year-over-Year Growth
```sql
WITH yearly AS (
    SELECT 
        YEAR(order_date) as year,
        SUM(total) as revenue
    FROM orders
    GROUP BY YEAR(order_date)
)
SELECT 
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) as prev_year,
    (revenue - LAG(revenue) OVER (ORDER BY year)) / LAG(revenue) OVER (ORDER BY year) * 100 as yoy_growth_pct
FROM yearly;
```

### Pivot Data
```sql
SELECT 
    product,
    SUM(CASE WHEN month = 'Jan' THEN sales END) as jan_sales,
    SUM(CASE WHEN month = 'Feb' THEN sales END) as feb_sales,
    SUM(CASE WHEN month = 'Mar' THEN sales END) as mar_sales
FROM monthly_sales
GROUP BY product;
```

---

## DuckDB-Specific Features

```sql
-- Read CSV
SELECT * FROM read_csv_auto('data.csv');

-- Read Parquet
SELECT * FROM read_parquet('data.parquet');

-- Read multiple files
SELECT * FROM read_csv_auto('data/*.csv');

-- Export to CSV
COPY (SELECT * FROM employees) TO 'output.csv' (HEADER, DELIMITER ',');

-- Export to Parquet
COPY (SELECT * FROM employees) TO 'output.parquet' (FORMAT PARQUET);

-- Create table from file
CREATE TABLE employees AS SELECT * FROM read_csv_auto('employees.csv');
```

---

## Quick Reference: Execution Order

```
1. FROM/JOIN     - Get tables
2. WHERE         - Filter rows
3. GROUP BY      - Group rows
4. HAVING        - Filter groups
5. SELECT        - Choose columns
6. DISTINCT      - Remove duplicates
7. ORDER BY      - Sort results
8. LIMIT/OFFSET  - Restrict rows
```

---

**💡 Pro Tips:**
- Always use `EXPLAIN` to understand query performance
- Index columns used in WHERE, JOIN, and ORDER BY
- Use CTEs for readability
- Test with LIMIT before running on full dataset
- Use transactions for multi-step operations
- Keep queries simple and readable

---

**📚 For more details, see the daily lessons in the `days/` folder!**
