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

A subquery in the FROM clause (also called a "derived table" or "inline view") is a SELECT statement that acts as a table in your main query.

**Think of it as:** "Create a temporary table on-the-fly and query it"

### Basic Syntax

```sql
SELECT columns
FROM (
    SELECT columns
    FROM table
    WHERE condition
) AS alias_name
WHERE condition;
```

**Critical:** You MUST give the subquery an alias (AS alias_name)

### Simple Example

```sql
-- Without subquery (limited)
SELECT AVG(salary) FROM employees;

-- With subquery - query the aggregated results
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

**Why use a subquery?** You can't use aggregate results directly in CASE statements without a subquery.

### Why Use Subqueries in FROM?

**Reason 1: Multi-level Aggregations**
```sql
-- Find departments with above-average average salary
SELECT department, avg_salary
FROM (
    SELECT 
        department,
        AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) AS dept_stats
WHERE avg_salary > (SELECT AVG(salary) FROM employees);
```

**Reason 2: Simplify Complex Logic**
```sql
-- Calculate percentage of total for each category
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

**Reason 3: Pre-filter Data**
```sql
-- Work with a subset of data
SELECT 
    customer_name,
    order_count,
    total_spent
FROM (
    SELECT 
        c.customer_name,
        COUNT(o.id) as order_count,
        SUM(o.total) as total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_name
) AS customer_stats
WHERE order_count >= 5
ORDER BY total_spent DESC;
```

### Subquery vs Regular Query

