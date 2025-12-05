# Day 19: Date and Time Functions

## Learning Objectives
- Master date and time data types in SQL
- Learn EXTRACT, DATE_PART, and DATE_TRUNC functions
- Work with INTERVAL for date arithmetic
- Format and parse dates
- Calculate date differences and ranges
- Build time-based analytics queries

## Theory (15 minutes)

### Date and Time Data Types

**DATE** - Date only (YYYY-MM-DD)
```sql
DATE '2024-01-15'
```

**TIME** - Time only (HH:MM:SS)
```sql
TIME '14:30:00'
```

**TIMESTAMP** - Date and time
```sql
TIMESTAMP '2024-01-15 14:30:00'
```

**INTERVAL** - Duration
```sql
INTERVAL '5 days'
INTERVAL '2 hours'
INTERVAL '3 months'
```

### Current Date and Time

```sql
-- Current date
SELECT CURRENT_DATE;
-- Result: 2024-12-04

-- Current timestamp
SELECT CURRENT_TIMESTAMP;
-- Result: 2024-12-04 15:30:45

-- Current time
SELECT CURRENT_TIME;
-- Result: 15:30:45

-- Alternative: NOW()
SELECT NOW();
-- Result: 2024-12-04 15:30:45
```

### EXTRACT Function

Extract parts of a date/timestamp:

```sql
SELECT 
    order_date,
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    EXTRACT(DAY FROM order_date) as day,
    EXTRACT(QUARTER FROM order_date) as quarter,
    EXTRACT(DOW FROM order_date) as day_of_week,  -- 0=Sunday
    EXTRACT(DOY FROM order_date) as day_of_year,
    EXTRACT(WEEK FROM order_date) as week_number
FROM orders;
```

**Common extractions:**
- `YEAR` - 2024
- `MONTH` - 1-12
- `DAY` - 1-31
- `QUARTER` - 1-4
- `DOW` - Day of week (0-6, Sunday=0)
- `DOY` - Day of year (1-366)
- `WEEK` - Week number (1-53)
- `HOUR` - 0-23
- `MINUTE` - 0-59
- `SECOND` - 0-59

### DATE_PART Function

Alternative syntax (same as EXTRACT):

```sql
SELECT 
    order_date,
    DATE_PART('year', order_date) as year,
    DATE_PART('month', order_date) as month,
    DATE_PART('day', order_date) as day
FROM orders;
```

### DATE_TRUNC Function

Truncate to specific precision:

```sql
SELECT 
    order_date,
    DATE_TRUNC('year', order_date) as year_start,
    DATE_TRUNC('month', order_date) as month_start,
    DATE_TRUNC('week', order_date) as week_start,
    DATE_TRUNC('day', order_date) as day_start
FROM orders;
```

**Example:**
```
order_date: 2024-03-15
DATE_TRUNC('year', ...): 2024-01-01
DATE_TRUNC('month', ...): 2024-03-01
DATE_TRUNC('week', ...): 2024-03-11 (Monday)
```

**Use case - Group by month:**
```sql
SELECT 
    DATE_TRUNC('month', order_date) as month,
    COUNT(*) as order_count,
    SUM(total) as revenue
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
```

### INTERVAL Arithmetic

Add or subtract time periods:

```sql
-- Add intervals
SELECT 
    CURRENT_DATE as today,
    CURRENT_DATE + INTERVAL '1 day' as tomorrow,
    CURRENT_DATE + INTERVAL '7 days' as next_week,
    CURRENT_DATE + INTERVAL '1 month' as next_month,
    CURRENT_DATE + INTERVAL '1 year' as next_year;

-- Subtract intervals
SELECT 
    CURRENT_DATE as today,
    CURRENT_DATE - INTERVAL '1 day' as yesterday,
    CURRENT_DATE - INTERVAL '30 days' as thirty_days_ago,
    CURRENT_DATE - INTERVAL '6 months' as six_months_ago;

-- Combine intervals
SELECT 
    CURRENT_DATE + INTERVAL '1 year 2 months 15 days' as future_date;
```

