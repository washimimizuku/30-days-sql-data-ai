# Day 17: Window Functions - LAG, LEAD

## Learning Objectives
- Master LAG and LEAD for accessing previous/next rows
- Learn FIRST_VALUE and LAST_VALUE functions
- Calculate moving averages and running totals
- Perform time-series analysis and trend detection
- Compare current row with previous/next rows
- Build advanced analytical queries

## Theory (15 minutes)

### Review: Window Functions Basics

From Day 16, you learned ROW_NUMBER(), RANK(), DENSE_RANK(). Today we'll learn functions that access other rows relative to the current row.

**Window function structure:**
```sql
function_name() OVER (
    PARTITION BY column
    ORDER BY column
    ROWS/RANGE frame_specification
)
```

### What is LAG?

LAG accesses data from a PREVIOUS row in the result set without using a self-join.

**Think of it as:** "Look back N rows and get that value"

**Syntax:**
```sql
LAG(column, offset, default) OVER (ORDER BY column)
```

**Parameters:**
- `column` - The column to retrieve
- `offset` - How many rows back (default: 1)
- `default` - Value if no previous row exists (default: NULL)

**Basic Example:**
```sql
SELECT 
    order_date,
    total,
    LAG(total) OVER (ORDER BY order_date) as previous_order_total
FROM orders;
```

**Result:**
```
order_date  | total | previous_order_total
2024-01-01  | 100   | NULL (no previous)
2024-01-02  | 150   | 100
2024-01-03  | 120   | 150
```

### What is LEAD?

LEAD accesses data from a NEXT row in the result set.

**Think of it as:** "Look forward N rows and get that value"

**Syntax:**
```sql
LEAD(column, offset, default) OVER (ORDER BY column)
```

**Basic Example:**
```sql
SELECT 
    order_date,
    total,
    LEAD(total) OVER (ORDER BY order_date) as next_order_total
FROM orders;
```

**Result:**
```
order_date  | total | next_order_total
2024-01-01  | 100   | 150
2024-01-02  | 150   | 120
2024-01-03  | 120   | NULL (no next)
```

### LAG for Comparisons

**Calculate change from previous row:**
```sql
SELECT 
    order_date,
    total,
    LAG(total) OVER (ORDER BY order_date) as prev_total,
    total - LAG(total) OVER (ORDER BY order_date) as change,
    ROUND((total - LAG(total) OVER (ORDER BY order_date)) * 100.0 / 
          LAG(total) OVER (ORDER BY order_date), 2) as change_pct
FROM orders;
```

**Result:**
```
order_date  | total | prev_total | change | change_pct
2024-01-01  | 100   | NULL       | NULL   | NULL
2024-01-02  | 150   | 100        | 50     | 50.00
2024-01-03  | 120   | 150        | -30    | -20.00
```

### LAG with PARTITION BY

Use PARTITION BY to reset LAG within groups:

```sql
SELECT 
    customer_id,
    order_date,
    total,
    LAG(total) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as prev_order_for_customer,
    LAG(order_date) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as prev_order_date,
    order_date - LAG(order_date) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as days_since_last_order
FROM orders;
```

**This shows each customer's previous order, not the previous order overall.**

### LAG with Different Offsets

```sql
SELECT 
    order_date,
    total,
    LAG(total, 1) OVER (ORDER BY order_date) as prev_1_day,
    LAG(total, 7) OVER (ORDER BY order_date) as prev_7_days,
    LAG(total, 30) OVER (ORDER BY order_date) as prev_30_days
FROM daily_sales;
```

### LAG with Default Values

```sql
SELECT 
    order_date,
    total,
    LAG(total, 1, 0) OVER (ORDER BY order_date) as prev_total,
    total - LAG(total, 1, 0) OVER (ORDER BY order_date) as change
FROM orders;
```

**Now first row shows 0 instead of NULL for prev_total.**

### LEAD for Forecasting

```sql
SELECT 
    order_date,
    total,
    LEAD(total) OVER (ORDER BY order_date) as next_day_total,
    LEAD(total, 7) OVER (ORDER BY order_date) as next_week_total,
    CASE 
        WHEN LEAD(total) OVER (ORDER BY order_date) > total THEN 'Increasing'
        WHEN LEAD(total) OVER (ORDER BY order_date) < total THEN 'Decreasing'
        ELSE 'Stable'
    END as trend
FROM daily_sales;
```

