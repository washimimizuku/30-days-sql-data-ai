# Day 26: DDL Basics and Transactions

## Learning Objectives
- Master CREATE TABLE and DDL operations
- Learn ALTER TABLE, DROP TABLE
- Understand transactions and ACID properties
- Learn BEGIN, COMMIT, ROLLBACK
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### Part 1: DDL (Data Definition Language)

#### CREATE TABLE - Basic Syntax

```sql
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype
);
```

**Example:**
```sql
CREATE TABLE employees (
    id INTEGER,
    name VARCHAR(100),
    email VARCHAR(100),
    salary DECIMAL(10, 2),
    hire_date DATE,
    is_active BOOLEAN
);
```

#### CREATE TABLE with Constraints

```sql
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    department_id INTEGER,
    hire_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE
);
```

#### CREATE TABLE AS (CTAS)

Create table from query results:

```sql
-- Create table from SELECT
CREATE TABLE high_earners AS
SELECT *
FROM employees
WHERE salary > 100000;

-- Create summary table
CREATE TABLE dept_summary AS
SELECT 
    department_id,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department_id;

-- Create with specific columns
CREATE TABLE employee_names AS
SELECT id, name, email
FROM employees;
```

#### CREATE TABLE IF NOT EXISTS

Avoid errors if table already exists:

```sql
CREATE TABLE IF NOT EXISTS employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

-- Won't error if table exists
CREATE TABLE IF NOT EXISTS products (
    id INTEGER,
    name VARCHAR(200),
    price DECIMAL(10, 2)
);
```

#### DROP TABLE - Remove Tables

```sql
-- Drop table
DROP TABLE employees;

-- Drop if exists (no error if doesn't exist)
DROP TABLE IF EXISTS employees;

-- Drop multiple tables
DROP TABLE IF EXISTS employees, departments, orders;
```

#### TRUNCATE TABLE - Remove All Rows

```sql
-- Remove all rows but keep table structure (faster than DELETE)
TRUNCATE TABLE employees;

-- Keeps table definition, indexes, constraints
TRUNCATE TABLE logs;
```

#### ALTER TABLE - Modify Table Structure

**Add Column:**
```sql
-- Add single column
ALTER TABLE employees
ADD COLUMN phone VARCHAR(20);

-- Add column with default
ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50) DEFAULT '';

-- Add column with constraint
ALTER TABLE employees
ADD COLUMN age INTEGER CHECK (age >= 18);
```

**Drop Column:**
```sql
ALTER TABLE employees
DROP COLUMN middle_name;

-- Drop if exists
ALTER TABLE employees
DROP COLUMN IF EXISTS temp_column;
```

**Rename Column:**
```sql
ALTER TABLE employees
RENAME COLUMN name TO full_name;
```

**Rename Table:**
```sql
ALTER TABLE employees
RENAME TO staff;

-- Or
RENAME TABLE employees TO staff;
```

**Modify Column Type:**
```sql
ALTER TABLE employees
ALTER COLUMN salary TYPE DECIMAL(12, 2);

-- Change with USING for conversion
ALTER TABLE employees
ALTER COLUMN salary TYPE INTEGER USING CAST(salary AS INTEGER);
```

#### Practical DDL Examples

**Example 1: Create Complete Schema**
```sql
-- Departments table
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employees table with foreign key
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2) CHECK (salary >= 0),
    department_id INTEGER,
    hire_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Projects table
CREATE TABLE projects (
    id INTEGER PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12, 2),
    department_id INTEGER,
    CHECK (end_date >= start_date),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
```

**Example 2: Create Reporting Tables**
```sql
-- Daily sales summary
CREATE TABLE IF NOT EXISTS daily_sales_summary AS
SELECT 
    DATE(order_date) as sale_date,
    COUNT(*) as order_count,
    SUM(total) as total_sales,
    AVG(total) as avg_order_value
FROM orders
GROUP BY DATE(order_date);

-- Top customers
CREATE TABLE IF NOT EXISTS top_customers AS
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as lifetime_value
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 10
ORDER BY lifetime_value DESC;
```

