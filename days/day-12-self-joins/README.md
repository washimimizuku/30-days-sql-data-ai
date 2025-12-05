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

A self join is when you join a table to itself. This is useful when a table contains relationships between its own rows.

**Think of it as:** "Comparing rows in a table with other rows in the same table"

**Key concept:** Use different table aliases to treat the same table as if it were two different tables.

### Self Join Syntax

```sql
SELECT 
    t1.column as column1,
    t2.column as column2
FROM table_name t1
JOIN table_name t2
  ON t1.some_column = t2.other_column;
```

**Critical:** You MUST use different aliases (t1, t2) to distinguish between the two "copies" of the table.

### Classic Example: Employee-Manager Relationship

Most common self join use case - employees table where each employee has a manager who is also an employee:

```sql
-- employees table
id | name    | manager_id
1  | Alice   | NULL       (CEO, no manager)
2  | Bob     | 1          (reports to Alice)
3  | Charlie | 1          (reports to Alice)
4  | David   | 2          (reports to Bob)
5  | Eve     | 2          (reports to Bob)
```

**Query to show employees with their managers:**
```sql
SELECT 
    e.name as employee_name,
    m.name as manager_name
FROM employees e
LEFT JOIN employees m
  ON e.manager_id = m.id;
```

**Result:**
```
employee_name | manager_name
Alice         | NULL         (CEO has no manager)
Bob           | Alice
Charlie       | Alice
David         | Bob
Eve           | Bob
```

**Explanation:**
- `e` (employee) is the first "copy" of the table
- `m` (manager) is the second "copy" of the table
- We join where employee's manager_id matches manager's id
- Use LEFT JOIN to include employees without managers (like the CEO)

### Self Join for Hierarchies

**Find all employees and their manager's manager:**
```sql
SELECT 
    e.name as employee,
    m1.name as manager,
    m2.name as manager_of_manager
FROM employees e
LEFT JOIN employees m1 ON e.manager_id = m1.id
LEFT JOIN employees m2 ON m1.manager_id = m2.id;
```

**Count direct reports for each manager:**
```sql
SELECT 
    m.name as manager_name,
    COUNT(e.id) as direct_reports
FROM employees m
LEFT JOIN employees e ON m.id = e.manager_id
GROUP BY m.name
ORDER BY direct_reports DESC;
```

**Find employees at the same level (same manager):**
```sql
SELECT 
    e1.name as employee1,
    e2.name as employee2,
    m.name as shared_manager
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.manager_id
JOIN employees m ON e1.manager_id = m.id
WHERE e1.id < e2.id;  -- Avoid duplicates and self-matches
```

### Self Join for Comparisons

**Find products in the same category:**
```sql
SELECT 
    p1.product_name as product1,
    p2.product_name as product2,
    p1.category,
    ABS(p1.price - p2.price) as price_difference
FROM products p1
JOIN products p2 
  ON p1.category = p2.category
  AND p1.id < p2.id  -- Avoid duplicates
WHERE ABS(p1.price - p2.price) < 10
ORDER BY price_difference;
```

**Find customers in the same city:**
```sql
SELECT 
    c1.customer_name as customer1,
    c2.customer_name as customer2,
    c1.city
FROM customers c1
JOIN customers c2 
  ON c1.city = c2.city
  AND c1.id < c2.id;
```

### Self Join for Sequences

**Find consecutive orders from the same customer:**
```sql
SELECT 
    o1.id as first_order,
    o2.id as next_order,
    o1.customer_id,
    o1.order_date as first_date,
    o2.order_date as next_date,
    o2.order_date - o1.order_date as days_between
FROM orders o1
JOIN orders o2 
  ON o1.customer_id = o2.customer_id
  AND o2.order_date > o1.order_date
WHERE o2.order_date - o1.order_date <= 7  -- Within 7 days
ORDER BY o1.customer_id, o1.order_date;
```

**Find gaps in sequences:**
```sql
-- Find missing order IDs
SELECT 
    o1.id as last_existing_id,
    o2.id as next_existing_id,
    o2.id - o1.id - 1 as missing_count
FROM orders o1
JOIN orders o2 ON o2.id > o1.id
WHERE NOT EXISTS (
    SELECT 1 FROM orders o3 
    WHERE o3.id > o1.id AND o3.id < o2.id
)
AND o2.id - o1.id > 1;
```

