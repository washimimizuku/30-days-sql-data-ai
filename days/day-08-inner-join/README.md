# Day 8: INNER JOIN

## Learning Objectives
- Understand INNER JOIN for combining tables
- Learn to join two tables on matching values
- Master the ON clause for join conditions
- Use table aliases for readability
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### What is INNER JOIN?

INNER JOIN combines rows from two tables based on a matching condition. It returns only rows where the join condition is TRUE in BOTH tables.

**Think of it as:** "Give me data where there's a match in both tables"

### Basic INNER JOIN Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2
  ON table1.column = table2.column;
```

### Simple INNER JOIN Example

```sql
-- Join employees with their departments
SELECT 
    employees.name,
    employees.salary,
    departments.department_name
FROM employees
INNER JOIN departments
  ON employees.department_id = departments.id;
```

**What happens:**
1. For each employee, find matching department (where department_id = id)
2. Combine employee and department data
3. Return only rows with matches in BOTH tables

**Result:**
```
name          | salary | department_name
--------------|--------|----------------
John Doe      | 75000  | Engineering
Jane Smith    | 80000  | Sales
Bob Johnson   | 70000  | Marketing
```

### Using Table Aliases

Table aliases make queries shorter and more readable:

```sql
-- With aliases (recommended)
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;
```

**Benefits:**
- Shorter to type
- Easier to read
- Required when joining table to itself

### Selecting Specific Columns

Choose which columns to display:

```sql
-- Select specific columns from both tables
SELECT 
    e.name as employee_name,
    e.salary,
    d.department_name,
    d.location
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;
```

### INNER JOIN with WHERE

Add filtering after joining:

```sql
-- Join and filter
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
WHERE e.salary > 70000;

-- Multiple conditions
SELECT 
    e.name,
    d.department_name,
    d.location
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
WHERE d.location = 'New York'
  AND e.is_active = TRUE;
```

### INNER JOIN Multiple Tables

Join more than two tables:

```sql
-- Join employees, departments, and locations
SELECT 
    e.name as employee_name,
    d.department_name,
    l.city,
    l.country
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
INNER JOIN locations l
  ON d.location_id = l.id;
```

**Execution:**
1. Join employees with departments
2. Join result with locations
3. Return combined data

### INNER JOIN with Aggregates

Combine joins with GROUP BY:

```sql
-- Count employees per department
SELECT 
    d.department_name,
    COUNT(e.id) as employee_count
FROM departments d
INNER JOIN employees e
  ON d.id = e.department_id
GROUP BY d.department_name;

-- Total sales per customer
SELECT 
    c.customer_name,
    SUM(o.total) as total_spent
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id
GROUP BY c.customer_name;
```

### INNER JOIN with ORDER BY

Sort joined results:

```sql
-- Employees with departments, sorted by salary
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
ORDER BY e.salary DESC;

-- Products with categories, sorted by price
SELECT 
    p.product_name,
    p.price,
    c.category_name
FROM products p
INNER JOIN categories c
  ON p.category_id = c.id
ORDER BY p.price DESC;
```

### Different JOIN Conditions

Join on different types of conditions:

```sql
-- Equality join (most common)
SELECT *
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.id;

-- Multiple column join
SELECT *
FROM order_items oi
INNER JOIN products p
  ON oi.product_id = p.id
  AND oi.warehouse_id = p.warehouse_id;

-- Join with calculation
SELECT *
FROM employees e1
INNER JOIN employees e2
  ON e1.manager_id = e2.id;
```

### Practical Examples

**Example 1: Order Details**
```sql
-- Get order details with customer information
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    c.email,
    o.total
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.id
ORDER BY o.order_date DESC;
```

**Example 2: Product Catalog**
```sql
-- Products with category and supplier information
SELECT 
    p.product_name,
    p.price,
    c.category_name,
    s.supplier_name
FROM products p
INNER JOIN categories c
  ON p.category_id = c.id
INNER JOIN suppliers s
  ON p.supplier_id = s.id
