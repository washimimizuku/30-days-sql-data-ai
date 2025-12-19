# 🚀 Quick Start Guide

## Prerequisites

- **Time commitment**: 1 hour per day for 30 days
- **Prior knowledge**: None required - starts from basics
- **System**: macOS, Linux, or Windows
- **Python**: 3.8+ (for setup scripts)

---

## Installation

### 1. Clone or Download This Repository

```bash
cd ~/Code
git clone <your-repo-url>
cd 30-days-sql-data-ai
```

### 2. Create Python Virtual Environment

**Why use a virtual environment?**
- Keeps dependencies isolated from your system Python
- Prevents version conflicts
- Makes the project portable

```bash
# Create virtual environment
python3 -m venv venv

# Activate it (macOS/Linux)
source venv/bin/activate

# Activate it (Windows)
venv\Scripts\activate

# Your prompt should now show (venv)
```

### 3. Install Dependencies

```bash
# Install all required packages
pip3 install -r requirements.txt

# This installs:
# - duckdb (database engine)
# - pandas (data manipulation)
# - faker (sample data generation)
# - jupyter (optional, for notebooks)
# - matplotlib (optional, for visualizations)
```

### 4. Verify Installation

```bash
# Check DuckDB is installed
python3 -c "import duckdb; print(f'DuckDB {duckdb.__version__} installed!')"

# Or run the test script
python3 tools/test_setup.py
```

### 5. Deactivate Virtual Environment (when done)

```bash
# To exit the virtual environment
deactivate
```

**Important:** Always activate the virtual environment before working:
```bash
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows
```

---

## Daily Workflow

### Step 0: Activate Virtual Environment

**Always do this first!**

```bash
# From the project root
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows
```

### Step 1: Setup Database (2 min)

```bash
python3 days/day-01-setup-select-basics/setup.py
```

This creates a DuckDB database in `data/databases/` with sample data.

### Step 2: Read the Lesson (15 min)

```bash
cat README.md  # or open in your editor
```

### Step 3: Write SQL Queries (40 min)

```bash
# Edit exercise.sql
code exercise.sql  # or use any text editor

# Test your queries using the helper script (easiest!)
python3 tools/run_sql.py data/databases/day01.db days/day-01-setup-select-basics/exercise.sql

# Or test individual queries with Python (shows results)
python3 -c "import duckdb; conn = duckdb.connect('data/databases/day01.db'); print(conn.execute('SELECT * FROM employees LIMIT 5').fetchall())"

# Or use Python directly (for running exercise.sql file)
python3 -c "import duckdb; conn = duckdb.connect('data/databases/day01.db'); conn.execute(open('days/day-01-setup-select-basics/exercise.sql').read())"

# Or use interactive Python shell
python3
>>> import duckdb
>>> conn = duckdb.connect('data/databases/day01.db')
>>> conn.execute("SELECT * FROM employees").fetchall()
>>> exit()
```

**Note:** 
- All databases are stored in `data/databases/` to keep your workspace organized
- Exercise files contain TODO comments - you need to write the actual SQL queries
- Use the helper script or interactive Python to test your queries as you write them

### Step 4: Check Solution (5 min)

```bash
# Compare with solution
cat solution.sql

# Run solution using the helper script
python3 tools/run_sql.py data/databases/day01.db days/day-01-setup-select-basics/solution.sql
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
├── venv/                 # Virtual environment (created by you)
├── data/
│   └── databases/        # All DuckDB databases stored here
│       ├── day01.db
│       ├── day02.db
│       └── ...
├── docs/
│   ├── SETUP.md          # Detailed setup
│   └── ...
├── tools/
│   └── test_setup.py     # Verify installation
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

### Interactive Mode (Python)

```bash
# Open Python with DuckDB
python

# In Python shell:
>>> import duckdb
>>> conn = duckdb.connect('day01.db')
>>> 
>>> # Run queries interactively
>>> conn.execute("SELECT * FROM employees").fetchall()
>>> 
>>> # Or use fetchdf() for pandas DataFrame
>>> conn.execute("SELECT * FROM employees").fetchdf()
>>> 
>>> # Close connection
>>> conn.close()
>>> exit()
```

### Run SQL File (Python)

```bash
# Method 1: Use the provided helper script (easiest!)
python ../../tools/run_sql.py ../../data/databases/day01.db exercise.sql

# Method 2: One-liner (to see results, use fetchall())
python -c "import duckdb; conn = duckdb.connect('../../data/databases/day01.db'); print(conn.execute('SELECT * FROM employees LIMIT 5').fetchall())"

