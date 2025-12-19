# Setup Guide - 30 Days of SQL for Data and AI

## Prerequisites
- Python 3.8+ installed
- Basic command line knowledge
- Git (optional, for tracking progress)

## Installation

### 1. Clone or Download Repository

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

**Alternative:** Some students prefer the standalone DuckDB CLI. See the [DuckDB CLI section](#duckdb-cli-alternative) below for installation and usage.

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

## DuckDB CLI (Alternative)

**For students who prefer command-line tools**, you can install the standalone DuckDB CLI.

### Installation

**macOS (Homebrew):**
```bash
brew install duckdb
```

**Linux/macOS (Direct download):**
```bash
# Download latest release
curl -L https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip -o duckdb.zip
unzip duckdb.zip
sudo mv duckdb /usr/local/bin/
```

**Windows:**
Download from [DuckDB releases](https://github.com/duckdb/duckdb/releases) and add to PATH.

### Usage

```bash
# Run SQL file directly
duckdb data/databases/day01.db < days/day-01-setup-select-basics/solution.sql

# Interactive mode
duckdb data/databases/day01.db
.mode table
SELECT * FROM employees;
.quit

# One-liner query
duckdb data/databases/day01.db "SELECT COUNT(*) FROM employees;"
```

---

## Project Structure

```
30-days-sql-data-ai/
├── README.md              # Overview
├── QUICKSTART.md          # 5-minute setup guide
├── requirements.txt       # Python packages
├── venv/                  # Virtual environment (created by you)
│
├── docs/                  # 📚 Documentation
│   ├── CURRICULUM.md      # Day-by-day breakdown
│   ├── SETUP.md           # This file
│   ├── TROUBLESHOOTING.md # Common issues & fixes
│   ├── PROJECT_STRUCTURE.md
│   ├── CONTRIBUTING.md
│   └── GIT_SETUP.md
│
├── tools/                 # 🛠️ Utilities
│   ├── cheatsheet.md      # SQL quick reference
│   ├── run_sql.py         # Helper script to run SQL files
│   └── test_setup.py      # Verify installation
│
├── data/                  # 📊 Data files
│   ├── raw/               # Original data
│   ├── processed/         # Processed data
│   └── databases/         # DuckDB files (created by setup scripts)
│
└── days/                  # 📖 30 Daily Lessons
    ├── day-01-setup-select-basics/
    │   ├── README.md      # Lesson (15 min)
    │   ├── setup.py       # Create database
    │   ├── exercise.sql   # Your queries (40 min)
    │   ├── solution.sql   # Solutions
    │   └── quiz.md        # Quiz (5 min)
    ├── day-02-where-filtering/
    └── ... (day-30-capstone-analytics-database)
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
cd days/day-XX-topic-name
python3 setup.py
```

This creates a DuckDB database in `data/databases/` with sample data.

### Step 2: Read the Lesson (15 min)

```bash
cat days/day-XX-topic-name/README.md  # or open in your editor
```

### Step 3: Write SQL Queries (40 min)

```bash
# Edit exercise.sql
code days/day-XX-topic-name/exercise.sql  # or use any text editor

# Test your queries using the helper script (shows results!)
python3 tools/run_sql.py data/databases/dayXX.db days/day-XX-topic-name/exercise.sql

# Or test with a simple query to verify database works
python3 -c "import duckdb; conn = duckdb.connect('data/databases/dayXX.db'); print(conn.execute('SELECT * FROM employees LIMIT 5').fetchall())"

# Alternative: Use DuckDB CLI (if installed)
duckdb data/databases/dayXX.db < days/day-XX-topic-name/exercise.sql
```

### Step 4: Check Solution (5 min)

```bash
# Compare with solution
cat days/day-XX-topic-name/solution.sql

# Run solution using the helper script
python3 tools/run_sql.py data/databases/dayXX.db days/day-XX-topic-name/solution.sql

# Alternative: Use DuckDB CLI (if installed)
duckdb data/databases/dayXX.db < days/day-XX-topic-name/solution.sql
```

### Step 5: Take Quiz (5 min)

```bash
cat days/day-XX-topic-name/quiz.md
```

---

## Using DuckDB

### Python (Recommended)

```python
import duckdb

# Connect to database (from project root)
conn = duckdb.connect('data/databases/day01.db')

# Query and get results
conn.execute("SELECT * FROM employees").fetchall()

# Query and get DataFrame
conn.execute("SELECT * FROM employees").fetchdf()

# Run SQL file
conn.execute(open('days/day-01-setup-select-basics/exercise.sql').read())

# Close connection
conn.close()
```

### Helper Script (Easiest)

```bash
# Run any SQL file and see results (from project root)
python3 tools/run_sql.py data/databases/day01.db days/day-01-setup-select-basics/exercise.sql
```

### DuckDB CLI (Alternative)

```bash
# Run SQL file
duckdb data/databases/day01.db < days/day-01-setup-select-basics/exercise.sql

# Interactive mode
duckdb data/databases/day01.db
SELECT * FROM employees;
.quit
```

---

## DuckDB Advantages

✅ **Zero installation** - Just `pip3 install duckdb`  
✅ **No server setup** - Works immediately  
✅ **Full SQL support** - All standard SQL features  
✅ **Fast** - Optimized for analytics  
✅ **Reads data files** - CSV, JSON, Parquet directly  
✅ **Perfect for learning** - Focus on SQL, not database admin

### Quick Example
```python
import duckdb

# Create in-memory database
con = duckdb.connect(':memory:')

# Query CSV directly
result = con.execute("SELECT * FROM 'data.csv'").df()
```

---

## Troubleshooting

### "No module named 'duckdb'"

Make sure you've activated the virtual environment:
```bash
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Then verify installation
python3 -c "import duckdb; print(duckdb.__version__)"
```

### "Table does not exist"

Run the setup script first (with venv activated):
```bash
cd days/day-XX-topic-name
python3 setup.py
```

### Virtual environment not activated

If you see errors, check your prompt for `(venv)`:
```bash
# Should see: (venv) user@machine:~/path$

# If not, activate it:
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows
```

### Permission errors
- Check file permissions
- Use different directory
- Try running with `python3` instead of `python`

---

## Getting Help

- Check [tools/cheatsheet.md](../tools/cheatsheet.md) for quick reference
- See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for common issues
- Review previous days
- Google error messages
- Check DuckDB documentation: [duckdb.org/docs](https://duckdb.org/docs/)

---

## Ready to Start?

Once setup is complete:

```bash
# 1. Activate virtual environment (from project root)
source venv/bin/activate  # macOS/Linux
# venv\Scripts\activate   # Windows

# 2. Run setup for Day 1
python3 days/day-01-setup-select-basics/setup.py

# 3. Return to project root and start learning!
cat days/day-01-setup-select-basics/README.md
```

**Let's master SQL! 📊**
