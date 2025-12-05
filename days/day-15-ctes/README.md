# Day 15: CTEs (Common Table Expressions)

## Learning Objectives
- Understand CTEs (Common Table Expressions) and the WITH clause
- Learn to write readable, modular SQL queries
- Master multiple CTEs in one query
- Understand recursive CTEs for hierarchical data
- Replace complex subqueries with cleaner CTEs
- Build maintainable SQL code

## Theory (15 minutes)

### What are CTEs?

A CTE (Common Table Expression) is a named temporary result set - like a named subquery you can reference multiple times.

**Syntax:**
```sql
WITH cte_name AS (
    SELECT columns FROM table WHERE condition
)
SELECT * FROM cte_name;
```

### Simple Example

**Without CTE:**
```sql
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees GROUP BY department
) AS dept_avg
WHERE avg_salary > 60000;
```

**With CTE (cleaner):**
```sql
WITH dept_avg AS (
    SELECT department, AVG(salary) as avg_salary
    FROM employees GROUP BY department
)
SELECT department, avg_salary
FROM dept_avg
WHERE avg_salary > 60000;
```

### Why Use CTEs?

1. **Readability** - Break complex queries into logical steps
2. **Reusability** - Reference same CTE multiple times
3. **Maintainability** - Easier to modify than nested subqueries
4. **Recursion** - CTEs can be recursive (subqueries cannot)

### Multiple CTEs

Separate with commas, not multiple WITH:

```sql
WITH 
customer_totals AS (
    SELECT customer_id, COUNT(*) as order_count, SUM(total) as total_spent
    FROM orders GROUP BY customer_id
),
customer_segments AS (
    SELECT 
        customer_id,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent > 1000 THEN 'High Value'
            ELSE 'Regular'
        END as segment
    FROM customer_totals
)
SELECT c.customer_name, ct.order_count, cs.segment
FROM customers c
JOIN customer_totals ct ON c.id = ct.customer_id
JOIN customer_segments cs ON c.id = cs.customer_id;
```

### CTEs Referencing CTEs

CTEs can reference previously defined CTEs:

```sql
WITH 
monthly_revenue AS (
    SELECT DATE_TRUNC('month', order_date) as month, SUM(total) as revenue
    FROM orders GROUP BY DATE_TRUNC('month', order_date)
),
revenue_with_previous AS (
    SELECT month, revenue, LAG(revenue) OVER (ORDER BY month) as prev_month_revenue
    FROM monthly_revenue
),
revenue_growth AS (
    SELECT month, revenue, prev_month_revenue,
        ROUND((revenue - prev_month_revenue) * 100.0 / prev_month_revenue, 2) as growth_pct
    FROM revenue_with_previous
    WHERE prev_month_revenue IS NOT NULL
)
SELECT * FROM revenue_growth;
```

### Customer Segmentation Example

```sql
WITH 
customer_metrics AS (
    SELECT 
        c.customer_name,
        COUNT(o.id) as order_count,
        COALESCE(SUM(o.total), 0) as total_spent,
        MAX(o.order_date) as last_order
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
),
customer_segments AS (
    SELECT 
        *,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent > 1000 THEN 'High Value'
            ELSE 'Regular'
        END as segment
    FROM customer_metrics
)
SELECT segment, COUNT(*) as customer_count, SUM(total_spent) as segment_revenue
FROM customer_segments
GROUP BY segment;
```

### Recursive CTEs

Recursive CTEs call themselves - perfect for hierarchical data:

**Syntax:**
```sql
WITH RECURSIVE cte_name AS (
    -- Base case
    SELECT ...
    UNION ALL
    -- Recursive case
    SELECT ... FROM cte_name WHERE ...
)
SELECT * FROM cte_name;
```

**Organization Chart Example:**
```sql
WITH RECURSIVE org_chart AS (
    SELECT id, name, manager_id, 0 as level, name as path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.id, e.name, e.manager_id, oc.level + 1, oc.path || ' > ' || e.name
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT REPEAT('  ', level) || name as org_structure, level, path
FROM org_chart
ORDER BY path;
```

**Number Series Example:**
```sql
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;
```

### Best Practices

1. **Use descriptive names** - `customer_totals` not `cte1`
2. **One CTE per logical step** - Break complex logic into steps
3. **Order matters** - Define CTEs before referencing them
4. **Filter early** - Apply WHERE in CTEs when possible
5. **Don't overuse** - Simple queries don't need CTEs

### Common Patterns

**Ranking and Filtering:**
```sql
WITH ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as rank
    FROM products
)
SELECT * FROM ranked WHERE rank <= 5;
```

**Multi-level Aggregation:**
```sql
WITH 
sales_by_product AS (
    SELECT product_id, SUM(quantity) as total_sold FROM order_items GROUP BY product_id
),
sales_by_category AS (
    SELECT p.category, SUM(s.total_sold) as category_total
    FROM sales_by_product s
    JOIN products p ON s.product_id = p.id
    GROUP BY p.category
)
SELECT * FROM sales_by_category;
```

