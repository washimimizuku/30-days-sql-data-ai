# Day 18: CASE Statements

## Learning Objectives
- Master CASE statements for conditional logic in SQL
- Learn both simple and searched CASE expressions
- Use CASE for categorization and data transformation
- Combine CASE with aggregations for powerful analytics
- Create pivot tables and conditional counts
- Build dynamic, flexible SQL queries

## Theory (15 minutes)

### What are CASE Statements?

CASE statements add conditional logic to SQL - like if/else in programming. They let you return different values based on conditions.

**Think of it as:** "If this condition, then that value, else another value"

### Two Types of CASE

**1. Simple CASE** - Compare one expression to multiple values
**2. Searched CASE** - Evaluate multiple different conditions

### Searched CASE Syntax (Most Common)

```sql
CASE 
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN condition3 THEN result3
    ELSE default_result
END
```

**Example:**
```sql
SELECT 
    product_name,
    price,
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_category
FROM products;
```

### Simple CASE Syntax

```sql
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END
```

**Example:**
```sql
SELECT 
    order_id,
    status,
    CASE status
        WHEN 'pending' THEN 'Processing'
        WHEN 'shipped' THEN 'In Transit'
        WHEN 'delivered' THEN 'Complete'
        ELSE 'Unknown'
    END as status_description
FROM orders;
```

**Note:** Searched CASE is more flexible and commonly used.

### Basic CASE Examples

**Categorize by range:**
```sql
SELECT 
    name,
    salary,
    CASE 
        WHEN salary >= 100000 THEN 'High'
        WHEN salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END as salary_band
FROM employees;
```

**Binary classification:**
```sql
SELECT 
    product_name,
    stock,
    CASE 
        WHEN stock > 0 THEN 'In Stock'
        ELSE 'Out of Stock'
    END as availability
FROM products;
```

**Multiple conditions:**
```sql
SELECT 
    customer_name,
    order_count,
    total_spent,
    CASE 
        WHEN order_count >= 10 AND total_spent > 5000 THEN 'VIP'
        WHEN order_count >= 5 OR total_spent > 2000 THEN 'Valued'
        WHEN order_count > 0 THEN 'Regular'
        ELSE 'New'
    END as customer_tier
FROM customer_stats;
```

### CASE in SELECT

Most common use - create new columns:

```sql
SELECT 
    product_name,
    price,
    cost,
    price - cost as profit,
    CASE 
        WHEN price - cost > 50 THEN 'High Margin'
        WHEN price - cost > 20 THEN 'Medium Margin'
        ELSE 'Low Margin'
    END as margin_category,
    CASE 
        WHEN (price - cost) / price > 0.5 THEN 'Excellent'
        WHEN (price - cost) / price > 0.3 THEN 'Good'
        ELSE 'Poor'
    END as profitability
FROM products;
```

### CASE with Aggregations

**Conditional counting:**
```sql
SELECT 
    COUNT(*) as total_orders,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled
FROM orders;
```

**Why not WHERE?** Because WHERE filters rows - we want to count different conditions in one query.

**Conditional summing:**
```sql
SELECT 
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as completed_revenue,
    SUM(CASE WHEN status = 'pending' THEN total ELSE 0 END) as pending_revenue,
    SUM(CASE WHEN status = 'cancelled' THEN total ELSE 0 END) as lost_revenue
FROM orders;
```

**Conditional averaging:**
```sql
SELECT 
    category,
    AVG(CASE WHEN price > 100 THEN price END) as avg_premium_price,
    AVG(CASE WHEN price <= 100 THEN price END) as avg_budget_price
FROM products
GROUP BY category;
```

### CASE in WHERE Clause

```sql
-- Dynamic filtering
SELECT *
FROM products
WHERE 
    CASE 
        WHEN category = 'Electronics' THEN price > 100
        WHEN category = 'Books' THEN price > 20
        ELSE price > 50
    END;
```

