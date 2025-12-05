# 🚀 Quick Start Guide

## Prerequisites

- **Time commitment**: 1 hour per day for 30 days
- **Prior knowledge**: None required - starts from basics
- **System**: macOS, Linux, or Windows
- **Python**: 3.8+ (for setup scripts)

---

## Installation

### 1. Install DuckDB

```bash
# Via pip (recommended)
pip install duckdb

# Verify installation
python -c "import duckdb; print(duckdb.__version__)"

# Or download CLI from duckdb.org
```

### 2. Install Python (if needed)

```bash
# Check Python version
python --version  # Should be 3.8+

# Install if needed (macOS)
brew install python

# Ubuntu/Debian
sudo apt install python3 python3-pip
```

### 3. Clone or Download This Repository

```bash
cd ~/Code
git clone <your-repo-url>
cd 30-days-sql-data-ai
```

---

## Daily Workflow

### Step 1: Setup Database (2 min)

```bash
cd days/day-01-setup-select-basics
python setup.py
```

This creates a DuckDB database with sample data.

### Step 2: Read the Lesson (15 min)

```bash
cat README.md  # or open in your editor
```

### Step 3: Write SQL Queries (40 min)

```bash
# Edit exercise.sql
code exercise.sql  # or use any text editor

# Test your queries
duckdb day01.db < exercise.sql

# Or use interactive mode
duckdb day01.db
```

### Step 4: Check Solution (5 min)

```bash
# Compare with solution
cat solution.sql

# Run solution
duckdb day01.db < solution.sql
```

### Step 5: Take Quiz (5 min)

```bash
cat quiz.md
```

---

## Folder Structure

```
30-days-sql-data-ai/
├── README.md              # Overview
├── CURRICULUM.md          # Full curriculum
├── QUICKSTART.md          # This file
├── resources/
│   ├── SETUP.md          # Detailed setup
│   └── cheatsheet.md     # SQL quick reference
├── tools/
│   └── check_setup.py    # Verify installation
└── days/
    ├── day-01-setup-select-basics/
    │   ├── README.md     # Lesson (15 min)
    │   ├── setup.py      # Create database
    │   ├── exercise.sql  # Your queries (40 min)
    │   ├── solution.sql  # Solutions
    │   └── quiz.md       # Quiz (5 min)
    ├── day-02-where-filtering/
    └── ...
```

---

## DuckDB Basics

### Interactive Mode

```bash
# Open database
duckdb day01.db

# Run queries interactively
SELECT * FROM employees;

# Exit
.quit
```

### Run SQL File

```bash
# Execute all queries in file
duckdb day01.db < exercise.sql

# With output to file
duckdb day01.db < exercise.sql > results.txt
```

### Useful Commands

```sql
-- Show all tables
SHOW TABLES;

-- Describe table structure
DESCRIBE employees;

-- Show table schema
PRAGMA table_info('employees');

-- Export to CSV
COPY (SELECT * FROM employees) TO 'output.csv' (HEADER, DELIMITER ',');

-- Read CSV
SELECT * FROM read_csv_auto('data.csv');

-- Read Parquet
SELECT * FROM read_parquet('data.parquet');
```

---

## Tips for Success

### 1. Start Simple

Begin with basic SELECT, then add complexity:

```sql
-- Start here
SELECT name FROM employees;

-- Add more
SELECT name, salary FROM employees;

-- Add calculations
SELECT name, salary, salary * 12 as annual FROM employees;

-- Add filtering
SELECT name, salary FROM employees WHERE salary > 70000;
```

### 2. Format Your Queries

```sql
-- ❌ Hard to read
SELECT name,salary,department FROM employees WHERE salary>70000 ORDER BY salary DESC;

-- ✅ Easy to read
SELECT 
    name,
    salary,
    department
FROM employees
WHERE salary > 70000
ORDER BY salary DESC;
```

### 3. Use Comments

```sql
-- This query finds high earners
SELECT name, salary
FROM employees
WHERE salary > 80000;  -- Above 80K threshold
```

### 4. Test Incrementally

Build queries step by step:

```sql
-- Step 1: Basic select
SELECT * FROM employees;

-- Step 2: Add filtering
SELECT * FROM employees WHERE department = 'Sales';

-- Step 3: Add aggregation
SELECT department, AVG(salary) FROM employees GROUP BY department;
```

### 5. Use LIMIT for Testing

```sql
-- Test with small result set first
SELECT * FROM large_table LIMIT 10;
```

---

## Common Commands

### Database Operations

```bash
# Create new database
duckdb mydata.db

# Open existing database
duckdb day01.db

# Run SQL file
duckdb day01.db < queries.sql

# Export results
duckdb day01.db -c "SELECT * FROM employees" > output.csv
```

### DuckDB CLI Commands

```sql
-- Show help
.help

-- Show tables
.tables

-- Show schema
.schema employees

-- Change output mode
.mode csv
.mode markdown
.mode table

-- Exit
.quit
```

---

## Troubleshooting

### "duckdb: command not found"

```bash
# Install via pip
pip install duckdb

# Or download from duckdb.org
```

### "Table does not exist"

Run the setup script first:
```bash
python setup.py
```

### "Syntax error"

Check for:
- Missing semicolons
- Typos in keywords
- Incorrect table/column names
- Unmatched quotes

### Query Returns No Results

Check:
- Table has data: `SELECT COUNT(*) FROM table_name;`
- WHERE conditions are correct
- Column names are spelled correctly

---

## Learning Resources

### Official

- [DuckDB Documentation](https://duckdb.org/docs/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)
- [SQL Tutorial](https://www.sqltutorial.org/)

### Practice

- [SQLZoo](https://sqlzoo.net/) - Interactive SQL tutorial
- [LeetCode SQL](https://leetcode.com/problemset/database/) - SQL problems
- [HackerRank SQL](https://www.hackerrank.com/domains/sql) - SQL challenges

### Community

- [DuckDB Discord](https://discord.duckdb.org/)
- [r/SQL](https://reddit.com/r/SQL)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/duckdb)

---

## Week-by-Week Overview

### Week 1: SQL Basics
SELECT, WHERE, ORDER BY, aggregations, GROUP BY

### Week 2: JOINs and Subqueries
All join types, subqueries, mini project

### Week 3: Intermediate SQL
CTEs, window functions, CASE, date/string functions

### Week 4: Advanced & Data Engineering
Optimization, transactions, views, data modeling, JSON

---

## Sample Queries

### Basic Query

```sql
SELECT name, salary
FROM employees
WHERE department = 'Engineering'
ORDER BY salary DESC;
```

### Aggregation

```sql
SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary) as avg_salary
FROM employees
GROUP BY department;
```

### Join

```sql
SELECT 
    e.name,
    d.department_name,
    e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;
```

### Window Function

```sql
SELECT 
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees;
```

---

## Getting Help

1. **Read the error message** - DuckDB errors are clear
2. **Check the lesson README** - Examples and explanations
3. **Look at the solution** - Compare your approach
4. **Search documentation** - DuckDB docs are excellent
5. **Ask the community** - DuckDB Discord is active

---

## Ready to Start?

```bash
cd days/day-01-setup-select-basics
python setup.py
duckdb day01.db
```

**Let's master SQL! 📊**
