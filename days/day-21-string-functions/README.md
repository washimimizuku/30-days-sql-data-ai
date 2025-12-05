# Day 21: String Functions and Data Types

## Learning Objectives
- Understand string functions
- Learn CONCAT, UPPER, LOWER, SUBSTRING, LENGTH
- Understand SQL data types
- Learn type conversion with CAST
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### Part 1: String Functions

#### CONCAT - Combine Strings

```sql
-- Combine first and last name
SELECT CONCAT(first_name, ' ', last_name) as full_name
FROM employees;

-- Combine multiple columns
SELECT CONCAT(city, ', ', state, ' ', zip_code) as full_address
FROM addresses;

-- Alternative: || operator
SELECT first_name || ' ' || last_name as full_name
FROM employees;
```

#### UPPER and LOWER - Change Case

```sql
-- Convert to uppercase
SELECT UPPER(name) as name_upper
FROM employees;

-- Convert to lowercase
SELECT LOWER(email) as email_lower
FROM employees;

-- Mixed case for formatting
SELECT 
    UPPER(SUBSTRING(first_name, 1, 1)) || LOWER(SUBSTRING(first_name, 2)) as proper_case
FROM employees;
```

#### SUBSTRING - Extract Part of String

```sql
-- Extract first 3 characters
SELECT SUBSTRING(name, 1, 3) as name_prefix
FROM employees;

-- Extract from position to end
SELECT SUBSTRING(email, 1, POSITION('@' IN email) - 1) as username
FROM employees;

-- Get file extension
SELECT SUBSTRING(filename, LENGTH(filename) - 2) as extension
FROM files;
```

#### LENGTH - Get String Length

```sql
-- Count characters
SELECT name, LENGTH(name) as name_length
FROM employees;

-- Find long descriptions
SELECT *
FROM products
WHERE LENGTH(description) > 100;
```

#### Other Useful String Functions

```sql
-- TRIM - Remove spaces
SELECT TRIM(name) as trimmed_name
FROM employees;

-- REPLACE - Replace text
SELECT REPLACE(phone, '-', '') as phone_no_dashes
FROM employees;

-- POSITION - Find substring position
SELECT POSITION('@' IN email) as at_position
FROM employees;

-- LEFT and RIGHT - Extract from ends
SELECT 
    LEFT(code, 3) as prefix,
    RIGHT(code, 2) as suffix
FROM products;
```

### Part 2: SQL Data Types

#### Numeric Data Types

```sql
-- Integer types
TINYINT     -- -128 to 127
SMALLINT    -- -32,768 to 32,767
INTEGER     -- -2,147,483,648 to 2,147,483,647
BIGINT      -- Very large integers

-- Decimal types
DECIMAL(10, 2)  -- 10 digits total, 2 after decimal
NUMERIC(10, 2)  -- Same as DECIMAL
FLOAT           -- Floating point
DOUBLE          -- Double precision floating point

-- Example usage
CREATE TABLE products (
    id INTEGER,
    price DECIMAL(10, 2),
    weight FLOAT
);
```

#### String Data Types

```sql
-- Variable length
VARCHAR(100)    -- Up to 100 characters
TEXT            -- No limit

-- Fixed length
CHAR(5)         -- Always 5 characters (padded)

-- Example usage
CREATE TABLE employees (
    id INTEGER,
    name VARCHAR(100),
    code CHAR(5),
    bio TEXT
);
```

#### Date and Time Types

```sql
DATE            -- Date only (YYYY-MM-DD)
TIME            -- Time only (HH:MM:SS)
TIMESTAMP       -- Date and time
INTERVAL        -- Duration

-- Example usage
CREATE TABLE events (
    id INTEGER,
    event_date DATE,
    event_time TIME,
    created_at TIMESTAMP,
    duration INTERVAL
);
```

#### Boolean Type