### CASE in ORDER BY

```sql
-- Custom sorting
SELECT product_name, category, price
FROM products
ORDER BY 
    CASE category
        WHEN 'Electronics' THEN 1
        WHEN 'Books' THEN 2
        WHEN 'Clothing' THEN 3
        ELSE 4
    END,
    price DESC;
```

### CASE in GROUP BY

```sql
-- Group by calculated categories
SELECT 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_tier,
    COUNT(*) as product_count,
    AVG(price) as avg_price
FROM products
GROUP BY 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END;
```

### Nested CASE Statements

```sql
SELECT 
    customer_name,
    order_count,
    total_spent,
    CASE 
        WHEN order_count = 0 THEN 'Never Ordered'
        WHEN order_count < 5 THEN 
            CASE 
                WHEN total_spent > 1000 THEN 'High Value New'
                ELSE 'Regular New'
            END
        ELSE 
            CASE 
                WHEN total_spent > 5000 THEN 'VIP'
                WHEN total_spent > 2000 THEN 'Loyal'
                ELSE 'Regular'
            END
    END as customer_segment
FROM customer_stats;
```

### Practical Example: Customer Segmentation

```sql
SELECT 
    customer_name,
    order_count,
    total_spent,
    days_since_last_order,
    -- RFM Segmentation
    CASE 
        WHEN days_since_last_order <= 30 AND order_count >= 10 AND total_spent > 5000 
            THEN 'Champions'
        WHEN days_since_last_order <= 60 AND order_count >= 5 AND total_spent > 2000 
            THEN 'Loyal Customers'
        WHEN days_since_last_order <= 90 AND total_spent > 1000 
            THEN 'Potential Loyalists'
        WHEN days_since_last_order > 180 AND order_count >= 5 
            THEN 'At Risk'
        WHEN days_since_last_order > 365 
            THEN 'Lost'
        WHEN order_count <= 2 
            THEN 'New Customers'
        ELSE 'Regular'
    END as segment
FROM customer_metrics
ORDER BY 
    CASE 
        WHEN days_since_last_order <= 30 AND order_count >= 10 AND total_spent > 5000 THEN 1
        WHEN days_since_last_order <= 60 AND order_count >= 5 AND total_spent > 2000 THEN 2
        ELSE 3
    END;
```

### Practical Example: Pivot Table

```sql
-- Sales by category and quarter
SELECT 
    category,
    SUM(CASE WHEN quarter = 1 THEN revenue ELSE 0 END) as q1_revenue,
    SUM(CASE WHEN quarter = 2 THEN revenue ELSE 0 END) as q2_revenue,
    SUM(CASE WHEN quarter = 3 THEN revenue ELSE 0 END) as q3_revenue,
    SUM(CASE WHEN quarter = 4 THEN revenue ELSE 0 END) as q4_revenue,
    SUM(revenue) as total_revenue
FROM (
    SELECT 
        p.category,
        EXTRACT(QUARTER FROM o.order_date) as quarter,
        SUM(oi.quantity * oi.price) as revenue
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN orders o ON oi.order_id = o.id
    GROUP BY p.category, EXTRACT(QUARTER FROM o.order_date)
) AS quarterly_sales
GROUP BY category;
```

### Practical Example: Dynamic Pricing

```sql
SELECT 
    product_name,
    price as original_price,
    stock,
    CASE 
        WHEN stock = 0 THEN price * 1.2  -- Out of stock premium
        WHEN stock < 10 THEN price * 1.1  -- Low stock markup
        WHEN stock > 100 THEN price * 0.9  -- Overstock discount
        ELSE price
    END as dynamic_price,
    CASE 
        WHEN stock = 0 THEN 'Out of Stock'
        WHEN stock < 10 THEN 'Low Stock - Price Increased'
        WHEN stock > 100 THEN 'Clearance Sale'
        ELSE 'Regular Price'
    END as pricing_reason
FROM products;
```

