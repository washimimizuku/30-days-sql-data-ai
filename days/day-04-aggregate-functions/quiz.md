# Day 4 Quiz: Aggregate Functions

Test your understanding of COUNT, SUM, AVG, MIN, and MAX!

---

## Questions

### 1. What do aggregate functions do?

- A) Filter rows based on conditions
- B) Perform calculations on a set of rows and return a single value
- C) Sort the results
- D) Join tables together

### 2. What's the difference between COUNT(*) and COUNT(column)?

- A) No difference, they're the same
- B) COUNT(*) counts all rows, COUNT(column) counts non-NULL values only
- C) COUNT(*) is faster but less accurate
- D) COUNT(column) counts all rows, COUNT(*) counts non-NULL values

### 3. Which aggregate function would you use to find the total payroll?

- A) COUNT(salary)
- B) AVG(salary)
- C) SUM(salary)
- D) MAX(salary)

### 4. How do aggregate functions handle NULL values?

- A) They include NULLs in calculations
- B) They cause an error
- C) They ignore NULLs (except COUNT(*))
- D) They convert NULLs to zero

### 5. What does COUNT(DISTINCT city) return?

- A) Total number of cities including duplicates
- B) Number of unique cities
- C) Number of NULL cities
- D) An error

### 6. Which query finds the average salary?

- A) SELECT SUM(salary) FROM employees
- B) SELECT AVG(salary) FROM employees
- C) SELECT COUNT(salary) FROM employees
- D) SELECT AVERAGE(salary) FROM employees

### 7. What does MIN() work with?

- A) Only numbers
- B) Only dates
- C) Numbers, dates, and strings
- D) Only strings

### 8. If you have salaries: 50000, 60000, NULL, 70000, what does AVG(salary) return?

- A) 45000 (180000/4)
- B) 60000 (180000/3)
- C) NULL
- D) Error

### 9. Can you use multiple aggregate functions in one query?

- A) No, only one per query
- B) Yes, you can combine multiple aggregates
- C) Only with GROUP BY
- D) Only COUNT and SUM

### 10. What's wrong with: SELECT name, AVG(salary) FROM employees?

- A) Nothing, it's correct
- B) Cannot mix non-aggregate columns with aggregates without GROUP BY
- C) AVG syntax is wrong
- D) Should use SUM instead of AVG

### 11. How do you round the average to 2 decimal places?

- A) AVG(salary, 2)
- B) ROUND(AVG(salary), 2)
- C) AVG(ROUND(salary, 2))
- D) DECIMAL(AVG(salary), 2)

### 12. Which query counts unique departments?

- A) SELECT COUNT(department) FROM employees
- B) SELECT COUNT(*) FROM employees
- C) SELECT COUNT(DISTINCT department) FROM employees
- D) SELECT DISTINCT COUNT(department) FROM employees

### 13. Can you use aggregate functions in WHERE clause?

- A) Yes, always
- B) No, use HAVING instead (or subquery)
- C) Only COUNT
- D) Only with GROUP BY

### 14. What does MAX(name) return?

- A) The longest name
- B) The alphabetically last name
- C) An error (MAX only works with numbers)
- D) The most common name

### 15. Which shows total revenue and average order value?

- A) SELECT SUM(total), AVG(total) FROM orders
- B) SELECT TOTAL(orders), AVERAGE(orders) FROM orders
- C) SELECT COUNT(total), SUM(total) FROM orders
- D) SELECT MAX(total), MIN(total) FROM orders

---

## Answers

1. **B** - Perform calculations on a set of rows and return a single value
   - Aggregate functions summarize data into a single result

2. **B** - COUNT(*) counts all rows, COUNT(column) counts non-NULL values only
   - COUNT(*) includes rows with NULL values, COUNT(column) excludes them

3. **C** - SUM(salary)
   - SUM adds up all salary values to get total payroll

4. **C** - They ignore NULLs (except COUNT(*))
   - COUNT(*) counts all rows, other aggregates skip NULL values

5. **B** - Number of unique cities
   - DISTINCT removes duplicates before counting

6. **B** - SELECT AVG(salary) FROM employees
   - AVG calculates the mean of all values

7. **C** - Numbers, dates, and strings
   - MIN finds smallest number, earliest date, or alphabetically first string

8. **B** - 60000 (180000/3)
   - AVG ignores NULL, so divides by count of non-NULL values (3, not 4)

9. **B** - Yes, you can combine multiple aggregates
   - You can use COUNT, SUM, AVG, MIN, MAX together in one SELECT

10. **B** - Cannot mix non-aggregate columns with aggregates without GROUP BY
    - Either aggregate all columns or use GROUP BY

11. **B** - ROUND(AVG(salary), 2)
    - ROUND function takes value and decimal places

12. **C** - SELECT COUNT(DISTINCT department) FROM employees
    - DISTINCT removes duplicates, then COUNT counts them

13. **B** - No, use HAVING instead (or subquery)
    - WHERE filters before aggregation, HAVING filters after

14. **B** - The alphabetically last name
    - MAX on strings returns the last in alphabetical order

15. **A** - SELECT SUM(total), AVG(total) FROM orders
    - Combines SUM for total revenue and AVG for average order value

---

## Scoring

- **13-15 correct**: Excellent! You've mastered aggregate functions
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **COUNT(*) vs COUNT(column)** - COUNT(*) includes NULLs, COUNT(column) doesn't

✅ **SUM adds values** - Total of all numeric values

✅ **AVG calculates mean** - Sum divided by count of non-NULL values

✅ **MIN finds smallest** - Works with numbers, dates, strings

✅ **MAX finds largest** - Works with numbers, dates, strings

✅ **NULL handling** - Aggregates ignore NULLs (except COUNT(*))

✅ **DISTINCT with aggregates** - Count or sum unique values only

✅ **Multiple aggregates** - Can combine in one query

✅ **Cannot mix with non-aggregates** - Need GROUP BY (next lesson!)

✅ **ROUND for readability** - Use ROUND(AVG(col), 2) for clean output
