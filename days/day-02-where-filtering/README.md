# Day 2: WHERE Clause and Filtering

## Learning Objectives
- Understand WHERE clause and filtering
- Learn WHERE, AND, OR, NOT, IN, BETWEEN
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### WHERE Clause Basics

The WHERE clause filters rows based on conditions.

**Syntax:**
```sql
SELECT column1, column2
FROM table_name
WHERE condition;
```

**Example:**
```sql
SELECT name, salary
FROM employees
WHERE salary > 50000;
```

### Comparison Operators

```sql
-- Equal to
WHERE salary = 50000

-- Not equal to
WHERE department != 'Sales'
WHERE department <> 'Sales'  -- Alternative syntax

-- Greater than / Less than
WHERE salary > 50000
WHERE salary < 100000
WHERE salary >= 50000
WHERE salary <= 100000
```

### Logical Operators (AND, OR, NOT)

**AND** - All conditions must be true:
```sql
SELECT name, salary, department
FROM employees
WHERE salary > 50000 
  AND department = 'Engineering';
```

**OR** - At least one condition must be true:
```sql
SELECT name, city
FROM employees
WHERE city = 'New York' 
   OR city = 'London';
```

**NOT** - Negates a condition:
```sql
SELECT name, department
FROM employees
WHERE NOT department = 'Sales';
```

**Combining operators:**
```sql
SELECT name, salary, department
FROM employees
WHERE (department = 'Engineering' OR department = 'Sales')
  AND salary > 60000;
```

### IN Operator

Match any value in a list:

```sql
-- Instead of multiple OR conditions
SELECT name, city
FROM employees
WHERE city IN ('New York', 'London', 'Tokyo', 'Paris');

-- Equivalent to:
WHERE city = 'New York' 
   OR city = 'London' 
   OR city = 'Tokyo' 
   OR city = 'Paris';

-- NOT IN
SELECT name, city
FROM employees
WHERE city NOT IN ('New York', 'London');
```

**With numbers:**
```sql
SELECT name, department_id
FROM employees
WHERE department_id IN (1, 3, 5, 7);
```

### BETWEEN Operator

Check if a value is within a range (inclusive):

```sql
-- Salary between 50000 and 100000 (inclusive)
SELECT name, salary
FROM employees
WHERE salary BETWEEN 50000 AND 100000;

-- Equivalent to:
WHERE salary >= 50000 AND salary <= 100000;

-- NOT BETWEEN
SELECT name, salary
FROM employees
WHERE salary NOT BETWEEN 30000 AND 50000;
```

**With dates:**
```sql
SELECT name, hire_date
FROM employees
WHERE hire_date BETWEEN '2020-01-01' AND '2023-12-31';
```

### LIKE Operator and Wildcards

Pattern matching with wildcards:

**Wildcards:**
- `%` - Matches zero or more characters
- `_` - Matches exactly one character

```sql
-- Names starting with 'John'
SELECT name
FROM employees
WHERE name LIKE 'John%';

-- Names ending with 'son'
SELECT name
FROM employees
WHERE name LIKE '%son';

-- Names containing 'ann'
SELECT name
FROM employees
WHERE name LIKE '%ann%';

-- Exactly 5 characters
SELECT code
FROM products
WHERE code LIKE '_____';

-- Starts with A, any char, then B
SELECT code
FROM products
WHERE code LIKE 'A_B%';

-- NOT LIKE
SELECT name
FROM employees
WHERE name NOT LIKE 'A%';
```

**Case-insensitive matching (DuckDB):**
```sql
-- ILIKE is case-insensitive
SELECT name
FROM employees
WHERE name ILIKE 'john%';  -- Matches 'John', 'JOHN', 'john'
```

### IS NULL and IS NOT NULL

Check for NULL values:

```sql
-- Find employees with no email
SELECT name
FROM employees
WHERE email IS NULL;

-- Find employees with email
SELECT name
FROM employees
WHERE email IS NOT NULL;
```

