# Day 16: Window Functions - ROW_NUMBER, RANK, DENSE_RANK

## 📖 Learning Objectives (15 min)

By the end of today, you will:
- Understand what window functions are and why they're powerful
- Master ROW_NUMBER() for sequential numbering
- Use RANK() and DENSE_RANK() for ranking with ties
- Apply PARTITION BY to create groups within window functions
- Combine window functions with CTEs for advanced queries
- Solve real-world problems like "top N per group"

---

## 📚 Theory (15 minutes)

### What are Window Functions?

Window functions perform calculations across a set of rows related to the current row, WITHOUT collapsing the rows like GROUP BY does.

**Key Difference:**
```sql
-- GROUP BY: Collapses rows
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
-- Result: One row per department

-- Window Function: Keeps all rows
SELECT 
    name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) as dept_avg
FROM employees;
-- Result: All rows, with department average added
```

### ROW_NUMBER()

Assigns a unique sequential number to each row:

```sql
SELECT 
    name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
FROM employees;
```

**Result:**
```
name          salary  row_num
Frank Miller  85000   1
Charlie Brown 80000   2
Iris Chen     78000   3
...
```

### RANK()

Assigns ranks with gaps for ties:

```sql
SELECT 
    name,
    salary,
    RANK() OVER (ORDER BY salary DESC) as rank
FROM employees;
```

**With ties:**
```
name          salary  rank
Frank Miller  85000   1
Charlie Brown 80000   2
Iris Chen     78000   3
Alice Johnson 75000   4
Alice Clone   75000   4  -- Same rank
Diana Prince  70000   6  -- Gap! (skips 5)
```

### DENSE_RANK()

Assigns ranks WITHOUT gaps for ties:

```sql
SELECT 
    name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank
FROM employees;
```

**With ties:**
```
name          salary  dense_rank
Frank Miller  85000   1
Charlie Brown 80000   2
Iris Chen     78000   3
Alice Johnson 75000   4
Alice Clone   75000   4  -- Same rank
Diana Prince  70000   5  -- No gap!
```

### PARTITION BY

Divide data into groups and apply window function to each group:

```sql
-- Rank employees within each department
SELECT 
    name,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department 
        ORDER BY salary DESC
    ) as dept_rank
FROM employees;
```

**Result:**
```
name          department   salary  dept_rank
Frank Miller  Engineering  85000   1
Charlie Brown Engineering  80000   2
Iris Chen     Engineering  78000   3
Diana Prince  Marketing    70000   1
Grace Lee     Marketing    72000   2
...
```

### Window Function Syntax

```sql
function_name() OVER (
    [PARTITION BY column1, column2, ...]
    [ORDER BY column1 [ASC|DESC], ...]
)
```

**Components:**
- `function_name()` - ROW_NUMBER, RANK, DENSE_RANK, etc.
- `PARTITION BY` - Optional, divides rows into groups
- `ORDER BY` - Optional, defines order within partition

---

## 🎯 Real-World Use Cases

### Use Case 1: E-commerce Product Rankings

Find the top 3 products in each category by sales:

```sql
WITH product_rankings AS (
    SELECT 
        category,
        product_name,
        total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY total_sales DESC
        ) as rank_in_category
    FROM products
)
SELECT * FROM product_rankings 
WHERE rank_in_category <= 3;
```

### Use Case 2: Employee Performance Reviews

Rank employees by performance score, handling ties appropriately:

```sql
SELECT 
    employee_name,
    department,
    performance_score,
    RANK() OVER (ORDER BY performance_score DESC) as overall_rank,
    DENSE_RANK() OVER (
        PARTITION BY department 
        ORDER BY performance_score DESC
    ) as dept_rank
FROM employee_reviews
WHERE review_year = 2024;
```

### Use Case 3: Pagination

Implement pagination for web applications:

```sql
-- Get page 2 (rows 11-20) of products
WITH numbered_products AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY product_name) as row_num
    FROM products
)
SELECT * FROM numbered_products
WHERE row_num BETWEEN 11 AND 20;
```

### Use Case 4: Duplicate Detection

Find and number duplicate records:

```sql
SELECT 
    email,
    name,
    created_date,
    ROW_NUMBER() OVER (
        PARTITION BY email 
        ORDER BY created_date
    ) as occurrence_number
FROM users
WHERE email IN (
    SELECT email 
    FROM users 
    GROUP BY email 
    HAVING COUNT(*) > 1
);
```

### Use Case 5: Sales Leaderboard

Create a sales leaderboard with proper tie handling:

```sql
SELECT 
    salesperson_name,
    region,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) as rank,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) as dense_rank,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) as row_num
FROM sales_summary
WHERE quarter = 'Q4 2024';
```

**Result shows the difference:**
```
name        sales   rank  dense_rank  row_num
John Smith  100000  1     1           1
Jane Doe    100000  1     1           2  -- Same rank, different row_num
Bob Jones   95000   3     2           3  -- RANK skips 2, DENSE_RANK doesn't
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

Run the setup script to create sample data:

```bash
python setup.py
```

This creates tables:
- `employees` - Employee information with salaries and departments
- `sales` - Sales transactions by salesperson
- `products` - Product catalog with categories
- `orders` - Customer orders with dates

### Exercise 1: Basic ROW_NUMBER (5 min)

Write queries to:
1. Assign row numbers to all employees ordered by salary (highest first)
2. Assign row numbers ordered by hire_date (earliest first)
3. Assign row numbers ordered by name alphabetically
4. Number employees within each department

### Exercise 2: Understanding RANK vs DENSE_RANK (10 min)

Write a single query that shows:
1. Employee name and salary
2. ROW_NUMBER() ordered by salary descending
3. RANK() ordered by salary descending
4. DENSE_RANK() ordered by salary descending
5. Observe the differences when salaries are tied

**Expected pattern:**
- ROW_NUMBER: Always unique (1, 2, 3, 4, 5...)
- RANK: Gaps after ties (1, 2, 2, 4, 5...)
- DENSE_RANK: No gaps (1, 2, 2, 3, 4...)

### Exercise 3: PARTITION BY Mastery (10 min)

Write queries to:
1. Rank employees within each department by salary
2. Assign row numbers to products within each category
3. Rank salespeople within each region by total sales
4. Number orders for each customer by order date

### Exercise 4: Top N per Group (10 min)

Solve these common business problems:

1. **Top 3 Earners per Department**
   - Find the 3 highest-paid employees in each department
   - Use ROW_NUMBER() with PARTITION BY
   - Filter using a CTE

2. **Best Selling Products per Category**
   - Find the top 2 products in each category by quantity sold
   - Show category, product name, and quantity

3. **Most Recent Orders per Customer**
   - Get the 5 most recent orders for each customer
   - Include customer name, order date, and amount

### Exercise 5: Advanced Patterns (5 min)

1. **Quartile Assignment**
   - Divide employees into 4 salary quartiles using NTILE(4)
   - Show employee name, salary, and quartile number

2. **Percentile Ranking**
   - Calculate the percentile rank of each employee's salary
   - Use PERCENT_RANK() function

3. **Duplicate Removal**
   - Find duplicate emails in the employees table
   - Keep only the first occurrence (earliest hire_date)
   - Use ROW_NUMBER() to identify duplicates

---

## 🎯 Practice

Complete all exercises in `exercise.sql`:

```bash
# Run setup
python setup.py

# Test your queries
duckdb day16.db < exercise.sql

# Compare with solution
duckdb day16.db < solution.sql
```

---

## 💡 Key Concepts & Best Practices

### When to Use Each Function

**ROW_NUMBER():**
- Need unique numbers for each row
- Pagination
- Selecting top N per group

**RANK():**
- Need to show ties with same rank
- OK to have gaps in ranking
- Traditional ranking (1, 2, 2, 4)

**DENSE_RANK():**
- Need to show ties with same rank
- NO gaps in ranking
- Continuous ranking (1, 2, 2, 3)

### Common Patterns & Recipes

**Pattern 1: Top N per Group**
```sql
WITH ranked AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY department 
            ORDER BY salary DESC
        ) as rn
    FROM employees
)
SELECT * FROM ranked WHERE rn <= 3;
```

**Pattern 2: Percentile Ranking**
```sql
SELECT 
    name,
    salary,
    PERCENT_RANK() OVER (ORDER BY salary) as percentile,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary) * 100, 1) as percentile_pct
