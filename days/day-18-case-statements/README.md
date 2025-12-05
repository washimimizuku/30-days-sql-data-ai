# Day 18: CASE Statements

## 📖 Learning Objectives

By the end of today, you will:
- Master CASE statements for conditional logic in SQL
- Use CASE for categorization and data transformation
- Combine CASE with aggregations for analytics
- Create pivot tables with conditional aggregation
- Build dynamic, flexible SQL queries

---

## 📚 Theory (15 minutes)

### What are CASE Statements?

CASE statements add conditional logic to SQL - like if/else in programming.

### Searched CASE Syntax (Most Common)

```sql
CASE 
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
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
    CASE status
        WHEN 'pending' THEN 'Processing'
        WHEN 'shipped' THEN 'In Transit'
        WHEN 'delivered' THEN 'Complete'
        ELSE 'Unknown'
    END as status_description
FROM orders;
```

**Note:** Searched CASE is more flexible and commonly used.

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

**Why not WHERE?** WHERE filters rows - we want to count different conditions in one query.

**Conditional summing:**
```sql
SELECT 
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as completed_revenue,
    SUM(CASE WHEN status = 'pending' THEN total ELSE 0 END) as pending_revenue
FROM orders;
```

### CASE in Different Clauses

**In WHERE:**
```sql
SELECT * FROM products
WHERE CASE 
    WHEN category = 'Electronics' THEN price > 100
    WHEN category = 'Books' THEN price > 20
    ELSE price > 50
END;
```

**In ORDER BY:**
```sql
SELECT product_name, category, price
FROM products
ORDER BY 
    CASE category
        WHEN 'Electronics' THEN 1
        WHEN 'Books' THEN 2
        ELSE 3
    END,
    price DESC;
```

**In GROUP BY:**
```sql
SELECT 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_tier,
    COUNT(*) as product_count
FROM products
GROUP BY 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END;
```

---

## 🎯 Real-World Use Cases

### Customer Segmentation
```sql
SELECT 
    customer_name,
    order_count,
    total_spent,
    CASE 
        WHEN order_count >= 10 AND total_spent > 5000 THEN 'VIP'
        WHEN order_count >= 5 OR total_spent > 2000 THEN 'Loyal'
        WHEN order_count > 0 THEN 'Regular'
        ELSE 'New'
    END as customer_tier
FROM customer_stats;
```

### Pivot Table
```sql
-- Sales by category and quarter
SELECT 
    category,
    SUM(CASE WHEN quarter = 1 THEN revenue ELSE 0 END) as q1_revenue,
    SUM(CASE WHEN quarter = 2 THEN revenue ELSE 0 END) as q2_revenue,
    SUM(CASE WHEN quarter = 3 THEN revenue ELSE 0 END) as q3_revenue,
    SUM(CASE WHEN quarter = 4 THEN revenue ELSE 0 END) as q4_revenue
FROM quarterly_sales
GROUP BY category;
```

### Dynamic Pricing
```sql
SELECT 
    product_name,
    price,
    stock,
    CASE 
        WHEN stock = 0 THEN price * 1.2  -- Out of stock premium
        WHEN stock < 10 THEN price * 1.1  -- Low stock markup
        WHEN stock > 100 THEN price * 0.9  -- Overstock discount
        ELSE price
    END as dynamic_price
FROM products;
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

```bash
python setup.py
```

Tables: `products`, `employees`, `customers`, `orders`, `order_items`

### Exercises

Complete 20 exercises in `exercise.sql`:

1. **Basic CASE** (10 min) - Categorization, binary classification, status descriptions
2. **CASE with Aggregations** (10 min) - Conditional counting, summing, revenue by status
3. **Complex Categorization** (10 min) - Customer segmentation, profitability tiers, bonuses
4. **Pivot Tables** (5 min) - Revenue by category and status, monthly sales
5. **Advanced Applications** (5 min) - Nested CASE, CASE in ORDER BY/WHERE/GROUP BY

---

## 💡 Key Patterns & Best Practices

### Common Patterns

**Binning:**
```sql
CASE 
    WHEN value < 10 THEN '0-10'
    WHEN value < 20 THEN '10-20'
    ELSE '20+'
END
```

**Flag Creation:**
```sql
CASE WHEN condition THEN 1 ELSE 0 END as flag
```

**Conditional Aggregation:**
```sql
SUM(CASE WHEN condition THEN amount ELSE 0 END)
```

**Pivot:**
```sql
SUM(CASE WHEN category = 'A' THEN amount ELSE 0 END) as category_a
```

### Best Practices

1. **Always include ELSE** - Avoid NULL results
2. **Order conditions carefully** - Most specific first
3. **Use meaningful names** - Clear column aliases
4. **Keep it readable** - Format with line breaks
5. **Consider performance** - Simple conditions are faster

### Common Mistakes

❌ **Forgetting ELSE:**
```sql
-- Bad - returns NULL for unmatched
CASE WHEN price > 100 THEN 'Expensive' END
```

✅ **Always include ELSE:**
```sql
CASE WHEN price > 100 THEN 'Expensive' ELSE 'Affordable' END
```

❌ **Wrong condition order:**
```sql
-- Wrong - all values match first condition
CASE 
    WHEN price > 0 THEN 'Has Price'
    WHEN price > 100 THEN 'Expensive'  -- Never reached!
END
```

✅ **Specific conditions first:**
```sql
CASE 
    WHEN price > 100 THEN 'Expensive'
    WHEN price > 0 THEN 'Has Price'
END
```

❌ **Type mismatch:**
```sql
-- Wrong - mixing types
CASE 
    WHEN condition THEN 'Yes'
    ELSE 0  -- String vs Number
END
```

✅ **Consistent types:**
```sql
CASE 
    WHEN condition THEN 'Yes'
    ELSE 'No'
END
```

---

## ✅ Quiz

Test your knowledge in `quiz.md`!

---

## 🚀 Next Steps

Tomorrow: Date and Time Functions - Working with temporal data.
