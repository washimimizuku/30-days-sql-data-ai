# Day 1 Quiz: Setup and SELECT Basics

Test your understanding of basic SELECT statements!

---

## Questions

### 1. What does SELECT * do?

- A) Deletes all rows
- B) Selects all columns from a table
- C) Selects all tables in the database
- D) Creates a new table

### 2. What is the correct order of clauses in a basic SELECT statement?

- A) FROM table_name SELECT columns
- B) SELECT columns FROM table_name
- C) SELECT FROM table_name columns
- D) table_name SELECT columns FROM

### 3. What does the AS keyword do?

- A) Creates a new table
- B) Creates a column alias (renames output columns)
- C) Deletes data
- D) Sorts the results

### 4. Which query selects only the name and salary columns?

- A) SELECT * FROM employees
- B) SELECT name, salary FROM employees
- C) SELECT employees FROM name, salary
- D) FROM employees SELECT name, salary

### 5. What does DISTINCT do?

- A) Sorts the results
- B) Removes duplicate rows from results
- C) Counts the number of rows
- D) Filters rows based on conditions

### 6. Can you perform calculations in SELECT?

- A) No, only in WHERE clause
- B) Yes, you can use expressions like salary * 12
- C) Only with special functions
- D) Only in subqueries

### 7. What is the result of: SELECT salary * 12 AS annual FROM employees?

- A) Creates a new column called annual with monthly salary
- B) Creates a new column called annual with yearly salary
- C) Multiplies all salaries by 12 permanently
- D) Returns an error

### 8. Which is a valid column alias?

- A) SELECT name AS employee_name
- B) SELECT name employee_name (without AS)
- C) SELECT name AS "Employee Name"
- D) All of the above

### 9. What does SELECT DISTINCT city, department return?

- A) All unique cities
- B) All unique departments
- C) All unique combinations of city and department
- D) An error

### 10. What is DuckDB best suited for?

- A) Web server hosting
- B) Analytical queries (OLAP)
- C) Transactional systems (OLTP)
- D) Image processing

### 11. Which statement is true about SELECT?

- A) You must always use SELECT *
- B) You can select specific columns or all columns
- C) You cannot use calculations in SELECT
- D) SELECT doesn't need a FROM clause

### 12. What's the difference between these: SELECT name, salary vs SELECT salary, name?

- A) No difference
- B) The order of columns in the output
- C) One is faster than the other
- D) The second one is invalid

### 13. Can you use the same column multiple times in SELECT?

- A) No, each column can only appear once
- B) Yes, you can select the same column multiple times
- C) Only if you use DISTINCT
- D) Only with aliases

### 14. What does this query do: SELECT name, salary, salary * 0.1 AS tax FROM employees?

- A) Calculates 10% tax and shows it alongside name and salary
- B) Reduces all salaries by 10%
- C) Returns an error
- D) Creates a new tax column in the table

### 15. Which is a best practice for SELECT statements?

- A) Always use SELECT * for better performance
- B) Select only the columns you need
- C) Never use aliases
- D) Avoid calculations in SELECT

---

## Answers

1. **B** - Selects all columns from a table
   - SELECT * retrieves every column from the specified table

2. **B** - SELECT columns FROM table_name
   - Standard SQL syntax: SELECT what you want FROM where it is

3. **B** - Creates a column alias (renames output columns)
   - AS makes output more readable by renaming columns

4. **B** - SELECT name, salary FROM employees
   - List specific columns separated by commas

5. **B** - Removes duplicate rows from results
   - DISTINCT returns only unique rows

6. **B** - Yes, you can use expressions like salary * 12
   - SELECT can include calculations and expressions

7. **B** - Creates a new column called annual with yearly salary
   - Multiplies each salary by 12 and names the result "annual"

8. **D** - All of the above
   - AS is optional, and quotes allow spaces in aliases

9. **C** - All unique combinations of city and department
   - DISTINCT with multiple columns finds unique combinations

10. **B** - Analytical queries (OLAP)
    - DuckDB is optimized for analytics, not transactions

11. **B** - You can select specific columns or all columns
    - SELECT is flexible - choose what you need

12. **B** - The order of columns in the output
    - Column order in SELECT determines output order

13. **B** - Yes, you can select the same column multiple times
    - Useful for showing original and calculated values

14. **A** - Calculates 10% tax and shows it alongside name and salary
    - Creates a calculated column without modifying the table

15. **B** - Select only the columns you need
    - More efficient and clearer than SELECT *

---

## Scoring

- **13-15 correct**: Excellent! You've mastered SELECT basics
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **SELECT retrieves data** - Specify columns or use * for all

✅ **FROM specifies the table** - Required in most queries

✅ **Column order matters** - Output matches SELECT order

✅ **AS creates aliases** - Makes output more readable

✅ **Calculations allowed** - Use expressions like salary * 12

✅ **DISTINCT removes duplicates** - Returns unique rows

✅ **Select what you need** - Avoid SELECT * in production

✅ **Multiple columns** - Separate with commas

✅ **Same column multiple times** - Useful for comparisons

✅ **DuckDB for analytics** - Perfect for learning SQL