### Self Join for Relationships

**Find customers who bought the same product:**
```sql
SELECT 
    c1.customer_name as customer1,
    c2.customer_name as customer2,
    p.product_name
FROM order_items oi1
JOIN order_items oi2 ON oi1.product_id = oi2.product_id
JOIN orders o1 ON oi1.order_id = o1.id
JOIN orders o2 ON oi2.order_id = o2.id
JOIN customers c1 ON o1.customer_id = c1.id
JOIN customers c2 ON o2.customer_id = c2.id
JOIN products p ON oi1.product_id = p.id
WHERE c1.id < c2.id;
```

**Find products frequently bought together:**
```sql
SELECT 
    p1.product_name as product1,
    p2.product_name as product2,
    COUNT(*) as times_bought_together
FROM order_items oi1
JOIN order_items oi2 
  ON oi1.order_id = oi2.order_id
  AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.id
JOIN products p2 ON oi2.product_id = p2.id
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(*) >= 5
ORDER BY times_bought_together DESC;
```

### Self Join with Aggregations

**Compare each employee's salary to department average:**
```sql
SELECT 
    e.name,
    e.salary,
    AVG(e2.salary) as dept_avg_salary,
    e.salary - AVG(e2.salary) as difference_from_avg
FROM employees e
JOIN employees e2 ON e.department_id = e2.department_id
GROUP BY e.id, e.name, e.salary
ORDER BY difference_from_avg DESC;
```

**Find employees earning more than their manager:**
```sql
SELECT 
    e.name as employee,
    e.salary as employee_salary,
    m.name as manager,
    m.salary as manager_salary,
    e.salary - m.salary as difference
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > m.salary;
```

### Practical Example: Organization Chart

```sql
-- Complete org chart with levels
WITH RECURSIVE org_chart AS (
    -- Level 0: CEO (no manager)
    SELECT 
        id,
        name,
        manager_id,
        0 as level,
        name as path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive: each level down
    SELECT 
        e.id,
        e.name,
        e.manager_id,
        oc.level + 1,
        oc.path || ' > ' || e.name
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT 
    REPEAT('  ', level) || name as org_structure,
    level,
    path
FROM org_chart
ORDER BY path;
```

### Practical Example: Product Recommendations

```sql
-- "Customers who bought X also bought Y"
SELECT 
    p1.product_name as purchased_product,
    p2.product_name as also_purchased,
    COUNT(DISTINCT o1.customer_id) as customer_count,
    ROUND(COUNT(DISTINCT o1.customer_id) * 100.0 / 
          (SELECT COUNT(DISTINCT customer_id) 
           FROM orders o 
           JOIN order_items oi ON o.id = oi.order_id 
           WHERE oi.product_id = p1.id), 2) as percentage
FROM order_items oi1
JOIN order_items oi2 
  ON oi1.order_id = oi2.order_id
  AND oi1.product_id != oi2.product_id
JOIN orders o1 ON oi1.order_id = o1.id
JOIN products p1 ON oi1.product_id = p1.id
JOIN products p2 ON oi2.product_id = p2.id
WHERE p1.product_name = 'Laptop'
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(DISTINCT o1.customer_id) >= 3
ORDER BY customer_count DESC
LIMIT 10;
```

### Important Patterns

**Pattern 1: Avoid Self-Matches**
```sql
-- Use WHERE to exclude matching the same row
WHERE t1.id != t2.id

-- Or use < to avoid duplicates
WHERE t1.id < t2.id
```

**Pattern 2: Use LEFT JOIN for Optional Relationships**
```sql
-- Include employees without managers
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id
```

**Pattern 3: Multiple Self Joins**
```sql
-- Join the same table multiple times
FROM employees e
LEFT JOIN employees m1 ON e.manager_id = m1.id
LEFT JOIN employees m2 ON m1.manager_id = m2.id
```

### Common Use Cases

1. **Hierarchical Data**
   - Organization charts
   - Category trees
   - File system structures
   - Comment threads

2. **Comparisons**
   - Find similar products
   - Compare prices
   - Find duplicates
   - Identify outliers

3. **Sequences**
   - Find consecutive records
   - Calculate differences between rows
   - Identify gaps
   - Track changes over time

4. **Relationships**
   - Find common connections
   - Product recommendations
   - Social network analysis
   - Collaborative filtering

