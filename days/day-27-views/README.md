# Day 27: Views and Constraints

## Learning Objectives
- Understand views and materialized views
- Learn CREATE VIEW and view management
- Master database constraints
- Learn PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### Part 1: Views

#### What are Views?

A view is a virtual table based on a SQL query. It doesn't store data itself but provides a way to simplify complex queries and control data access.

**Basic View:**
```sql
-- Create a view
CREATE VIEW active_employees AS
SELECT id, name, email, department
FROM employees
WHERE is_active = TRUE;

-- Query the view like a table
SELECT * FROM active_employees;
```

#### CREATE VIEW

```sql
-- Simple view
CREATE VIEW high_earners AS
SELECT name, salary, department
FROM employees
WHERE salary > 100000;

-- View with joins
CREATE VIEW employee_details AS
SELECT 
    e.id,
    e.name,
    e.email,
    d.name as department_name,
    d.location
FROM employees e
JOIN departments d ON e.department_id = d.id;

-- View with aggregations
CREATE VIEW department_stats AS
SELECT 
    department_id,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department_id;
```

#### CREATE OR REPLACE VIEW

```sql
-- Update existing view or create new one
CREATE OR REPLACE VIEW active_employees AS
SELECT id, name, email, department, hire_date
FROM employees
WHERE is_active = TRUE AND hire_date >= '2020-01-01';
```

#### DROP VIEW

```sql
-- Remove a view
DROP VIEW active_employees;

-- Drop if exists
DROP VIEW IF EXISTS active_employees;
```

#### Benefits of Views

1. **Simplify Complex Queries:**
```sql
-- Instead of writing this every time:
SELECT e.name, d.name as dept, p.name as project
FROM employees e
JOIN departments d ON e.department_id = d.id
JOIN project_assignments pa ON e.id = pa.employee_id
JOIN projects p ON pa.project_id = p.id;

-- Create a view:
CREATE VIEW employee_projects AS
SELECT e.name, d.name as dept, p.name as project
FROM employees e
JOIN departments d ON e.department_id = d.id
JOIN project_assignments pa ON e.id = pa.employee_id
JOIN projects p ON pa.project_id = p.id;

-- Then simply:
SELECT * FROM employee_projects;
```

2. **Security/Access Control:**
```sql
-- Hide sensitive columns
CREATE VIEW public_employees AS
SELECT id, name, department, hire_date
FROM employees;
-- Salary and SSN are hidden
```

3. **Data Abstraction:**
```sql
-- Present data in different format
CREATE VIEW employee_summary AS
SELECT 
    id,
    CONCAT(first_name, ' ', last_name) as full_name,
    YEAR(CURRENT_DATE) - YEAR(hire_date) as years_employed
FROM employees;
```

### Part 2: Constraints

Constraints enforce rules on data to maintain integrity and validity.

#### PRIMARY KEY

Uniquely identifies each row in a table.

```sql
-- Single column primary key
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

-- Composite primary key
CREATE TABLE order_items (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    PRIMARY KEY (order_id, product_id)
);

-- Named constraint
CREATE TABLE employees (
    id INTEGER CONSTRAINT pk_employees PRIMARY KEY,
    name VARCHAR(100)
);
```

**Rules:**
- Must contain unique values
- Cannot contain NULL
- Only one PRIMARY KEY per table
- Automatically creates an index

#### FOREIGN KEY

Enforces referential integrity between tables.

```sql
-- Basic foreign key
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- Named foreign key
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    department_id INTEGER,
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) 
        REFERENCES departments(id)
);

-- With ON DELETE and ON UPDATE actions
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
```

**ON DELETE Options:**
- `CASCADE` - Delete child rows when parent is deleted
- `SET NULL` - Set foreign key to NULL when parent is deleted
- `RESTRICT` - Prevent deletion of parent if children exist (default)
- `NO ACTION` - Same as RESTRICT

**ON UPDATE Options:**
- `CASCADE` - Update foreign key when parent key changes
- `SET NULL` - Set foreign key to NULL when parent key changes
- `RESTRICT` - Prevent update of parent if children exist

**Example:**
```sql
-- Departments table
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

-- Employees table with foreign key
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id)
        ON DELETE SET NULL  -- If department deleted, set to NULL
        ON UPDATE CASCADE   -- If department ID changes, update here too
);
```

#### UNIQUE Constraint

