# Day 27: Views

## Learning Objectives
- Understand what views are and why they're useful
- Master CREATE VIEW and DROP VIEW
- Learn to simplify complex queries with views
- Use views for security and data abstraction
- Practice querying views

## Theory (15 minutes)

### What are Views?

A view is a virtual table based on a SQL query. It doesn't store data itself but provides a saved query you can reuse like a table.

**Think of it as:** A saved SELECT query with a name.

```sql
-- Instead of writing this complex query every time:
SELECT e.name, e.email, d.name as department
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE e.is_active = TRUE;

-- Create a view once:
CREATE VIEW active_employees AS
SELECT e.name, e.email, d.name as department
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE e.is_active = TRUE;

-- Then query it simply:
SELECT * FROM active_employees;
```

### Creating Views

**Basic syntax:**
```sql
CREATE VIEW view_name AS
SELECT columns
FROM tables
WHERE conditions;
```

**Simple view:**
```sql
CREATE VIEW high_earners AS
SELECT name, salary, department
FROM employees
WHERE salary > 100000;

-- Query it:
SELECT * FROM high_earners;
```

**View with JOIN:**
```sql
CREATE VIEW employee_details AS
SELECT 
    e.id,
    e.name,
    e.email,
    d.name as department_name,
    d.location
FROM employees e
JOIN departments d ON e.department_id = d.id;

-- Query it:
SELECT * FROM employee_details WHERE location = 'Seattle';
```

**View with aggregations:**
```sql
CREATE VIEW department_stats AS
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department;

-- Query it:
SELECT * FROM department_stats ORDER BY avg_salary DESC;
```

### CREATE OR REPLACE VIEW

Update an existing view or create a new one:

```sql
-- First version
CREATE VIEW active_employees AS
SELECT id, name, email
FROM employees
WHERE is_active = TRUE;

-- Update it later
CREATE OR REPLACE VIEW active_employees AS
SELECT id, name, email, department, hire_date
FROM employees
WHERE is_active = TRUE AND hire_date >= '2020-01-01';
```

### Dropping Views

```sql
-- Drop a view
DROP VIEW active_employees;

-- Drop if exists (no error if doesn't exist)
DROP VIEW IF EXISTS active_employees;
```

### Why Use Views?

**1. Simplify Complex Queries**

```sql
-- Complex query with multiple JOINs:
SELECT 
    o.id,
    c.name as customer,
    p.name as product,
    oi.quantity,
    oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;

-- Create view:
CREATE VIEW order_details AS
SELECT 
    o.id,
    c.name as customer,
    p.name as product,
    oi.quantity,
    oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id;

-- Now simply:
SELECT * FROM order_details WHERE customer = 'Alice';
```

**2. Security and Access Control**

Hide sensitive columns:

```sql
-- Full table has sensitive data
CREATE TABLE employees (
    id INTEGER,
    name VARCHAR,
    email VARCHAR,
    salary DECIMAL,
    ssn VARCHAR  -- Sensitive!
);

-- Create public view without sensitive columns
CREATE VIEW public_employees AS
SELECT id, name, email
FROM employees;

-- Users can query public_employees but not see salary/SSN
```

**3. Data Abstraction**

Present data in different formats:

```sql
CREATE VIEW employee_summary AS
SELECT 
    id,
    name || ' (' || email || ')' as contact_info,
    YEAR(CURRENT_DATE) - YEAR(hire_date) as years_employed,
    CASE 
        WHEN salary > 100000 THEN 'High'
        WHEN salary > 60000 THEN 'Medium'
        ELSE 'Entry'
    END as salary_band
FROM employees;
```

**4. Reusable Logic**

```sql
-- Create view for frequently used calculation
CREATE VIEW monthly_sales AS
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(*) as order_count,
    SUM(total) as revenue,
    AVG(total) as avg_order_value
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

-- Use in multiple queries:
SELECT * FROM monthly_sales WHERE month >= '2024-01-01';
SELECT * FROM monthly_sales ORDER BY revenue DESC LIMIT 12;
```

### Practical Examples