### Best Practices

1. **Always use clear aliases** - e (employee), m (manager), p1, p2
2. **Use WHERE to avoid self-matches** - t1.id != t2.id or t1.id < t2.id
3. **Consider performance** - Self joins can be expensive on large tables
4. **Use LEFT JOIN when appropriate** - Include records without matches
5. **Add indexes** - On join columns (manager_id, etc.)

### Common Mistakes

**Mistake 1: Forgetting to exclude self-matches**
```sql
-- Wrong - includes matching each row to itself
SELECT p1.name, p2.name
FROM products p1
JOIN products p2 ON p1.category = p2.category;

-- Correct
SELECT p1.name, p2.name
FROM products p1
JOIN products p2 ON p1.category = p2.category
WHERE p1.id != p2.id;
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
-- Wrong - excludes CEO without manager
FROM employees e
JOIN employees m ON e.manager_id = m.id;

-- Correct
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day12.db` with sample data.

### Database Schema

**employees** table:
- id, name, manager_id, department_id, salary, hire_date

**products** table:
- id, product_name, category, price, cost

**customers** table:
- id, customer_name, city, state, registration_date

**orders** table:
- id, customer_id, order_date, total

**order_items** table:
- id, order_id, product_id, quantity, price

### Part 1: Employee-Manager Relationships (Easy)

### Exercise 1: Employees with Managers (Easy)
Write a query to show all employees with their manager's name.
Use LEFT JOIN to include employees without managers.

**Expected columns:** employee_name, manager_name

### Exercise 2: Count Direct Reports (Easy)
Write a query to show each manager with their count of direct reports.
Only include managers who have at least one direct report.

**Expected columns:** manager_name, direct_reports

**Hint:** Self join and GROUP BY

### Exercise 3: Employees Without Managers (Easy)
Write a query to find all employees who don't have a manager (top-level executives).

**Expected columns:** name, salary, hire_date

### Exercise 4: Manager's Manager (Medium)
Write a query to show each employee with their manager and their manager's manager.

**Expected columns:** employee_name, manager_name, manager_of_manager

**Hint:** Two self joins

### Exercise 5: Employees Earning More Than Manager (Medium)
Write a query to find employees who earn more than their manager.
Show employee name, employee salary, manager name, and manager salary.

**Expected columns:** employee_name, employee_salary, manager_name, manager_salary, difference

### Exercise 6: Same Department Colleagues (Medium)
Write a query to find pairs of employees who work in the same department.
Avoid duplicates and self-matches.

**Expected columns:** employee1, employee2, department_id

**Hint:** Use WHERE id < id to avoid duplicates

### Exercise 7: Salary Comparison (Medium)
Write a query to compare each employee's salary to the average salary in their department.
Show employee name, salary, department average, and difference.

**Expected columns:** name, salary, dept_avg_salary, difference_from_avg

### Part 2: Product Comparisons (Medium)

### Exercise 8: Products in Same Category (Easy)
Write a query to find pairs of products in the same category.
Avoid duplicates and self-matches.

**Expected columns:** product1, product2, category

### Exercise 9: Similar Priced Products (Medium)
Write a query to find pairs of products with prices within $10 of each other.
Show both products, their prices, and the price difference.

**Expected columns:** product1, price1, product2, price2, price_difference

**Hint:** Use ABS() for absolute difference

### Exercise 10: Product Price Comparison (Medium)
Write a query to compare each product's price to the average price in its category.
Show product name, price, category average, and percentage difference.

**Expected columns:** product_name, price, category_avg_price, pct_difference

### Exercise 11: Most Expensive vs Cheapest (Medium)
For each category, find the most expensive and cheapest products.
Show category, both products, and the price difference.

**Expected columns:** category, expensive_product, expensive_price, cheap_product, cheap_price, difference

**Hint:** Use subqueries or window functions with self join

### Part 3: Customer Relationships (Medium)

### Exercise 12: Customers in Same City (Easy)
Write a query to find pairs of customers in the same city.
Avoid duplicates and self-matches.

**Expected columns:** customer1, customer2, city

### Exercise 13: Customers in Same State (Medium)
Write a query to count how many other customers are in the same state as each customer.

**Expected columns:** customer_name, state, other_customers_in_state

### Exercise 14: Customer Registration Comparison (Medium)
Write a query to find pairs of customers who registered on the same day.