Ensures all values in a column (or combination of columns) are unique.

```sql
-- Single column unique
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    name VARCHAR(100)
);

-- Multiple columns unique together
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    UNIQUE (first_name, last_name)
);

-- Named unique constraint
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    email VARCHAR(100),
    CONSTRAINT uq_email UNIQUE (email)
);
```

**Rules:**
- Allows NULL values (multiple NULLs allowed)
- Can have multiple UNIQUE constraints per table
- Automatically creates an index

#### NOT NULL Constraint

Ensures a column cannot contain NULL values.

```sql
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20)  -- Can be NULL
);

-- All columns required
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL
);
```

#### CHECK Constraint

Validates data based on a condition.

```sql
-- Simple check
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2) CHECK (salary > 0),
    age INTEGER CHECK (age >= 18 AND age <= 100)
);

-- Named check constraint
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    discount_price DECIMAL(10, 2),
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_discount CHECK (discount_price <= price)
);

-- Complex check
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    status VARCHAR(20),
    CHECK (ship_date >= order_date),
    CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled'))
);
```

#### DEFAULT Constraint

Provides a default value when none is specified.

```sql
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    hire_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'active',
    salary DECIMAL(10, 2) DEFAULT 50000.00
);

-- Insert without specifying defaults
INSERT INTO employees (id, name)
VALUES (1, 'John Doe');
-- hire_date, is_active, status, salary will use defaults
```

#### Complete Example with All Constraints

```sql
-- Departments table
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employees table with all constraint types
CREATE TABLE employees (
    -- Primary key
    id INTEGER PRIMARY KEY,
    
    -- NOT NULL constraints
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    
    -- UNIQUE constraint
    CONSTRAINT uq_email UNIQUE (email),
    
    -- CHECK constraints
    salary DECIMAL(10, 2) CHECK (salary >= 0),
    age INTEGER CHECK (age >= 18),
    
    -- DEFAULT constraints
    hire_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'active',
    
    -- Foreign key
    department_id INTEGER,
    CONSTRAINT fk_department FOREIGN KEY (department_id) 
        REFERENCES departments(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    -- Additional checks
    CHECK (status IN ('active', 'inactive', 'terminated'))
);
```

#### Adding Constraints to Existing Tables

```sql
-- Add PRIMARY KEY
ALTER TABLE employees
ADD PRIMARY KEY (id);

-- Add FOREIGN KEY
ALTER TABLE employees
ADD FOREIGN KEY (department_id) REFERENCES departments(id);

-- Add UNIQUE
ALTER TABLE employees
ADD UNIQUE (email);

-- Add CHECK
ALTER TABLE employees
ADD CHECK (salary > 0);

-- Add NOT NULL
ALTER TABLE employees
ALTER COLUMN name SET NOT NULL;

-- Add DEFAULT
ALTER TABLE employees
ALTER COLUMN is_active SET DEFAULT TRUE;
```

#### Dropping Constraints

```sql
-- Drop constraint by name
ALTER TABLE employees
DROP CONSTRAINT fk_emp_dept;

-- Drop primary key
ALTER TABLE employees
DROP PRIMARY KEY;

-- Drop NOT NULL
ALTER TABLE employees
ALTER COLUMN name DROP NOT NULL;
```

## 💻 Exercises (40 minutes)

### Part 1: Views

1. Create a view showing active employees only
2. Create a view with employee details including department name (JOIN)
3. Create a view with department statistics (aggregations)
4. Create a view that hides sensitive columns (salary, SSN)
5. Use CREATE OR REPLACE to update an existing view
6. Query views like regular tables
7. Drop a view using DROP VIEW IF EXISTS

### Part 2: PRIMARY KEY

1. Create a table with single column PRIMARY KEY
2. Create a table with composite PRIMARY KEY (two columns)
3. Create a table with named PRIMARY KEY constraint
4. Try to insert duplicate primary keys (observe error)
5. Try to insert NULL into primary key (observe error)

### Part 3: FOREIGN KEY

1. Create two tables with FOREIGN KEY relationship
2. Create FOREIGN KEY with ON DELETE CASCADE
3. Create FOREIGN KEY with ON DELETE SET NULL
4. Test foreign key by trying to insert invalid reference
5. Test ON DELETE CASCADE by deleting parent record
6. Create multiple foreign keys in one table

### Part 4: UNIQUE Constraint

