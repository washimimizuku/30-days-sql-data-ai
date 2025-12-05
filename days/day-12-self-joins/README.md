# Day 12: Self Joins

## Learning Objectives
- Understand self joins and when to use them
- Master joining a table to itself with different aliases
- Learn hierarchical data queries (managers, org charts)
- Find related records within the same table
- Compare rows within a table
- Build advanced SQL relationship skills

## Theory (15 minutes)

### What is a Self Join?

A self join is when you join a table to itself - useful when a table contains relationships between its own rows.

**Key concept:** Use different aliases to treat the same table as two "copies".

**Syntax:**
```sql
SELECT t1.column, t2.column
FROM table_name t1
JOIN table_name t2 ON t1.some_column = t2.other_column;
```

### Classic Example: Employee-Manager

Most common use case - employees table where each employee has a manager who is also an employee:

```sql
-- employees table
id | name    | manager_id
1  | Alice   | NULL       (CEO)
2  | Bob     | 1          (reports to Alice)
3  | Charlie | 1          (reports to Alice)
4  | David   | 2          (reports to Bob)
```

**Show employees with their managers:**
```sql
SELECT 
    e.name as employee_name,
    m.name as manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

**Result:**
```
Alice   | NULL    (CEO has no manager)
Bob     | Alice
Charlie | Alice
David   | Bob
```

**Why LEFT JOIN?** To include employees without managers (like the CEO).

### Self Join for Hierarchies

**Count direct reports:**
```sql
SELECT 
    m.name as manager_name,
    COUNT(e.id) as direct_reports
FROM employees m
JOIN employees e ON m.id = e.manager_id
GROUP BY m.name;
```

**Find manager's manager:**
```sql
SELECT 
    e.name as employee,
    m1.name as manager,
    m2.name as manager_of_manager
FROM employees e
LEFT JOIN employees m1 ON e.manager_id = m1.id
LEFT JOIN employees m2 ON m1.manager_id = m2.id;
```

**Employees earning more than their manager:**
```sql
SELECT 
    e.name as employee,
    e.salary,
    m.name as manager,
    m.salary,
    e.salary - m.salary as difference
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > m.salary;
```

### Self Join for Comparisons

**Find products in the same category:**
```sql
SELECT 
    p1.product_name as product1,
    p2.product_name as product2,
    p1.category
FROM products p1
JOIN products p2 ON p1.category = p2.category
WHERE p1.id < p2.id;  -- Avoid duplicates
```

**Find similar priced products:**
```sql
SELECT 
    p1.product_name,
    p2.product_name,
    ABS(p1.price - p2.price) as price_diff
FROM products p1
JOIN products p2 ON p1.id < p2.id
WHERE ABS(p1.price - p2.price) < 10;
```

**Compare to department average:**
```sql
SELECT 
    e.name,
    e.salary,
    AVG(e2.salary) as dept_avg,
    e.salary - AVG(e2.salary) as difference
FROM employees e
JOIN employees e2 ON e.department_id = e2.department_id
GROUP BY e.id, e.name, e.salary;
```

### Self Join for Sequences

**Find consecutive orders:**
```sql
SELECT 
    o1.id as first_order,
    o2.id as next_order,
    o2.order_date - o1.order_date as days_between
FROM orders o1
JOIN orders o2 
  ON o1.customer_id = o2.customer_id
  AND o2.order_date > o1.order_date
WHERE o2.order_date - o1.order_date <= 7;
```

### Self Join for Relationships

**Products bought together:**
```sql
SELECT 
    p1.product_name as product1,
    p2.product_name as product2,
    COUNT(*) as times_together
FROM order_items oi1
JOIN order_items oi2 
  ON oi1.order_id = oi2.order_id
  AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.id
JOIN products p2 ON oi2.product_id = p2.id
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(*) >= 3
ORDER BY times_together DESC;
```

### Important Patterns

**Avoid self-matches:**
```sql
WHERE t1.id != t2.id  -- Excludes matching same row
```

**Avoid duplicate pairs:**
```sql
WHERE t1.id < t2.id  -- Gets only (A,B), not (B,A)
```

**Multiple self joins:**
```sql
FROM employees e
LEFT JOIN employees m1 ON e.manager_id = m1.id
LEFT JOIN employees m2 ON m1.manager_id = m2.id
```

### Common Use Cases

1. **Hierarchical Data** - Org charts, category trees
2. **Comparisons** - Similar products, price comparisons
3. **Sequences** - Consecutive orders, gaps, trends
4. **Relationships** - Products bought together, recommendations

### Best Practices

- Use clear aliases (e/m for employee/manager, p1/p2 for products)
- Use WHERE to avoid self-matches (id != id or id < id)
- Use LEFT JOIN for optional relationships
- Index join columns (manager_id, etc.)
- Consider performance on large tables

### Common Mistakes

**Mistake 1: Forgetting to exclude self-matches**
```sql
-- Wrong - matches each row to itself
WHERE p1.category = p2.category

