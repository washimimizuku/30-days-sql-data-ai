# Day 21: String Functions

## 📖 Learning Objectives

By the end of today, you will:
- Master string manipulation functions (CONCAT, UPPER, LOWER, SUBSTRING, LENGTH)
- Understand SQL data types (numeric, string, date, boolean)
- Learn type conversion with CAST
- Clean and format text data
- Build practical data transformation queries

---

## 📚 Theory (15 minutes)

### String Functions

**CONCAT - Combine Strings**
```sql
SELECT CONCAT(first_name, ' ', last_name) as full_name FROM employees;
-- Alternative: || operator
SELECT first_name || ' ' || last_name as full_name FROM employees;
```

**UPPER / LOWER - Change Case**
```sql
SELECT UPPER(name) as name_upper, LOWER(email) as email_lower FROM employees;
```

**SUBSTRING - Extract Part of String**
```sql
-- Extract first 3 characters
SELECT SUBSTRING(name, 1, 3) as prefix FROM employees;

-- Extract username from email (before @)
SELECT SUBSTRING(email, 1, POSITION('@' IN email) - 1) as username FROM employees;
```

**LENGTH - Get String Length**
```sql
SELECT name, LENGTH(name) as name_length FROM employees;
```

**TRIM - Remove Whitespace**
```sql
SELECT TRIM(name) as trimmed_name FROM employees;
```

**REPLACE - Replace Text**
```sql
SELECT REPLACE(phone, '-', '') as phone_no_dashes FROM employees;
```

**POSITION - Find Substring**
```sql
SELECT POSITION('@' IN email) as at_position FROM employees;
```

**LEFT / RIGHT - Extract from Ends**
```sql
SELECT LEFT(code, 3) as prefix, RIGHT(code, 2) as suffix FROM products;
```

### SQL Data Types

**Numeric Types:**
- `INTEGER` - Whole numbers
- `BIGINT` - Large integers
- `DECIMAL(10, 2)` - Fixed precision (10 digits, 2 after decimal)
- `FLOAT` / `DOUBLE` - Floating point

**String Types:**
- `VARCHAR(100)` - Variable length, max 100 characters
- `TEXT` - No length limit
- `CHAR(5)` - Fixed length, always 5 characters

**Date/Time Types:**
- `DATE` - Date only (YYYY-MM-DD)
- `TIME` - Time only (HH:MM:SS)
- `TIMESTAMP` - Date and time
- `INTERVAL` - Duration

**Other Types:**
- `BOOLEAN` - TRUE/FALSE
- `JSON` - JSON data

### Type Conversion (CAST)

```sql
-- String to integer
SELECT CAST('123' AS INTEGER);
SELECT '123'::INTEGER;  -- Shorthand

-- Integer to string
SELECT CAST(123 AS VARCHAR);

-- String to date
SELECT CAST('2024-01-15' AS DATE);

-- Decimal to integer (truncates)
SELECT CAST(123.45 AS INTEGER);  -- Returns 123
```

---

## 🎯 Real-World Use Cases

### Data Cleaning
```sql
-- Standardize emails to lowercase
SELECT LOWER(TRIM(email)) as clean_email FROM users;

-- Extract area code from phone
SELECT SUBSTRING(phone, 1, 3) as area_code FROM contacts;

-- Remove special characters
SELECT REPLACE(REPLACE(phone, '-', ''), ' ', '') as clean_phone FROM contacts;
```

### Data Formatting
```sql
-- Create display names
SELECT CONCAT(UPPER(SUBSTRING(first_name, 1, 1)), LOWER(SUBSTRING(first_name, 2)), ' ', last_name) as display_name
FROM employees;

-- Format addresses
SELECT CONCAT(street, ', ', city, ', ', state, ' ', zip_code) as full_address FROM addresses;
```

### Data Validation
```sql
-- Find invalid emails (no @)
SELECT * FROM users WHERE POSITION('@' IN email) = 0;

-- Find short passwords
SELECT * FROM users WHERE LENGTH(password) < 8;
```

---

## 💻 Hands-On Exercises (40 min)

### Setup

```bash
python setup.py
```

Tables: `employees`, `customers`, `products`

### Exercises

Complete 20 exercises in `exercise.sql`:

1. **Basic String Functions** (10 min) - CONCAT, UPPER, LOWER, SUBSTRING, LENGTH
2. **String Manipulation** (10 min) - TRIM, REPLACE, POSITION, LEFT, RIGHT
3. **Data Cleaning** (10 min) - Clean emails, phones, names
4. **Type Conversion** (5 min) - CAST between types
5. **Advanced Patterns** (5 min) - Complex string transformations

---

## 💡 Key Patterns & Best Practices

### Common Patterns

**Extract username from email:**
```sql
SUBSTRING(email, 1, POSITION('@' IN email) - 1)
```

**Proper case (capitalize first letter):**
```sql
UPPER(SUBSTRING(name, 1, 1)) || LOWER(SUBSTRING(name, 2))
```

**Clean phone numbers:**
```sql
REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '(', '')
```

**Full name:**
```sql
CONCAT(first_name, ' ', last_name)
-- or
first_name || ' ' || last_name
```

### Best Practices

1. **Use appropriate data types** - VARCHAR for variable text, INTEGER for whole numbers
2. **Standardize text** - Use LOWER() for case-insensitive comparisons
3. **Trim whitespace** - Always TRIM() user input
4. **Validate data** - Check LENGTH(), POSITION() for required patterns
5. **Use CAST explicitly** - Makes type conversions clear

### Common Mistakes

❌ **Not handling NULL:**
```sql
CONCAT(first_name, ' ', last_name)  -- NULL if either is NULL
```

✅ **Handle NULL:**
```sql
CONCAT(COALESCE(first_name, ''), ' ', COALESCE(last_name, ''))
```

❌ **Wrong SUBSTRING indices:**
```sql
SUBSTRING(text, 0, 3)  -- SQL uses 1-based indexing!
```

✅ **Correct indices:**
```sql
SUBSTRING(text, 1, 3)  -- Start at position 1
```

---

## ✅ Quiz

Test your knowledge in `quiz.md`!

---

## 🚀 Next Steps

Tomorrow: NULL Handling - Working with missing data.
