# Day 22: NULL Handling and Data Manipulation

## Learning Objectives
- Understand NULL handling and COALESCE
- Learn IS NULL, IS NOT NULL, COALESCE, NULLIF
- Master INSERT, UPDATE, DELETE operations
- Practice data manipulation with real queries
- Build practical SQL skills

## Theory (15 minutes)

### Part 1: NULL Handling

#### What is NULL?

NULL represents missing or unknown data. It's NOT the same as zero, empty string, or false.

```sql
-- NULL is not equal to anything, even itself
SELECT NULL = NULL;  -- Returns NULL (not TRUE!)

-- Must use IS NULL
SELECT * FROM employees WHERE email IS NULL;
SELECT * FROM employees WHERE email IS NOT NULL;
```

#### IS NULL and IS NOT NULL

```sql
-- Find employees with no email
SELECT name
FROM employees
WHERE email IS NULL;

-- Find employees with email
SELECT name
FROM employees
WHERE email IS NOT NULL;

-- Find employees with no phone OR no email
SELECT name
FROM employees
WHERE phone IS NULL OR email IS NULL;
```

#### COALESCE - Return First Non-NULL Value

```sql
-- Return first non-NULL value
SELECT 
    name,
    COALESCE(phone, email, 'No contact') as contact
FROM employees;

-- Provide default for NULL salary
SELECT 
    name,
    COALESCE(salary, 0) as salary
FROM employees;

-- Chain multiple columns
SELECT 
    COALESCE(preferred_name, first_name, 'Unknown') as display_name
FROM employees;
```

#### NULLIF - Return NULL if Values Match

```sql
-- Return NULL if values are equal, otherwise return first value
SELECT NULLIF(10, 10);  -- Returns NULL
SELECT NULLIF(10, 20);  -- Returns 10

-- Avoid division by zero
SELECT 
    total_sales / NULLIF(order_count, 0) as avg_order_value
FROM sales_summary;

-- Replace empty strings with NULL
SELECT 
    name,
    NULLIF(email, '') as email
FROM employees;
```

#### NULL in Calculations

```sql
-- NULL in arithmetic returns NULL
SELECT 10 + NULL;  -- Returns NULL
SELECT salary * 1.1 FROM employees WHERE salary IS NULL;  -- Returns NULL

-- Use COALESCE to handle NULLs in calculations
SELECT 
    name,
    (salary + COALESCE(bonus, 0)) as total_compensation
FROM employees;
```

#### NULL in Aggregates

```sql
-- Aggregates ignore NULL (except COUNT(*))
SELECT 
    COUNT(*) as total_rows,           -- Counts all rows
    COUNT(email) as rows_with_email,  -- Counts non-NULL emails
    AVG(salary) as avg_salary         -- Ignores NULL salaries
FROM employees;
```

### Part 2: Data Manipulation (DML)

#### INSERT - Adding Data

**Insert Single Row:**
```sql
-- Specify columns (recommended)
INSERT INTO employees (id, name, email, salary, hire_date)
VALUES (1, 'John Doe', 'john@example.com', 75000, '2024-01-15');

-- All columns (must match table order)
INSERT INTO employees
VALUES (2, 'Jane Smith', 'jane@example.com', 80000, '2024-01-20', TRUE);
```

**Insert Multiple Rows:**
```sql
INSERT INTO employees (id, name, email, salary, hire_date)
VALUES 
    (3, 'Bob Johnson', 'bob@example.com', 70000, '2024-02-01'),
    (4, 'Alice Williams', 'alice@example.com', 85000, '2024-02-15'),
    (5, 'Charlie Brown', 'charlie@example.com', 72000, '2024-03-01');
```

**Insert from SELECT:**
```sql
-- Copy data from another table
INSERT INTO employees_backup
SELECT * FROM employees;

-- Insert specific data
INSERT INTO high_earners (id, name, salary)
SELECT id, name, salary
FROM employees
WHERE salary > 100000;

-- Insert with transformation
INSERT INTO employee_summary (dept_id, emp_count, avg_salary)
SELECT 
    department_id,
    COUNT(*) as emp_count,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department_id;
```