### FIRST_VALUE and LAST_VALUE

**FIRST_VALUE** - Get the first value in the window
**LAST_VALUE** - Get the last value in the window

```sql
SELECT 
    order_date,
    total,
    FIRST_VALUE(total) OVER (ORDER BY order_date) as first_order_total,
    LAST_VALUE(total) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_order_total
FROM orders;
```

**Important:** LAST_VALUE needs frame specification to work correctly!

### FIRST_VALUE with PARTITION BY

```sql
-- Compare each product's price to the first product in its category
SELECT 
    category,
    product_name,
    price,
    FIRST_VALUE(product_name) OVER (
        PARTITION BY category 
        ORDER BY price DESC
    ) as most_expensive_in_category,
    FIRST_VALUE(price) OVER (
        PARTITION BY category 
        ORDER BY price DESC
    ) as highest_price_in_category,
    price - FIRST_VALUE(price) OVER (
        PARTITION BY category 
        ORDER BY price DESC
    ) as difference_from_highest
FROM products;
```

### Moving Averages

Calculate average over a sliding window:

```sql
-- 7-day moving average
SELECT 
    order_date,
    total,
    AVG(total) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7_days
FROM daily_sales;
```

**Frame specification:**
- `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` = current row + 6 previous = 7 rows total

**More examples:**
```sql
-- 3-day moving average
AVG(total) OVER (
    ORDER BY order_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)

-- 5-day centered moving average
AVG(total) OVER (
    ORDER BY order_date
    ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
)

-- Moving average from start to current
AVG(total) OVER (
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
```

### Running Totals

```sql
SELECT 
    order_date,
    total,
    SUM(total) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as running_total
FROM orders;
```

**Shorthand (same result):**
```sql
SUM(total) OVER (ORDER BY order_date)
```

### Running Totals by Group

```sql
SELECT 
    category,
    order_date,
    total,
    SUM(total) OVER (
        PARTITION BY category
        ORDER BY order_date
    ) as running_total_by_category
FROM sales;
```

### Practical Example: Month-over-Month Growth

```sql
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(total) as revenue
    FROM orders
    WHERE status = 'completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as prev_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) as growth,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / 
        LAG(revenue) OVER (ORDER BY month), 
        2
    ) as growth_pct
FROM monthly_revenue
ORDER BY month;
```

### Practical Example: Customer Purchase Patterns

```sql
SELECT 
    customer_id,
    customer_name,
    order_date,
    total,
    -- Previous order
    LAG(order_date) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as prev_order_date,
    -- Days between orders
    order_date - LAG(order_date) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as days_since_last_order,
    -- Order value change
    total - LAG(total) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as order_value_change,
    -- Running total for customer
    SUM(total) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
    ) as customer_lifetime_value
FROM orders o
JOIN customers c ON o.customer_id = c.id
ORDER BY customer_id, order_date;
```

### Practical Example: Stock Price Analysis

```sql
SELECT 
    date,
    close_price,
    -- Previous day
    LAG(close_price) OVER (ORDER BY date) as prev_close,
    -- Daily change
    close_price - LAG(close_price) OVER (ORDER BY date) as daily_change,
    -- 7-day moving average
    AVG(close_price) OVER (
        ORDER BY date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as ma_7,
    -- 30-day moving average
    AVG(close_price) OVER (
        ORDER BY date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) as ma_30,
    -- Highest in last 52 weeks
    MAX(close_price) OVER (
        ORDER BY date
        ROWS BETWEEN 364 PRECEDING AND CURRENT ROW
    ) as week_52_high,
    -- Lowest in last 52 weeks
    MIN(close_price) OVER (
        ORDER BY date
        ROWS BETWEEN 364 PRECEDING AND CURRENT ROW
    ) as week_52_low
FROM stock_prices
ORDER BY date;
```

### Practical Example: Sales Trend Detection

