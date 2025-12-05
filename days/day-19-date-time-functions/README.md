# Day 19: Date and Time Functions

## 📖 Learning Objectives

By the end of today, you will:
- Master date and time data types in SQL
- Learn EXTRACT, DATE_PART, and DATE_TRUNC functions
- Work with INTERVAL for date arithmetic
- Calculate date differences and ranges
- Build time-based analytics queries

---

## 📚 Theory (15 minutes)

### Date and Time Data Types

**DATE** - Date only (YYYY-MM-DD)
**TIME** - Time only (HH:MM:SS)
**TIMESTAMP** - Date and time
**INTERVAL** - Duration

```sql
DATE '2024-01-15'
TIME '14:30:00'
TIMESTAMP '2024-01-15 14:30:00'
INTERVAL '5 days'
```

### Current Date and Time

```sql
SELECT CURRENT_DATE;           -- 2024-12-05
SELECT CURRENT_TIMESTAMP;      -- 2024-12-05 15:30:45
SELECT NOW();                  -- Same as CURRENT_TIMESTAMP
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
    EXTRACT(WEEK FROM order_date) as week_number
FROM orders;
```

### DATE_TRUNC Function

Truncate to specific precision:

```sql
SELECT 
    order_date,
    DATE_TRUNC('year', order_date) as year_start,    -- 2024-01-01
    DATE_TRUNC('month', order_date) as month_start,  -- 2024-03-01
    DATE_TRUNC('week', order_date) as week_start,    -- Monday of week
    DATE_TRUNC('day', order_date) as day_start
FROM orders;
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
    CURRENT_DATE + INTERVAL '1 month' as next_month;

-- Subtract intervals
SELECT 
    CURRENT_DATE - INTERVAL '30 days' as thirty_days_ago,
    CURRENT_DATE - INTERVAL '6 months' as six_months_ago;
```

### Date Arithmetic

```sql
-- Difference between dates (returns integer days)
SELECT 
    order_date,
    CURRENT_DATE - order_date as days_ago,
    delivery_date - order_date as delivery_days
FROM orders;
```

### Filtering by Date

```sql
-- Last 30 days
SELECT * FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';

-- This month
SELECT * FROM orders
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', CURRENT_DATE);

-- This year
SELECT * FROM orders
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE);
```

---

## 🎯 Real-World Use Cases

### Customer Tenure Segmentation
```sql
SELECT 
    customer_name,
    registration_date,
    CASE 
        WHEN registration_date >= CURRENT_DATE - INTERVAL '3 months' THEN 'New'
        WHEN registration_date >= CURRENT_DATE - INTERVAL '1 year' THEN 'Recent'
        WHEN registration_date >= CURRENT_DATE - INTERVAL '3 years' THEN 'Established'
        ELSE 'Veteran'
    END as tenure_segment
FROM customers;
```

### Seasonal Analysis
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
ORDER BY year, season;
```

### Cohort Analysis
```sql
SELECT 
    DATE_TRUNC('month', registration_date) as cohort_month,
    COUNT(*) as customers_in_cohort,
    COUNT(CASE WHEN last_order_date >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as active,
    ROUND(COUNT(CASE WHEN last_order_date >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) * 100.0 / COUNT(*), 2) as retention_rate
FROM customers
GROUP BY DATE_TRUNC('month', registration_date)
ORDER BY cohort_month;
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

```bash
python setup.py
```

Tables: `orders`, `customers`, `employees`, `events`

### Exercises

Complete 20 exercises in `exercise.sql`:

1. **Basic Date Functions** (10 min) - EXTRACT, current date, day of week, quarters
2. **Date Arithmetic** (10 min) - Add/subtract intervals, date ranges, age calculations
3. **DATE_TRUNC and Grouping** (10 min) - Monthly/weekly revenue, quarterly performance
4. **Time-Based Filtering** (5 min) - Recent customers, inactive customers, seasonal analysis
5. **Advanced Analysis** (5 min) - Customer segments, cohorts, time-based analytics

---

## 💡 Key Patterns & Best Practices

### Common Patterns

**Last N days:**
```sql
WHERE date >= CURRENT_DATE - INTERVAL 'N days'
```

**Month-to-date:**
```sql
WHERE date >= DATE_TRUNC('month', CURRENT_DATE)
```

**Group by month:**
```sql
GROUP BY DATE_TRUNC('month', date)
```

**Age calculation:**
```sql
(CURRENT_DATE - birth_date) / 365 as age_years
```

### Best Practices

1. **Use DATE type** - Not strings
2. **Use INTERVAL for arithmetic** - Clearer than adding days
3. **Index date columns** - For better performance
4. **Use DATE_TRUNC for grouping** - Better than EXTRACT
5. **Handle NULL dates** - Always check for NULL

### Common Mistakes

❌ **Comparing dates as strings:**
```sql
WHERE order_date > '2024-01-01'  -- Wrong
```

✅ **Use DATE type:**
```sql
WHERE order_date > DATE '2024-01-01'
```

❌ **Not handling NULL:**
```sql
WHERE CURRENT_DATE - order_date > 30  -- Fails on NULL
```

✅ **Check for NULL:**
```sql
WHERE order_date IS NOT NULL AND CURRENT_DATE - order_date > 30
```

---

## ✅ Quiz

Test your knowledge in `quiz.md`!

---

## 🚀 Next Steps

Tomorrow: Mini Project - Data Warehouse - Build a complete analytics database.