### Practical Example: Performance Ratings

```sql
SELECT 
    employee_name,
    sales_target,
    actual_sales,
    ROUND(actual_sales * 100.0 / sales_target, 2) as achievement_pct,
    CASE 
        WHEN actual_sales >= sales_target * 1.2 THEN 'Outstanding'
        WHEN actual_sales >= sales_target THEN 'Exceeds Expectations'
        WHEN actual_sales >= sales_target * 0.8 THEN 'Meets Expectations'
        WHEN actual_sales >= sales_target * 0.6 THEN 'Needs Improvement'
        ELSE 'Unsatisfactory'
    END as performance_rating,
    CASE 
        WHEN actual_sales >= sales_target * 1.2 THEN sales_target * 0.15
        WHEN actual_sales >= sales_target THEN sales_target * 0.10
        WHEN actual_sales >= sales_target * 0.8 THEN sales_target * 0.05
        ELSE 0
    END as bonus
FROM employee_sales;
```

### CASE with NULL Handling

```sql
SELECT 
    customer_name,
    last_order_date,
    CASE 
        WHEN last_order_date IS NULL THEN 'Never Ordered'
        WHEN last_order_date >= CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
        WHEN last_order_date >= CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
        ELSE 'Churned'
    END as status
FROM customers;
```

### CASE for Data Cleaning

```sql
SELECT 
    customer_name,
    -- Standardize city names
    CASE 
        WHEN LOWER(city) IN ('nyc', 'new york', 'ny') THEN 'New York'
        WHEN LOWER(city) IN ('la', 'los angeles') THEN 'Los Angeles'
        WHEN LOWER(city) IN ('sf', 'san francisco') THEN 'San Francisco'
        ELSE city
    END as standardized_city,
    -- Clean phone numbers
    CASE 
        WHEN phone IS NULL OR phone = '' THEN 'No Phone'
        WHEN LENGTH(phone) < 10 THEN 'Invalid'
        ELSE phone
    END as clean_phone
FROM customers;
```

### Multiple CASE Statements

```sql
SELECT 
    product_name,
    price,
    stock,
    -- Price category
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_category,
    -- Stock status
    CASE 
        WHEN stock = 0 THEN 'Out of Stock'
        WHEN stock < 10 THEN 'Low Stock'
        WHEN stock < 50 THEN 'Adequate'
        ELSE 'Well Stocked'
    END as stock_status,
    -- Action needed
    CASE 
        WHEN stock = 0 THEN 'Reorder Immediately'
        WHEN stock < 10 AND price > 100 THEN 'Reorder Soon'
        WHEN stock > 200 THEN 'Consider Promotion'
        ELSE 'No Action'
    END as recommendation
FROM products;
```

### Best Practices

1. **Always include ELSE** - Avoid NULL results
2. **Order conditions carefully** - Most specific first
3. **Use meaningful names** - Clear column aliases
4. **Keep it readable** - Format with line breaks
5. **Consider performance** - Simple conditions are faster
6. **Avoid deep nesting** - Use CTEs for complex logic

### Common Patterns

**Pattern 1: Binning**
```sql
CASE 
    WHEN value < 10 THEN '0-10'
    WHEN value < 20 THEN '10-20'
    WHEN value < 30 THEN '20-30'
    ELSE '30+'
END
```

**Pattern 2: Flag Creation**
```sql
CASE WHEN condition THEN 1 ELSE 0 END as flag
```

**Pattern 3: Conditional Aggregation**
```sql
SUM(CASE WHEN condition THEN amount ELSE 0 END)
```

**Pattern 4: Pivot**
```sql
SUM(CASE WHEN category = 'A' THEN amount ELSE 0 END) as category_a
```

### Common Mistakes

**Mistake 1: Forgetting ELSE**
```sql
-- Bad - returns NULL for unmatched
CASE WHEN price > 100 THEN 'Expensive' END

-- Good
CASE WHEN price > 100 THEN 'Expensive' ELSE 'Affordable' END
```

