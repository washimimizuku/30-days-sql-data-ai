# Day 1: Setup and SELECT Basics

## 📖 Learning Objectives (15 min)

By the end of today, you will:
- Install and set up DuckDB
- Understand the basic structure of a SELECT statement
- Query data from a single table
- Use column aliases
- Filter columns with SELECT

---

## Theory

### What is DuckDB?

DuckDB is an in-process SQL database designed for analytics (OLAP). Think of it as "SQLite for analytics."

**Why DuckDB?**
- No server setup required
- Fast analytical queries
- Works with CSV, Parquet, JSON
- Full SQL support
- Perfect for learning and local development

### Installing DuckDB

```bash
# Install via pip
pip install duckdb

# Or download CLI from duckdb.org
```

### Basic SELECT Statement

The SELECT statement retrieves data from a database.

**Syntax:**
```sql
SELECT column1, column2, ...
FROM table_name;
```

**Example:**
```sql
-- Select specific columns
SELECT name, age, city
FROM employees;

-- Select all columns
SELECT *
FROM employees;
```

### Column Aliases

Use `AS` to rename columns in the output:

```sql
SELECT 
    name AS employee_name,
    age AS employee_age,
    salary * 12 AS annual_salary
FROM employees;
```

### Selecting Expressions

You can perform calculations in SELECT:

```sql
SELECT 
    name,
    salary,
    salary * 0.1 AS tax,
    salary * 0.9 AS after_tax
FROM employees;
```

### DISTINCT

Remove duplicate rows:

```sql
-- Get unique cities
SELECT DISTINCT city
FROM employees;

-- Get unique combinations
SELECT DISTINCT city, department
FROM employees;
```

---

## 💻 Exercises (40 min)

### Setup

First, run the setup script to create the database:

```bash
python setup.py
```

This creates `day01.db` with sample data.

### Exercise 1: Basic SELECT

Write queries to:
1. Select all columns from the `employees` table
2. Select only `name` and `salary` columns
3. Select `name`, `department`, and `hire_date`

### Exercise 2: Column Aliases

Write a query that:
1. Selects `name` as `employee_name`
2. Selects `salary` as `monthly_salary`
3. Calculates `salary * 12` as `annual_salary`

### Exercise 3: Calculations

Write a query that:
1. Shows employee name
2. Shows current salary
3. Calculates a 10% raise as `new_salary`
4. Calculates the difference as `raise_amount`

### Exercise 4: DISTINCT

Write queries to:
1. Get all unique departments
2. Get all unique cities
3. Get unique combinations of department and city

---

## 🎯 Practice

Complete the exercises in `exercise.sql`:

```bash
# Run your queries
duckdb day01.db < exercise.sql

# Or use interactive mode
duckdb day01.db
```

Check your solutions against `solution.sql`.

---

## 📊 Sample Data

The `employees` table has:
- `id` - Employee ID
- `name` - Employee name
- `department` - Department name
- `salary` - Monthly salary
- `city` - Office location
- `hire_date` - Date hired

---

## 💡 Key Concepts

### SELECT Execution Order

```sql
SELECT column1, column2    -- 2. Then select columns
FROM table_name            -- 1. First, get data from table
```

### Best Practices

1. **Be specific** - Select only needed columns, not `*`
2. **Use aliases** - Make output readable
3. **Format queries** - Use indentation and line breaks
4. **Comment your code** - Use `--` for comments

### Common Mistakes

```sql
-- ❌ Missing FROM clause
SELECT name;

-- ✅ Correct
SELECT name FROM employees;

-- ❌ Typo in column name
SELECT nmae FROM employees;

-- ✅ Correct
SELECT name FROM employees;
```

---

## 📚 Resources

- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial - SELECT](https://www.sqltutorial.org/sql-select/)
- [DuckDB Installation](https://duckdb.org/docs/installation/)

---

## ✅ Quiz

Take the quiz in `quiz.md` to test your understanding!

---

## 🚀 Next Steps

Tomorrow: WHERE Clause and Filtering - Learn how to filter rows based on conditions.
