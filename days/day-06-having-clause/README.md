# Day 6: HAVING Clause

## Learning Objectives
- Understand HAVING clause for filtering groups
- Learn the difference between WHERE and HAVING
- Master filtering aggregated results
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### What is HAVING?

HAVING filters groups AFTER they've been created by GROUP BY. It's like WHERE, but for aggregated data.

**Key Difference:**
- **WHERE** filters rows BEFORE grouping
- **HAVING** filters groups AFTER grouping

### Basic HAVING Syntax

```sql
SELECT column, aggregate_function(column)
FROM table
GROUP BY column
HAVING aggregate_function(column) condition;
```

### HAVING with COUNT

Filter groups based on count:

```sql
-- Departments with more than 10 employees
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 10;
```

**Result:** Only departments with > 10 employees

**More examples:**
```sql
-- Customers with more than 5 orders
SELECT customer_id, COUNT(*) as order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5;

-- Categories with at least 20 products
SELECT category, COUNT(*) as product_count
FROM products
GROUP BY category
HAVING COUNT(*) >= 20;

-- Cities with fewer than 3 employees
SELECT city, COUNT(*) as employee_count
FROM employees
GROUP BY city
HAVING COUNT(*) < 3;
```

### HAVING with SUM

Filter groups based on sum:

```sql
-- Departments with total payroll over $500,000
SELECT department, SUM(salary) as total_payroll
FROM employees
GROUP BY department
HAVING SUM(salary) > 500000;

-- Customers who spent more than $10,000
SELECT customer_id, SUM(total) as total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total) > 10000;

-- Products with total sales over 1000 units
SELECT product_id, SUM(quantity) as total_sold
FROM order_items
GROUP BY product_id
HAVING SUM(quantity) > 1000;
```

### HAVING with AVG

Filter groups based on average:

```sql
-- Departments with average salary above $75,000
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 75000;

-- Categories with average price over $100
SELECT category, AVG(price) as avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 100;

-- Customers with average order value over $500
SELECT customer_id, AVG(total) as avg_order_value
FROM orders
GROUP BY customer_id
HAVING AVG(total) > 500;
```

### HAVING with MIN and MAX

Filter groups based on min/max values:

```sql
-- Departments where lowest salary is above $50,000
SELECT department, MIN(salary) as min_salary
FROM employees
GROUP BY department
HAVING MIN(salary) > 50000;

-- Categories where most expensive item is over $1000
SELECT category, MAX(price) as max_price
FROM products
GROUP BY category
HAVING MAX(price) > 1000;
```

### WHERE vs HAVING

**WHERE:** Filters individual rows BEFORE grouping
**HAVING:** Filters groups AFTER grouping

```sql
-- WHERE filters rows first, then groups
SELECT department, AVG(salary) as avg_salary
FROM employees
WHERE is_active = TRUE  -- Filter rows first
GROUP BY department
HAVING AVG(salary) > 70000;  -- Filter groups after

-- Execution order:
-- 1. WHERE filters rows (only active employees)
-- 2. GROUP BY groups remaining rows
-- 3. AVG calculates for each group
-- 4. HAVING filters groups (only avg > 70000)
```

**Example showing the difference:**
```sql
-- Count active employees per department, only departments with > 5
SELECT department, COUNT(*) as active_count
FROM employees
WHERE is_active = TRUE  -- WHERE: filter rows
GROUP BY department
HAVING COUNT(*) > 5;  -- HAVING: filter groups

-- This is different from:
SELECT department, COUNT(*) as total_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;  -- Counts ALL employees, then filters
```

### Multiple Conditions in HAVING

Combine multiple conditions:

```sql
-- Departments with > 10 employees AND avg salary > $70,000
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 10 AND AVG(salary) > 70000;

-- Categories with > 50 products OR avg price > $200
SELECT 
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price
FROM products
GROUP BY category
HAVING COUNT(*) > 50 OR AVG(price) > 200;
```

### HAVING with Multiple Aggregates

Filter on different aggregates:

```sql
-- Departments with > 5 employees and total payroll > $300,000
SELECT 
    department,
    COUNT(*) as employee_count,
    SUM(salary) as total_payroll,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING COUNT(*) > 5 AND SUM(salary) > 300000;
```

