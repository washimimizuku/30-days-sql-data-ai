# Troubleshooting Guide

## macOS: "externally-managed-environment" Error

### Problem
You see this error even with virtual environment activated:
```
error: externally-managed-environment
```

### Why This Happens
- macOS Homebrew Python 3.11+ has PEP 668 protection
- Your shell has a `python` alias pointing to system Python
- Even with venv activated, the alias takes precedence over the venv

### Diagnosis
Check which Python you're actually using:
```bash
which python   # Shows: /opt/homebrew/bin/python3 (system) ❌
which python3  # Shows: .../venv/bin/python3 (venv) ✓
```

If `python` shows system path but `python3` shows venv path, you have the alias issue.

### Solution

**Option 1: Use python3 or pip directly (Easiest)**
```bash
# Your venv is already working correctly!
# Just use python3 or pip instead of python:

python3 -m pip install -r requirements.txt
# OR simply:
pip install -r requirements.txt

# Run scripts with python3:
python3 tools/test_setup.py
python3 days/day-01-setup-select-basics/setup.py

# The 'pip' command works because it's in your venv
```

**Option 2: Recreate venv (if needed)**
```bash
# Only if Option 1 doesn't work
deactivate
rm -rf venv
python3 -m venv venv
source venv/bin/activate
python3 -m pip install -r requirements.txt
```

**Option 3: Check and fix shell aliases**
```bash
# Check if python is aliased
type python

# If it shows an alias, you can:
# 1. Use python3 instead (recommended)
# 2. Or temporarily unalias:
unalias python  # Only for current session
```

### Verification
After activation, check which Python you're using:
```bash
which python3  # Should be in venv
python3 --version
pip --version  # Should show path in venv
```

---

## Windows: PowerShell Execution Policy

### Problem
```
cannot be loaded because running scripts is disabled
```

### Solution
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then try activating again:
```powershell
venv\Scripts\Activate.ps1
```

---

## "Module not found" Errors

### Problem
```python
ModuleNotFoundError: No module named 'duckdb'
```

### Solution
1. **Check if venv is activated:**
   ```bash
   # You should see (venv) in your prompt
   # If not, activate it:
   source venv/bin/activate  # Mac/Linux
   venv\Scripts\activate     # Windows
   ```

2. **Verify pip is from venv:**
   ```bash
   which pip  # Mac/Linux
   where pip  # Windows
   # Should show path inside venv folder
   ```

3. **Reinstall packages:**
   ```bash
   pip install -r requirements.txt
   ```

---

## DuckDB Connection Errors

### Problem
```python
duckdb.IOException: Could not open database
```

### Solution
1. **Check file permissions:**
   ```bash
   ls -la data/databases/  # Mac/Linux
   dir data\databases\     # Windows
   ```

2. **Create directories if missing:**
   ```bash
   mkdir -p data/databases data/raw data/processed
   ```

3. **Use in-memory database for testing:**
   ```python
   import duckdb
   con = duckdb.connect(':memory:')
   ```

---

## SQL Syntax Errors

### Problem
```
Parser Error: syntax error at or near "..."
```

### Common Causes
1. **Missing semicolon** - Not required in DuckDB Python API
2. **Wrong quotes** - Use single quotes for strings: `'text'`
3. **Reserved keywords** - Use double quotes for table/column names: `"order"`
4. **Case sensitivity** - DuckDB is case-insensitive by default

### Solution
```sql
-- ❌ Wrong
SELECT * FROM table WHERE name = "John"

-- ✓ Correct
SELECT * FROM table WHERE name = 'John'

-- ❌ Wrong (reserved keyword)
SELECT order FROM orders

-- ✓ Correct
SELECT "order" FROM orders
```

---

## Virtual Environment Not Activating

### Mac/Linux
```bash
# Make sure you're in project directory
cd 30-days-sql-data-ai

# Create venv with python3
python3 -m venv venv

# Activate
source venv/bin/activate

# Verify
echo $VIRTUAL_ENV  # Should show path to venv
```

### Windows
```bash
# Make sure you're in project directory
cd 30-days-sql-data-ai

# Create venv
python -m venv venv

# Activate (Command Prompt)
venv\Scripts\activate

# Activate (PowerShell)
venv\Scripts\Activate.ps1

# Verify
echo %VIRTUAL_ENV%  # Should show path to venv
```