1. Create table with UNIQUE constraint on email
2. Create UNIQUE constraint on multiple columns together
3. Try to insert duplicate values (observe error)
4. Insert multiple NULL values (should work)

### Part 5: NOT NULL Constraint

1. Create table with NOT NULL columns
2. Try to insert NULL into NOT NULL column (observe error)
3. Add NOT NULL to existing column
4. Remove NOT NULL from column

### Part 6: CHECK Constraint

1. Create table with CHECK constraint on salary (> 0)
2. Create CHECK constraint on age range (18-100)
3. Create CHECK constraint on status (must be in list)
4. Create CHECK comparing two columns (end_date >= start_date)
5. Try to insert invalid data (observe error)

### Part 7: DEFAULT Constraint

1. Create table with DEFAULT values
2. Insert row without specifying default columns
3. Verify defaults were applied
4. Override default by specifying value

### Part 8: Complete Schema

1. Create a complete database schema with:
   - Departments table (PRIMARY KEY, UNIQUE)
   - Employees table (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, DEFAULT)
   - Projects table (PRIMARY KEY, FOREIGN KEY, CHECK)
2. Test all constraints by trying to violate them
3. Insert valid data into all tables
4. Create views on top of the schema

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### Views Summary

**Benefits:**
- Simplify complex queries
- Provide security/access control
- Abstract data presentation
- Reusable query logic

**Commands:**
- `CREATE VIEW` - Create new view
- `CREATE OR REPLACE VIEW` - Update or create view
- `DROP VIEW` - Remove view

### Constraints Summary

| Constraint | Purpose | Rules |
|------------|---------|-------|
| PRIMARY KEY | Unique identifier | Unique, NOT NULL, one per table |
| FOREIGN KEY | Referential integrity | References another table's PK |
| UNIQUE | Unique values | Allows NULL, multiple per table |
| NOT NULL | Required values | Cannot be NULL |
| CHECK | Value validation | Custom condition |
| DEFAULT | Default value | Used when not specified |

### Foreign Key Actions

| Action | Effect |
|--------|--------|
| CASCADE | Propagate change to child rows |
| SET NULL | Set child foreign key to NULL |
| RESTRICT | Prevent change if children exist |
| NO ACTION | Same as RESTRICT (default) |

### Best Practices

**Views:**
- Use views to simplify frequently used complex queries
- Create views for security (hide sensitive columns)
- Name views clearly (e.g., `vw_active_employees`)
- Don't overuse views (can impact performance)
- Document view purpose and dependencies

**Constraints:**
- Always use PRIMARY KEY for tables
- Use FOREIGN KEY to maintain referential integrity
- Use NOT NULL for required fields
- Use CHECK for business rules
- Use UNIQUE for natural keys (email, username)
- Use DEFAULT for common values
- Name constraints for easier management

### Common Patterns

```sql
-- Pattern 1: Security view
CREATE VIEW public_employees AS
SELECT id, name, department, hire_date
FROM employees;
-- Hides salary, SSN, etc.

-- Pattern 2: Simplified reporting view
CREATE VIEW sales_summary AS
SELECT 
    DATE(order_date) as date,
    COUNT(*) as orders,
    SUM(total) as revenue
FROM orders
GROUP BY DATE(order_date);

-- Pattern 3: Complete table with constraints
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    department_id INTEGER,
    hire_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
```

### Common Mistakes

```sql
-- ❌ Wrong - No PRIMARY KEY
CREATE TABLE employees (
    id INTEGER,
    name VARCHAR(100)
);

-- ✅ Correct - With PRIMARY KEY
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

-- ❌ Wrong - Foreign key to non-existent table
CREATE TABLE employees (
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
-- Must create departments table first!

-- ✅ Correct - Create parent table first
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- ❌ Wrong - CHECK with wrong syntax
CHECK salary > 0  -- Missing parentheses

-- ✅ Correct
CHECK (salary > 0)
```

## Key Takeaways
- Views are virtual tables based on queries
- Use views to simplify complex queries and control access
- PRIMARY KEY uniquely identifies rows (required for most tables)
- FOREIGN KEY maintains relationships between tables
- UNIQUE ensures no duplicate values
- NOT NULL requires values (no NULLs allowed)
- CHECK validates data against conditions
- DEFAULT provides values when not specified
- Constraints enforce data integrity and business rules
- Always create parent tables before child tables with foreign keys

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 28