WHERE p.in_stock = TRUE;
```

**Example 3: Sales Report**
```sql
-- Sales report with product and customer details
SELECT 
    c.customer_name,
    p.product_name,
    oi.quantity,
    oi.price,
    oi.quantity * oi.price as line_total
FROM order_items oi
INNER JOIN orders o
  ON oi.order_id = o.id
INNER JOIN customers c
  ON o.customer_id = c.id
INNER JOIN products p
  ON oi.product_id = p.id
WHERE o.order_date >= '2024-01-01';
```

**Example 4: Department Summary**
```sql
-- Department statistics with location
SELECT 
    d.department_name,
    l.city,
    COUNT(e.id) as employee_count,
    AVG(e.salary) as avg_salary,
    SUM(e.salary) as total_payroll
FROM departments d
INNER JOIN locations l
  ON d.location_id = l.id
INNER JOIN employees e
  ON d.id = e.department_id
GROUP BY d.department_name, l.city
ORDER BY total_payroll DESC;
```

### Understanding INNER JOIN Behavior

**Only returns matches:**
```sql
-- If employee has no department (department_id is NULL)
-- or department doesn't exist, employee won't appear in results

SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;
-- Employees without departments are excluded
-- Departments without employees are excluded
```

**Visual representation:**
```
Employees:          Departments:
id | name | dept_id    id | name
1  | John | 1          1  | Engineering
2  | Jane | 2          2  | Sales
3  | Bob  | NULL       3  | Marketing

INNER JOIN result (only matches):
John - Engineering
Jane - Sales
(Bob excluded - no department)
(Marketing excluded - no employees)
```

## 💻 Exercises (40 minutes)

### Exercise 1: Basic INNER JOIN

Write queries to:
1. Join employees with departments, show name and department_name
2. Join products with categories, show product_name and category_name
3. Join orders with customers, show order_id and customer_name
4. Join books with authors, show book_title and author_name

### Exercise 2: Using Table Aliases

Write queries using aliases:
1. Join employees (e) with departments (d), select e.name, d.department_name
2. Join products (p) with suppliers (s), select p.product_name, s.supplier_name
3. Join orders (o) with customers (c), select o.order_id, c.customer_name, o.total
4. Join students (s) with courses (c), select s.student_name, c.course_name

### Exercise 3: Selecting Specific Columns

Write queries to:
1. Join employees with departments, show: employee name, salary, department name, location
2. Join products with categories, show: product name, price, category name, description
3. Join orders with customers, show: order date, customer name, email, total
4. Join movies with directors, show: movie title, release year, director name

### Exercise 4: INNER JOIN with WHERE

Write queries to:
1. Join employees with departments, only show Engineering department
2. Join products with categories, only show products with price > $100
3. Join orders with customers, only show orders from 2024
4. Join employees with departments, only show active employees in New York

### Exercise 5: Multiple Table JOINs

Write queries to:
1. Join employees → departments → locations (show name, dept, city)
2. Join orders → customers → addresses (show order_id, customer, city)
3. Join products → categories → suppliers (show product, category, supplier)
4. Join order_items → orders → customers (show item, order_date, customer)

### Exercise 6: INNER JOIN with Aggregates

Write queries to:
1. Count employees per department (join employees with departments)
2. Sum total sales per customer (join orders with customers)
3. Average price per category (join products with categories)
4. Count orders per product (join order_items with products)

### Exercise 7: INNER JOIN with ORDER BY

Write queries to:
1. Join employees with departments, order by salary DESC
2. Join products with categories, order by price ASC
3. Join orders with customers, order by order_date DESC
4. Join movies with directors, order by release_year DESC

### Exercise 8: Complex Queries

Write queries to:
1. Top 10 customers by total spending (join orders with customers, aggregate, order)
2. Products never ordered (hint: this needs LEFT JOIN - preview for Day 9!)
3. Department report: dept name, location, employee count, avg salary (multiple joins, group by)
4. Recent orders with full details: order date, customer name, product names, quantities (multiple joins)

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### INNER JOIN Summary

| Aspect | Description |
|--------|-------------|
| **Purpose** | Combine rows from two tables based on matching condition |
| **Returns** | Only rows with matches in BOTH tables |
| **Syntax** | FROM table1 INNER JOIN table2 ON condition |
| **Alias** | FROM table1 t1 INNER JOIN table2 t2 ON t1.col = t2.col |

### JOIN Syntax Variations

```sql
-- Explicit INNER JOIN (recommended)
SELECT *
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;

