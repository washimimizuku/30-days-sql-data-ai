# Day 4: Aggregate Functions - COUNT, SUM, AVG

## Learning Objectives
- Understand aggregate functions
- Learn COUNT, SUM, AVG, MIN, MAX
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### What are Aggregate Functions?

Aggregate functions perform calculations on a set of rows and return a single value. They're essential for data analysis and reporting.

### COUNT - Count Rows

Counts the number of rows:

```sql
-- Count all rows
SELECT COUNT(*) as total_employees
FROM employees;

-- Count non-NULL values in a column
SELECT COUNT(email) as employees_with_email
FROM employees;

-- Count distinct values
SELECT COUNT(DISTINCT city) as unique_cities
FROM employees;

-- Count with condition
SELECT COUNT(*) as high_earners
FROM employees
WHERE salary > 100000;
```

**Key differences:**
- `COUNT(*)` - Counts all rows (including NULLs)
- `COUNT(column)` - Counts non-NULL values only
- `COUNT(DISTINCT column)` - Counts unique non-NULL values

### SUM - Add Values

Adds up numeric values:

```sql
-- Total salary expense
SELECT SUM(salary) as total_payroll
FROM employees;

-- Total sales
SELECT SUM(amount) as total_sales
FROM orders;

-- Sum with condition
SELECT SUM(amount) as total_refunds
FROM transactions
WHERE type = 'refund';
```

**Note:** SUM ignores NULL values

### AVG - Calculate Average

Calculates the mean (average) of numeric values:

```sql
-- Average salary
SELECT AVG(salary) as average_salary
FROM employees;

-- Average order value
SELECT AVG(total) as avg_order_value
FROM orders;

-- Average with rounding
SELECT ROUND(AVG(salary), 2) as avg_salary
FROM employees;
```

**Note:** AVG ignores NULL values and divides by count of non-NULL values

### MIN - Find Minimum

Finds the smallest value:

```sql
-- Lowest salary
SELECT MIN(salary) as lowest_salary
FROM employees;

-- Earliest hire date
SELECT MIN(hire_date) as first_hire
FROM employees;

-- Cheapest product
SELECT MIN(price) as min_price
FROM products;

-- Alphabetically first name
SELECT MIN(name) as first_name_alphabetically
FROM employees;
```

**Works with:**
- Numbers (smallest number)
- Dates (earliest date)
- Strings (alphabetically first)

### MAX - Find Maximum

Finds the largest value:

```sql
-- Highest salary
SELECT MAX(salary) as highest_salary
FROM employees;

-- Most recent hire date
SELECT MAX(hire_date) as latest_hire
FROM employees;

-- Most expensive product
SELECT MAX(price) as max_price
FROM products;

-- Alphabetically last name
SELECT MAX(name) as last_name_alphabetically
FROM employees;
```

**Works with:**
- Numbers (largest number)
- Dates (most recent date)
- Strings (alphabetically last)

### Combining Multiple Aggregates

You can use multiple aggregate functions in one query:

```sql
-- Salary statistics
SELECT 
    COUNT(*) as employee_count,
    SUM(salary) as total_payroll,
    AVG(salary) as average_salary,
    MIN(salary) as lowest_salary,
    MAX(salary) as highest_salary,
    MAX(salary) - MIN(salary) as salary_range
FROM employees;

-- Order statistics
SELECT 
    COUNT(*) as total_orders,
    SUM(amount) as total_revenue,
    AVG(amount) as avg_order_value,
    MIN(amount) as smallest_order,
    MAX(amount) as largest_order
FROM orders;
```

### Aggregates with WHERE

Filter rows before aggregating:

```sql
-- Statistics for Engineering department only
SELECT 
    COUNT(*) as eng_count,
    AVG(salary) as eng_avg_salary,
    MAX(salary) as eng_max_salary
FROM employees
WHERE department = 'Engineering';

-- Sales in 2024
SELECT 
    COUNT(*) as order_count,
    SUM(amount) as total_sales
FROM orders
WHERE order_date >= '2024-01-01';
```

### Handling NULL Values

Aggregate functions (except COUNT(*)) ignore NULL values:

```sql
-- Example data:
-- salaries: 50000, 60000, NULL, 70000

SELECT 
    COUNT(*) as total_rows,           -- 4
    COUNT(salary) as non_null_count,  -- 3
    SUM(salary) as total,             -- 180000
    AVG(salary) as average            -- 60000 (180000/3, not 180000/4)
FROM employees;
```

### DISTINCT with Aggregates

```sql
-- Count unique cities
SELECT COUNT(DISTINCT city) as unique_cities
FROM employees;

-- Sum of unique salaries (unusual but possible)
SELECT SUM(DISTINCT salary) as sum_unique_salaries
FROM employees;

-- Average of unique values
SELECT AVG(DISTINCT price) as avg_unique_prices
FROM products;
```

