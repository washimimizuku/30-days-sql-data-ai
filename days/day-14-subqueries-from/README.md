# Day 14: Subqueries in FROM

## Learning Objectives
- Understand subqueries in the FROM clause (derived tables)
- Learn to create temporary result sets for complex queries
- Master multi-level aggregations
- Use subqueries to simplify complex logic
- Build modular, readable SQL queries
- Prepare for CTEs (Common Table Expressions)

## Theory (15 minutes)

### What are Subqueries in FROM?

A subquery in the FROM clause (also called a "derived table" or "inline view") creates a temporary result set that acts as a table.

**Think of it as:** "Create a temporary table on-the-fly and query it"

**Syntax:**
```sql
SELECT columns
FROM (
    SELECT columns
    FROM table
    WHERE condition
) AS alias_name  -- Alias is REQUIRED!
WHERE condition;
```

### Simple Example

```sql
-- Categorize department averages
SELECT 
    dept_avg,
    CASE 
        WHEN dept_avg > 75000 THEN 'High Paying'
        WHEN dept_avg > 50000 THEN 'Medium Paying'
        ELSE 'Low Paying'
    END as pay_category
FROM (
    SELECT 
        department,
        AVG(salary) as dept_avg
    FROM employees
    GROUP BY department
) AS dept_averages;
```

**Why?** You can't use aggregate results directly in CASE without a subquery.

### Why Use Subqueries in FROM?

**1. Multi-level Aggregations**
```sql
-- Find departments with above-average average salary
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) AS dept_stats
WHERE avg_salary > (SELECT AVG(salary) FROM employees);
```

**2. Filter Aggregated Results**
```sql
-- Can't do this without subquery:
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
WHERE AVG(salary) > 70000;  -- ERROR!

-- With subquery (works):
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) AS dept_avg
WHERE avg_salary > 70000;
```

**3. Simplify Complex Logic**
```sql
-- Calculate percentage of total
SELECT 
    category,
    category_total,
    ROUND(category_total * 100.0 / overall_total, 2) as percentage
FROM (
    SELECT 
        category,
        SUM(sales) as category_total,
        (SELECT SUM(sales) FROM products) as overall_total
    FROM products
    GROUP BY category
) AS category_sales;
```

### Multiple Subqueries

Join multiple derived tables:

```sql
SELECT 
    cs.customer_name,
    cs.order_count,
    ps.product_variety
FROM (
    SELECT customer_id, customer_name, COUNT(*) as order_count
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY customer_id, customer_name
) AS cs
JOIN (
    SELECT customer_id, COUNT(DISTINCT product_id) as product_variety
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY customer_id
) AS ps ON cs.customer_id = ps.customer_id;
```

### Ranking Pattern

Common pattern: rank in subquery, filter in outer query:

```sql
-- Top 3 products per category
SELECT *
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.price) as revenue,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.price) DESC) as rank
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.category, p.product_name
) AS ranked_products
WHERE rank <= 3;
```

### Customer Segmentation Example

```sql
-- Segment customers and analyze segments
SELECT 
    segment,
    COUNT(*) as customer_count,
    AVG(total_spent) as avg_spent,
    SUM(total_spent) as segment_revenue
FROM (
    SELECT 
        customer_name,
        total_spent,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent > 1000 THEN 'High Value'
            ELSE 'Low Value'
        END as segment
    FROM (
        SELECT 
            c.customer_name,
            COALESCE(SUM(o.total), 0) as total_spent
        FROM customers c
        LEFT JOIN orders o ON c.id = o.customer_id
        GROUP BY c.customer_name
    ) AS customer_totals
) AS customer_segments
GROUP BY segment;
```

### Month-over-Month Growth

```sql
-- Calculate monthly revenue growth
SELECT 
    month,
    revenue,
    previous_month_revenue,
    revenue - previous_month_revenue as growth
FROM (
    SELECT 
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) as previous_month_revenue
    FROM (
        SELECT 
            DATE_TRUNC('month', order_date) as month,
            SUM(total) as revenue
        FROM orders
        WHERE status = 'completed'
        GROUP BY DATE_TRUNC('month', order_date)
    ) AS monthly_revenue
) AS revenue_with_previous
WHERE previous_month_revenue IS NOT NULL;
```

### Pivoting Data

```sql
-- Create pivot report
SELECT 
    product_name,
    SUM(CASE WHEN month = 1 THEN revenue ELSE 0 END) as jan_revenue,
    SUM(CASE WHEN month = 2 THEN revenue ELSE 0 END) as feb_revenue,
    SUM(CASE WHEN month = 3 THEN revenue ELSE 0 END) as mar_revenue
FROM (
    SELECT 
        p.product_name,
        EXTRACT(MONTH FROM o.order_date) as month,
        SUM(oi.quantity * oi.price) as revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2024
    GROUP BY p.product_name, EXTRACT(MONTH FROM o.order_date)
) AS monthly_sales
GROUP BY product_name;
```

### Best Practices

1. **Always use aliases** - Required for subqueries in FROM
2. **Filter early** - Apply WHERE in subquery when possible
3. **Select only needed columns** - Better performance
4. **Use meaningful names** - Makes queries readable
5. **Consider CTEs** - For complex queries (Day 15)