**Expected columns:** customer1, customer2, registration_date

### Part 4: Order Sequences (Hard)

### Exercise 15: Consecutive Orders (Medium)
Write a query to find consecutive orders from the same customer.
Show both order IDs, dates, and days between orders.

**Expected columns:** customer_id, first_order_id, first_order_date, second_order_id, second_order_date, days_between

**Hint:** Self join on customer_id where second date > first date

### Exercise 16: Quick Repeat Orders (Hard)
Write a query to find customers who placed another order within 7 days.
Show customer name, both order dates, and days between.

**Expected columns:** customer_name, first_order_date, second_order_date, days_between

### Exercise 17: Order Value Comparison (Medium)
Write a query to compare each customer's orders to their own average order value.
Show order ID, order total, customer average, and difference.

**Expected columns:** order_id, order_total, customer_avg, difference_from_avg

### Exercise 18: Increasing Order Values (Hard)
Write a query to find customers whose order values are consistently increasing.
Show customer name and their last 3 order values.

**Expected columns:** customer_name, order1_total, order2_total, order3_total

**Hint:** Multiple self joins with date ordering

### Part 5: Product Relationships (Hard)

### Exercise 19: Products Bought Together (Hard)
Write a query to find pairs of products that were bought together in the same order.
Show product names and how many times they were bought together.

**Expected columns:** product1, product2, times_together

**Hint:** Self join order_items on order_id, avoid duplicates

### Exercise 20: Frequently Bought Together (Hard)
Write a query to find the top 10 product pairs most frequently bought together.
Only include pairs bought together at least 3 times.

**Expected columns:** product1, product2, times_together

### Exercise 21: Product Recommendations (Very Hard)
For each product, find the top 3 products most frequently bought with it.
Show product name and recommended products with purchase count.

**Expected columns:** product_name, recommended_product, times_bought_together

**Hint:** Self join, GROUP BY, and use ROW_NUMBER() or LIMIT

### Exercise 22: Customers Who Bought Same Product (Medium)
Write a query to find pairs of customers who bought the same product.
Show customer names and product name.

**Expected columns:** customer1, customer2, product_name

### Part 6: Advanced Hierarchies (Hard)

### Exercise 23: Organization Depth (Hard)
Write a query to calculate how many levels deep each employee is in the organization.
Level 0 = CEO (no manager), Level 1 = reports to CEO, etc.

**Expected columns:** employee_name, level

**Hint:** Use recursive CTE or multiple self joins

### Exercise 24: All Subordinates (Very Hard)
Write a query to show each manager with ALL their subordinates (direct and indirect).
Show manager name and subordinate name.

**Expected columns:** manager_name, subordinate_name, levels_below

**Hint:** Recursive CTE

### Exercise 25: Salary Hierarchy (Hard)
Write a query to show the salary chain from each employee up to the CEO.
Show employee, their salary, manager's salary, and manager's manager's salary.

**Expected columns:** employee, emp_salary, manager_salary, manager_manager_salary

### Part 7: Comparisons and Analytics (Hard)

### Exercise 26: Above Average Performers (Medium)
Write a query to find employees whose salary is above the average of their peers (same manager).

**Expected columns:** employee_name, salary, peer_avg_salary, difference

### Exercise 27: Product Profit Comparison (Hard)
Write a query to compare each product's profit margin to others in its category.
Show product, its margin, category average margin, and rank.

**Expected columns:** product_name, profit_margin, category_avg_margin, rank_in_category

### Exercise 28: Customer Spending Comparison (Hard)
Write a query to compare each customer's total spending to others in their city.
Show customer, their total, city average, and their rank in city.

**Expected columns:** customer_name, total_spent, city_avg, rank_in_city

### Exercise 29: Order Size Patterns (Hard)
Write a query to find customers whose order sizes are increasing over time.
Compare each order to the previous order for the same customer.

**Expected columns:** customer_name, order_date, order_total, previous_order_total, change

**Hint:** Self join with date comparison

### Exercise 30: Complete Relationship Matrix (Very Hard)
Write a query to create a relationship matrix showing:
- Each employee
- Their manager
- Their peers (same manager)
- Their direct reports
- Their salary rank among peers

**Expected columns:** employee_name, manager_name, peer_count, direct_reports, salary_rank_among_peers

**Hint:** Multiple self joins and window functions

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
