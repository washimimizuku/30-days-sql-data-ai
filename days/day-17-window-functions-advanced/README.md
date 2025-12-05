# Day 17: Window Functions - LAG, LEAD, Moving Averages

## 📖 Learning Objectives

By the end of today, you will:
- Master LAG() and LEAD() for accessing previous/next rows
- Calculate moving averages and running totals
- Perform time-series analysis and trend detection
- Use FIRST_VALUE() and LAST_VALUE()

---

## 📚 Theory (15 minutes)

### LAG() - Access Previous Rows

LAG accesses data from a PREVIOUS row without using a self-join.

**Syntax:**
```sql
LAG(column, offset, default) OVER (ORDER BY column)
```

**Example:**
```sql
SELECT 
    order_date,
    total,
    LAG(total) OVER (ORDER BY order_date) as prev_total,
    total - LAG(total) OVER (ORDER BY order_date) as change
FROM orders;
```

Result:
```
order_date  | total | prev_total | change
2024-01-01  | 100   | NULL       | NULL
2024-01-02  | 150   | 100        | 50
2024-01-03  | 120   | 150        | -30
```

### LEAD() - Access Next Rows

LEAD accesses data from a NEXT row.

**Example:**
```sql
SELECT 
    order_date,
    total,
    LEAD(total) OVER (ORDER BY order_date) as next_total
FROM orders;
```

### LAG with PARTITION BY

Reset LAG within groups:

```sql
SELECT 
    customer_id,
    order_date,
    total,
    LAG(total) OVER (PARTITION BY customer_id ORDER BY order_date) as prev_order,
    order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as days_since_last
FROM orders;
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
    ) as ma_7
FROM daily_sales;
```

**Frame specifications:**
- `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` = 7 rows (current + 6 previous)
- `ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING` = 5 rows (centered)
- `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` = all rows from start

### Running Totals

```sql
SELECT 
    order_date,
    total,
    SUM(total) OVER (ORDER BY order_date) as running_total
FROM orders;
```

### FIRST_VALUE and LAST_VALUE

```sql
SELECT 
    order_date,
    total,
    FIRST_VALUE(total) OVER (ORDER BY order_date) as first_total,
    LAST_VALUE(total) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as last_total
FROM orders;
```

**Important:** LAST_VALUE needs proper frame specification!

---

## 🎯 Real-World Use Cases

### Month-over-Month Growth
```sql
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(total) as revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as prev_month,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / 
          LAG(revenue) OVER (ORDER BY month), 2) as growth_pct
FROM monthly_revenue;
```

### Customer Purchase Patterns
```sql
SELECT 
    customer_id,
    order_date,
    total,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as prev_order_date,
    order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) as days_between,
    SUM(total) OVER (PARTITION BY customer_id ORDER BY order_date) as lifetime_value
FROM orders;
```

### Stock Price Analysis
```sql
SELECT 
    date,
    close_price,
    LAG(close_price) OVER (ORDER BY date) as prev_close,
    close_price - LAG(close_price) OVER (ORDER BY date) as daily_change,
    AVG(close_price) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as ma_7,
    AVG(close_price) OVER (ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) as ma_30
FROM stock_prices;
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

```bash
python setup.py
```

Tables: `daily_sales`, `orders`, `customers`, `stock_prices`

### Exercises

Complete 20 exercises in `exercise.sql`:

1. **Basic LAG/LEAD** (10 min) - Previous/next day sales, daily changes, percentage changes
2. **LAG with PARTITION BY** (10 min) - Customer order history, days between orders
3. **Moving Averages** (10 min) - 7-day, 30-day, centered moving averages
4. **Running Totals** (5 min) - Cumulative sales, customer lifetime value
5. **Trend Analysis** (5 min) - Identify uptrends, peak detection

---

## 💡 Key Patterns & Best Practices

### Common Patterns

**Period-over-Period Change:**
```sql
value - LAG(value) OVER (ORDER BY date) as change
```

**Percentage Change:**
```sql
ROUND((value - LAG(value) OVER (ORDER BY date)) * 100.0 / 
      LAG(value) OVER (ORDER BY date), 2) as pct_change
```

**Moving Average:**
```sql
AVG(value) OVER (ORDER BY date ROWS BETWEEN n PRECEDING AND CURRENT ROW)
```

**Running Total:**
```sql
SUM(value) OVER (ORDER BY date)
```

### Common Mistakes

❌ **Wrong frame for LAST_VALUE:**
```sql
-- Wrong - only looks at current row
LAST_VALUE(total) OVER (ORDER BY date)
```

✅ **Correct:**
```sql
LAST_VALUE(total) OVER (
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

❌ **Forgetting ORDER BY:**
```sql
LAG(total) OVER ()  -- Undefined order!
```

✅ **Always specify ORDER BY:**
```sql
LAG(total) OVER (ORDER BY order_date)
```

### Frame Specifications

```sql
-- Current row only
ROWS BETWEEN CURRENT ROW AND CURRENT ROW

-- Current + 3 preceding (4 rows total)
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW

-- Centered window (5 rows total)
ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING

-- All rows from start to current
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

-- All rows in partition
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```

---

## ✅ Quiz

Test your knowledge in `quiz.md`!

---

## 🚀 Next Steps

Tomorrow: CASE Statements - Conditional logic in SQL.