```sql
WITH sales_with_trends AS (
    SELECT 
        order_date,
        total,
        LAG(total, 1) OVER (ORDER BY order_date) as prev_1,
        LAG(total, 2) OVER (ORDER BY order_date) as prev_2,
        LAG(total, 3) OVER (ORDER BY order_date) as prev_3,
        LEAD(total, 1) OVER (ORDER BY order_date) as next_1
    FROM daily_sales
)
SELECT 
    order_date,
    total,
    CASE 
        WHEN total > prev_1 AND prev_1 > prev_2 AND prev_2 > prev_3 
            THEN 'Strong Uptrend'
        WHEN total > prev_1 AND prev_1 > prev_2 
            THEN 'Uptrend'
        WHEN total < prev_1 AND prev_1 < prev_2 AND prev_2 < prev_3 
            THEN 'Strong Downtrend'
        WHEN total < prev_1 AND prev_1 < prev_2 
            THEN 'Downtrend'
        ELSE 'Stable'
    END as trend,
    CASE 
        WHEN next_1 > total THEN 'Expect Increase'
        WHEN next_1 < total THEN 'Expect Decrease'
        ELSE 'Uncertain'
    END as forecast
FROM sales_with_trends
WHERE prev_3 IS NOT NULL;
```

### Frame Specifications

**ROWS vs RANGE:**
- `ROWS` - Physical rows (count)
- `RANGE` - Logical range (values)

**Common frames:**
```sql
-- Current row only
ROWS BETWEEN CURRENT ROW AND CURRENT ROW

-- Current + 3 preceding
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW

-- Current + 2 preceding + 2 following (centered)
ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING

-- All rows from start to current
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- All rows from current to end
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

-- All rows in partition
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

### Combining Multiple Window Functions

```sql
SELECT 
    order_date,
    total,
    -- Ranking
    ROW_NUMBER() OVER (ORDER BY order_date) as row_num,
    -- Previous/Next
    LAG(total) OVER (ORDER BY order_date) as prev_total,
    LEAD(total) OVER (ORDER BY order_date) as next_total,
    -- Moving average
    AVG(total) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as ma_7,
    -- Running total
    SUM(total) OVER (ORDER BY order_date) as running_total,
    -- First/Last
    FIRST_VALUE(total) OVER (ORDER BY order_date) as first_total,
    LAST_VALUE(total) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_total
FROM orders;
```

### Performance Tips

1. **Index ORDER BY columns** - Window functions sort data
2. **Limit partitions** - Fewer partitions = better performance
3. **Reuse window definitions** - Use WINDOW clause
4. **Filter before windowing** - Use WHERE to reduce rows

**WINDOW clause example:**
```sql
SELECT 
    order_date,
    total,
    LAG(total) OVER w as prev_total,
    LEAD(total) OVER w as next_total,
    AVG(total) OVER w as avg_total
FROM orders
WINDOW w AS (ORDER BY order_date)
ORDER BY order_date;
```

### Common Patterns

**Pattern 1: Period-over-Period Change**
```sql
value - LAG(value) OVER (ORDER BY date) as change
```

**Pattern 2: Percentage Change**
```sql
(value - LAG(value) OVER (ORDER BY date)) * 100.0 / 
LAG(value) OVER (ORDER BY date) as pct_change
```

**Pattern 3: Moving Average**
```sql
AVG(value) OVER (
    ORDER BY date
    ROWS BETWEEN n PRECEDING AND CURRENT ROW
)
```

**Pattern 4: Running Total**
```sql
SUM(value) OVER (ORDER BY date)
```

### Common Mistakes

**Mistake 1: Wrong frame for LAST_VALUE**
```sql
-- Wrong - only looks at current row
LAST_VALUE(total) OVER (ORDER BY date)