### Complete Query with WHERE, GROUP BY, HAVING, ORDER BY

```sql
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary,
    SUM(salary) as total_payroll
FROM employees
WHERE is_active = TRUE  -- 1. Filter rows
GROUP BY department  -- 2. Group rows
HAVING COUNT(*) >= 5  -- 3. Filter groups
ORDER BY avg_salary DESC;  -- 4. Sort results
```

**Execution order:**
1. FROM - Get data from table
2. WHERE - Filter individual rows
3. GROUP BY - Group remaining rows
4. HAVING - Filter groups
5. SELECT - Calculate aggregates
6. ORDER BY - Sort final results

### Practical Examples

**Example 1: High-Value Customers**
```sql
-- Find customers who placed > 10 orders and spent > $5000
SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(total) as total_spent,
    AVG(total) as avg_order_value
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 10 AND SUM(total) > 5000
ORDER BY total_spent DESC;
```

**Example 2: Popular Products**
```sql
-- Products sold in > 100 orders with total quantity > 500
SELECT 
    product_id,
    COUNT(DISTINCT order_id) as order_count,
    SUM(quantity) as total_quantity
FROM order_items
GROUP BY product_id
HAVING COUNT(DISTINCT order_id) > 100 AND SUM(quantity) > 500;
```

**Example 3: Department Analysis**
```sql
-- Large departments with high average salaries
SELECT 
    department,
    city,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department, city
HAVING COUNT(*) >= 10 AND AVG(salary) > 75000
ORDER BY avg_salary DESC;
```

### HAVING with Calculated Expressions

```sql
-- Departments where salary range is > $50,000
SELECT 
    department,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    MAX(salary) - MIN(salary) as salary_range
FROM employees
GROUP BY department
HAVING MAX(salary) - MIN(salary) > 50000;
```

## 💻 Exercises (40 minutes)

### Exercise 1: HAVING with COUNT

Write queries to:
1. Find departments with more than 10 employees
2. Find customers with more than 5 orders
3. Find categories with fewer than 5 products
4. Find cities with at least 20 employees

### Exercise 2: HAVING with SUM

Write queries to:
1. Find departments with total payroll over $500,000
2. Find customers who spent more than $10,000
3. Find products with total sales over 1000 units
4. Find categories with total inventory value over $50,000

### Exercise 3: HAVING with AVG

Write queries to:
1. Find departments with average salary above $75,000
2. Find categories with average price over $100
3. Find customers with average order value over $500
4. Find products with average rating above 4.5

### Exercise 4: HAVING with MIN and MAX

Write queries to:
1. Find departments where minimum salary is above $50,000
2. Find categories where maximum price is over $1000
3. Find departments where salary range (max - min) is over $40,000
4. Find products where minimum order quantity is over 10

### Exercise 5: WHERE vs HAVING

Write queries to:
1. Count active employees per department, only departments with > 5 active employees
2. Average salary per city for employees hired after 2020, only cities with avg > $70,000
3. Total sales per product in 2024, only products with sales > $10,000
4. Count orders per customer for orders > $100, only customers with > 10 such orders

### Exercise 6: Multiple Conditions in HAVING

Write queries to:
1. Departments with > 10 employees AND average salary > $70,000
2. Categories with > 50 products OR average price > $200
3. Customers with > 5 orders AND total spent > $5000
4. Products with > 100 sales AND average price > $50

### Exercise 7: Complete Queries

Write queries combining WHERE, GROUP BY, HAVING, ORDER BY:
1. Active employees by department: count, avg salary; only depts with > 5 employees and avg > $65,000; order by avg salary DESC
2. 2024 sales by product: total quantity, total revenue; only products with > 100 units sold; order by revenue DESC
3. Customer analysis: order count, total spent, avg order value; only customers with > 10 orders; order by total spent DESC
4. Department report by city: count, avg salary, total payroll; only groups with > 3 employees; order by total payroll DESC

### Exercise 8: Advanced HAVING

Write queries to:
1. Find departments where the salary range (MAX - MIN) is greater than $60,000
2. Find categories where the price variance is high (MAX price > 3 * AVG price)
3. Find customers whose total spending is more than 10 times their average order value
4. Find products that appear in more than 50 distinct orders

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### WHERE vs HAVING