# Method 3: Interactive Python (best for exploration)
python
>>> import duckdb
>>> conn = duckdb.connect('../../data/databases/day01.db')
>>> conn.execute("SELECT * FROM employees").fetchall()
>>> exit()
```

### Using DuckDB CLI (Optional)

If you have the standalone DuckDB CLI installed:

```bash
# Open database
duckdb day01.db

# Run queries interactively
SELECT * FROM employees;

# Exit
.quit

# Run SQL file
duckdb day01.db < exercise.sql
```

### Useful Commands (Python)

```python
import duckdb

# Connect to database in data/databases folder
conn = duckdb.connect('../../data/databases/day01.db')

# Show all tables
conn.execute("SHOW TABLES").fetchall()

# Describe table structure
conn.execute("DESCRIBE employees").fetchall()

# Show table schema
conn.execute("PRAGMA table_info('employees')").fetchall()

# Export to CSV
conn.execute("COPY (SELECT * FROM employees) TO 'output.csv' (HEADER, DELIMITER ',')")

# Read CSV
conn.execute("SELECT * FROM read_csv_auto('data.csv')").fetchall()

# Read Parquet
conn.execute("SELECT * FROM read_parquet('data.parquet')").fetchall()

# Get results as pandas DataFrame
df = conn.execute("SELECT * FROM employees").fetchdf()
print(df.head())

conn.close()
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

### Database Operations (Python)

```bash
# Create/open database and run queries
python -c "import duckdb; conn = duckdb.connect('mydata.db'); conn.execute('CREATE TABLE test (id INT, name VARCHAR)'); conn.close()"

# Run SQL file
python -c "import duckdb; conn = duckdb.connect('day01.db'); conn.execute(open('queries.sql').read())"

# Export results to CSV
python -c "import duckdb; conn = duckdb.connect('day01.db'); conn.execute('COPY (SELECT * FROM employees) TO \"output.csv\" (HEADER, DELIMITER \",\")')"

# Quick query and print results
python -c "import duckdb; conn = duckdb.connect('day01.db'); print(conn.execute('SELECT * FROM employees').fetchall())"
```

### Python Interactive Commands

```python
import duckdb

# Connect to database
conn = duckdb.connect('day01.db')

# Show tables
conn.execute("SHOW TABLES").fetchall()

# Show schema
conn.execute("DESCRIBE employees").fetchall()

# Get results as list
results = conn.execute("SELECT * FROM employees").fetchall()

# Get results as pandas DataFrame
df = conn.execute("SELECT * FROM employees").fetchdf()

# Execute multiple statements
conn.execute("""
    CREATE TABLE test (id INT);
    INSERT INTO test VALUES (1), (2), (3);
""")

# Close connection
conn.close()
```

### DuckDB CLI Commands (if installed separately)

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

### "No module named 'duckdb'"

Make sure you've activated the virtual environment:
```bash
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Then verify installation
python -c "import duckdb; print(duckdb.__version__)"
```

### "Table does not exist"

Run the setup script first (with venv activated):
```bash
python setup.py
```

### Virtual environment not activated

If you see errors, check your prompt for `(venv)`:
```bash
# Should see: (venv) user@machine:~/path$

# If not, activate it:
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows
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
# 1. Activate virtual environment
source venv/bin/activate  # macOS/Linux
# venv\Scripts\activate   # Windows

# 2. Navigate to Day 1
cd days/day-01-setup-select-basics

# 3. Run setup script (creates database in data/databases/)
python setup.py

# 4. Start querying with Python
python
>>> import duckdb
>>> conn = duckdb.connect('../../data/databases/day01.db')
>>> conn.execute("SELECT * FROM employees").fetchall()
```

**Let's master SQL! 📊**

---

## Quick Reference Card

### Every Day Workflow

```bash
# 1. Activate venv (if not already active)
source venv/bin/activate

# 2. Go to day folder
cd days/day-XX-topic

# 3. Run setup (creates database in data/databases/)
python setup.py

# 4. Work on exercises
# Edit exercise.sql, then test:
python ../../tools/run_sql.py ../../data/databases/dayXX.db exercise.sql

# 5. Check solution
python ../../tools/run_sql.py ../../data/databases/dayXX.db solution.sql
```

### Quick Python DuckDB Commands

```python
import duckdb
conn = duckdb.connect('database.db')

# Query and get results
conn.execute("SELECT * FROM table").fetchall()

# Query and get DataFrame
conn.execute("SELECT * FROM table").fetchdf()

# Run SQL file
conn.execute(open('file.sql').read())

# Close
conn.close()
```
