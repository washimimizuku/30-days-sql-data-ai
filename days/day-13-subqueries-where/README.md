# Day 13: Subqueries in WHERE

## Learning Objectives
- Understand subqueries in WHERE
- Learn subqueries in WHERE clause
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### What are Subqueries?

A subquery is a query nested inside another query. Subqueries in the WHERE clause are used to filter rows based on the results of another query.

**Basic Syntax:**
```sql
SELECT column1, column2
FROM table_name
WHERE column_name operator (
    SELECT column_name
    FROM another_table
    WHERE condition
);
```

### Scalar Subqueries

Returns a single value (one row, one column):

```sql
-- Find employees with salary above average
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Find products more expensive than a specific product
SELECT name, price
FROM products
WHERE price > (
    SELECT price
    FROM products
    WHERE name = 'Widget A'
);
```

### IN Operator with Subqueries

Check if a value matches any value in the subquery result:

```sql
-- Find employees in departments located in New York
SELECT name, department_id
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE city = 'New York'
);

-- Find customers who have placed orders
SELECT name
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
);

-- NOT IN - Find customers who haven't placed orders
SELECT name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL  -- Important!
);
```

**⚠️ Warning with NOT IN and NULL:**
```sql
-- If subquery returns any NULL, NOT IN returns no rows!
-- Always filter out NULLs in subquery when using NOT IN
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL
);
```

### EXISTS Operator

Checks if the subquery returns any rows (more efficient than IN for many cases):

```sql
-- Find employees who have placed orders
SELECT name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.employee_id = e.id
);

-- Find departments that have employees
SELECT dept_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.id
);
```

**Why EXISTS is often better than IN:**
- Stops searching once it finds a match
- Doesn't care about NULLs
- Often faster for large datasets

### NOT EXISTS Operator

Checks if the subquery returns no rows:

```sql
-- Find employees who have NOT placed orders
SELECT name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.employee_id = e.id
);

-- Find customers with no orders
SELECT name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

-- Find products never ordered
SELECT product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.id
);
```

### ANY Operator

Compare to any value in the subquery (at least one must match):

```sql
-- Find employees with salary greater than ANY sales employee
SELECT name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
);
-- Equivalent to: salary > MIN(sales salaries)

-- Find products cheaper than ANY competitor product
SELECT name, price
FROM our_products
WHERE price < ANY (
    SELECT price
    FROM competitor_products
);
```

**Operators with ANY:**
- `> ANY` - Greater than the minimum
- `< ANY` - Less than the maximum
- `= ANY` - Same as IN

### ALL Operator

Compare to all values in the subquery (must match all):

```sql
-- Find employees with salary greater than ALL sales employees
SELECT name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department = 'Sales'
);
-- Equivalent to: salary > MAX(sales salaries)

-- Find products cheaper than ALL competitor products
SELECT name, price
FROM our_products
WHERE price < ALL (
    SELECT price
    FROM competitor_products
);
```

**Operators with ALL:**
- `> ALL` - Greater than the maximum
- `< ALL` - Less than the minimum
- `= ALL` - Equal to all (rarely used)

### Correlated Subqueries

Subquery references columns from the outer query:

```sql
-- Find employees earning more than their department average
SELECT name, salary, department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

-- Find products with above-average price in their category
SELECT name, price, category
FROM products p1
WHERE price > (
    SELECT AVG(price)
    FROM products p2
    WHERE p2.category = p1.category
);
```

## 💻 Exercises (40 minutes)

### Exercise 1: Scalar Subqueries

Write queries to:
1. Find employees with salary above the company average
2. Find products with price above the average price
3. Find orders with total greater than the average order total
4. Find employees older than the oldest employee in 'Sales'

### Exercise 2: IN Operator with Subqueries

Write queries to:
1. Find employees in departments located in 'New York'
2. Find customers who have placed orders
3. Find products that have been ordered
4. Find employees NOT in departments with 'Manager' in the name

### Exercise 3: EXISTS Operator

Write queries to:
1. Find employees who have placed orders (use EXISTS)
2. Find departments that have at least one employee
3. Find customers who have orders with total > 1000
4. Find products that appear in at least one order

### Exercise 4: NOT EXISTS Operator

Write queries to:
1. Find employees who have NOT placed any orders
2. Find customers with no orders
3. Find products that have never been ordered
4. Find departments with no employees

### Exercise 5: ANY Operator

Write queries to:
1. Find employees with salary > ANY salary in 'Sales' department
2. Find products cheaper than ANY product in 'Electronics' category
3. Find orders with total > ANY order from customer 'ABC Corp'

### Exercise 6: ALL Operator

Write queries to:
1. Find employees with salary > ALL salaries in 'Sales' department
2. Find products cheaper than ALL products in 'Premium' category
3. Find customers with all orders having total > 500

### Exercise 7: Correlated Subqueries

Write queries to:
1. Find employees earning more than their department average
2. Find products with above-average price in their category
3. Find customers who have spent more than the average for their city
4. Find orders with total above the customer's average order total

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### EXISTS vs IN

**Use EXISTS when:**
- Checking for existence (don't need actual values)
- Working with large datasets
- Subquery might return NULLs

**Use IN when:**
- Need to match specific values
- Subquery returns small result set
- More readable for simple cases

```sql
-- EXISTS - Often faster
WHERE EXISTS (SELECT 1 FROM orders WHERE customer_id = c.id)

-- IN - More intuitive
WHERE customer_id IN (SELECT customer_id FROM orders)
```

### ANY vs ALL

**ANY** - At least one must match:
- `> ANY` means greater than the minimum
- `< ANY` means less than the maximum

**ALL** - Must match all:
- `> ALL` means greater than the maximum
- `< ALL` means less than the minimum

### Performance Tips

1. **EXISTS is usually faster than IN** for large datasets
2. **Avoid NOT IN with NULLs** - Use NOT EXISTS instead
3. **Correlated subqueries** can be slow - consider JOINs
4. **Scalar subqueries** should return exactly one value

### Common Patterns

```sql
-- Pattern 1: Find records with related data
WHERE EXISTS (SELECT 1 FROM related WHERE related.id = main.id)

-- Pattern 2: Find records without related data
WHERE NOT EXISTS (SELECT 1 FROM related WHERE related.id = main.id)

-- Pattern 3: Compare to aggregate
WHERE value > (SELECT AVG(value) FROM table)

-- Pattern 4: Compare to department/category average
WHERE value > (SELECT AVG(value) FROM table t2 WHERE t2.group = t1.group)
```

## Key Takeaways
- Subqueries in WHERE filter based on another query's results
- Use IN for matching values, EXISTS for checking existence
- EXISTS is often faster than IN for large datasets
- NOT EXISTS is safer than NOT IN (handles NULLs better)
- ANY and ALL compare to multiple values
- Correlated subqueries reference outer query columns

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 14