-- Correct - looks at all rows
LAST_VALUE(total) OVER (
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

**Mistake 2: Forgetting ORDER BY**
```sql
-- Wrong - undefined order
LAG(total) OVER ()

-- Correct
LAG(total) OVER (ORDER BY order_date)
```

**Mistake 3: Using aggregate without frame**
```sql
-- Unexpected - default frame is RANGE UNBOUNDED PRECEDING
AVG(total) OVER (ORDER BY date)

-- Explicit - clearer intent
AVG(total) OVER (
    ORDER BY date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
)
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day17.db` with sample data.

### Database Schema

**daily_sales** table:
- date, total, orders_count

**orders** table:
- id, customer_id, order_date, total, status

**customers** table:
- id, customer_name, registration_date

**products** table:
- id, product_name, category, price

**stock_prices** table:
- date, symbol, open_price, close_price, volume

### Part 1: Basic LAG and LEAD (Easy)

### Exercise 1: Previous Day Sales (Easy)
Write a query to show each day's sales with the previous day's sales.

**Expected columns:** date, total, prev_day_total

**Hint:** Use LAG with ORDER BY date

### Exercise 2: Next Day Sales (Easy)
Write a query to show each day's sales with the next day's sales.

**Expected columns:** date, total, next_day_total

### Exercise 3: Daily Change (Easy)
Write a query to calculate the change in sales from the previous day.

**Expected columns:** date, total, prev_day_total, change

**Hint:** total - LAG(total)

### Exercise 4: Percentage Change (Medium)
Write a query to calculate the percentage change in sales from the previous day.

**Expected columns:** date, total, prev_day_total, change_pct

**Hint:** (current - previous) * 100.0 / previous

### Exercise 5: Week-over-Week Comparison (Medium)
Write a query to compare each day's sales to the same day last week (7 days ago).

**Expected columns:** date, total, last_week_total, wow_change

**Hint:** LAG(total, 7)

### Part 2: LAG/LEAD with PARTITION BY (Medium)

### Exercise 6: Customer Order History (Medium)
Write a query to show each customer's orders with their previous order date and amount.

**Expected columns:** customer_name, order_date, total, prev_order_date, prev_order_total

**Hint:** PARTITION BY customer_id, ORDER BY order_date

### Exercise 7: Days Between Orders (Medium)
Write a query to calculate days between consecutive orders for each customer.

**Expected columns:** customer_name, order_date, prev_order_date, days_between

### Exercise 8: Order Value Trend (Medium)
Write a query to show if each customer's order value is increasing or decreasing compared to their previous order.

**Expected columns:** customer_name, order_date, total, prev_total, trend

**Hint:** Use CASE to compare current vs previous

### Exercise 9: Product Price Changes (Medium)
Assuming products table has a history of price changes, show each price change with the previous price.

**Expected columns:** product_name, date, price, prev_price, price_change

### Part 3: FIRST_VALUE and LAST_VALUE (Medium)

### Exercise 10: First Order Comparison (Medium)
Write a query to compare each customer's order to their first order.

**Expected columns:** customer_name, order_date, total, first_order_total, difference_from_first

**Hint:** FIRST_VALUE with PARTITION BY customer_id

### Exercise 11: Category Price Range (Medium)
Write a query to show each product with the highest and lowest prices in its category.

**Expected columns:** product_name, category, price, highest_in_category, lowest_in_category

**Hint:** FIRST_VALUE and LAST_VALUE with PARTITION BY category

### Exercise 12: First and Last Day of Month (Hard)
Write a query to show each day's sales with the first and last day's sales of that month.

**Expected columns:** date, total, first_day_of_month_total, last_day_of_month_total

**Hint:** PARTITION BY month, use proper frame for LAST_VALUE

### Part 4: Moving Averages (Medium-Hard)

### Exercise 13: 7-Day Moving Average (Medium)
Write a query to calculate a 7-day moving average of sales.

**Expected columns:** date, total, ma_7

**Hint:** AVG with ROWS BETWEEN 6 PRECEDING AND CURRENT ROW

### Exercise 14: Multiple Moving Averages (Medium)
Write a query to calculate 3-day, 7-day, and 30-day moving averages.

**Expected columns:** date, total, ma_3, ma_7, ma_30

### Exercise 15: Centered Moving Average (Hard)
Write a query to calculate a 5-day centered moving average (2 days before, current, 2 days after).

**Expected columns:** date, total, centered_ma_5

**Hint:** ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING

### Exercise 16: Moving Average by Category (Hard)
Write a query to calculate a 7-day moving average of sales for each product category.

**Expected columns:** date, category, daily_total, ma_7

**Hint:** PARTITION BY category

### Part 5: Running Totals (Medium)

### Exercise 17: Running Total (Easy)
Write a query to calculate a running total of sales.

**Expected columns:** date, total, running_total

**Hint:** SUM with ORDER BY date

### Exercise 18: Running Total by Customer (Medium)
Write a query to calculate each customer's lifetime value (running total of their orders).

**Expected columns:** customer_name, order_date, total, lifetime_value

**Hint:** SUM with PARTITION BY customer_id

### Exercise 19: Running Average (Medium)
Write a query to calculate a running average of sales from the start.

**Expected columns:** date, total, running_avg

### Exercise 20: Percentage of Running Total (Hard)
Write a query to show each day's sales as a percentage of the running total.

**Expected columns:** date, total, running_total, pct_of_running_total

### Part 6: Trend Analysis (Hard)

### Exercise 21: Identify Uptrends (Hard)
Write a query to identify days where sales have been increasing for 3 consecutive days.

**Expected columns:** date, total, is_uptrend

**Hint:** Compare current with LAG(total, 1), LAG(total, 2)

### Exercise 22: Peak Detection (Hard)
Write a query to identify local peaks (days where sales are higher than both previous and next day).

**Expected columns:** date, total, is_peak

**Hint:** Use both LAG and LEAD

### Exercise 23: Trend Classification (Very Hard)
Write a query to classify each day's trend:
- Strong Uptrend: 3+ consecutive increases
- Uptrend: 2 consecutive increases
- Strong Downtrend: 3+ consecutive decreases
- Downtrend: 2 consecutive decreases
- Stable: otherwise

**Expected columns:** date, total, trend

### Part 7: Stock Price Analysis (Hard)

### Exercise 24: Daily Stock Returns (Medium)
Write a query to calculate daily returns (percentage change from previous close).

**Expected columns:** date, symbol, close_price, prev_close, daily_return_pct

### Exercise 25: 52-Week High/Low (Hard)
Write a query to show each day's price with the 52-week (364 days) high and low.

**Expected columns:** date, close_price, week_52_high, week_52_low

**Hint:** MAX and MIN with ROWS BETWEEN 364 PRECEDING AND CURRENT ROW

### Exercise 26: Moving Average Crossover (Very Hard)
Write a query to identify when the 7-day MA crosses above the 30-day MA (bullish signal).

**Expected columns:** date, close_price, ma_7, ma_30, crossover_signal

**Hint:** Compare current and previous MA positions

### Part 8: Customer Behavior Analysis (Hard)

### Exercise 27: Purchase Frequency Pattern (Hard)
Write a query to analyze each customer's purchase frequency:
- Average days between orders
- Shortest gap
- Longest gap
- Current gap (days since last order)

**Expected columns:** customer_name, avg_days_between, min_gap, max_gap, current_gap

**Hint:** Use LAG to calculate gaps, then aggregate

### Exercise 28: Order Value Progression (Hard)
Write a query to show if customers' order values are generally increasing, decreasing, or stable.

**Expected columns:** customer_name, order_count, avg_order_value, value_trend

**Hint:** Compare first half average to second half average

### Exercise 29: Customer Lifecycle Stage (Very Hard)
Write a query to classify customers by lifecycle stage:
- New: 1-2 orders
- Growing: 3-5 orders with increasing values
- Mature: 6+ orders with stable values
- Declining: decreasing order values
- At Risk: no order in 90+ days

**Expected columns:** customer_name, order_count, days_since_last_order, lifecycle_stage

### Part 9: Advanced Patterns (Very Hard)

### Exercise 30: Complete Time Series Analysis (Very Hard)
Write a query to create a comprehensive time series analysis:
- Daily sales
- Previous day, week, month
- 7-day and 30-day moving averages
- Running total
- Percentage change from previous day
- Trend classification
- Anomaly detection (> 2 std deviations from MA)

**Expected columns:** date, total, prev_day, prev_week, ma_7, ma_30, running_total, pct_change, trend, is_anomaly

**Hint:** Use CTEs to calculate statistics, then combine with window functions

## Key Takeaways

- **LAG accesses previous rows** - Look back N rows
- **LEAD accesses next rows** - Look forward N rows
- **FIRST_VALUE gets first in window** - Useful for comparisons
- **LAST_VALUE gets last in window** - Needs proper frame specification
- **Moving averages smooth data** - Use ROWS BETWEEN for sliding windows
- **Running totals accumulate** - SUM with ORDER BY
- **PARTITION BY resets windows** - Separate calculations per group
- **Frame specifications control range** - ROWS BETWEEN defines window
- **Combine multiple window functions** - Powerful for analysis
- **Great for time series** - Trends, changes, patterns
- **Essential for analytics** - Period-over-period comparisons
- **Use WINDOW clause for reuse** - Define window once, use multiple times

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 18
