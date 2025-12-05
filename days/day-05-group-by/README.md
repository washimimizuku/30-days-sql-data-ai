# Day 5: GROUP BY Basics

## Learning Objectives
- Understand GROUP BY for grouping rows
- Learn to combine GROUP BY with aggregate functions
- Master grouping by single and multiple columns
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### What is GROUP BY?

GROUP BY groups rows that have the same values in specified columns into summary rows. It's almost always used with aggregate functions (COUNT, SUM, AVG, MIN, MAX).

**Think of it as:** "For each unique value in this column, calculate something"

### Basic GROUP BY Syntax

```sql
SELECT column, aggregate_function(column)
FROM table
GROUP BY column;
```

### GROUP BY with COUNT

Count how many rows in each group:

```sql
-- Count employees in each department
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;
```

**Result:**
```
department    | employee_count
--------------|---------------
Engineering   | 15
Sales         | 10
Marketing     | 8
```

**More examples:**
```sql
-- Count orders per customer
SELECT customer_id, COUNT(*) as order_count
FROM orders
GROUP BY customer_id;

-- Count products in each category
SELECT category, COUNT(*) as product_count
FROM products
GROUP BY category;
```

### GROUP BY with SUM

Sum values for each group:

```sql
-- Total salary per department
SELECT department, SUM(salary) as total_payroll
FROM employees
GROUP BY department;

-- Total sales per product
SELECT product_id, SUM(quantity) as total_sold
FROM order_items
GROUP BY product_id;

-- Revenue per customer
SELECT customer_id, SUM(total) as total_spent
FROM orders
GROUP BY customer_id;
```

### GROUP BY with AVG

Calculate average for each group:

```sql
-- Average salary per department
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department;

-- Average order value per customer
SELECT customer_id, AVG(total) as avg_order_value
FROM orders
GROUP BY customer_id;

-- Average price per category
SELECT category, AVG(price) as avg_price
FROM products
GROUP BY category;
```

### GROUP BY with MIN and MAX

Find minimum and maximum in each group:

```sql
-- Salary range per department
SELECT 
    department,
    MIN(salary) as lowest_salary,
    MAX(salary) as highest_salary
FROM employees
GROUP BY department;

-- Price range per category
SELECT 
    category,
    MIN(price) as cheapest,
    MAX(price) as most_expensive
FROM products
GROUP BY category;
```

### Multiple Aggregates in One Query

Combine multiple aggregate functions:

```sql
-- Department statistics
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    SUM(salary) as total_payroll
FROM employees
GROUP BY department;
```

### GROUP BY Multiple Columns

Group by more than one column:

```sql
-- Count employees by department AND city
SELECT 
    department,
    city,
    COUNT(*) as employee_count
FROM employees
GROUP BY department, city;
```

**Result:**
```
department    | city      | employee_count
--------------|-----------|---------------
Engineering   | New York  | 8
Engineering   | London    | 7
Sales         | New York  | 5
Sales         | London    | 5
```

**More examples:**
```sql
-- Sales by product and month
SELECT 
    product_id,
    EXTRACT(MONTH FROM order_date) as month,
    SUM(quantity) as total_sold
FROM order_items
GROUP BY product_id, EXTRACT(MONTH FROM order_date);

-- Average order value by customer and year
SELECT 
    customer_id,
    EXTRACT(YEAR FROM order_date) as year,
    AVG(total) as avg_order_value
FROM orders
GROUP BY customer_id, EXTRACT(YEAR FROM order_date);
```

### GROUP BY with WHERE

Filter BEFORE grouping with WHERE:

```sql
-- Average salary per department (only active employees)
SELECT department, AVG(salary) as avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department;

-- Total sales per product (only 2024 orders)
SELECT 
    product_id,
    SUM(quantity) as total_sold
FROM order_items
WHERE order_date >= '2024-01-01'
GROUP BY product_id;
```

**Execution order:**
1. WHERE filters rows
2. GROUP BY groups remaining rows
3. Aggregate functions calculate

### Important Rules

**Rule 1:** Every column in SELECT must be either:
- In the GROUP BY clause, OR
- Inside an aggregate function

```sql
-- ❌ Wrong - name is not in GROUP BY or aggregate
SELECT department, name, COUNT(*)
FROM employees
GROUP BY department;

-- ✅ Correct - only grouped column and aggregate
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- ✅ Correct - both columns in GROUP BY
SELECT department, city, COUNT(*) as employee_count
FROM employees
GROUP BY department, city;
```

**Rule 2:** GROUP BY comes after WHERE but before ORDER BY

```sql
SELECT department, AVG(salary) as avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department
ORDER BY avg_salary DESC;
```

### Practical Examples

**Example 1: Sales Report**
```sql
-- Total revenue and order count per customer
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_revenue,
    AVG(total) as avg_order_value
FROM orders
GROUP BY customer_id
ORDER BY total_revenue DESC;
```

**Example 2: Inventory Summary**
```sql
-- Product count and total value per category
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(price * quantity) as total_value
FROM products
GROUP BY category;
```

**Example 3: Employee Demographics**
```sql
-- Employee distribution by department and city
SELECT 
    department,
    city,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department, city
ORDER BY department, city;
```

## 💻 Exercises (40 minutes)

### Exercise 1: GROUP BY with COUNT

Write queries to:
1. Count employees in each department
2. Count products in each category
3. Count orders per customer
4. Count employees in each city