### Common Mistakes

**Mistake 1: Multiple WITH keywords**
```sql
-- Wrong
WITH cte1 AS (...) WITH cte2 AS (...)

-- Correct
WITH cte1 AS (...), cte2 AS (...)
```

**Mistake 2: Wrong order**
```sql
-- Wrong - cte2 references cte1 before it's defined
WITH cte2 AS (SELECT * FROM cte1), cte1 AS (...)

-- Correct
WITH cte1 AS (...), cte2 AS (SELECT * FROM cte1)
```

**Mistake 3: Forgetting RECURSIVE**
```sql
-- Wrong
WITH org_chart AS (... UNION ALL ...)

-- Correct
WITH RECURSIVE org_chart AS (... UNION ALL ...)
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day15.db` with sample data including hierarchical employee structure for recursive CTEs.

### Database Schema
- **employees**: id, name, manager_id, department, salary, hire_date
- **products**: id, product_name, category, price, cost, stock
- **customers**: id, customer_name, email, city, state, registration_date
- **orders**: id, customer_id, order_date, total, status
- **order_items**: id, order_id, product_id, quantity, price

### Part 1: Basic CTEs (3 exercises)

### Exercise 1: Simple CTE (Easy)
Rewrite subquery as CTE: find departments with avg salary > 60000.

### Exercise 2: CTE with Filtering (Easy)
Use CTE to find customers who spent more than $1000 total.

### Exercise 3: CTE for Readability (Easy)
Use CTE to find products priced above their category average.

### Part 2: Multiple CTEs (4 exercises)

### Exercise 4: Two CTEs (Medium)
Two CTEs: customer order counts and total spending. Join in main query.

### Exercise 5: Three CTEs (Medium)
Three CTEs: monthly revenue, add previous month (LAG), calculate growth %.

### Exercise 6: CTEs Referencing CTEs (Medium)
CTE1: customer totals, CTE2: segment (ref CTE1), CTE3: aggregate by segment (ref CTE2).

### Exercise 7: Complex CTE Chain (Hard)
4 CTEs: product sales → profitability → rankings → category summaries.

### Part 3: CTEs for Analysis (3 exercises)

### Exercise 8: Customer Segmentation (Medium)
Segment customers by spending: VIP (>5000), High (1000-5000), Medium (500-1000), Low (<500).

### Exercise 9: Product Performance Dashboard (Hard)
Multiple CTEs for dashboard: sales metrics, profitability, inventory status.

### Exercise 10: Customer Lifetime Value (Hard)
Calculate: first/last purchase, total orders, total spent, avg order value, lifespan.

### Part 4: Ranking and Top-N (3 exercises)

### Exercise 11: Top 3 per Category (Medium)
Use CTE with ROW_NUMBER() to find top 3 products by revenue per category.

### Exercise 12: Top Customers per City (Medium)
Find top 2 customers by spending in each city.

### Exercise 13: Best and Worst Performers (Hard)
Find top 5 and bottom 5 products by profit. Combine with UNION.

### Part 5: Recursive CTEs (4 exercises)

### Exercise 14: Number Series (Easy)
Recursive CTE to generate numbers 1 to 20.

### Exercise 15: Date Series (Medium)
Recursive CTE to generate all dates in January 2024.

### Exercise 16: Organization Chart (Medium)
Recursive CTE for org hierarchy with levels and paths.

### Exercise 17: All Subordinates (Hard)
Recursive CTE showing each manager with ALL subordinates (direct and indirect).

### Part 6: Complex Business Logic (3 exercises)

### Exercise 18: Customer Churn Prediction (Hard)
Identify at-risk customers: days since last order, avg days between orders, risk level.

### Exercise 19: Inventory Reorder Report (Hard)
Calculate daily sales rate and days of stock remaining. Flag reorder needed.

### Exercise 20: Sales Reconciliation (Hard)
Reconcile: sum of order totals vs sum of order_items totals. Find discrepancies.

## Key Takeaways

- **CTEs make queries readable** - Break complex logic into named steps
- **Use WITH clause** - Define CTEs before main query
- **Multiple CTEs with commas** - Separate with commas, not multiple WITH
- **CTEs can reference other CTEs** - Build on previous results
- **Recursive CTEs for hierarchies** - Use WITH RECURSIVE
- **Better than nested subqueries** - More maintainable and readable
- **Can reuse CTEs** - Reference same CTE multiple times
- **Use descriptive names** - customer_totals not cte1
- **One CTE per logical step** - Don't try to do everything in one CTE
- **Order matters** - Define CTEs before referencing them
- **Great for complex analysis** - Segmentation, cohorts, rankings
- **Prepare for production** - CTEs make code maintainable

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 16