### Date Arithmetic

```sql
-- Difference between dates (returns integer days)
SELECT 
    order_date,
    CURRENT_DATE - order_date as days_ago,
    delivery_date - order_date as delivery_days
FROM orders;

-- Add days directly
SELECT 
    order_date,
    order_date + 7 as week_later,
    order_date - 30 as month_earlier
FROM orders;
```

### Filtering by Date

```sql
-- Specific date
SELECT * FROM orders
WHERE order_date = DATE '2024-01-15';

-- Date range
SELECT * FROM orders
WHERE order_date BETWEEN DATE '2024-01-01' AND DATE '2024-01-31';

-- Last 30 days
SELECT * FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';

-- This year
SELECT * FROM orders
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE);

-- This month
SELECT * FROM orders
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', CURRENT_DATE);

-- Last quarter
SELECT * FROM orders
WHERE order_date >= DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months'
  AND order_date < DATE_TRUNC('quarter', CURRENT_DATE);
```

### Date Formatting

```sql
-- Format dates
SELECT 
    order_date,
    TO_CHAR(order_date, 'YYYY-MM-DD') as iso_format,
    TO_CHAR(order_date, 'Mon DD, YYYY') as readable,
    TO_CHAR(order_date, 'Day, Month DD, YYYY') as full_format,
    TO_CHAR(order_date, 'MM/DD/YYYY') as us_format,
    TO_CHAR(order_date, 'DD/MM/YYYY') as eu_format
FROM orders;
```

**Common format codes:**
- `YYYY` - 4-digit year
- `YY` - 2-digit year
- `MM` - Month number (01-12)
- `Mon` - Abbreviated month name
- `Month` - Full month name
- `DD` - Day of month (01-31)
- `Day` - Full day name
- `Dy` - Abbreviated day name
- `HH24` - Hour (00-23)
- `HH` - Hour (01-12)
- `MI` - Minute
- `SS` - Second

### Parsing Dates

```sql
-- Parse string to date
SELECT 
    TO_DATE('2024-01-15', 'YYYY-MM-DD') as parsed_date,
    TO_TIMESTAMP('2024-01-15 14:30:00', 'YYYY-MM-DD HH24:MI:SS') as parsed_timestamp;

-- Cast string to date
SELECT 
    CAST('2024-01-15' AS DATE) as date1,
    '2024-01-15'::DATE as date2;  -- PostgreSQL/DuckDB shorthand
```

### Practical Example: Age Calculation

```sql
SELECT 
    customer_name,
    registration_date,
    CURRENT_DATE - registration_date as days_as_customer,
    (CURRENT_DATE - registration_date) / 365 as years_as_customer,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, registration_date)) as exact_years
FROM customers;
```

### Practical Example: Business Days

```sql
-- Exclude weekends
SELECT 
    order_date,
    EXTRACT(DOW FROM order_date) as day_of_week,
    CASE 
        WHEN EXTRACT(DOW FROM order_date) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END as day_type
FROM orders
WHERE EXTRACT(DOW FROM order_date) NOT IN (0, 6);  -- Exclude Sat/Sun
```

### Practical Example: Time-Based Segmentation

```sql
SELECT 
    customer_name,
    registration_date,
    CASE 
        WHEN registration_date >= CURRENT_DATE - INTERVAL '30 days' 
            THEN 'New (< 1 month)'
        WHEN registration_date >= CURRENT_DATE - INTERVAL '90 days' 
            THEN 'Recent (1-3 months)'
        WHEN registration_date >= CURRENT_DATE - INTERVAL '1 year' 
            THEN 'Established (3-12 months)'
        ELSE 'Veteran (1+ years)'
    END as customer_age_segment
FROM customers;
```

### Practical Example: Cohort Analysis