FROM employees;
```

**Pattern 3: Quartile/Decile Assignment**
```sql
SELECT 
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary) as salary_quartile,
    NTILE(10) OVER (ORDER BY salary) as salary_decile
FROM employees;
```

**Pattern 4: Deduplication**
```sql
-- Keep first occurrence, remove duplicates
WITH numbered AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY email 
            ORDER BY created_date
        ) as rn
    FROM users
)
DELETE FROM users 
WHERE id IN (
    SELECT id FROM numbered WHERE rn > 1
);
```

**Pattern 5: Gap Detection**
```sql
-- Find gaps in sequential IDs
WITH numbered AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (ORDER BY id) as expected_id
    FROM orders
)
SELECT * FROM numbered 
WHERE id != expected_id;
```

### Performance Tips

1. **Index columns used in ORDER BY** - Speeds up window function sorting
2. **Limit partitions when possible** - Fewer partitions = better performance
3. **Use CTEs for readability** - Makes complex queries maintainable
4. **Filter after windowing** - Window functions run before WHERE clause
5. **Consider materialized views** - For frequently used window calculations

### Common Mistakes to Avoid

❌ **Mistake 1: Using WHERE with window functions**
```sql
-- WRONG: Window functions not allowed in WHERE
SELECT name, ROW_NUMBER() OVER (ORDER BY salary) as rn
FROM employees
WHERE rn <= 5;  -- ERROR!
```

✅ **Correct: Use CTE or subquery**
```sql
WITH numbered AS (
    SELECT name, ROW_NUMBER() OVER (ORDER BY salary) as rn
    FROM employees
)
SELECT * FROM numbered WHERE rn <= 5;
```

❌ **Mistake 2: Forgetting ORDER BY in window**
```sql
-- WRONG: ROW_NUMBER without ORDER BY gives arbitrary order
SELECT name, ROW_NUMBER() OVER () as rn
FROM employees;
```

✅ **Correct: Always specify ORDER BY**
```sql
SELECT name, ROW_NUMBER() OVER (ORDER BY salary DESC) as rn
FROM employees;
```

❌ **Mistake 3: Confusing RANK functions**
```sql
-- Using RANK when you need unique numbers
SELECT name, RANK() OVER (ORDER BY salary) as id
FROM employees;
-- Problem: Ties get same rank, not unique!
```

✅ **Correct: Use ROW_NUMBER for unique values**
```sql
SELECT name, ROW_NUMBER() OVER (ORDER BY salary, name) as id
FROM employees;
```

### Window Functions Cheat Sheet

| Function | Ties? | Gaps? | Use Case |
|----------|-------|-------|----------|
| ROW_NUMBER() | No (always unique) | N/A | Pagination, unique IDs |
| RANK() | Yes (same rank) | Yes | Traditional rankings |
| DENSE_RANK() | Yes (same rank) | No | Continuous rankings |
| NTILE(n) | Distributes evenly | N/A | Quartiles, deciles |
| PERCENT_RANK() | Returns 0-1 | N/A | Percentile calculations |

---

## 🧪 Try It Yourself

Before looking at solutions, try these challenges:

**Challenge 1: Sales Analysis**
Find the top 2 salespeople in each region for Q4 2024.

**Challenge 2: Product Catalog**
Number all products within each category, ordered by price (highest first).

**Challenge 3: Customer Segmentation**
Divide customers into 5 groups (quintiles) based on total purchase amount.

**Challenge 4: Duplicate Detection**
Find all employees with duplicate email addresses and show which occurrence each is.

**Challenge 5: Performance Review**
Rank employees within their department by performance score, showing both RANK and DENSE_RANK to handle ties.

---

## 📚 Resources

- [DuckDB Window Functions](https://duckdb.org/docs/sql/window_functions)
- [SQL Window Functions Tutorial](https://www.sqltutorial.org/sql-window-functions/)
- [PostgreSQL Window Functions](https://www.postgresql.org/docs/current/tutorial-window.html)

---

## ✅ Quiz

Take the quiz in `quiz.md` to test your understanding!

---

## 🚀 Next Steps

Tomorrow: Advanced Window Functions - Learn LAG, LEAD, and moving aggregates.
