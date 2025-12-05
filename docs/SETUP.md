# Setup Guide - 30 Days of SQL for Data and AI

## Prerequisites
- Python 3.11+ installed
- Basic command line knowledge

## Step 1: Install DuckDB

```bash
pip install duckdb
```

That's it! DuckDB requires no server setup.

## Step 2: Verify Installation

```bash
# Navigate to bootcamp folder
cd 30-days-sql-data-ai

# Run test
python resources/test_setup.py
```

Should output:
```
✅ Python version: 3.11.x
✅ DuckDB installed
✅ All set! Ready to start Day 1
```

## Step 3: Install Optional Tools

### DuckDB CLI (Optional)
```bash
# macOS
brew install duckdb

# Or download from duckdb.org
```

### VS Code Extensions (Optional)
- SQLTools
- SQLTools DuckDB Driver

## Using DuckDB

### Python
```python
import duckdb

# In-memory database
con = duckdb.connect(':memory:')

# Or persistent file
con = duckdb.connect('data/databases/mydb.duckdb')

# Execute query
result = con.execute("SELECT * FROM table").fetchall()

# Get as DataFrame
df = con.execute("SELECT * FROM table").df()
```

### CLI
```bash
duckdb data/databases/mydb.duckdb

# Inside DuckDB CLI:
SELECT * FROM table;
.quit
```

## Folder Structure

```
30-days-sql-data-ai/
├── README.md
├── CURRICULUM.md
├── resources/
│   ├── SETUP.md (this file)
│   ├── cheatsheet.md
│   └── test_setup.py
├── data/
│   ├── raw/          # CSV, JSON files
│   ├── processed/    # Processed data
│   └── databases/    # DuckDB files
└── days/
    ├── day-01/
    │   ├── README.md
    │   ├── exercise.sql
    │   ├── solution.sql
    │   ├── setup.py (creates tables)
    │   └── quiz.md
    └── ...
```

## Daily Workflow

1. **Read** `days/day-XX/README.md` (15 min)
2. **Setup** Run `python days/day-XX/setup.py` (creates tables)
3. **Practice** Write queries in `exercise.sql` (40 min)
4. **Check** `solution.sql` if stuck
5. **Quiz** `quiz.md` (5 min)

## DuckDB Advantages

✅ No server setup
✅ Works with CSV/Parquet directly
✅ Fast for analytics
✅ Full SQL support
✅ Easy to learn

## Example Usage

```python
import duckdb

# Query CSV directly!
result = duckdb.execute("""
    SELECT * FROM 'data/raw/sales.csv'
    WHERE amount > 100
""").df()

# Create table from CSV
duckdb.execute("""
    CREATE TABLE sales AS
    SELECT * FROM 'data/raw/sales.csv'
""")
```

## Troubleshooting

### DuckDB not found
```bash
pip install --upgrade duckdb
```

### Permission errors
- Check file permissions
- Use different directory

## Getting Help

- Check `resources/cheatsheet.md`
- DuckDB docs: [duckdb.org/docs](https://duckdb.org/docs/)

## Ready to Start?

Once setup is complete, go to `days/day-01/` and begin!