---

## Setup Script Fails

### Problem
```python
python days/day-01-setup-select-basics/setup.py
# Error: ...
```

### Solution
1. **Check you're in project root:**
   ```bash
   pwd  # Should show: .../30-days-sql-data-ai
   ```

2. **Verify DuckDB is installed:**
   ```bash
   python3 -c "import duckdb; print(duckdb.__version__)"
   ```

3. **Run with full path:**
   ```bash
   python3 days/day-01-setup-select-basics/setup.py
   ```

4. **Check for specific errors:**
   - **Import errors**: Reinstall packages
   - **Permission errors**: Check directory permissions
   - **Path errors**: Ensure data/ directories exist

---

## Starting Fresh

If nothing works, start completely fresh:

```bash
# Deactivate if active
deactivate

# Remove old venv
rm -rf venv  # Mac/Linux
rmdir /s venv  # Windows

# Create new venv
python3 -m venv venv  # Mac/Linux
python -m venv venv   # Windows

# Activate
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows

# Upgrade pip
python -m pip install --upgrade pip

# Install packages
pip install -r requirements.txt

# Verify
python tools/test_setup.py
```

---

## Python Version Issues

### Check Python Version
```bash
python --version   # or python3 --version
```

### Need Python 3.11+
If you have an older version:

**Mac:**
```bash
brew install python@3.11
```

**Windows:**
Download from [python.org](https://www.python.org/downloads/)

**Linux:**
```bash
sudo apt update
sudo apt install python3.11
```

---

## Package Installation Fails

### Upgrade pip first
```bash
python -m pip install --upgrade pip setuptools wheel
```

### Install packages one by one
```bash
pip install duckdb
pip install pandas
pip install faker
```

### Check for specific errors
- **No space left**: Free up disk space
- **Permission denied**: Don't use `sudo` with venv
- **Network error**: Check internet connection

---

## DuckDB-Specific Issues

### Database File Locked
```python
# Close existing connections
con.close()

# Or use in-memory database
con = duckdb.connect(':memory:')
```

### Query Returns No Results
```sql
-- Check if table exists
SHOW TABLES;

-- Check table contents
SELECT COUNT(*) FROM table_name;

-- Verify data was inserted
SELECT * FROM table_name LIMIT 5;
```

### Performance Issues
```sql
-- Check query plan
EXPLAIN SELECT * FROM table_name WHERE ...;

-- Create indexes (if needed)
CREATE INDEX idx_name ON table_name(column_name);
```

---

## Still Stuck?

1. **Check you're in the right directory:**
   ```bash
   pwd  # Mac/Linux
   cd   # Windows
   # Should show: .../30-days-sql-data-ai
   ```

2. **Verify Python installation:**
   ```bash
   python3 --version  # Mac/Linux
   python --version   # Windows
   ```

3. **Check DuckDB works:**
   ```bash
   python3 -c "import duckdb; print('DuckDB OK')"
   ```

4. **Read error messages carefully** - they usually tell you what's wrong

5. **Google the exact error message** - someone has likely solved it

6. **Ask for help** with:
   - Your operating system
   - Python version
   - DuckDB version
   - Exact error message
   - What you've tried

---

## Quick Reference

### Daily Workflow
```bash
# Start
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows

# Run setup script
python3 days/day-XX-topic/setup.py

# Work on exercises...

# End
deactivate
```

### Common Commands
```bash
# Check if venv is active
echo $VIRTUAL_ENV  # Mac/Linux
echo %VIRTUAL_ENV%  # Windows

# List installed packages
pip list

# Install new package
pip install package_name

# Test DuckDB
python3 -c "import duckdb; con = duckdb.connect(':memory:'); print('OK')"
```

---

## DuckDB Quick Test

Run this to verify DuckDB works:

```python
import duckdb

# Create in-memory database
con = duckdb.connect(':memory:')

# Create table
con.execute("CREATE TABLE test (id INTEGER, name VARCHAR)")

# Insert data
con.execute("INSERT INTO test VALUES (1, 'Alice'), (2, 'Bob')")

# Query
result = con.execute("SELECT * FROM test").fetchall()
print(result)  # Should print: [(1, 'Alice'), (2, 'Bob')]

con.close()
print("DuckDB is working correctly!")
```