**Note:** Cannot use `= NULL` or `!= NULL`:
```sql
-- ❌ Wrong
WHERE email = NULL

-- ✅ Correct
WHERE email IS NULL
```

## 💻 Exercises (40 minutes)

### Exercise 1: Basic WHERE Conditions

Write queries to:
1. Find all employees with salary greater than 70000
2. Find all employees in the 'Engineering' department
3. Find all employees hired after '2022-01-01'
4. Find all employees with salary less than or equal to 60000

### Exercise 2: Logical Operators (AND, OR, NOT)

Write queries to:
1. Find employees in 'Engineering' with salary > 75000
2. Find employees in either 'Sales' or 'Marketing' departments
3. Find employees NOT in the 'HR' department
4. Find employees in 'Engineering' OR 'Sales' with salary > 70000

### Exercise 3: IN Operator

Write queries to:
1. Find employees in cities: 'New York', 'London', 'Tokyo'
2. Find employees with department_id in (1, 3, 5)
3. Find employees NOT in cities: 'Paris', 'Berlin'
4. Find products with category in ('Electronics', 'Books', 'Clothing')

### Exercise 4: BETWEEN Operator

Write queries to:
1. Find employees with salary between 50000 and 80000
2. Find employees hired between '2020-01-01' and '2022-12-31'
3. Find products with price between 10 and 50
4. Find employees with salary NOT between 40000 and 60000

### Exercise 5: LIKE Operator

Write queries to:
1. Find employees whose name starts with 'J'
2. Find employees whose email ends with '@company.com'
3. Find employees whose name contains 'son'
4. Find products with code exactly 5 characters long
5. Find employees whose name does NOT start with 'A'

### Exercise 6: IS NULL

Write queries to:
1. Find employees with no phone number (NULL)
2. Find employees with an email address (NOT NULL)
3. Find products with no description (NULL)

### Exercise 7: Complex Conditions

Write queries combining multiple operators:
1. Find employees in 'Engineering' or 'Sales', with salary > 70000, hired after '2021-01-01'
2. Find employees whose name starts with 'J' or 'M', in cities 'New York' or 'London'
3. Find products with price between 20 and 100, category in ('Electronics', 'Books'), and NOT NULL description

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### Operator Precedence

When combining operators, SQL evaluates in this order:
1. Parentheses `()`
2. NOT
3. AND
4. OR

```sql
-- Without parentheses - AND evaluated first
WHERE department = 'Sales' OR department = 'Marketing' AND salary > 70000
-- Means: Sales (any salary) OR (Marketing with salary > 70000)

-- With parentheses - clearer intent
WHERE (department = 'Sales' OR department = 'Marketing') AND salary > 70000
-- Means: (Sales OR Marketing) with salary > 70000
```

### Best Practices

1. **Use IN for multiple values** - More readable than multiple ORs
2. **Use BETWEEN for ranges** - Clearer than >= AND <=
3. **Use parentheses** - Make complex conditions clear
4. **Use IS NULL** - Never use = NULL
5. **Consider indexes** - WHERE conditions on indexed columns are faster

### Common Mistakes

```sql
-- ❌ Wrong - Cannot use = with NULL
WHERE email = NULL

-- ✅ Correct
WHERE email IS NULL

-- ❌ Wrong - Missing parentheses
WHERE dept = 'Sales' OR dept = 'Marketing' AND salary > 70000

-- ✅ Correct
WHERE (dept = 'Sales' OR dept = 'Marketing') AND salary > 70000

-- ❌ Wrong - BETWEEN is inclusive
WHERE salary BETWEEN 50000 AND 100000  -- Includes both 50000 and 100000

-- ✅ Correct understanding
WHERE salary >= 50000 AND salary <= 100000  -- Same as BETWEEN
```

## Key Takeaways
- WHERE clause filters rows based on conditions
- Use IN for multiple values, BETWEEN for ranges
- LIKE with % and _ for pattern matching
- IS NULL to check for NULL values
- Combine conditions with AND, OR, NOT
- Use parentheses for complex conditions

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 3