**Example 1: Dashboard View**
```sql
CREATE VIEW sales_dashboard AS
SELECT 
    DATE(order_date) as date,
    COUNT(*) as orders,
    SUM(total) as revenue,
    AVG(total) as avg_order,
    COUNT(DISTINCT customer_id) as unique_customers
FROM orders
GROUP BY DATE(order_date);

-- Query for last 7 days:
SELECT * FROM sales_dashboard 
WHERE date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY date;
```

**Example 2: Customer Segmentation**
```sql
CREATE VIEW customer_segments AS
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as lifetime_value,
    CASE 
        WHEN SUM(total) > 10000 THEN 'VIP'
        WHEN SUM(total) > 5000 THEN 'Premium'
        WHEN SUM(total) > 1000 THEN 'Regular'
        ELSE 'New'
    END as segment
FROM orders
GROUP BY customer_id;

-- Find VIP customers:
SELECT * FROM customer_segments WHERE segment = 'VIP';
```

**Example 3: Product Performance**
```sql
CREATE VIEW product_performance AS
SELECT 
    p.id,
    p.product_name,
    p.category,
    COUNT(oi.id) as times_ordered,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.quantity * oi.price) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.product_name, p.category;

-- Top products by revenue:
SELECT * FROM product_performance 
ORDER BY total_revenue DESC 
LIMIT 10;
```

### Querying Views

Views can be queried just like tables:

```sql
-- Create view
CREATE VIEW active_employees AS
SELECT id, name, email, department
FROM employees
WHERE is_active = TRUE;

-- Query like a table
SELECT * FROM active_employees;
SELECT * FROM active_employees WHERE department = 'Sales';
SELECT department, COUNT(*) FROM active_employees GROUP BY department;

-- Join with other tables/views
SELECT ae.name, o.order_date, o.total
FROM active_employees ae
JOIN orders o ON ae.id = o.employee_id;
```

### View Limitations

**Views are read-only in most cases:**
```sql
-- This usually won't work:
UPDATE active_employees SET salary = 50000 WHERE id = 1;

-- Instead, update the underlying table:
UPDATE employees SET salary = 50000 WHERE id = 1;
```

**Views don't store data:**
- Every query on a view runs the underlying SELECT
- Complex views can be slow
- Consider materialized views for better performance (not covered today)

### Best Practices

1. **Name views clearly** - Use prefixes like `vw_` or descriptive names
2. **Document purpose** - Comment what the view is for
3. **Keep views simple** - Complex views can be slow
4. **Use for common queries** - Don't create views for one-time queries
5. **Security** - Use views to hide sensitive columns
6. **Test performance** - Complex views can impact query speed

## Exercises (40 minutes)

### Setup
```bash
python setup.py
```

Creates `day27.db` with:
- **employees** (15 rows): id, name, email, department, salary, is_active, hire_date
- **departments** (5 rows): id, name, location
- **orders** (30 rows): id, customer_id, order_date, total, status
- **customers** (10 rows): id, name, email, city
- **products** (20 rows): id, product_name, category, price
- **order_items** (60 rows): id, order_id, product_id, quantity, price

### Instructions

Complete 20 exercises in `exercise.sql`:

**Part 1: Basic Views (1-5)** - Simple CREATE VIEW  
**Part 2: Views with JOINs (6-10)** - Multi-table views  
**Part 3: Aggregate Views (11-15)** - Views with GROUP BY  
**Part 4: Practical Views (16-20)** - Real-world scenarios

Check `solution.sql` for complete solutions.

## Key Takeaways

- Views are virtual tables based on SELECT queries
- Use CREATE VIEW to save complex queries
- Query views just like regular tables
- Views simplify complex queries and improve reusability
- Use views for security (hide sensitive columns)
- Use CREATE OR REPLACE VIEW to update views
- Use DROP VIEW to remove views
- Views don't store data - they run the query each time
- Name views clearly and document their purpose
- Test view performance with complex queries

## Resources
- [DuckDB Views Documentation](https://duckdb.org/docs/sql/statements/create_view)
- [SQL Views Tutorial](https://www.sqltutorial.org/sql-views/)

## Next Steps
- Complete the exercises
- Check your solutions
- Take the quiz in `quiz.md`
- Move to Day 28: Data Modeling
