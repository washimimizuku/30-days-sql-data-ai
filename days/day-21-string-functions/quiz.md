# Day 21 Quiz: String Functions

Test your understanding of string functions and data types!

---

## Questions

### 1. What does CONCAT('Hello', ' ', 'World') return?

- A) HelloWorld
- B) Hello World
- C) Hello, World
- D) Error

### 2. What is the alternative to CONCAT in SQL?

- A) + operator
- B) || operator
- C) & operator
- D) MERGE function

### 3. What does UPPER('Hello World') return?

- A) hello world
- B) HELLO WORLD
- C) Hello World
- D) Hello world

### 4. How do you extract the first 5 characters of a string?

- A) LEFT(string, 5)
- B) SUBSTRING(string, 1, 5)
- C) Both A and B
- D) EXTRACT(string, 5)

### 5. What does LENGTH('Hello') return?

- A) 4
- B) 5
- C) 6
- D) Error

### 6. How do you find the position of '@' in an email?

- A) FIND('@', email)
- B) POSITION('@' IN email)
- C) INDEX('@', email)
- D) LOCATE('@', email)

### 7. What does TRIM('  Hello  ') return?

- A) '  Hello  '
- B) 'Hello  '
- C) '  Hello'
- D) 'Hello'

### 8. How do you replace all dashes in a phone number?

- A) REPLACE(phone, '-', '')
- B) REMOVE(phone, '-')
- C) DELETE(phone, '-')
- D) SUBSTITUTE(phone, '-', '')

### 9. What is the correct data type for storing prices with 2 decimal places?

- A) INTEGER
- B) FLOAT
- C) DECIMAL(10, 2)
- D) VARCHAR

### 10. How do you convert a string to an integer?

- A) CAST(string AS INTEGER)
- B) TO_INT(string)
- C) INTEGER(string)
- D) CONVERT(string, INT)

### 11. What does CAST(123.45 AS INTEGER) return?

- A) 123
- B) 124
- C) 123.45
- D) Error

### 12. Which data type is best for variable-length text up to 100 characters?

- A) CHAR(100)
- B) VARCHAR(100)
- C) TEXT
- D) STRING(100)

### 13. What does SUBSTRING('Hello', 1, 3) return?

- A) Hel
- B) ell
- C) Hello
- D) llo

### 14. How do you extract the username from 'user@email.com'?

- A) SUBSTRING(email, 1, 4)
- B) SUBSTRING(email, 1, POSITION('@' IN email) - 1)
- C) LEFT(email, '@')
- D) EXTRACT(email, '@')

### 15. What is the shorthand for CAST in DuckDB/PostgreSQL?

- A) ->
- B) ::
- C) =>
- D) ~~

---

## Answers

1. **B** - Hello World
   - CONCAT joins strings with the separator included

2. **B** - || operator
   - 'Hello' || ' ' || 'World' = 'Hello World'

3. **B** - HELLO WORLD
   - UPPER converts all characters to uppercase

4. **C** - Both A and B
   - LEFT(string, 5) and SUBSTRING(string, 1, 5) both work

5. **B** - 5
   - LENGTH counts the number of characters

6. **B** - POSITION('@' IN email)
   - Returns the position of the substring

7. **D** - 'Hello'
   - TRIM removes leading and trailing whitespace

8. **A** - REPLACE(phone, '-', '')
   - REPLACE substitutes all occurrences

9. **C** - DECIMAL(10, 2)
   - Fixed precision with 2 decimal places

10. **A** - CAST(string AS INTEGER)
    - Standard SQL type conversion

11. **A** - 123
    - CAST to INTEGER truncates decimal places

12. **B** - VARCHAR(100)
    - Variable length, efficient for text up to 100 chars

13. **A** - Hel
    - SUBSTRING(string, start, length) - starts at position 1

14. **B** - SUBSTRING(email, 1, POSITION('@' IN email) - 1)
    - Extracts from start to position before @

15. **B** - ::
    - '123'::INTEGER is shorthand for CAST('123' AS INTEGER)

---

## Scoring

- **13-15 correct**: Excellent! You've mastered string functions
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **CONCAT / ||** - Combine strings

✅ **UPPER / LOWER** - Change case

✅ **SUBSTRING** - Extract part of string (1-based indexing)

✅ **LENGTH** - Count characters

✅ **TRIM** - Remove whitespace

✅ **REPLACE** - Substitute text

✅ **POSITION** - Find substring location

✅ **Data Types** - VARCHAR for text, DECIMAL for prices, INTEGER for whole numbers

✅ **CAST** - Convert between types (CAST or :: operator)

✅ **String cleaning** - Combine functions for data standardization