**Mistake 2: Wrong condition order**
```sql
-- Wrong - all values match first condition
CASE 
    WHEN price > 0 THEN 'Has Price'
    WHEN price > 100 THEN 'Expensive'  -- Never reached!
END

-- Correct - specific first
CASE 
    WHEN price > 100 THEN 'Expensive'
    WHEN price > 0 THEN 'Has Price'
END
```

**Mistake 3: Type mismatch**
```sql
-- Wrong - mixing types
CASE 
    WHEN condition THEN 'Yes'
    ELSE 0  -- String vs Number
END

-- Correct - consistent types
CASE 
    WHEN condition THEN 'Yes'
    ELSE 'No'
END
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day18.db` with sample data.

### Database Schema

**products** table:
- id, product_name, category, price, cost, stock

**employees** table:
- id, name, department, salary, performance_score, hire_date

**customers** table:
- id, customer_name, city, state, registration_date

**orders** table:
- id, customer_id, order_date, total, status

**order_items** table:
- id, order_id, product_id, quantity, price

### Part 1: Basic CASE Statements (Easy)

### Exercise 1: Simple Categorization (Easy)
Write a query to categorize products by price:
- Budget: < $50
- Mid-Range: $50-$200
- Premium: > $200

**Expected columns:** product_name, price, price_category

### Exercise 2: Binary Classification (Easy)
Write a query to show product availability:
- "In Stock" if stock > 0
- "Out of Stock" if stock = 0

**Expected columns:** product_name, stock, availability

### Exercise 3: Status Description (Easy)
Write a query to convert order status codes to descriptions:
- 'pending' → 'Processing'
- 'shipped' → 'In Transit'
- 'delivered' → 'Complete'
- 'cancelled' → 'Cancelled'

**Expected columns:** order_id, status, status_description

### Exercise 4: Salary Bands (Easy)
Write a query to categorize employees by salary:
- High: >= $100,000
- Medium: $60,000-$99,999
- Low: < $60,000

**Expected columns:** name, salary, salary_band

### Exercise 5: Stock Status (Easy)
Write a query to categorize products by stock level:
- "Out of Stock": 0
- "Low Stock": 1-10
- "Adequate": 11-50
- "Well Stocked": > 50

**Expected columns:** product_name, stock, stock_status

### Part 2: CASE with Aggregations (Medium)

### Exercise 6: Conditional Counting (Medium)
Write a query to count orders by status in one row:
- Total orders
- Completed orders
- Pending orders
- Cancelled orders

**Expected columns:** total_orders, completed, pending, cancelled

**Hint:** Use COUNT(CASE WHEN ... THEN 1 END)

### Exercise 7: Conditional Revenue (Medium)
Write a query to calculate revenue by status:
- Total revenue (all orders)
- Completed revenue
- Pending revenue
- Cancelled revenue

**Expected columns:** total_revenue, completed_revenue, pending_revenue, cancelled_revenue

### Exercise 8: Category Performance (Medium)
Write a query to show for each category:
- Total products
- Products in stock (stock > 0)
- Products out of stock
- Average price of in-stock products

**Expected columns:** category, total_products, in_stock, out_of_stock, avg_in_stock_price

### Exercise 9: Employee Performance Distribution (Medium)
Write a query to count employees by performance rating:
- Outstanding: score >= 90
- Good: score 70-89
- Satisfactory: score 50-69
- Needs Improvement: score < 50

**Expected columns:** outstanding, good, satisfactory, needs_improvement

### Exercise 10: Price Range Analysis (Medium)
Write a query to show for each category:
- Count of budget products (< $50)
- Count of mid-range products ($50-$200)
- Count of premium products (> $200)
- Total products

**Expected columns:** category, budget_count, midrange_count, premium_count, total

### Part 3: Complex Categorization (Medium-Hard)