```sql
SELECT 
    DATE_TRUNC('month', registration_date) as cohort_month,
    COUNT(*) as customers_in_cohort,
    COUNT(CASE 
        WHEN last_order_date >= CURRENT_DATE - INTERVAL '30 days' 
        THEN 1 
    END) as active_customers,
    ROUND(
        COUNT(CASE WHEN last_order_date >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) * 100.0 / 
        COUNT(*), 
        2
    ) as retention_rate
FROM customers
GROUP BY DATE_TRUNC('month', registration_date)
ORDER BY cohort_month;
```

### Practical Example: Seasonal Analysis

```sql
SELECT 
    EXTRACT(YEAR FROM order_date) as year,
    CASE 
        WHEN EXTRACT(MONTH FROM order_date) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM order_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM order_date) IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
    END as season,
    COUNT(*) as order_count,
    SUM(total) as revenue
FROM orders
GROUP BY year, season
ORDER BY year, 
    CASE season
        WHEN 'Winter' THEN 1
        WHEN 'Spring' THEN 2
        WHEN 'Summer' THEN 3
        ELSE 4
    END;
```

### Practical Example: Time of Day Analysis

```sql
SELECT 
    EXTRACT(HOUR FROM order_timestamp) as hour,
    CASE 
        WHEN EXTRACT(HOUR FROM order_timestamp) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_timestamp) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM order_timestamp) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END as time_of_day,
    COUNT(*) as order_count,
    AVG(total) as avg_order_value
FROM orders
GROUP BY hour, time_of_day
ORDER BY hour;
```

### Generate Date Series

```sql
-- Generate all dates in a range
SELECT 
    DATE '2024-01-01' + INTERVAL (n) DAY as date
FROM generate_series(0, 364) as t(n);

-- Or using recursive CTE
WITH RECURSIVE dates AS (
    SELECT DATE '2024-01-01' as date
    UNION ALL
    SELECT date + INTERVAL '1 day'
    FROM dates
    WHERE date < DATE '2024-12-31'
)
SELECT * FROM dates;
```

### Date Ranges and Overlaps

```sql
-- Check if date ranges overlap
SELECT 
    event1_name,
    event2_name,
    CASE 
        WHEN event1_end < event2_start OR event2_end < event1_start 
            THEN 'No Overlap'
        ELSE 'Overlaps'
    END as overlap_status
FROM events e1
CROSS JOIN events e2
WHERE e1.id < e2.id;
```

### Working with Timestamps

```sql
SELECT 
    order_timestamp,
    -- Extract date part
    CAST(order_timestamp AS DATE) as order_date,
    -- Extract time part
    CAST(order_timestamp AS TIME) as order_time,
    -- Time difference
    CURRENT_TIMESTAMP - order_timestamp as time_since_order,
    -- Extract components
    EXTRACT(HOUR FROM order_timestamp) as hour,
    EXTRACT(MINUTE FROM order_timestamp) as minute
FROM orders;
```

### Best Practices

1. **Use DATE type for dates** - Not strings
2. **Use INTERVAL for arithmetic** - Clearer than adding days
3. **Index date columns** - For better query performance
4. **Use DATE_TRUNC for grouping** - Better than EXTRACT for aggregations
5. **Be timezone aware** - Use TIMESTAMP WITH TIME ZONE when needed
6. **Validate date inputs** - Check for valid dates when parsing

### Common Patterns

**Pattern 1: Last N days**
```sql
WHERE date >= CURRENT_DATE - INTERVAL 'N days'
```

**Pattern 2: Month-to-date**
```sql
WHERE date >= DATE_TRUNC('month', CURRENT_DATE)
```

**Pattern 3: Year-over-year**
```sql
WHERE date BETWEEN 
    DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year'
    AND DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 day'
```

**Pattern 4: Group by month**
```sql
GROUP BY DATE_TRUNC('month', date)
```

### Common Mistakes

**Mistake 1: Comparing dates as strings**
```sql
-- Wrong
WHERE order_date > '2024-01-01'

-- Correct
WHERE order_date > DATE '2024-01-01'
```

**Mistake 2: Not handling NULL dates**
```sql
-- Wrong - fails on NULL
WHERE CURRENT_DATE - order_date > 30

-- Correct
WHERE order_date IS NOT NULL 
  AND CURRENT_DATE - order_date > 30
```