**Insert with DEFAULT Values:**
```sql
-- Use DEFAULT keyword
INSERT INTO employees (id, name, email, hire_date)
VALUES (6, 'David Lee', 'david@example.com', DEFAULT);

-- Omit columns with defaults
INSERT INTO employees (id, name, email)
VALUES (7, 'Emma Wilson', 'emma@example.com');
-- hire_date and is_active will use DEFAULT values
```

#### UPDATE - Modifying Data

**Update Single Column:**
```sql
-- Update one employee
UPDATE employees
SET salary = 80000
WHERE id = 1;

-- Update based on condition
UPDATE employees
SET is_active = FALSE
WHERE hire_date < '2020-01-01';
```

**Update Multiple Columns:**
```sql
UPDATE employees
SET 
    salary = 85000,
    email = 'newemail@example.com',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 2;
```

**Update with Calculations:**
```sql
-- Give 10% raise to all employees
UPDATE employees
SET salary = salary * 1.10;

-- Give 15% raise to Engineering department
UPDATE employees
SET salary = salary * 1.15
WHERE department_id = (
    SELECT id FROM departments WHERE name = 'Engineering'
);

-- Increment counter
UPDATE products
SET view_count = view_count + 1
WHERE id = 100;
```

**Update with CASE:**
```sql
-- Different raises by department
UPDATE employees
SET salary = salary * 
    CASE department
        WHEN 'Engineering' THEN 1.15
        WHEN 'Sales' THEN 1.12
        WHEN 'Marketing' THEN 1.10
        ELSE 1.05
    END;
```

**Update from Another Table (if supported):**
```sql
-- Update based on join
UPDATE employees e
SET salary = s.new_salary
FROM salary_adjustments s
WHERE e.id = s.employee_id;
```

#### DELETE - Removing Data

**Delete Specific Rows:**
```sql
-- Delete one employee
DELETE FROM employees
WHERE id = 1;

-- Delete multiple employees
DELETE FROM employees
WHERE department_id = 5;

-- Delete with condition
DELETE FROM employees
WHERE hire_date < '2020-01-01' AND is_active = FALSE;
```

**Delete with Subquery:**
```sql
-- Delete employees in closed departments
DELETE FROM employees
WHERE department_id IN (
    SELECT id FROM departments WHERE status = 'closed'
);

-- Delete old records
DELETE FROM logs
WHERE log_date < (SELECT DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY));
```

**Delete All Rows:**
```sql
-- Deletes ALL rows (be careful!)
DELETE FROM employees;

-- Better: Use TRUNCATE for deleting all rows (faster)
TRUNCATE TABLE employees;
```

#### Transaction Safety

Always use transactions for important operations:

```sql
-- Start transaction
BEGIN;

-- Make changes
UPDATE employees SET salary = salary * 1.10 WHERE department_id = 1;
DELETE FROM employees WHERE is_active = FALSE;

-- Check results
SELECT * FROM employees WHERE department_id = 1;

-- If good, commit
COMMIT;

-- If bad, rollback
-- ROLLBACK;
```

#### Practical DML Examples

**Example 1: Data Migration**
```sql
-- Copy active employees to new table
INSERT INTO employees_2024
SELECT * FROM employees
WHERE hire_date >= '2024-01-01' AND is_active = TRUE;
```

**Example 2: Bulk Update**
```sql
-- Fix email domain
UPDATE employees
SET email = REPLACE(email, '@oldcompany.com', '@newcompany.com')
WHERE email LIKE '%@oldcompany.com';
```

**Example 3: Archive and Delete**
```sql
BEGIN;

-- Archive old records
INSERT INTO employees_archive
SELECT * FROM employees
WHERE hire_date < '2020-01-01';

-- Delete archived records
DELETE FROM employees
WHERE hire_date < '2020-01-01';

COMMIT;
```