### Exercise 11: Customer Segmentation (Medium)
Write a query to segment customers based on their order history:
- VIP: 10+ orders AND $5000+ spent
- Loyal: 5+ orders OR $2000+ spent
- Regular: 1+ orders
- New: 0 orders

**Expected columns:** customer_name, order_count, total_spent, segment

**Hint:** Join customers with aggregated orders, use CASE with AND/OR

### Exercise 12: Product Profitability Tiers (Medium)
Write a query to categorize products by profit margin:
- Excellent: margin > 50%
- Good: margin 30-50%
- Fair: margin 15-30%
- Poor: margin < 15%

**Expected columns:** product_name, price, cost, profit_margin_pct, tier

**Hint:** profit_margin = (price - cost) / price * 100

### Exercise 13: Employee Bonus Calculation (Hard)
Write a query to calculate bonuses based on performance:
- Outstanding (>= 90): 15% of salary
- Good (70-89): 10% of salary
- Satisfactory (50-69): 5% of salary
- Below 50: 0

**Expected columns:** name, salary, performance_score, bonus_amount

### Exercise 14: Dynamic Pricing (Hard)
Write a query to calculate dynamic prices based on stock:
- Out of stock (0): price * 1.2
- Low stock (< 10): price * 1.1
- Overstock (> 100): price * 0.9
- Normal: price

**Expected columns:** product_name, price, stock, dynamic_price, pricing_reason

### Exercise 15: Customer Status (Medium)
Write a query to determine customer status based on last order date:
- Active: ordered in last 30 days
- At Risk: ordered 31-90 days ago
- Churned: ordered 90+ days ago
- Never Ordered: no orders

**Expected columns:** customer_name, last_order_date, days_since_last_order, status

### Part 4: Pivot Tables (Hard)

### Exercise 16: Sales by Status Pivot (Medium)
Write a query to create a pivot showing revenue by category and status:
- Rows: categories
- Columns: order statuses (completed, pending, cancelled)

**Expected columns:** category, completed_revenue, pending_revenue, cancelled_revenue

### Exercise 17: Monthly Sales Pivot (Hard)
Write a query to create a pivot showing sales by product and month:
- Rows: products
- Columns: months (Jan, Feb, Mar)

**Expected columns:** product_name, jan_sales, feb_sales, mar_sales, total_sales

### Exercise 18: Quarterly Performance (Hard)
Write a query to show quarterly revenue by category:
- Rows: categories
- Columns: Q1, Q2, Q3, Q4

**Expected columns:** category, q1_revenue, q2_revenue, q3_revenue, q4_revenue

### Part 5: Nested CASE (Hard)

### Exercise 19: Advanced Customer Segmentation (Hard)
Write a query with nested CASE to segment customers:
- If never ordered: "Never Ordered"
- If < 5 orders:
  - If spent > $1000: "High Value New"
  - Else: "Regular New"
- If >= 5 orders:
  - If spent > $5000: "VIP"
  - If spent > $2000: "Loyal"
  - Else: "Regular"

**Expected columns:** customer_name, order_count, total_spent, segment

### Exercise 20: Product Recommendation (Hard)
Write a query with nested CASE to recommend actions:
- If out of stock:
  - If high price (> $100): "Urgent Reorder"
  - Else: "Reorder"
- If low stock (< 10):
  - If fast-moving (sold > 50): "Reorder Soon"
  - Else: "Monitor"
- If overstock (> 200):
  - "Promotion Needed"
- Else: "No Action"

**Expected columns:** product_name, stock, units_sold, recommendation

### Part 6: CASE in Different Clauses (Medium)

### Exercise 21: CASE in ORDER BY (Medium)
Write a query to sort products with custom logic:
- Electronics first
- Books second
- Clothing third
- Others last
- Within each category, sort by price descending

**Expected columns:** product_name, category, price

**Hint:** Use CASE in ORDER BY