### Common Mistakes

**Mistake 1: Forgetting alias**
```sql
-- Wrong
SELECT * FROM (SELECT * FROM table);

-- Correct
SELECT * FROM (SELECT * FROM table) AS t;
```

**Mistake 2: Not filtering early**
```sql
-- Inefficient
SELECT * FROM (SELECT * FROM huge_table) AS t WHERE date = '2024-01-01';

-- Better
SELECT * FROM (SELECT * FROM huge_table WHERE date = '2024-01-01') AS t;
```

**Mistake 3: Selecting unnecessary columns**
```sql
-- Bad
SELECT customer_id FROM (SELECT * FROM orders) AS o;

-- Good
SELECT customer_id FROM (SELECT customer_id FROM orders) AS o;
```

### When to Use

**Use subqueries in FROM when you need to:**
- Aggregate aggregated data (multi-level aggregations)
- Apply logic to aggregate results
- Rank results then filter by rank
- Create temporary result sets for complex queries

**Consider alternatives:**
- CTEs (Day 15) - More readable for complex queries
- Views - For frequently used subqueries

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day14.db` with sample data for derived table practice.

### Database Schema
- **employees**: id, name, department, salary, hire_date
- **products**: id, product_name, category, price, cost, stock
- **customers**: id, customer_name, city, state, registration_date
- **orders**: id, customer_id, order_date, total, status
- **order_items**: id, order_id, product_id, quantity, price

### Part 1: Basic Derived Tables (5 exercises)

### Exercise 1: Simple Derived Table (Easy)
Get department average salaries, then filter for departments with average > 60000.

### Exercise 2: Aggregate of Aggregates (Easy)
Find the average of department average salaries.

### Exercise 3: Filter Aggregated Results (Easy)
Find customers with more than 3 orders using a subquery.

### Exercise 4: Add Calculated Column (Medium)
Get category sales totals with percentage of grand total.

### Exercise 5: Categorize Aggregated Data (Medium)
Categorize departments by average salary: High (>80000), Medium (60000-80000), Low (<60000).

### Part 2: Multi-Level Aggregations (4 exercises)

### Exercise 6: Top Spending Customers (Medium)
Find the top 10 customers by total spending.

### Exercise 7: Above Average Departments (Medium)
Find departments where average salary is above company average.

### Exercise 8: Monthly Revenue Analysis (Hard)
Show monthly revenue with previous month for comparison using LAG().

### Exercise 9: Customer Lifetime Value Segments (Hard)
Segment customers by spending: VIP (>5000), High (1000-5000), Medium (500-1000), Low (<500).
Show statistics for each segment.

### Part 3: Multiple Subqueries (3 exercises)

### Exercise 10: Join Two Subqueries (Medium)
Join customer order counts with product variety (distinct products bought).

### Exercise 11: Compare Products to Category Average (Medium)
Show each product with its category's average price and difference.

### Exercise 12: Customer and Order Statistics (Hard)
Combine customer total spending with order frequency. Filter for total_spent > 1000 AND order_count >= 3.

### Part 4: Ranking and Filtering (3 exercises)

### Exercise 13: Top 3 Products per Category (Medium)
Find top 3 products by revenue in each category using ROW_NUMBER().

### Exercise 14: Top Customers per City (Hard)
Find top 2 customers by spending in each city.

### Exercise 15: Products Above Category Median (Hard)
Find products priced above their category's median using PERCENTILE_CONT(0.5).

### Part 5: Complex Business Logic (2 exercises)

### Exercise 16: Product Profitability Analysis (Hard)
Show products with revenue, cost, profit, profit margin, and rank by margin in category.

### Exercise 17: Customer Purchase Patterns (Hard)
Analyze: total orders, total spent, avg order value, days since last order.
Include only customers with at least 2 orders.

### Part 6: Pivoting and Reshaping (2 exercises)

### Exercise 18: Monthly Sales Pivot (Medium)
Create pivot with categories as rows and months (1-3) as columns showing revenue.

### Exercise 19: Category Performance Matrix (Hard)
Create matrix with categories as rows and quarters as columns showing revenue.

### Part 7: Advanced Patterns (1 exercise)

### Exercise 20: Customer Segmentation Matrix (Very Hard)
Create 2D segmentation by order frequency (High/Medium/Low) and avg order value (High/Medium/Low).
Show count and total revenue for each combination.

## Key Takeaways

- **Subqueries in FROM create derived tables** - Temporary result sets
- **Always use an alias** - Required for subqueries in FROM (AS alias_name)
- **Enable multi-level aggregations** - Aggregate, then aggregate again
- **Simplify complex logic** - Break queries into logical steps
- **Filter early** - Apply WHERE in subquery for better performance
- **Can join multiple subqueries** - Combine different aggregations
- **Can nest subqueries** - Subqueries within subqueries
- **Great for ranking then filtering** - Use ROW_NUMBER(), then WHERE rank <= N
- **Prepare for CTEs** - CTEs (Day 15) are more readable for complex queries
- **Consider performance** - Only select needed columns, filter early
- **Use meaningful aliases** - Makes queries more readable

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 15
