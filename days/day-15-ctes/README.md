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

A CTE (Common Table Expression) is a named temporary result set that exists only during query execution. Think of it as a named subquery that you can reference multiple times.

**Think of it as:** "Give a name to a subquery and reuse it"

### Basic CTE Syntax

```sql
WITH cte_name AS (
    SELECT columns
    FROM table
    WHERE condition
)
SELECT *
FROM cte_name;
```

**Key parts:**
- `WITH` - Starts the CTE definition
- `cte_name` - Name you give to the CTE
- `AS (...)` - The query that defines the CTE
- Main query - Uses the CTE like a table

### Simple Example

**Without CTE (subquery in FROM):**
```sql
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
) AS dept_avg
WHERE avg_salary > 60000;
```

**With CTE (cleaner):**
```sql
WITH dept_avg AS (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
)
SELECT department, avg_salary
FROM dept_avg
WHERE avg_salary > 60000;
```

**Benefits:** More readable, named result set, can reference multiple times

### Why Use CTEs?

**Reason 1: Readability**
CTEs make complex queries easier to understand by breaking them into logical steps.

**Reason 2: Reusability**
Reference the same CTE multiple times in one query (can't do with subqueries).

**Reason 3: Maintainability**
Easier to modify and debug than nested subqueries.

**Reason 4: Recursion**
CTEs can be recursive (subqueries cannot).

### Multiple CTEs

You can define multiple CTEs in one query:

```sql
WITH 
customer_totals AS (
    SELECT 
        customer_id,
        COUNT(*) as order_count,
        SUM(total) as total_spent
    FROM orders
    GROUP BY customer_id
),
customer_categories AS (
    SELECT 
        customer_id,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent > 1000 THEN 'High Value'
            ELSE 'Regular'
        END as category
    FROM customer_totals
)
SELECT 
    c.customer_name,
    ct.order_count,
    ct.total_spent,
    cc.category
FROM customers c
JOIN customer_totals ct ON c.id = ct.customer_id
JOIN customer_categories cc ON c.id = cc.customer_id
ORDER BY ct.total_spent DESC;
```

**Note:** Separate multiple CTEs with commas, not multiple WITH keywords.

### CTEs Referencing Other CTEs

CTEs can reference previously defined CTEs:

```sql
WITH 
-- Step 1: Calculate monthly revenue
monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(total) as revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
-- Step 2: Add previous month (references monthly_revenue)
revenue_with_previous AS (
    SELECT 
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) as prev_month_revenue
    FROM monthly_revenue
),
-- Step 3: Calculate growth (references revenue_with_previous)
revenue_growth AS (
    SELECT 
        month,
        revenue,
        prev_month_revenue,
        revenue - prev_month_revenue as growth,
        ROUND((revenue - prev_month_revenue) * 100.0 / prev_month_revenue, 2) as growth_pct
    FROM revenue_with_previous
    WHERE prev_month_revenue IS NOT NULL
)
SELECT * FROM revenue_growth
ORDER BY month;
```

### CTE vs Subquery in FROM

**Subquery approach:**
```sql
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT customer_id, SUM(total) as total_spent
        FROM orders
        GROUP BY customer_id
    ) AS totals
    WHERE total_spent > 1000
) AS high_value
WHERE customer_id IN (SELECT id FROM customers WHERE city = 'Seattle');
```

**CTE approach (much cleaner):**
```sql
WITH 
order_totals AS (
    SELECT customer_id, SUM(total) as total_spent
    FROM orders
    GROUP BY customer_id
),
high_value_customers AS (
    SELECT * FROM order_totals
    WHERE total_spent > 1000
),
seattle_customers AS (
    SELECT id FROM customers WHERE city = 'Seattle'
)
SELECT *
FROM high_value_customers
WHERE customer_id IN (SELECT id FROM seattle_customers);
```

### Practical Example: Customer Analysis

```sql
WITH 
-- Calculate customer metrics
customer_metrics AS (
    SELECT 
        c.id,
        c.customer_name,
        c.city,
        COUNT(o.id) as order_count,
        COALESCE(SUM(o.total), 0) as total_spent,
        COALESCE(AVG(o.total), 0) as avg_order_value,
        MIN(o.order_date) as first_order,
        MAX(o.order_date) as last_order
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id, c.customer_name, c.city
),
-- Segment customers
customer_segments AS (
    SELECT 
        *,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent > 1000 THEN 'High Value'
            WHEN total_spent > 0 THEN 'Regular'
            ELSE 'Never Ordered'
        END as segment,
        CASE 
            WHEN last_order >= CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
            WHEN last_order >= CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
            WHEN last_order IS NOT NULL THEN 'Churned'
            ELSE 'Never Ordered'
        END as status
    FROM customer_metrics
)
-- Final report
SELECT 
    segment,
    status,
    COUNT(*) as customer_count,
    SUM(total_spent) as segment_revenue,
    AVG(avg_order_value) as avg_order_value
FROM customer_segments
GROUP BY segment, status
ORDER BY segment_revenue DESC;
```

### Practical Example: Product Performance

```sql
WITH 
-- Product sales
product_sales AS (
    SELECT 
        p.id,
        p.product_name,
        p.category,
        p.price,
        p.cost,
        COALESCE(SUM(oi.quantity), 0) as units_sold,
        COALESCE(SUM(oi.quantity * oi.price), 0) as revenue,
        COALESCE(SUM(oi.quantity * p.cost), 0) as total_cost
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.id, p.product_name, p.category, p.price, p.cost
),
-- Calculate profitability
product_profitability AS (
    SELECT 
        *,
        revenue - total_cost as profit,
        CASE 
            WHEN revenue > 0 THEN ROUND((revenue - total_cost) * 100.0 / revenue, 2)
            ELSE 0
        END as profit_margin_pct
    FROM product_sales
),
-- Rank by category
product_rankings AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) as rank_in_category
    FROM product_profitability
)
-- Top 3 per category
SELECT 
    category,
    product_name,
    units_sold,
    revenue,
    profit,
    profit_margin_pct,
    rank_in_category
FROM product_rankings
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;
```

### Recursive CTEs

Recursive CTEs call themselves - perfect for hierarchical data like org charts, category trees, etc.

**Syntax:**
```sql
WITH RECURSIVE cte_name AS (
    -- Base case (anchor)
    SELECT ...
    
    UNION ALL
    
    -- Recursive case
    SELECT ...
    FROM cte_name  -- References itself!
    WHERE ...
)
SELECT * FROM cte_name;
```

**Example: Organization Chart**
```sql
WITH RECURSIVE org_chart AS (
    -- Base case: Top-level employees (no manager)
    SELECT 
        id,
        name,
        manager_id,
        0 as level,
        name as path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: Employees with managers
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

**Example: Number Series**
```sql
WITH RECURSIVE numbers AS (
    -- Base case
    SELECT 1 as n
    
    UNION ALL
    
    -- Recursive case
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT * FROM numbers;
-- Result: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
```

**Example: Date Series**
```sql
WITH RECURSIVE date_series AS (
    SELECT DATE '2024-01-01' as date
    
    UNION ALL
    
    SELECT date + INTERVAL '1 day'
    FROM date_series
    WHERE date < DATE '2024-12-31'
)
SELECT 
    date,
    EXTRACT(DOW FROM date) as day_of_week,
    EXTRACT(MONTH FROM date) as month
FROM date_series;
```

### CTEs for Complex Joins

```sql
WITH 
-- Customer order summary
customer_orders AS (
    SELECT 
        customer_id,
        COUNT(*) as order_count,
        SUM(total) as total_spent
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
-- Customer product variety
customer_products AS (
    SELECT 
        o.customer_id,
        COUNT(DISTINCT oi.product_id) as unique_products,
        COUNT(DISTINCT p.category) as unique_categories
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
    GROUP BY o.customer_id
),
-- Customer recency
customer_recency AS (
    SELECT 
        customer_id,
        MAX(order_date) as last_order_date,
        CURRENT_DATE - MAX(order_date) as days_since_last_order
    FROM orders
    GROUP BY customer_id
)
-- Combine all metrics
SELECT 
    c.customer_name,
    c.email,
    co.order_count,
    co.total_spent,
    cp.unique_products,
    cp.unique_categories,
    cr.last_order_date,
    cr.days_since_last_order
FROM customers c
LEFT JOIN customer_orders co ON c.id = co.customer_id
LEFT JOIN customer_products cp ON c.id = cp.customer_id
LEFT JOIN customer_recency cr ON c.id = cr.customer_id
ORDER BY co.total_spent DESC NULLS LAST;
```

### CTEs for Data Quality

```sql
WITH 
-- Find orphaned orders
orphaned_orders AS (
    SELECT o.*
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.id
    WHERE c.id IS NULL
),
-- Find orders without items
empty_orders AS (
    SELECT o.*
    FROM orders o
    LEFT JOIN order_items oi ON o.id = oi.order_id
    WHERE oi.id IS NULL
),
-- Find duplicate customers
duplicate_customers AS (
    SELECT email, COUNT(*) as count
    FROM customers
    GROUP BY email
    HAVING COUNT(*) > 1
)
-- Summary report
SELECT 
    'Orphaned Orders' as issue,
    COUNT(*) as count
FROM orphaned_orders
UNION ALL
SELECT 'Empty Orders', COUNT(*) FROM empty_orders
UNION ALL
SELECT 'Duplicate Emails', COUNT(*) FROM duplicate_customers;
```

### Best Practices

1. **Use descriptive names** - `customer_totals` not `cte1`
2. **One CTE per logical step** - Break complex logic into steps
3. **Order matters** - Define CTEs before referencing them
4. **Comment complex CTEs** - Explain what each CTE does
5. **Don't overuse** - Simple queries don't need CTEs
6. **Consider performance** - CTEs are materialized once per query

### Common Patterns

**Pattern 1: Filter, Aggregate, Filter**
```sql
WITH 
filtered_data AS (
    SELECT * FROM orders WHERE status = 'completed'
),
aggregated AS (
    SELECT customer_id, SUM(total) as total
    FROM filtered_data
    GROUP BY customer_id
)
SELECT * FROM aggregated WHERE total > 1000;
```

**Pattern 2: Multiple Aggregations**
```sql
WITH 
sales_by_product AS (
    SELECT product_id, SUM(quantity) as total_sold
    FROM order_items
    GROUP BY product_id
),
sales_by_category AS (
    SELECT p.category, SUM(s.total_sold) as category_total
    FROM sales_by_product s
    JOIN products p ON s.product_id = p.id
    GROUP BY p.category
)
SELECT * FROM sales_by_category;
```

**Pattern 3: Ranking and Filtering**
```sql
WITH ranked AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as rank
    FROM products
)
SELECT * FROM ranked WHERE rank <= 5;
```

### Performance Considerations

**CTEs are typically materialized once:**
- Good: Reuse expensive calculations
- Bad: Large CTEs can use memory

**Optimization tips:**
- Filter early in CTEs
- Only select needed columns
- Consider indexes on base tables
- For very large results, consider temp tables

### Common Mistakes

**Mistake 1: Multiple WITH keywords**
```sql
-- Wrong
WITH cte1 AS (...)
WITH cte2 AS (...)  -- ERROR!

-- Correct
WITH 
cte1 AS (...),
cte2 AS (...)
```

**Mistake 2: Referencing CTE before definition**
```sql
-- Wrong - cte2 references cte1 before it's defined
WITH 
cte2 AS (SELECT * FROM cte1),
cte1 AS (SELECT * FROM table)

-- Correct - define cte1 first
WITH 
cte1 AS (SELECT * FROM table),
cte2 AS (SELECT * FROM cte1)
```

**Mistake 3: Forgetting RECURSIVE keyword**
```sql
-- Wrong - recursive CTE without RECURSIVE
WITH org_chart AS (
    SELECT * FROM employees WHERE manager_id IS NULL
    UNION ALL
    SELECT e.* FROM employees e JOIN org_chart ON ...
)

-- Correct
WITH RECURSIVE org_chart AS (...)
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day15.db` with sample data.

### Database Schema

**employees** table:
- id, name, manager_id, department, salary, hire_date

**products** table:
- id, product_name, category, price, cost, stock

**customers** table:
- id, customer_name, email, city, state, registration_date

**orders** table:
- id, customer_id, order_date, total, status

**order_items** table:
- id, order_id, product_id, quantity, price

### Part 1: Basic CTEs (Easy)

### Exercise 1: Simple CTE (Easy)
Rewrite this subquery as a CTE:
```sql
SELECT * FROM (
    SELECT department, AVG(salary) as avg_salary
    FROM employees GROUP BY department
) WHERE avg_salary > 60000;
```

**Expected columns:** department, avg_salary

### Exercise 2: CTE with Filtering (Easy)
Write a query using a CTE to find customers who spent more than $1000 total.

**Expected columns:** customer_name, total_spent

**Hint:** CTE calculates totals, main query filters

### Exercise 3: CTE for Readability (Easy)
Write a query using a CTE to find products priced above their category average.

**Expected columns:** product_name, category, price, category_avg

### Part 2: Multiple CTEs (Medium)

### Exercise 4: Two CTEs (Medium)
Write a query with two CTEs:
1. Calculate customer order counts
2. Calculate customer total spending
3. Join them in the main query

**Expected columns:** customer_name, order_count, total_spent

### Exercise 5: Three CTEs (Medium)
Write a query with three CTEs:
1. Monthly revenue
2. Add previous month revenue (LAG)
3. Calculate growth percentage
4. Main query shows results

**Expected columns:** month, revenue, prev_month_revenue, growth_pct

### Exercise 6: CTEs Referencing CTEs (Medium)
Write a query where:
- CTE1: Customer totals
- CTE2: Segment customers (references CTE1)
- CTE3: Aggregate by segment (references CTE2)

**Expected columns:** segment, customer_count, avg_spending

### Exercise 7: Complex CTE Chain (Hard)
Write a query with 4 CTEs:
1. Product sales
2. Product profitability (references #1)
3. Product rankings (references #2)
4. Category summaries (references #3)

**Expected columns:** category, top_product, total_profit

### Part 3: CTEs for Analysis (Medium-Hard)

### Exercise 8: Customer Segmentation (Medium)
Write a query using CTEs to segment customers:
- Calculate RFM metrics (Recency, Frequency, Monetary)
- Assign scores
- Create segments

**Expected columns:** customer_name, recency_score, frequency_score, monetary_score, segment

### Exercise 9: Product Performance Dashboard (Hard)
Write a query using multiple CTEs to create a product dashboard:
- Sales metrics
- Profitability metrics
- Inventory metrics
- Combine all

**Expected columns:** product_name, units_sold, revenue, profit, stock_status

### Exercise 10: Customer Lifetime Value (Hard)
Write a query using CTEs to calculate customer LTV:
- First purchase date
- Last purchase date
- Total orders
- Total spent
- Average order value
- Customer lifespan
- Estimated LTV

**Expected columns:** customer_name, total_spent, order_count, avg_order_value, lifespan_days, estimated_ltv

### Exercise 11: Cohort Analysis (Very Hard)
Write a query using CTEs for cohort analysis:
- Group customers by registration month (cohort)
- Calculate metrics per cohort
- Show retention rates

**Expected columns:** cohort_month, customers, total_revenue, avg_ltv, retention_rate

### Part 4: Ranking and Top-N (Medium)

### Exercise 12: Top 3 per Category (Medium)
Write a query using a CTE to find top 3 products by revenue in each category.

**Expected columns:** category, product_name, revenue, rank

**Hint:** CTE with ROW_NUMBER(), main query filters rank <= 3

### Exercise 13: Top Customers per City (Medium)
Write a query using CTEs to find the top 2 customers by spending in each city.

**Expected columns:** city, customer_name, total_spent, rank_in_city

### Exercise 14: Best and Worst Performers (Hard)
Write a query using CTEs to find:
- Top 5 products by profit
- Bottom 5 products by profit
- Combine with UNION

**Expected columns:** product_name, profit, performance_type

### Part 5: Recursive CTEs (Hard)

### Exercise 15: Number Series (Easy)
Write a recursive CTE to generate numbers 1 to 100.

**Expected columns:** n

### Exercise 16: Date Series (Medium)
Write a recursive CTE to generate all dates in 2024.

**Expected columns:** date, day_of_week, month

### Exercise 17: Organization Chart (Medium)
Write a recursive CTE to show the complete organization hierarchy.
Show each employee with their level and path from CEO.

**Expected columns:** employee_name, level, path

**Hint:** Base case: manager_id IS NULL, Recursive: join on manager_id

### Exercise 18: All Subordinates (Hard)
Write a recursive CTE to show each manager with ALL their subordinates (direct and indirect).

**Expected columns:** manager_name, subordinate_name, levels_below

### Exercise 19: Category Tree (Hard)
Assuming categories have parent_category_id, write a recursive CTE to show the full category hierarchy.

**Expected columns:** category_name, level, full_path

### Exercise 20: Fibonacci Sequence (Hard)
Write a recursive CTE to generate the first 20 Fibonacci numbers.

**Expected columns:** n, fibonacci_number

**Hint:** Base cases: 0, 1; Recursive: sum of previous two

### Part 6: Complex Business Logic (Hard)

### Exercise 21: Customer Churn Prediction (Hard)
Write a query using CTEs to identify at-risk customers:
- Calculate days since last order
- Calculate order frequency
- Identify customers who are overdue for next order

**Expected columns:** customer_name, days_since_last_order, avg_days_between_orders, days_overdue, risk_level

### Exercise 22: Inventory Reorder Report (Hard)
Write a query using CTEs to create a reorder report:
- Calculate sales velocity (units per day)
- Calculate days of stock remaining
- Identify products needing reorder

**Expected columns:** product_name, current_stock, daily_sales_rate, days_remaining, reorder_needed

### Exercise 23: Product Recommendation Engine (Very Hard)
Write a query using CTEs to find product recommendations:
- Find products frequently bought together
- Calculate recommendation scores
- Rank recommendations

**Expected columns:** product_name, recommended_product, times_bought_together, recommendation_score

### Exercise 24: Customer Journey Analysis (Very Hard)
Write a query using CTEs to analyze customer journeys:
- First order details
- Order progression
- Product category evolution
- Customer maturity stage

**Expected columns:** customer_name, first_order_date, order_progression, category_diversity, maturity_stage

### Part 7: Data Quality and Reconciliation (Medium-Hard)

### Exercise 25: Data Quality Report (Medium)
Write a query using CTEs to create a data quality report:
- Orphaned orders (no customer)
- Empty orders (no items)
- Invalid prices (negative or zero)
- Duplicate emails

**Expected columns:** issue_type, count, severity

### Exercise 26: Sales Reconciliation (Hard)
Write a query using CTEs to reconcile sales data:
- Sum of order totals
- Sum of order_items totals
- Identify discrepancies

**Expected columns:** order_id, order_total, items_total, difference

### Exercise 27: Inventory Audit (Hard)
Write a query using CTEs to audit inventory:
- Expected stock (starting + purchases - sales)
- Actual stock
- Discrepancies

**Expected columns:** product_name, expected_stock, actual_stock, variance

### Part 8: Advanced Patterns (Very Hard)

### Exercise 28: Running Totals by Category (Hard)
Write a query using CTEs to calculate running totals:
- Daily sales by category
- Running total within each category
- Percentage of category total

**Expected columns:** date, category, daily_sales, running_total, pct_of_total

### Exercise 29: Pivot Table with CTEs (Very Hard)
Write a query using CTEs to create a pivot table:
- Products as rows
- Months as columns
- Revenue as values

**Expected columns:** product_name, jan, feb, mar, apr, may, jun, total

### Exercise 30: Complete Business Intelligence Report (Very Hard)
Write a query using multiple CTEs to create a comprehensive BI report:
- Customer metrics (count, active, churned)
- Product metrics (count, sold, never sold)
- Order metrics (count by status)
- Revenue metrics (total, by category, growth)
- Top performers (customers, products)

Combine all into a single result set.

**Expected columns:** metric_category, metric_name, metric_value, additional_info

**Hint:** Use UNION ALL to combine different metric types

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