## 💻 Exercises (40 minutes)

### Exercise 1: COUNT

Write queries to:
1. Count total number of employees
2. Count employees with non-NULL email addresses
3. Count unique cities where employees are located
4. Count employees in the 'Engineering' department
5. Count orders placed in 2024

### Exercise 2: SUM

Write queries to:
1. Calculate total payroll (sum of all salaries)
2. Calculate total sales amount from orders
3. Calculate total quantity of products in inventory
4. Calculate total refund amount (where type = 'refund')
5. Calculate sum of salaries for 'Sales' department

### Exercise 3: AVG

Write queries to:
1. Calculate average salary across all employees
2. Calculate average order value
3. Calculate average product price
4. Calculate average salary in 'Engineering' department
5. Calculate average age of employees

### Exercise 4: MIN and MAX

Write queries to:
1. Find the lowest and highest salary
2. Find the earliest and latest hire date
3. Find the cheapest and most expensive product
4. Find the minimum and maximum order total
5. Find alphabetically first and last employee name

### Exercise 5: Multiple Aggregates

Write queries to:
1. Show count, sum, avg, min, max of salaries
2. Show order statistics (count, total, average, min, max)
3. Show product statistics (count, avg price, min price, max price)
4. Show employee statistics by department (you'll learn GROUP BY next!)

### Exercise 6: Aggregates with WHERE

Write queries to:
1. Average salary for employees hired after 2020
2. Total sales for orders over $1000
3. Count of products with price between $10 and $50
4. Sum of salaries for employees in 'Engineering' or 'Sales'
5. Average order value for customer_id = 5

### Exercise 7: DISTINCT with Aggregates

Write queries to:
1. Count unique departments
2. Count unique cities
3. Sum of unique salary values
4. Count unique product categories
5. Count unique customers who placed orders

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### Aggregate Functions Summary

| Function | Purpose | Ignores NULL? | Works With |
|----------|---------|---------------|------------|
| COUNT(*) | Count all rows | No | Any |
| COUNT(col) | Count non-NULL values | Yes | Any |
| SUM | Add values | Yes | Numbers |
| AVG | Calculate average | Yes | Numbers |
| MIN | Find minimum | Yes | Numbers, dates, strings |
| MAX | Find maximum | Yes | Numbers, dates, strings |

### NULL Handling

```sql
-- Data: 10, 20, NULL, 30

COUNT(*)      -- 4 (counts all rows)
COUNT(value)  -- 3 (counts non-NULL)
SUM(value)    -- 60 (ignores NULL)
AVG(value)    -- 20 (60/3, not 60/4)
MIN(value)    -- 10
MAX(value)    -- 30
```

### Common Patterns

```sql
-- Pattern 1: Basic statistics
SELECT 
    COUNT(*) as count,
    AVG(value) as average,
    MIN(value) as minimum,
    MAX(value) as maximum
FROM table;

-- Pattern 2: With filtering
SELECT AVG(salary)
FROM employees
WHERE department = 'Engineering';

-- Pattern 3: Distinct counts
SELECT 
    COUNT(*) as total_rows,
    COUNT(DISTINCT city) as unique_cities
FROM employees;

-- Pattern 4: Calculated fields
SELECT 
    SUM(quantity * price) as total_revenue,
    AVG(quantity * price) as avg_order_value
FROM order_items;
```

### Best Practices

1. **Use COUNT(*) for row counts** - Faster than COUNT(column)
2. **Use DISTINCT carefully** - Can be slow on large datasets
3. **Round AVG results** - Use ROUND(AVG(col), 2) for readability
4. **Check for NULLs** - Understand how they affect your calculations
5. **Combine with WHERE** - Filter before aggregating for better performance

### Common Mistakes

```sql
-- ❌ Wrong - Mixing aggregates and non-aggregates
SELECT name, AVG(salary)
FROM employees;
-- Error: name is not aggregated

-- ✅ Correct - Use GROUP BY (next lesson!)
SELECT department, AVG(salary)
FROM employees
GROUP BY department;

-- ❌ Wrong - Using aggregate in WHERE
SELECT *
FROM employees
WHERE salary > AVG(salary);
-- Error: Can't use aggregate in WHERE

-- ✅ Correct - Use subquery
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

## Key Takeaways
- COUNT counts rows, SUM adds values, AVG calculates average
- MIN finds smallest value, MAX finds largest value
- Aggregate functions ignore NULL values (except COUNT(*))
- Use DISTINCT to count/sum unique values
- Combine multiple aggregates in one query
- Filter with WHERE before aggregating
- Cannot mix aggregates and non-aggregates without GROUP BY

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 5
