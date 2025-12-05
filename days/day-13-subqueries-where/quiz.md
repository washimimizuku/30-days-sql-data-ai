# Day 13 Quiz: Subqueries in WHERE

## Instructions
Answer all 15 questions. Check your answers at the bottom.

---

### 1. What is a subquery?
   - A) A query that runs after the main query
   - B) A query nested inside another query
   - C) A query that returns multiple tables
   - D) A query without a WHERE clause

### 2. What does a scalar subquery return?
   - A) Multiple rows and columns
   - B) A single value (one row, one column)
   - C) Multiple rows, one column
   - D) No results

### 3. Which query finds employees with above-average salary?
   - A) `SELECT * FROM employees WHERE salary > AVG(salary)`
   - B) `SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees)`
   - C) `SELECT * FROM employees HAVING salary > AVG(salary)`
   - D) `SELECT * FROM employees WHERE salary = MAX(salary)`

### 4. What does the IN operator do with subqueries?
   - A) Checks if a value exists in the subquery results
   - B) Joins two tables
   - C) Counts rows
   - D) Sorts results

### 5. What's the danger with NOT IN and NULL values?
   - A) It's slower than EXISTS
   - B) If the subquery returns any NULL, NOT IN returns no rows
   - C) It causes syntax errors
   - D) There's no danger

### 6. What does EXISTS check?
   - A) If the subquery returns any rows (true/false)
   - B) If values match exactly
   - C) If values are NULL
   - D) If tables exist

### 7. When is EXISTS typically better than IN?
   - A) Never, they're the same
   - B) For large datasets and when checking existence
   - C) Only for small tables
   - D) Only with NULL values

### 8. What does NOT EXISTS find?
   - A) All records
   - B) Records where the subquery returns no matching rows
   - C) NULL values
   - D) Duplicate records

### 9. What does `salary > ANY (subquery)` mean?
   - A) Salary greater than all values in subquery
   - B) Salary greater than at least one value (the minimum)
   - C) Salary equal to any value
   - D) Salary less than any value

### 10. What does `salary > ALL (subquery)` mean?
   - A) Salary greater than at least one value
   - B) Salary greater than every value (the maximum)
   - C) Salary equal to all values
   - D) Salary less than all values

### 11. What is a correlated subquery?
   - A) A subquery that runs once
   - B) A subquery that references columns from the outer query
   - C) A subquery with multiple tables
   - D) A subquery without WHERE

### 12. Which is safer for finding records without matches?
   - A) NOT IN
   - B) NOT EXISTS
   - C) They're equally safe
   - D) Neither works

### 13. What does `= ANY` do?
   - A) Same as IN
   - B) Same as ALL
   - C) Same as EXISTS
   - D) Same as NOT IN

### 14. How do you find employees earning more than their department average?
   - A) Use a simple WHERE clause
   - B) Use a correlated subquery comparing to department average
   - C) Use GROUP BY only
   - D) Use DISTINCT

### 15. Which subquery type is typically fastest for checking existence?
   - A) IN
   - B) NOT IN
   - C) EXISTS
   - D) ALL

---

## Answers

1. **B** - A query nested inside another query
   - Subqueries are queries within queries, used to filter or calculate values

2. **B** - A single value (one row, one column)
   - Scalar subqueries return exactly one value, used with comparison operators

3. **B** - `SELECT * FROM employees WHERE salary > (SELECT AVG(salary) FROM employees)`
   - The subquery calculates the average, then the outer query compares to it

4. **A** - Checks if a value exists in the subquery results
   - IN checks if a value matches any value returned by the subquery

5. **B** - If the subquery returns any NULL, NOT IN returns no rows
   - This is a common gotcha - always filter NULLs when using NOT IN

6. **A** - If the subquery returns any rows (true/false)
   - EXISTS returns true if the subquery finds at least one row

7. **B** - For large datasets and when checking existence
   - EXISTS stops searching once it finds a match, making it faster

8. **B** - Records where the subquery returns no matching rows
   - NOT EXISTS finds records that don't have related data

9. **B** - Salary greater than at least one value (the minimum)
   - > ANY means greater than the smallest value in the subquery

10. **B** - Salary greater than every value (the maximum)
    - > ALL means greater than the largest value in the subquery

11. **B** - A subquery that references columns from the outer query
    - Correlated subqueries use values from the outer query in their WHERE clause

12. **B** - NOT EXISTS
    - NOT EXISTS handles NULLs properly, while NOT IN can fail with NULLs

13. **A** - Same as IN
    - = ANY is functionally equivalent to IN

14. **B** - Use a correlated subquery comparing to department average
    - Need to calculate average for each employee's specific department

15. **C** - EXISTS
    - EXISTS stops searching once it finds a match, making it very efficient

---

## Scoring
- 13-15 correct: Excellent! You understand subqueries well.
- 10-12 correct: Good! Review the concepts you missed.
- 7-9 correct: Fair. Review the theory and practice more exercises.
- Below 7: Review the theory section and try the exercises again.