## 💻 Exercises (40 minutes)

### Part 1: NULL Handling

1. Find all employees with NULL email addresses
2. Find all products with NULL descriptions
3. Use COALESCE to provide default values for NULL phone numbers
4. Use NULLIF to avoid division by zero in calculations
5. Count total rows vs rows with non-NULL emails
6. Calculate average salary handling NULL values correctly

### Part 2: INSERT Operations

1. Insert a single new employee with all fields
2. Insert 3 employees in one statement
3. Insert employees from a SELECT query (salary > 80000)
4. Insert with DEFAULT values for some columns
5. Create a summary table using INSERT...SELECT with aggregations

### Part 3: UPDATE Operations

1. Update salary for a specific employee
2. Give 10% raise to all employees in 'Engineering' department
3. Update multiple columns for employees hired after 2023
4. Use CASE to give different raises by department
5. Update email addresses to lowercase
6. Increment a counter field

### Part 4: DELETE Operations

1. Delete a specific employee by ID
2. Delete all employees from a specific department
3. Delete employees hired before 2020 who are inactive
4. Delete using a subquery (employees in closed departments)
5. Practice DELETE in a transaction with ROLLBACK

### Part 5: Combined Operations

1. Insert test data, update it, then delete it (in a transaction)
2. Archive old records (INSERT into archive, then DELETE from main table)
3. Migrate data between tables with transformations
4. Clean up data (UPDATE to fix issues, DELETE invalid records)

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### NULL Handling
- NULL represents missing/unknown data
- Use IS NULL / IS NOT NULL (never = NULL)
- COALESCE returns first non-NULL value
- NULLIF returns NULL if values match
- Aggregates ignore NULL (except COUNT(*))

### DML Operations Summary

| Operation | Purpose | Syntax |
|-----------|---------|--------|
| INSERT | Add new rows | INSERT INTO table VALUES (...) |
| UPDATE | Modify existing rows | UPDATE table SET col=val WHERE ... |
| DELETE | Remove rows | DELETE FROM table WHERE ... |

### Best Practices

**INSERT:**
- Always specify column names
- Use multiple VALUES for bulk inserts
- Use INSERT...SELECT for copying data
- Validate data before inserting

**UPDATE:**
- Always use WHERE clause (unless updating all rows intentionally)
- Test with SELECT first
- Use transactions for important updates
- Be careful with calculations (check for NULL)

**DELETE:**
- Always use WHERE clause (unless deleting all rows intentionally)
- Test with SELECT first
- Use transactions for important deletes
- Consider archiving before deleting

**Transactions:**
- Use BEGIN...COMMIT for multi-step operations
- Use ROLLBACK if something goes wrong
- Test in transaction before committing

### Common Mistakes

```sql
-- ❌ Wrong - No WHERE clause (updates ALL rows!)
UPDATE employees SET salary = 100000;

-- ✅ Correct - With WHERE clause
UPDATE employees SET salary = 100000 WHERE id = 1;

-- ❌ Wrong - Using = NULL
WHERE email = NULL

-- ✅ Correct - Using IS NULL
WHERE email IS NULL

-- ❌ Wrong - Forgetting transaction
DELETE FROM important_table WHERE condition;

-- ✅ Correct - Using transaction
BEGIN;
DELETE FROM important_table WHERE condition;
-- Check results
SELECT * FROM important_table;
COMMIT;  -- or ROLLBACK if wrong
```

## Key Takeaways
- NULL is not equal to anything, use IS NULL / IS NOT NULL
- COALESCE provides default values for NULL
- INSERT adds new data (single, multiple, or from SELECT)
- UPDATE modifies existing data (always use WHERE!)
- DELETE removes data (always use WHERE!)
- Use transactions for important data changes
- Always test with SELECT before UPDATE/DELETE

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 23