**Example 3: Table Modifications**
```sql
-- Add new columns
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);
ALTER TABLE employees ADD COLUMN emergency_contact VARCHAR(100);

-- Rename for clarity
ALTER TABLE employees RENAME COLUMN name TO full_name;

-- Remove obsolete column
ALTER TABLE employees DROP COLUMN IF EXISTS old_field;
```

### Part 2: Transactions and ACID

#### What are Transactions?

A transaction is a sequence of SQL operations treated as a single unit of work. Either all operations succeed (COMMIT) or all fail (ROLLBACK).

**Basic Transaction:**
```sql
BEGIN;  -- or START TRANSACTION

-- Multiple operations
INSERT INTO accounts (id, balance) VALUES (1, 1000);
INSERT INTO accounts (id, balance) VALUES (2, 500);

COMMIT;  -- Save changes
```

**Transaction with Rollback:**
```sql
BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- Check if something went wrong
SELECT * FROM accounts WHERE id IN (1, 2);

-- If wrong, undo changes
ROLLBACK;

-- If correct, save changes
-- COMMIT;
```

#### ACID Properties

**A - Atomicity:**
All operations in a transaction succeed or all fail (no partial completion).

```sql
BEGIN;
-- Transfer money between accounts
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- Both updates happen or neither happens
COMMIT;
```

**C - Consistency:**
Database moves from one valid state to another (constraints are maintained).

```sql
BEGIN;
-- This will fail if it violates CHECK constraint
UPDATE employees SET salary = -1000 WHERE id = 1;
-- Transaction rolls back, database stays consistent
COMMIT;
```

**I - Isolation:**
Concurrent transactions don't interfere with each other.

```sql
-- Transaction 1
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 100;
-- Other transactions don't see this change until COMMIT
COMMIT;
```

**D - Durability:**
Once committed, changes are permanent (survive system failures).

```sql
BEGIN;
INSERT INTO orders (id, total) VALUES (1, 500);
COMMIT;
-- Even if system crashes, this order is saved
```

#### Practical Transaction Examples

**Example 1: Money Transfer**
```sql
BEGIN;

-- Deduct from sender
UPDATE accounts 
SET balance = balance - 100 
WHERE account_id = 'A123';

-- Add to receiver
UPDATE accounts 
SET balance = balance + 100 
WHERE account_id = 'B456';

-- Verify balances are correct
SELECT account_id, balance 
FROM accounts 
WHERE account_id IN ('A123', 'B456');

-- If all good, commit
COMMIT;
```

**Example 2: Order Processing**
```sql
BEGIN;

-- Create order
INSERT INTO orders (customer_id, total, status)
VALUES (100, 250.00, 'pending');

-- Get the order ID
-- (In practice, use RETURNING or LAST_INSERT_ID)

-- Add order items
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES 
    (1001, 50, 2, 100.00),
    (1001, 75, 1, 50.00);

-- Update inventory
UPDATE products SET stock = stock - 2 WHERE id = 50;
UPDATE products SET stock = stock - 1 WHERE id = 75;

COMMIT;
```

**Example 3: Data Migration**
```sql
BEGIN;

-- Copy data
INSERT INTO employees_new
SELECT * FROM employees_old;

-- Verify count matches
SELECT 
    (SELECT COUNT(*) FROM employees_old) as old_count,
    (SELECT COUNT(*) FROM employees_new) as new_count;

-- If counts match, commit
COMMIT;

-- Then drop old table
DROP TABLE IF EXISTS employees_old;
```

## 💻 Exercises (40 minutes)

### Part 1: CREATE TABLE

1. Create a `products` table with id, name, price, category, stock
2. Create a `customers` table with appropriate columns and constraints
3. Create an `orders` table with foreign keys to customers
4. Use CREATE TABLE AS to create a summary table from existing data
5. Create a table with CHECK constraints on price and quantity
6. Use CREATE TABLE IF NOT EXISTS for idempotent scripts

