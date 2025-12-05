# Day 16: Window Functions - ROW_NUMBER, RANK

## 📖 Learning Objectives (15 min)

By the end of today, you will:
- Understand what window functions are
- Use ROW_NUMBER() to assign row numbers
- Use RANK() and DENSE_RANK() for ranking
- Understand PARTITION BY for grouping
- Use ORDER BY within window functions

---

## Theory

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

## 💻 Exercises (40 min)

### Exercise 1: ROW_NUMBER

Write queries to:
1. Assign row numbers to all employees ordered by salary (highest first)
2. Assign row numbers ordered by hire_date (earliest first)
3. Assign row numbers ordered by name alphabetically

### Exercise 2: RANK vs DENSE_RANK

Write a query that shows:
1. Employee name and salary
2. RANK() ordered by salary descending
3. DENSE_RANK() ordered by salary descending
4. Compare the difference when there are ties

### Exercise 3: PARTITION BY

Write queries to:
1. Rank employees within each department by salary
2. Assign row numbers within each city
3. Rank employees within each department by hire_date

### Exercise 4: Top N per Group

Write a query to:
1. Find the top 2 highest-paid employees in each department
2. Use ROW_NUMBER() with PARTITION BY
3. Filter using a CTE or subquery

---

## 🎯 Practice

Complete the exercises in `exercise.sql`:

```bash
python setup.py
duckdb day16.db < exercise.sql
```

---

## 💡 Key Concepts

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

### Common Patterns

**Top N per Group:**
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

**Percentile Ranking:**
```sql
SELECT 
    name,
    salary,
    PERCENT_RANK() OVER (ORDER BY salary) as percentile
FROM employees;
```

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