### Exercise 2: GROUP BY with SUM

Write queries to:
1. Calculate total payroll per department
2. Calculate total sales per product
3. Calculate total revenue per customer
4. Calculate total quantity sold per category

### Exercise 3: GROUP BY with AVG

Write queries to:
1. Calculate average salary per department
2. Calculate average price per category
3. Calculate average order value per customer
4. Calculate average age per department

### Exercise 4: GROUP BY with MIN and MAX

Write queries to:
1. Find lowest and highest salary in each department
2. Find cheapest and most expensive product in each category
3. Find earliest and latest hire date per department
4. Find smallest and largest order per customer

### Exercise 5: Multiple Aggregates

Write queries combining multiple aggregates:
1. For each department: count, avg salary, min salary, max salary
2. For each category: count products, avg price, total value
3. For each customer: count orders, total spent, avg order value
4. For each city: count employees, avg salary, total payroll

### Exercise 6: GROUP BY Multiple Columns

Write queries to:
1. Count employees by department AND city
2. Sum sales by product AND month
3. Average salary by department AND job_title
4. Count orders by customer AND year

### Exercise 7: GROUP BY with WHERE

Write queries to:
1. Average salary per department (only active employees)
2. Total sales per product (only 2024 orders)
3. Count employees per city (only hired after 2020)
4. Sum revenue per customer (only orders > $100)

### Exercise 8: Real-World Scenarios

Write queries to:
1. Department report: count, avg salary, total payroll, ordered by total payroll DESC
2. Product performance: category, count, total sold, avg price
3. Customer analysis: customer_id, order count, total spent, avg order value
4. Monthly sales: month, total orders, total revenue, avg order value

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### GROUP BY Summary

| Concept | Purpose | Example |
|---------|---------|---------|
| GROUP BY | Group rows by column values | GROUP BY department |
| With COUNT | Count rows in each group | COUNT(*) |
| With SUM | Sum values in each group | SUM(salary) |
| With AVG | Average values in each group | AVG(price) |
| With MIN/MAX | Find min/max in each group | MIN(salary), MAX(salary) |
| Multiple columns | Group by multiple criteria | GROUP BY dept, city |

### SQL Execution Order

```sql
SELECT department, AVG(salary)  -- 4. Select and calculate
FROM employees                   -- 1. Get data from table
WHERE is_active = TRUE          -- 2. Filter rows
GROUP BY department             -- 3. Group rows
ORDER BY AVG(salary) DESC;      -- 5. Sort results
```

### Important Rules

1. **Every non-aggregated column in SELECT must be in GROUP BY**
   ```sql
   -- ❌ Wrong
   SELECT department, name, COUNT(*)
   FROM employees
   GROUP BY department;
   
   -- ✅ Correct
   SELECT department, COUNT(*)
   FROM employees
   GROUP BY department;
   ```

2. **GROUP BY comes after WHERE, before ORDER BY**
   ```sql
   SELECT ... FROM ... WHERE ... GROUP BY ... ORDER BY ...
   ```

3. **Can't use column aliases in GROUP BY (in most databases)**
   ```sql
   -- ❌ Wrong (in most databases)
   SELECT department as dept, COUNT(*)
   FROM employees
   GROUP BY dept;
   
   -- ✅ Correct
   SELECT department as dept, COUNT(*)
   FROM employees
   GROUP BY department;
   ```

### Common Patterns

```sql
-- Pattern 1: Count per group
SELECT category, COUNT(*) as count
FROM products
GROUP BY category;

-- Pattern 2: Sum per group
SELECT department, SUM(salary) as total
FROM employees
GROUP BY department;

-- Pattern 3: Multiple aggregates
SELECT 
    department,
    COUNT(*) as count,
    AVG(salary) as avg_sal,
    SUM(salary) as total
FROM employees
GROUP BY department;

-- Pattern 4: Multiple grouping columns
SELECT department, city, COUNT(*) as count
FROM employees
GROUP BY department, city;

-- Pattern 5: With filtering and sorting
SELECT department, AVG(salary) as avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department
ORDER BY avg_salary DESC;
```

### Best Practices

1. **Use meaningful aliases** - Make results readable
2. **Order results** - Add ORDER BY for consistent output
3. **Filter before grouping** - Use WHERE to reduce data
4. **Use HAVING for group filters** - Filter after grouping (next lesson!)
5. **Index GROUP BY columns** - Improves performance

### Common Mistakes

```sql
-- ❌ Wrong - column not in GROUP BY or aggregate
SELECT department, name, COUNT(*)
FROM employees
GROUP BY department;

-- ✅ Correct - only grouped columns and aggregates
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- ❌ Wrong - trying to filter aggregates with WHERE
SELECT department, AVG(salary)
FROM employees
WHERE AVG(salary) > 50000  -- Error!
GROUP BY department;

-- ✅ Correct - use HAVING for aggregate filters (Day 6!)
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

### When to Use GROUP BY

Use GROUP BY when you need to:
- Count items per category
- Calculate totals per group
- Find averages per group
- Analyze data by segments
- Create summary reports
- Aggregate data for visualization

## Key Takeaways
- GROUP BY groups rows with same values together
- Almost always used with aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- Every column in SELECT must be in GROUP BY or an aggregate
- Can group by multiple columns for detailed analysis
- WHERE filters before grouping, HAVING filters after (next lesson)
- Essential for data analysis and reporting

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 6
