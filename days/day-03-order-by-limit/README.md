# Day 3: ORDER BY and LIMIT

## Learning Objectives
- Understand ORDER BY for sorting results
- Learn ASC and DESC for sort direction
- Master LIMIT for restricting results
- Use OFFSET for pagination
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### ORDER BY - Sorting Results

ORDER BY sorts query results by one or more columns.

**Basic Syntax:**
```sql
SELECT column1, column2
FROM table_name
ORDER BY column1;
```

**Example:**
```sql
-- Sort employees by salary (lowest to highest)
SELECT name, salary
FROM employees
ORDER BY salary;

-- Sort by name alphabetically
SELECT name, department
FROM employees
ORDER BY name;
```

### ASC and DESC - Sort Direction

**ASC (Ascending)** - Default, sorts from lowest to highest:
```sql
-- Explicit ascending (same as default)
SELECT name, salary
FROM employees
ORDER BY salary ASC;
```

**DESC (Descending)** - Sorts from highest to lowest:
```sql
-- Sort by salary, highest first
SELECT name, salary
FROM employees
ORDER BY salary DESC;

-- Sort by hire date, most recent first
SELECT name, hire_date
FROM employees
ORDER BY hire_date DESC;
```

### Multiple Column Sorting

Sort by multiple columns - first column is primary sort, then second, etc.:

```sql
-- Sort by department, then by salary within each department
SELECT name, department, salary
FROM employees
ORDER BY department ASC, salary DESC;

-- Sort by city, then by name
SELECT name, city, salary
FROM employees
ORDER BY city, name;
```

**Example with different directions:**
```sql
-- Department A-Z, then salary highest to lowest within each department
SELECT name, department, salary
FROM employees
ORDER BY department ASC, salary DESC;
```

### LIMIT - Restricting Results

LIMIT restricts the number of rows returned:

```sql
-- Get top 5 highest paid employees
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Get 10 most recent hires
SELECT name, hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 10;
```

**Important:** LIMIT without ORDER BY returns arbitrary rows!

```sql
-- ❌ Bad - unpredictable results
SELECT name FROM employees LIMIT 5;

-- ✅ Good - predictable results
SELECT name FROM employees ORDER BY name LIMIT 5;
```

### OFFSET - Skipping Rows (Pagination)

OFFSET skips a specified number of rows:

```sql
-- Skip first 10 rows, get next 10
SELECT name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10 OFFSET 10;
```

**Pagination Pattern:**
```sql
-- Page 1 (rows 1-10)
SELECT * FROM employees ORDER BY name LIMIT 10 OFFSET 0;

-- Page 2 (rows 11-20)
SELECT * FROM employees ORDER BY name LIMIT 10 OFFSET 10;

-- Page 3 (rows 21-30)
SELECT * FROM employees ORDER BY name LIMIT 10 OFFSET 20;

-- Formula: OFFSET = (page_number - 1) * page_size
```

### Sorting with NULL Values

NULL values sort behavior:
- **ASC:** NULLs typically appear first
- **DESC:** NULLs typically appear last

```sql
-- NULLs will appear first
SELECT name, email
FROM employees
ORDER BY email ASC;

-- NULLs will appear last
SELECT name, email
FROM employees
ORDER BY email DESC;
```

### Sorting Different Data Types

**Numbers:** Numeric order
```sql
SELECT name, salary
FROM employees
ORDER BY salary DESC;  -- 100000, 90000, 80000...
```

**Strings:** Alphabetical order
```sql
SELECT name
FROM employees
ORDER BY name;  -- Alice, Bob, Charlie...
```

**Dates:** Chronological order
```sql
SELECT name, hire_date
FROM employees
ORDER BY hire_date;  -- 2020-01-01, 2020-02-15, 2020-03-20...
```

### Practical Examples

**Example 1: Top 10 Products by Price**
```sql
SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 10;
```

**Example 2: Recent Orders with Pagination**
```sql
-- Get orders 11-20 (page 2)
SELECT order_id, customer_name, order_date, total
FROM orders
ORDER BY order_date DESC
LIMIT 10 OFFSET 10;
```

**Example 3: Alphabetical List with Salary**
```sql
SELECT name, department, salary
FROM employees
ORDER BY name ASC;
```

**Example 4: Department Report**
```sql
-- Within each department, show highest paid first
SELECT department, name, salary
FROM employees
ORDER BY department ASC, salary DESC;
```

## 💻 Exercises (40 minutes)

### Exercise 1: Basic ORDER BY

Write queries to:
1. Sort employees by salary (lowest to highest)
2. Sort employees by name alphabetically
3. Sort employees by hire_date (oldest first)
4. Sort products by price (highest to lowest)

### Exercise 2: ASC and DESC