-- Correct
WHERE p1.category = p2.category AND p1.id != p2.id
```

**Mistake 2: Getting duplicate pairs**
```sql
-- Wrong - gets both (A,B) and (B,A)
WHERE t1.id != t2.id

-- Correct - gets only (A,B)
WHERE t1.id < t2.id
```

**Mistake 3: Using INNER JOIN when LEFT JOIN is needed**
```sql
-- Wrong - excludes CEO
FROM employees e JOIN employees m ON e.manager_id = m.id

-- Correct
FROM employees e LEFT JOIN employees m ON e.manager_id = m.id
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day12.db` with sample data including hierarchical employee structure.

### Database Schema
- **employees**: id, name, manager_id, department_id, salary, hire_date
- **products**: id, product_name, category, price, cost
- **customers**: id, customer_name, city, state, registration_date
- **orders**: id, customer_id, order_date, total
- **order_items**: id, order_id, product_id, quantity, price

### Part 1: Employee-Manager Relationships (7 exercises)

### Exercise 1: Employees with Managers (Easy)
Show all employees with their manager's name. Use LEFT JOIN to include employees without managers.

### Exercise 2: Count Direct Reports (Easy)
Show each manager with their count of direct reports.

### Exercise 3: Employees Without Managers (Easy)
Find all employees who don't have a manager (top-level executives).

### Exercise 4: Manager's Manager (Medium)
Show each employee with their manager and their manager's manager.

### Exercise 5: Employees Earning More Than Manager (Medium)
Find employees who earn more than their manager. Show names, salaries, and difference.

### Exercise 6: Same Department Colleagues (Medium)
Find pairs of employees in the same department. Avoid duplicates using id < id.

### Exercise 7: Salary Comparison (Medium)
Compare each employee's salary to the average salary in their department.

### Part 2: Product Comparisons (4 exercises)

### Exercise 8: Products in Same Category (Easy)
Find pairs of products in the same category. Avoid duplicates.

### Exercise 9: Similar Priced Products (Medium)
Find pairs of products with prices within $10 of each other.

### Exercise 10: Product Price Comparison (Medium)
Compare each product's price to the average price in its category.

### Exercise 11: Product Profit Margin Comparison (Hard)
Compare each product's profit margin to the average in its category.
Profit margin = (price - cost) / price * 100

### Part 3: Customer Relationships (3 exercises)

### Exercise 12: Customers in Same City (Easy)
Find pairs of customers in the same city.

### Exercise 13: Customers in Same State (Medium)
Count how many other customers are in the same state as each customer.

### Exercise 14: Customer Registration Comparison (Medium)
Find pairs of customers who registered on the same day.

### Part 4: Order Sequences (3 exercises)

### Exercise 15: Consecutive Orders (Medium)
Find consecutive orders from the same customer. Show both order IDs, dates, and days between.

### Exercise 16: Quick Repeat Orders (Hard)
Find customers who placed another order within 7 days.

### Exercise 17: Order Value Comparison (Medium)
Compare each customer's orders to their own average order value.

### Part 5: Product Relationships (3 exercises)

### Exercise 18: Products Bought Together (Hard)
Find pairs of products bought together in the same order at least 3 times.

### Exercise 19: Frequently Bought Together (Hard)
Find the top 10 product pairs most frequently bought together.

### Exercise 20: Customers Who Bought Same Product (Medium)
Find pairs of customers who bought the same product. Limit to 20 results.

## Key Takeaways

- **Self join = joining a table to itself** - Use different aliases (t1, t2)
- **Always use different aliases** - Required to distinguish the "two copies"
- **Avoid self-matches** - Use WHERE t1.id != t2.id
- **Avoid duplicates** - Use WHERE t1.id < t2.id for pairs
- **Use LEFT JOIN for optional relationships** - Include records without matches
- **Common for hierarchies** - Employee-manager, category trees, org charts
- **Great for comparisons** - Compare rows within same table
- **Find relationships** - Products bought together, similar customers
- **Sequence analysis** - Consecutive orders, gaps, trends
- **Can be expensive** - Consider performance on large tables
- **Index join columns** - Especially foreign keys like manager_id

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 13