**Mistake 3: Using EXTRACT for grouping**
```sql
-- Less efficient
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)

-- Better
GROUP BY DATE_TRUNC('month', date)
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day19.db` with sample data.

### Database Schema

**orders** table:
- id, customer_id, order_date, order_timestamp, total, status

**customers** table:
- id, customer_name, registration_date, birth_date

**employees** table:
- id, name, hire_date, department

**events** table:
- id, event_name, start_date, end_date

### Part 1: Basic Date Functions (Easy)

### Exercise 1: Extract Date Parts (Easy)
Write a query to extract year, month, and day from order dates.

**Expected columns:** order_id, order_date, year, month, day

### Exercise 2: Current Date Operations (Easy)
Write a query to show orders with days since order date.

**Expected columns:** order_id, order_date, days_ago

**Hint:** CURRENT_DATE - order_date

### Exercise 3: Day of Week (Easy)
Write a query to show orders with day of week name.

**Expected columns:** order_id, order_date, day_of_week

**Hint:** Use EXTRACT(DOW ...) and CASE

### Exercise 4: Quarter Extraction (Easy)
Write a query to show orders grouped by quarter.

**Expected columns:** year, quarter, order_count, total_revenue

### Exercise 5: Month Name (Easy)
Write a query to show orders with month name.

**Expected columns:** order_id, order_date, month_name

**Hint:** Use TO_CHAR or CASE with EXTRACT(MONTH ...)

### Part 2: Date Arithmetic (Medium)

### Exercise 6: Add Intervals (Easy)
Write a query to show order date plus 7 days, 30 days, and 1 year.

**Expected columns:** order_id, order_date, plus_7_days, plus_30_days, plus_1_year

### Exercise 7: Date Ranges (Medium)
Write a query to find orders from the last 30 days.

**Expected columns:** order_id, order_date, total

### Exercise 8: Month-to-Date Orders (Medium)
Write a query to find all orders from the current month.

**Expected columns:** order_id, order_date, total

**Hint:** DATE_TRUNC('month', CURRENT_DATE)

### Exercise 9: Year-over-Year Comparison (Hard)
Write a query to compare this year's orders to last year's for the same period.

**Expected columns:** month, this_year_orders, last_year_orders, yoy_change

### Exercise 10: Customer Age (Medium)
Write a query to calculate customer age from birth_date.

**Expected columns:** customer_name, birth_date, age_years

**Hint:** (CURRENT_DATE - birth_date) / 365

### Part 3: DATE_TRUNC and Grouping (Medium)

### Exercise 11: Monthly Revenue (Medium)
Write a query to calculate revenue by month.

**Expected columns:** month, order_count, total_revenue

**Hint:** GROUP BY DATE_TRUNC('month', order_date)

### Exercise 12: Weekly Trends (Medium)
Write a query to show order counts by week.

**Expected columns:** week_start, order_count

**Hint:** DATE_TRUNC('week', order_date)

### Exercise 13: Quarterly Performance (Medium)
Write a query to show revenue by year and quarter.

**Expected columns:** year, quarter, revenue

### Exercise 14: Daily Average by Month (Hard)
Write a query to calculate average daily revenue for each month.

**Expected columns:** month, total_revenue, days_in_month, avg_daily_revenue

**Hint:** Count distinct dates per month

### Part 4: Time-Based Filtering (Medium)

### Exercise 15: Recent Customers (Easy)
Write a query to find customers who registered in the last 90 days.

**Expected columns:** customer_name, registration_date, days_ago

### Exercise 16: Inactive Customers (Medium)
Write a query to find customers who haven't ordered in 6+ months.

**Expected columns:** customer_name, last_order_date, days_since_last_order

### Exercise 17: Seasonal Orders (Medium)
Write a query to categorize orders by season and count them.

**Expected columns:** season, order_count, total_revenue

**Hint:** Use CASE with EXTRACT(MONTH ...)