Write queries to:
1. Sort employees by salary DESC (highest paid first)
2. Sort employees by hire_date DESC (most recent first)
3. Sort products by name ASC (A to Z)
4. Sort orders by total DESC (largest orders first)

### Exercise 3: Multiple Column Sorting

Write queries to:
1. Sort by department ASC, then salary DESC within each department
2. Sort by city ASC, then name ASC within each city
3. Sort by category ASC, then price DESC within each category
4. Sort by order_date DESC, then customer_name ASC

### Exercise 4: LIMIT

Write queries to:
1. Get top 5 highest paid employees
2. Get 10 most expensive products
3. Get 3 most recent orders
4. Get 20 employees alphabetically

### Exercise 5: OFFSET and Pagination

Write queries to:
1. Get employees 11-20 when sorted by name (page 2, 10 per page)
2. Get products 21-30 when sorted by price DESC (page 3, 10 per page)
3. Get orders 6-10 when sorted by date DESC (page 2, 5 per page)
4. Implement pagination: page 4 with 25 items per page

### Exercise 6: Combined Operations

Write queries to:
1. Get top 10 highest paid employees with their names and salaries
2. Get 5 most recent hires with all their information
3. Get products 11-20 sorted by price (highest to lowest)
4. Get employees in 'Engineering' department, sorted by salary DESC, top 5

### Exercise 7: Real-World Scenarios

Write queries to:
1. Leaderboard: Top 10 customers by total purchases
2. Recent activity: Last 20 orders with customer names
3. Product catalog: Page 3 of products (items 21-30), sorted by name
4. Employee directory: Page 2 of employees (items 11-20), sorted alphabetically

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### ORDER BY Summary

| Clause | Purpose | Example |
|--------|---------|---------|
| ORDER BY col | Sort by column | ORDER BY salary |
| ASC | Ascending (default) | ORDER BY salary ASC |
| DESC | Descending | ORDER BY salary DESC |
| Multiple columns | Sort by multiple | ORDER BY dept, salary DESC |

### LIMIT and OFFSET

| Clause | Purpose | Example |
|--------|---------|---------|
| LIMIT n | Return first n rows | LIMIT 10 |
| OFFSET n | Skip first n rows | OFFSET 20 |
| Both | Pagination | LIMIT 10 OFFSET 20 |

### Best Practices

1. **Always use ORDER BY with LIMIT** - Without it, results are unpredictable
2. **Use indexes on ORDER BY columns** - Improves performance
3. **Be specific with sort direction** - Use ASC or DESC explicitly
4. **Consider NULL handling** - Know where NULLs will appear
5. **Use pagination for large datasets** - LIMIT and OFFSET together

### Common Patterns

```sql
-- Pattern 1: Top N
SELECT * FROM table
ORDER BY column DESC
LIMIT 10;

-- Pattern 2: Pagination
SELECT * FROM table
ORDER BY column
LIMIT page_size OFFSET (page_number - 1) * page_size;

-- Pattern 3: Multiple sort criteria
SELECT * FROM table
ORDER BY category ASC, price DESC, name ASC;

-- Pattern 4: Recent items
SELECT * FROM table
ORDER BY created_at DESC
LIMIT 20;
```

### Performance Tips

1. **Index ORDER BY columns** - Dramatically improves sort speed
2. **Limit early** - Don't sort more rows than needed
3. **Avoid OFFSET on large datasets** - Use cursor-based pagination instead
4. **Sort by indexed columns** - Much faster than non-indexed

### Common Mistakes

```sql
-- ❌ Wrong - LIMIT without ORDER BY (unpredictable)
SELECT * FROM employees LIMIT 10;

-- ✅ Correct - ORDER BY with LIMIT
SELECT * FROM employees ORDER BY name LIMIT 10;

-- ❌ Wrong - Inconsistent pagination (missing ORDER BY)
SELECT * FROM employees LIMIT 10 OFFSET 20;

-- ✅ Correct - Consistent pagination
SELECT * FROM employees ORDER BY id LIMIT 10 OFFSET 20;

-- ❌ Wrong - OFFSET before LIMIT (syntax error)
SELECT * FROM employees OFFSET 10 LIMIT 10;

-- ✅ Correct - LIMIT before OFFSET
SELECT * FROM employees LIMIT 10 OFFSET 10;
```

## Key Takeaways
- ORDER BY sorts results by one or more columns
- ASC (ascending) is default, DESC sorts in reverse
- LIMIT restricts the number of rows returned
- OFFSET skips rows (useful for pagination)
- Always use ORDER BY with LIMIT for predictable results
- Multiple columns can be used for complex sorting
- Pagination formula: LIMIT page_size OFFSET (page - 1) * page_size

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 4