### Part 2: ALTER TABLE

1. Add a `phone` column to employees table
2. Add a `created_at` column with DEFAULT CURRENT_TIMESTAMP
3. Rename a column from `name` to `full_name`
4. Drop an obsolete column
5. Rename a table
6. Add multiple columns in sequence

### Part 3: DROP and TRUNCATE

1. Drop a test table using DROP TABLE IF EXISTS
2. Drop multiple tables in one statement
3. Use TRUNCATE to remove all rows from a table
4. Compare performance of TRUNCATE vs DELETE

### Part 4: Transactions

1. Create a transaction that inserts multiple related records
2. Practice ROLLBACK by intentionally making an error
3. Transfer money between accounts using a transaction
4. Create an order with order items in a transaction
5. Migrate data between tables using a transaction
6. Test transaction isolation by running concurrent transactions

### Part 5: ACID Properties

1. Demonstrate Atomicity (all-or-nothing)
2. Demonstrate Consistency (constraints maintained)
3. Test what happens when a constraint is violated in a transaction
4. Practice safe data modifications using transactions

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### DDL Operations Summary

| Operation | Purpose | Example |
|-----------|---------|---------|
| CREATE TABLE | Create new table | CREATE TABLE employees (...) |
| CREATE TABLE AS | Create from query | CREATE TABLE summary AS SELECT ... |
| ALTER TABLE | Modify table | ALTER TABLE employees ADD COLUMN ... |
| DROP TABLE | Remove table | DROP TABLE IF EXISTS employees |
| TRUNCATE | Remove all rows | TRUNCATE TABLE logs |

### Transaction Commands

| Command | Purpose |
|---------|---------|
| BEGIN | Start transaction |
| COMMIT | Save changes |
| ROLLBACK | Undo changes |

### ACID Properties

| Property | Meaning | Example |
|----------|---------|---------|
| **A**tomicity | All or nothing | Transfer succeeds completely or not at all |
| **C**onsistency | Valid state to valid state | Constraints always maintained |
| **I**solation | Transactions don't interfere | Concurrent updates don't conflict |
| **D**urability | Changes are permanent | Committed data survives crashes |

### Best Practices

**DDL:**
- Use IF NOT EXISTS / IF EXISTS for idempotent scripts
- Always backup before ALTER or DROP
- Test DDL changes on development database first
- Use CREATE TABLE AS for quick reporting tables
- Document table structures and relationships

**Transactions:**
- Use transactions for multi-step operations
- Keep transactions short (don't hold locks long)
- Always handle errors (ROLLBACK on failure)
- Test with SELECT before COMMIT
- Use transactions for data integrity (transfers, orders, etc.)

### Common Patterns

```sql
-- Pattern 1: Safe table creation
DROP TABLE IF EXISTS temp_table;
CREATE TABLE temp_table AS
SELECT * FROM source_table WHERE condition;

-- Pattern 2: Safe data modification
BEGIN;
UPDATE table SET column = value WHERE condition;
SELECT * FROM table WHERE condition;  -- Verify
COMMIT;  -- or ROLLBACK if wrong

-- Pattern 3: Table evolution
ALTER TABLE employees ADD COLUMN IF NOT EXISTS phone VARCHAR(20);
ALTER TABLE employees DROP COLUMN IF EXISTS old_column;

-- Pattern 4: Data migration
BEGIN;
CREATE TABLE new_table AS SELECT * FROM old_table;
-- Verify
DROP TABLE old_table;
ALTER TABLE new_table RENAME TO old_table;
COMMIT;
```

## Key Takeaways
- CREATE TABLE defines new tables with columns and constraints
- ALTER TABLE modifies existing table structure
- DROP TABLE removes tables, TRUNCATE removes all rows
- CREATE TABLE AS creates tables from query results
- Transactions group multiple operations into atomic units
- ACID properties ensure data integrity and reliability
- Use BEGIN...COMMIT for multi-step operations
- Use ROLLBACK to undo changes if something goes wrong
- Always test DDL changes before applying to production

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 27