-- Implicit join (older style, avoid)
SELECT *
FROM employees e, departments d
WHERE e.department_id = d.id;

-- JOIN without INNER (same as INNER JOIN)
SELECT *
FROM employees e
JOIN departments d
  ON e.department_id = d.id;
```

### Common Patterns

```sql
-- Pattern 1: Basic two-table join
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;

-- Pattern 2: Join with filtering
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
WHERE e.salary > 70000;

-- Pattern 3: Join with aggregation
SELECT d.department_name, COUNT(e.id) as emp_count
FROM departments d
INNER JOIN employees e
  ON d.id = e.department_id
GROUP BY d.department_name;

-- Pattern 4: Multiple table joins
SELECT e.name, d.department_name, l.city
FROM employees e
INNER JOIN departments d ON e.department_id = d.id
INNER JOIN locations l ON d.location_id = l.id;

-- Pattern 5: Join with sorting
SELECT e.name, d.department_name, e.salary
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
ORDER BY e.salary DESC;
```

### Best Practices

1. **Use table aliases** - Makes queries shorter and clearer
2. **Use INNER JOIN explicitly** - More readable than implicit joins
3. **Put join conditions in ON** - Not in WHERE clause
4. **Index join columns** - Dramatically improves performance
5. **Select only needed columns** - Don't use SELECT *
6. **Use meaningful aliases** - e for employees, d for departments

### Common Mistakes

```sql
-- ❌ Wrong - Missing ON clause
SELECT *
FROM employees e
INNER JOIN departments d;

-- ✅ Correct - Include ON clause
SELECT *
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;

-- ❌ Wrong - Ambiguous column name
SELECT id, name, department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;
-- Error: 'id' exists in both tables

-- ✅ Correct - Qualify column names
SELECT e.id, e.name, d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;

-- ❌ Wrong - Join condition in WHERE (works but confusing)
SELECT *
FROM employees e, departments d
WHERE e.department_id = d.id;

-- ✅ Correct - Join condition in ON
SELECT *
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;
```

### Performance Tips

1. **Index foreign keys** - Join columns should be indexed
2. **Filter early** - Use WHERE to reduce rows before joining
3. **Join order matters** - Start with smallest table
4. **Avoid SELECT *** - Select only needed columns
5. **Use EXPLAIN** - Check query execution plan

```sql
-- ✅ Good - Filter before joining
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
WHERE e.is_active = TRUE;  -- Reduces rows early

-- ✅ Good - Select specific columns
SELECT e.name, e.salary, d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;
```

### When to Use INNER JOIN

Use INNER JOIN when you:
- Need data from multiple related tables
- Only want rows with matches in both tables
- Want to combine related information
- Need to filter based on related table data
- Are creating reports with related data

**Examples:**
- Orders with customer information
- Products with category details
- Employees with department names
- Students with enrolled courses

### INNER JOIN vs Other JOINs

**INNER JOIN:**
- Returns only matching rows
- Most common join type
- Use when you need data that exists in both tables

**LEFT JOIN (Day 9):**
- Returns all rows from left table
- Use when you need all records from one table

**RIGHT JOIN (Day 9):**
- Returns all rows from right table
- Less common than LEFT JOIN

## Key Takeaways
- INNER JOIN combines rows from two tables based on matching condition
- Returns only rows where match exists in BOTH tables
- Use ON clause to specify join condition
- Table aliases (e, d) make queries more readable
- Can join multiple tables by chaining INNER JOINs
- Combine with WHERE, GROUP BY, ORDER BY for complex queries
- Most common and important join type in SQL

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 9