### Exercise 18: Business Days Only (Medium)
Write a query to show orders placed on weekdays only (Monday-Friday).

**Expected columns:** order_id, order_date, day_name

**Hint:** EXTRACT(DOW ...) NOT IN (0, 6)

### Exercise 19: Time of Day Analysis (Hard)
Write a query to analyze orders by time of day (Morning, Afternoon, Evening, Night).

**Expected columns:** time_period, order_count, avg_order_value

**Hint:** EXTRACT(HOUR FROM order_timestamp)

### Part 5: Customer Segmentation by Time (Hard)

### Exercise 20: Customer Tenure Segments (Medium)
Write a query to segment customers by how long they've been registered:
- New: < 3 months
- Recent: 3-12 months
- Established: 1-3 years
- Veteran: 3+ years

**Expected columns:** tenure_segment, customer_count

### Exercise 21: Order Recency Segments (Hard)
Write a query to segment customers by last order date:
- Active: < 30 days
- At Risk: 30-90 days
- Churned: 90+ days
- Never Ordered: NULL

**Expected columns:** recency_segment, customer_count, avg_lifetime_value

### Exercise 22: Registration Cohorts (Hard)
Write a query to create monthly registration cohorts and show their order counts.

**Expected columns:** cohort_month, customers_in_cohort, total_orders, orders_per_customer

### Part 6: Date Calculations (Hard)

### Exercise 23: Days Between Orders (Medium)
Write a query to calculate average days between orders for each customer.

**Expected columns:** customer_name, order_count, avg_days_between_orders

**Hint:** Use LAG to get previous order date

### Exercise 24: Customer Lifetime (Medium)
Write a query to calculate each customer's lifetime (first to last order).

**Expected columns:** customer_name, first_order, last_order, lifetime_days

### Exercise 25: Event Duration (Easy)
Write a query to calculate the duration of each event in days.

**Expected columns:** event_name, start_date, end_date, duration_days

### Exercise 26: Overlapping Events (Hard)
Write a query to find pairs of events that overlap in time.

**Expected columns:** event1_name, event2_name, overlap_days

### Part 7: Advanced Date Analysis (Hard)

### Exercise 27: Same Day Last Year (Hard)
Write a query to compare each day's revenue to the same day last year.

**Expected columns:** date, revenue, last_year_revenue, yoy_change_pct

### Exercise 28: Moving Date Window (Hard)
Write a query to calculate 30-day rolling revenue for each date.

**Expected columns:** date, daily_revenue, rolling_30_day_revenue

**Hint:** Use window functions with date ranges

### Exercise 29: First Purchase Analysis (Hard)
Write a query to analyze time from registration to first purchase.

**Expected columns:** customer_name, registration_date, first_order_date, days_to_first_purchase

**Hint:** Join customers with their first order

### Exercise 30: Complete Date Analytics Dashboard (Very Hard)
Write a query to create a comprehensive date-based dashboard:
- Total orders by year, quarter, month
- Weekday vs weekend breakdown
- Peak hours analysis
- Seasonal trends
- Month-over-month growth
- Customer acquisition by month

**Expected columns:** metric_category, metric_name, time_period, value

**Hint:** Use UNION ALL to combine multiple analyses

## Key Takeaways

- **Use proper date types** - DATE, TIME, TIMESTAMP, not strings
- **EXTRACT gets date parts** - YEAR, MONTH, DAY, DOW, etc.
- **DATE_TRUNC for grouping** - Truncate to year, month, week, day
- **INTERVAL for arithmetic** - Add/subtract time periods
- **CURRENT_DATE for comparisons** - Find recent, old, or current records
- **Date differences return integers** - Days between dates
- **Format with TO_CHAR** - Display dates in different formats
- **Parse with TO_DATE** - Convert strings to dates
- **Index date columns** - Improves query performance
- **Handle NULL dates** - Always check for NULL in calculations
- **Use DATE_TRUNC for aggregations** - Better than EXTRACT for grouping
- **Essential for time-series analysis** - Trends, cohorts, seasonality

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 20