**Without subquery (doesn't work):**
```sql
-- ERROR: Can't use aggregate in WHERE
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
WHERE AVG(salary) > 70000;  -- ERROR!
```

**With HAVING (works but limited):**
```sql
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 70000;
```

**With subquery (more flexible):**
```sql
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) AS dept_avg
WHERE avg_salary > 70000
ORDER BY avg_salary DESC;
```

### Multiple Subqueries in FROM

You can join multiple subqueries:

```sql
SELECT 
    cs.customer_name,
    cs.order_count,
    ps.product_count,
    cs.total_spent
FROM (
    -- Customer order stats
    SELECT 
        customer_id,
        customer_name,
        COUNT(*) as order_count,
        SUM(total) as total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY customer_id, customer_name
) AS cs
JOIN (
    -- Customer product variety
    SELECT 
        o.customer_id,
        COUNT(DISTINCT oi.product_id) as product_count
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    GROUP BY o.customer_id
) AS ps ON cs.customer_id = ps.customer_id
WHERE cs.order_count >= 3;
```

### Nested Subqueries

Subqueries can contain subqueries:

```sql
-- Three levels deep
SELECT 
    category,
    high_value_customers,
    avg_order_value
FROM (
    SELECT 
        category,
        COUNT(*) as high_value_customers,
        AVG(total_spent) as avg_order_value
    FROM (
        SELECT 
            p.category,
            o.customer_id,
            SUM(oi.quantity * oi.price) as total_spent
        FROM orders o
        JOIN order_items oi ON o.id = oi.order_id
        JOIN products p ON oi.product_id = p.id
        GROUP BY p.category, o.customer_id
        HAVING SUM(oi.quantity * oi.price) > 1000
    ) AS high_spenders
    GROUP BY category
) AS category_stats
WHERE high_value_customers >= 5;
```

### Practical Example: Top Customers by Category

```sql
-- Find top 3 customers in each category
SELECT 
    category,
    customer_name,
    total_spent,
    rank_in_category
FROM (
    SELECT 
        p.category,
        c.customer_name,
        SUM(oi.quantity * oi.price) as total_spent,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.price) DESC) as rank_in_category
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
    GROUP BY p.category, c.customer_name
) AS customer_category_spending
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;
```

### Practical Example: Month-over-Month Growth

```sql
-- Calculate monthly revenue growth
SELECT 
    month,
    revenue,
    previous_month_revenue,
    revenue - previous_month_revenue as growth,
    ROUND((revenue - previous_month_revenue) * 100.0 / previous_month_revenue, 2) as growth_pct
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
WHERE previous_month_revenue IS NOT NULL
ORDER BY month;
```

### Practical Example: Customer Segmentation

```sql
-- Segment customers and analyze each segment
SELECT 
    segment,
    COUNT(*) as customer_count,
    AVG(total_spent) as avg_spent,
    AVG(order_count) as avg_orders,
    SUM(total_spent) as segment_revenue
FROM (
    SELECT 
        customer_name,
        order_count,
        total_spent,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent > 1000 THEN 'High Value'
            WHEN total_spent > 500 THEN 'Medium Value'
            ELSE 'Low Value'
        END as segment
    FROM (
        SELECT 
            c.customer_name,
            COUNT(o.id) as order_count,
            COALESCE(SUM(o.total), 0) as total_spent
        FROM customers c
        LEFT JOIN orders o ON c.id = o.customer_id
        GROUP BY c.customer_name
    ) AS customer_stats
) AS customer_segments
GROUP BY segment
ORDER BY segment_revenue DESC;
```

### Subqueries with Aggregations

**Pattern: Aggregate, then aggregate again**
```sql
-- Average of department averages
SELECT 
    AVG(dept_avg_salary) as company_avg_of_dept_avgs,
    MIN(dept_avg_salary) as lowest_dept_avg,
    MAX(dept_avg_salary) as highest_dept_avg
FROM (
    SELECT 
        department,
        AVG(salary) as dept_avg_salary
    FROM employees
    GROUP BY department
) AS dept_averages;
```

### Subqueries with JOINs

Join subqueries to base tables:

```sql
-- Compare each product to category average
SELECT 
    p.product_name,
    p.price,
    ca.avg_price as category_avg,
    p.price - ca.avg_price as difference,
    ROUND((p.price - ca.avg_price) * 100.0 / ca.avg_price, 2) as pct_difference
FROM products p
JOIN (
    SELECT 
        category,
        AVG(price) as avg_price
    FROM products
    GROUP BY category
) AS ca ON p.category = ca.category
ORDER BY pct_difference DESC;
```

### Subqueries for Ranking

```sql
-- Top 5 products by revenue in each category
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
WHERE rank <= 5
ORDER BY category, rank;
```

### Subqueries for Pivoting

```sql
-- Create a pivot-like report
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

### Performance Considerations

**Good: Pre-filter in subquery**
```sql
SELECT *
FROM (
    SELECT * 
    FROM large_table 
    WHERE date >= '2024-01-01'  -- Filter early
) AS recent_data
WHERE status = 'active';
```

**Bad: Filter after subquery**
```sql
SELECT *
FROM (
    SELECT * 
    FROM large_table  -- Processes all rows
) AS all_data
WHERE date >= '2024-01-01' AND status = 'active';
```

### Best Practices

1. **Always use aliases** - Required for subqueries in FROM
2. **Filter early** - Apply WHERE in the subquery when possible
3. **Keep it readable** - Use meaningful alias names
4. **Consider CTEs** - For complex queries, CTEs are more readable (Day 15)
5. **Limit columns** - Only SELECT columns you need in subquery
6. **Add comments** - Explain what each subquery does

### Common Mistakes

**Mistake 1: Forgetting alias**
```sql
-- Wrong - no alias
SELECT * FROM (SELECT * FROM table);

-- Correct
SELECT * FROM (SELECT * FROM table) AS t;
```

**Mistake 2: Selecting unnecessary columns**
```sql
-- Bad - selects all columns
SELECT customer_id, order_count
FROM (SELECT * FROM orders) AS o;

-- Good - only needed columns
SELECT customer_id, order_count
FROM (SELECT customer_id, COUNT(*) as order_count FROM orders GROUP BY customer_id) AS o;
```

**Mistake 3: Not filtering in subquery**
```sql
-- Inefficient
SELECT * FROM (SELECT * FROM huge_table) AS t WHERE date = '2024-01-01';

-- Better
SELECT * FROM (SELECT * FROM huge_table WHERE date = '2024-01-01') AS t;
```

### When to Use Subqueries in FROM

**Use when you need to:**
- Aggregate aggregated data (multi-level aggregations)
- Apply logic to aggregate results
- Create temporary result sets for complex queries
- Rank or window function results, then filter
- Simplify complex queries into logical steps

**Consider alternatives:**
- CTEs (Day 15) - More readable for complex queries
- Views - For frequently used subqueries
- Temporary tables - For very large intermediate results

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day14.db` with sample data.

### Database Schema

**employees** table:
- id, name, department, salary, hire_date

**products** table:
- id, product_name, category, price, cost, stock

**customers** table:
- id, customer_name, city, state, registration_date

**orders** table:
- id, customer_id, order_date, total, status

**order_items** table:
- id, order_id, product_id, quantity, price

### Part 1: Basic Subqueries in FROM (Easy)

### Exercise 1: Simple Derived Table (Easy)
Write a query using a subquery to get department average salaries, then filter for departments with average > 60000.

**Expected columns:** department, avg_salary

**Hint:** Subquery does GROUP BY, outer query does WHERE

### Exercise 2: Aggregate of Aggregates (Easy)
Write a query to find the average of department average salaries.

**Expected columns:** avg_of_dept_averages

**Hint:** Subquery calculates dept averages, outer query calculates AVG of those

### Exercise 3: Filter Aggregated Results (Easy)
Write a query to find customers with more than 3 orders. Use a subquery to count orders, then filter.

**Expected columns:** customer_name, order_count

### Exercise 4: Add Calculated Column (Medium)
Write a query using a subquery to get category totals, then add a column showing percentage of grand total.

**Expected columns:** category, category_total, percentage_of_total

**Hint:** Include grand total in subquery, calculate percentage in outer query

### Exercise 5: Categorize Aggregated Data (Medium)
Write a query to categorize departments by average salary:
- High: > 70000
- Medium: 50000-70000
- Low: < 50000

**Expected columns:** department, avg_salary, pay_category

**Hint:** Subquery aggregates, outer query uses CASE

### Part 2: Multi-Level Aggregations (Medium)

### Exercise 6: Top Spending Customers (Medium)
Write a query to find the top 10 customers by total spending. Use a subquery to calculate totals.

**Expected columns:** customer_name, total_spent

### Exercise 7: Above Average Departments (Medium)
Write a query to find departments where the average salary is above the company average.

**Expected columns:** department, dept_avg_salary, company_avg_salary, difference

**Hint:** Subquery for dept averages, compare to overall average

### Exercise 8: Product Performance Tiers (Medium)
Write a query to categorize products by revenue into Top 20%, Middle 60%, Bottom 20%.

**Expected columns:** product_name, revenue, tier

**Hint:** Subquery calculates revenue, outer query uses NTILE or percentile logic

### Exercise 9: Monthly Revenue Analysis (Hard)
Write a query to show monthly revenue with previous month for comparison.

**Expected columns:** month, revenue, previous_month_revenue, growth

**Hint:** Subquery aggregates by month, outer query uses LAG()

### Exercise 10: Customer Lifetime Value Segments (Hard)
Write a query to segment customers by LTV and show statistics for each segment.

**Expected columns:** segment, customer_count, avg_ltv, total_revenue

**Hint:** Inner subquery calculates LTV, middle subquery segments, outer aggregates

### Part 3: Multiple Subqueries (Medium-Hard)

### Exercise 11: Join Two Subqueries (Medium)
Write a query joining two subqueries:
- Customer order counts
- Customer product variety (distinct products bought)

**Expected columns:** customer_name, order_count, product_variety

### Exercise 12: Compare Products to Category Average (Medium)
Write a query to show each product with its category's average price and the difference.

**Expected columns:** product_name, price, category_avg_price, difference

**Hint:** Join products table to subquery of category averages

### Exercise 13: Customer and Order Statistics (Hard)
Write a query combining:
- Customer total spending (subquery 1)
- Customer order frequency (subquery 2)
- Customer product preferences (subquery 3)

**Expected columns:** customer_name, total_spent, order_count, favorite_category

### Exercise 14: Multi-Dimensional Analysis (Hard)
Write a query to analyze sales by category and month, showing:
- Revenue per category per month
- Category's percentage of that month's total

**Expected columns:** category, month, revenue, pct_of_month_total

### Part 4: Ranking and Filtering (Hard)

### Exercise 15: Top 3 Products per Category (Medium)
Write a query to find the top 3 products by revenue in each category.

**Expected columns:** category, product_name, revenue, rank_in_category

**Hint:** Subquery with ROW_NUMBER(), outer query filters rank <= 3

### Exercise 16: Top Customers per City (Hard)
Write a query to find the top 2 customers by spending in each city.

**Expected columns:** city, customer_name, total_spent, rank_in_city

### Exercise 17: Products Above Category Median (Hard)
Write a query to find products priced above their category's median price.

**Expected columns:** product_name, category, price, category_median

**Hint:** Subquery calculates median per category, join and filter

### Exercise 18: Consistent Top Performers (Very Hard)
Write a query to find products in the top 10 by revenue for at least 3 different months.

**Expected columns:** product_name, months_in_top_10, total_revenue

**Hint:** Multiple subqueries with ranking and counting

### Part 5: Complex Business Logic (Hard)

### Exercise 19: Customer Churn Analysis (Hard)
Write a query to identify customers who:
- Ordered in Q1 2024
- Did NOT order in Q2 2024
- Show their Q1 spending

**Expected columns:** customer_name, q1_orders, q1_spending

**Hint:** Subquery for Q1 customers, filter out those in Q2 subquery

### Exercise 20: Product Profitability Analysis (Hard)
Write a query to show products with:
- Revenue
- Cost
- Profit
- Profit margin
- Rank by profit margin in category

**Expected columns:** product_name, category, revenue, profit, profit_margin, rank_in_category

### Exercise 21: Customer Purchase Patterns (Very Hard)
Write a query to analyze customer purchase patterns:
- Average days between orders
- Order value trend (increasing/decreasing/stable)
- Product variety trend

**Expected columns:** customer_name, avg_days_between_orders, order_value_trend, variety_trend

**Hint:** Multiple nested subqueries with window functions

### Exercise 22: Market Basket Analysis (Very Hard)
Write a query to find product pairs frequently bought together, showing:
- Product pair
- Times bought together
- Percentage of orders containing product 1 that also contain product 2

**Expected columns:** product1, product2, times_together, pct_of_product1_orders

### Part 6: Pivoting and Reshaping (Hard)

### Exercise 23: Monthly Sales Pivot (Medium)
Write a query to create a pivot showing products as rows and months as columns with revenue.

**Expected columns:** product_name, jan_revenue, feb_revenue, mar_revenue

**Hint:** Subquery with month and revenue, outer query with CASE for each month

### Exercise 24: Category Performance Matrix (Hard)
Write a query to create a matrix showing:
- Categories as rows
- Quarters as columns
- Revenue in cells

**Expected columns:** category, q1_revenue, q2_revenue, q3_revenue, q4_revenue

### Exercise 25: Customer Cohort Analysis (Very Hard)
Write a query to analyze customer cohorts by registration month:
- Cohort (registration month)
- Customers in cohort
- Total revenue from cohort
- Average LTV
- Retention rate (% who ordered in last 3 months)

**Expected columns:** cohort_month, customer_count, total_revenue, avg_ltv, retention_rate

### Part 7: Advanced Patterns (Very Hard)

### Exercise 26: Running Totals by Category (Hard)
Write a query to show daily sales with running total by category.

**Expected columns:** date, category, daily_revenue, running_total

**Hint:** Subquery for daily totals, outer query with window function

### Exercise 27: Percentile Analysis (Hard)
Write a query to show products with their revenue percentile within their category.

**Expected columns:** product_name, category, revenue, percentile_in_category

**Hint:** Use PERCENT_RANK() in subquery

### Exercise 28: Gap Analysis (Very Hard)
Write a query to find gaps in daily orders:
- Dates with no orders
- Days since last order
- Revenue lost (estimated)

**Expected columns:** gap_date, days_since_last_order, estimated_lost_revenue

**Hint:** Generate date series, LEFT JOIN to orders subquery

### Exercise 29: Customer Segmentation Matrix (Very Hard)
Write a query to create a 2D segmentation:
- Segment by order frequency (High/Medium/Low)
- Segment by order value (High/Medium/Low)
- Show count and revenue for each cell

**Expected columns:** frequency_segment, value_segment, customer_count, total_revenue

**Hint:** Multiple nested subqueries with CASE statements

### Exercise 30: Complete Business Dashboard (Very Hard)
Write a query to create a comprehensive dashboard using multiple subqueries:
- Total customers and active customers
- Total products and products sold
- Total orders by status
- Revenue by category
- Top 5 customers
- Top 5 products
- Monthly revenue trend

**Expected columns:** metric_name, metric_value, additional_details

**Hint:** UNION multiple subqueries or use CROSS JOIN with aggregates

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