### Exercise 22: CASE in WHERE (Medium)
Write a query to filter products with category-specific price rules:
- Electronics: price > $100
- Books: price > $20
- Clothing: price > $30
- Others: price > $50

**Expected columns:** product_name, category, price

### Exercise 23: CASE in GROUP BY (Hard)
Write a query to group products by price tier and show statistics:
- Budget (< $50)
- Mid-Range ($50-$200)
- Premium (> $200)

**Expected columns:** price_tier, product_count, avg_price, total_value

**Hint:** Use same CASE in SELECT and GROUP BY

### Part 7: Real-World Applications (Hard)

### Exercise 24: RFM Segmentation (Very Hard)
Write a query to perform RFM (Recency, Frequency, Monetary) analysis:
- Calculate recency score (1-5 based on days since last order)
- Calculate frequency score (1-5 based on order count)
- Calculate monetary score (1-5 based on total spent)
- Assign segment based on combined scores

**Expected columns:** customer_name, recency_score, frequency_score, monetary_score, rfm_segment

### Exercise 25: Inventory Alert System (Hard)
Write a query to create an inventory alert system:
- Critical: out of stock AND high demand (sold > 100)
- High: low stock (< 10) AND medium demand (sold > 50)
- Medium: low stock AND low demand
- Low: adequate stock
- None: well stocked

**Expected columns:** product_name, stock, units_sold, alert_level, action_needed

### Exercise 26: Employee Performance Review (Hard)
Write a query to generate performance reviews:
- Calculate performance rating based on score
- Calculate salary adjustment recommendation
- Determine promotion eligibility
- Assign training needs

**Expected columns:** name, performance_score, rating, salary_adjustment_pct, promotion_eligible, training_needed

### Exercise 27: Customer Lifetime Value Prediction (Very Hard)
Write a query to predict customer lifetime value category:
- Calculate average order value
- Calculate order frequency
- Predict LTV category based on patterns
- Assign retention strategy

**Expected columns:** customer_name, avg_order_value, order_frequency, predicted_ltv_category, retention_strategy

### Exercise 28: Product Mix Analysis (Hard)
Write a query to analyze product mix and recommend actions:
- High margin + high sales: "Star Product"
- High margin + low sales: "Promote More"
- Low margin + high sales: "Review Pricing"
- Low margin + low sales: "Consider Discontinuing"

**Expected columns:** product_name, profit_margin, units_sold, product_type, recommendation

### Exercise 29: Seasonal Pricing Strategy (Very Hard)
Write a query to recommend seasonal pricing:
- Based on month, stock level, and historical sales
- Different strategies for different seasons
- Consider category-specific patterns

**Expected columns:** product_name, category, current_price, recommended_price, strategy, reason

### Exercise 30: Complete Business Dashboard (Very Hard)
Write a query using multiple CASE statements to create a dashboard:
- Customer metrics (segmented counts)
- Product metrics (categorized counts)
- Order metrics (status breakdown)
- Revenue metrics (by category and status)
- Alert counts (inventory, customer churn, etc.)

**Expected columns:** metric_category, metric_name, count, value, status

**Hint:** Use UNION ALL to combine different metric types, each using CASE

## Key Takeaways

- **CASE adds conditional logic to SQL** - Like if/else in programming
- **Two types: Simple and Searched** - Searched CASE is more flexible
- **Always include ELSE** - Avoid unexpected NULL results
- **Order conditions carefully** - Most specific conditions first
- **Great with aggregations** - COUNT(CASE...), SUM(CASE...)
- **Create pivot tables** - Use CASE to transform rows to columns
- **Can nest CASE statements** - For complex logic
- **Use in any clause** - SELECT, WHERE, ORDER BY, GROUP BY
- **Keep it readable** - Format with line breaks and indentation
- **Essential for categorization** - Segment customers, classify products
- **Powerful for reporting** - Create dynamic, flexible reports

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 19