```sql
BOOLEAN         -- TRUE, FALSE, or NULL

-- Example usage
CREATE TABLE users (
    id INTEGER,
    is_active BOOLEAN,
    is_verified BOOLEAN
);
```

#### Other Types

```sql
JSON            -- JSON data
ARRAY           -- Arrays
BLOB            -- Binary data
```

### Part 3: Type Conversion (CAST)

#### CAST Function

```sql
-- String to integer
SELECT CAST('123' AS INTEGER);

-- Integer to string
SELECT CAST(123 AS VARCHAR);

-- String to date
SELECT CAST('2024-01-15' AS DATE);

-- Decimal to integer (truncates)
SELECT CAST(123.45 AS INTEGER);  -- Returns 123
```

#### :: Operator (DuckDB/PostgreSQL Style)

```sql
-- Shorter syntax, same as CAST
SELECT '123'::INTEGER;
SELECT 123::VARCHAR;
SELECT '2024-01-15'::DATE;
SELECT 123.45::INTEGER;
```

#### Practical Type Conversion Examples

```sql
-- Convert price string to number for calculation
SELECT 
    product_name,
    price_string,
    CAST(price_string AS DECIMAL(10,2)) * 1.1 as price_with_tax
FROM products;

-- Extract year from date
SELECT 
    order_date,
    CAST(EXTRACT(YEAR FROM order_date) AS INTEGER) as order_year
FROM orders;

-- Convert boolean to text
SELECT 
    name,
    CASE 
        WHEN is_active THEN 'Active'
        ELSE 'Inactive'
    END as status
FROM users;

-- Handle type mismatches
SELECT 
    id,
    CAST(id AS VARCHAR) || '-' || code as full_code
FROM products;
```

## 💻 Exercises (40 minutes)

### Part 1: String Functions

1. Use CONCAT to create full names from first_name and last_name
2. Convert all emails to lowercase
3. Extract username from email (part before @)
4. Find employees with names longer than 10 characters
5. Replace all spaces in phone numbers with dashes
6. Extract first 3 characters of product codes
7. Trim whitespace from all names
8. Find position of '@' in email addresses

### Part 2: Data Types

1. Create a table with appropriate data types for:
   - Employee ID (integer)
   - Name (variable string, max 100)
   - Salary (decimal with 2 decimal places)
   - Hire date (date)
   - Is active (boolean)

2. Create a products table with:
   - ID, name, description, price, quantity, category

3. Identify appropriate data types for:
   - Phone numbers
   - Email addresses
   - Product prices
   - Dates of birth
   - Yes/No flags

### Part 3: Type Conversion

1. Convert string '12345' to integer and add 100
2. Convert integer 2024 to string and concatenate with '-01-01'
3. Convert string '2024-01-15' to DATE type
4. Convert decimal 123.456 to integer (observe truncation)
5. Convert price strings to decimals and calculate 10% tax
6. Extract year from date and convert to integer
7. Convert boolean flags to 'Yes'/'No' text

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### String Functions Summary
- CONCAT / || - Combine strings
- UPPER / LOWER - Change case
- SUBSTRING - Extract part of string
- LENGTH - Get string length
- TRIM - Remove whitespace
- REPLACE - Replace text
- POSITION - Find substring location

### Data Types Summary
- **Numeric**: INTEGER, BIGINT, DECIMAL, FLOAT, DOUBLE
- **String**: VARCHAR, TEXT, CHAR
- **Date/Time**: DATE, TIME, TIMESTAMP, INTERVAL
- **Boolean**: BOOLEAN (TRUE/FALSE)
- **Other**: JSON, ARRAY, BLOB

### Type Conversion
- Use CAST(value AS type) or value::type
- Important for calculations and comparisons
- Be aware of truncation (decimal to integer)
- Handle type mismatches in data imports

## Key Takeaways
- String functions manipulate and format text data
- Choose appropriate data types for each column
- Use CAST or :: for type conversion
- Understanding data types prevents errors and improves performance
- Type conversion is essential for data cleaning and transformation

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 22