| Aspect | WHERE | HAVING |
|--------|-------|--------|
| **Filters** | Individual rows | Groups |
| **When** | Before GROUP BY | After GROUP BY |
| **Works with** | Column values | Aggregate functions |
| **Example** | WHERE salary > 50000 | HAVING AVG(salary) > 50000 |

### SQL Execution Order

```sql
SELECT department, AVG(salary)  -- 5. Select and calculate
FROM employees                   -- 1. Get data
WHERE is_active = TRUE          -- 2. Filter rows
GROUP BY department             -- 3. Group rows
HAVING AVG(salary) > 70000      -- 4. Filter groups
ORDER BY AVG(salary) DESC;      -- 6. Sort results
```

### Common HAVING Patterns

```sql
-- Pattern 1: Filter by count
SELECT category, COUNT(*) as count
FROM products
GROUP BY category
HAVING COUNT(*) > 10;

-- Pattern 2: Filter by sum
SELECT customer_id, SUM(total) as total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total) > 5000;

-- Pattern 3: Filter by average
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 75000;

-- Pattern 4: Multiple conditions
SELECT department, COUNT(*), AVG(salary)
FROM employees
GROUP BY department
HAVING COUNT(*) > 10 AND AVG(salary) > 70000;

-- Pattern 5: With WHERE and ORDER BY
SELECT department, AVG(salary) as avg_salary
FROM employees
WHERE is_active = TRUE
GROUP BY department
HAVING AVG(salary) > 70000
ORDER BY avg_salary DESC;
```

### Best Practices

1. **Use WHERE for row filtering** - More efficient than HAVING
2. **Use HAVING for aggregate filtering** - Only way to filter groups
3. **Combine WHERE and HAVING** - Filter rows first, then groups
4. **Use meaningful aliases** - Make HAVING conditions readable
5. **Order results** - Add ORDER BY for consistent output

### Common Mistakes

```sql
-- ❌ Wrong - Can't use HAVING without GROUP BY
SELECT name, salary
FROM employees
HAVING salary > 50000;

-- ✅ Correct - Use WHERE for row filtering
SELECT name, salary
FROM employees
WHERE salary > 50000;

-- ❌ Wrong - Using WHERE for aggregate
SELECT department, AVG(salary)
FROM employees
WHERE AVG(salary) > 70000  -- Error!
GROUP BY department;

-- ✅ Correct - Use HAVING for aggregates
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000;

-- ❌ Wrong - Filtering rows with HAVING (inefficient)
SELECT department, COUNT(*)
FROM employees
GROUP BY department
HAVING department = 'Engineering';

-- ✅ Correct - Use WHERE for row filtering (efficient)
SELECT department, COUNT(*)
FROM employees
WHERE department = 'Engineering'
GROUP BY department;
```

### When to Use HAVING

Use HAVING when you need to:
- Filter based on aggregate results (COUNT, SUM, AVG, etc.)
- Find groups that meet certain criteria
- Analyze only significant groups
- Filter after calculations
- Work with grouped data

**Examples:**
- Departments with more than X employees
- Customers who spent more than $X
- Products sold more than X times
- Categories with average price above $X

### Performance Tips

1. **Use WHERE first** - Reduces rows before grouping
2. **Index GROUP BY columns** - Faster grouping
3. **Avoid complex HAVING expressions** - Keep it simple
4. **Filter early** - WHERE is faster than HAVING

```sql
-- ✅ Good - Filter with WHERE first
SELECT department, AVG(salary)
FROM employees
WHERE is_active = TRUE  -- Reduces rows early
GROUP BY department
HAVING AVG(salary) > 70000;

-- ❌ Less efficient - Only using HAVING
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000 AND department IN ('Engineering', 'Sales');
-- Better to filter department with WHERE
```

## Key Takeaways
- HAVING filters groups AFTER GROUP BY
- WHERE filters rows BEFORE GROUP BY
- HAVING works with aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- Use WHERE for row filtering, HAVING for group filtering
- Can combine WHERE and HAVING in same query
- Execution order: WHERE → GROUP BY → HAVING
- Essential for finding groups that meet specific criteria

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 7
