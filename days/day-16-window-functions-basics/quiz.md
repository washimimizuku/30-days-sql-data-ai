# Day 16 Quiz: Window Functions - ROW_NUMBER, RANK, DENSE_RANK

Test your understanding of window functions!

---

## Questions

### 1. What is the main difference between window functions and GROUP BY?

- A) Window functions are faster than GROUP BY
- B) Window functions keep all rows while GROUP BY collapses them
- C) Window functions can only be used with numeric data
- D) GROUP BY is more powerful than window functions

### 2. Which window function always assigns unique sequential numbers?

- A) RANK()
- B) DENSE_RANK()
- C) ROW_NUMBER()
- D) NTILE()

### 3. What happens with RANK() when there are tied values?

- A) It assigns the same rank and continues without gaps
- B) It assigns the same rank and skips the next rank(s)
- C) It assigns different ranks to tied values
- D) It throws an error

### 4. What is the purpose of PARTITION BY in a window function?

- A) To filter rows before applying the function
- B) To divide data into groups and apply the function to each group separately
- C) To sort the results
- D) To limit the number of rows returned

### 5. Which ranking function produces: 1, 2, 2, 3, 4 (no gaps)?

- A) ROW_NUMBER()
- B) RANK()
- C) DENSE_RANK()
- D) PERCENT_RANK()

### 6. Can you use a window function directly in a WHERE clause?

- A) Yes, always
- B) No, you must use a CTE or subquery
- C) Only with ROW_NUMBER()
- D) Only with PARTITION BY

### 7. What does this query do: `ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)`?

- A) Ranks all employees by salary
- B) Numbers employees within each department by salary (highest first)
- C) Counts employees in each department
- D) Finds the highest salary in each department

### 8. Which function would you use to divide data into equal-sized groups (like quartiles)?

- A) ROW_NUMBER()
- B) RANK()
- C) DENSE_RANK()
- D) NTILE()

### 9. What is required in a ROW_NUMBER() window function for consistent results?

- A) PARTITION BY clause
- B) ORDER BY clause
- C) WHERE clause
- D) HAVING clause

### 10. In the "top N per group" pattern, which function is typically used?

- A) RANK() because it handles ties well
- B) DENSE_RANK() because it has no gaps
- C) ROW_NUMBER() because it guarantees exactly N rows per group
- D) NTILE() because it divides into groups

### 11. What does PERCENT_RANK() return?

- A) The percentage of rows in each partition
- B) A value between 0 and 1 representing relative rank
- C) The count of rows
- D) The average rank

### 12. Which query pattern is INCORRECT?

- A) `SELECT name, ROW_NUMBER() OVER (ORDER BY salary) FROM employees`
- B) `SELECT name, RANK() OVER (PARTITION BY dept ORDER BY salary) FROM employees`
- C) `SELECT name FROM employees WHERE ROW_NUMBER() OVER (ORDER BY salary) <= 5`
- D) `WITH ranked AS (SELECT *, ROW_NUMBER() OVER (ORDER BY salary) as rn FROM employees) SELECT * FROM ranked WHERE rn <= 5`

### 13. What's the difference between these two: RANK() vs DENSE_RANK() with values [100, 90, 90, 80]?

- A) RANK: 1,2,2,3 | DENSE_RANK: 1,2,2,4
- B) RANK: 1,2,2,4 | DENSE_RANK: 1,2,2,3
- C) RANK: 1,2,3,4 | DENSE_RANK: 1,2,2,3
- D) They produce the same result

### 14. When would you use PARTITION BY without ORDER BY?

- A) Never, ORDER BY is always required
- B) When you want to calculate aggregates across partitions
- C) When you want random ordering
- D) When using ROW_NUMBER()

### 15. What is a common use case for window functions in pagination?

- A) Counting total pages
- B) Assigning row numbers and filtering by range
- C) Sorting results
- D) Grouping data

---

## Answers

1. **B** - Window functions keep all rows while GROUP BY collapses them
   - Window functions add calculated columns without reducing row count

2. **C** - ROW_NUMBER()
   - ROW_NUMBER() always assigns unique sequential numbers, even for tied values

3. **B** - It assigns the same rank and skips the next rank(s)
   - Example: 1, 2, 2, 4 (rank 3 is skipped)

4. **B** - To divide data into groups and apply the function to each group separately
   - PARTITION BY creates separate "windows" for each group

5. **C** - DENSE_RANK()
   - DENSE_RANK() doesn't skip ranks after ties

6. **B** - No, you must use a CTE or subquery
   - Window functions are evaluated after WHERE, so use a CTE to filter

7. **B** - Numbers employees within each department by salary (highest first)
   - PARTITION BY creates separate numbering for each department

8. **D** - NTILE()
   - NTILE(4) divides data into 4 equal groups (quartiles)

9. **B** - ORDER BY clause
   - Without ORDER BY, row numbers would be arbitrary/non-deterministic

10. **C** - ROW_NUMBER() because it guarantees exactly N rows per group
    - ROW_NUMBER() ensures unique ranks, giving exactly N rows when filtered

11. **B** - A value between 0 and 1 representing relative rank
    - 0 = lowest, 1 = highest, useful for percentile calculations

12. **C** - `SELECT name FROM employees WHERE ROW_NUMBER() OVER (ORDER BY salary) <= 5`
    - Window functions cannot be used directly in WHERE clause

13. **B** - RANK: 1,2,2,4 | DENSE_RANK: 1,2,2,3
    - RANK skips 3, DENSE_RANK continues with 3

14. **B** - When you want to calculate aggregates across partitions
    - Example: `AVG(salary) OVER (PARTITION BY department)` doesn't need ORDER BY

15. **B** - Assigning row numbers and filtering by range
    - Pattern: ROW_NUMBER() OVER (ORDER BY ...) then filter WHERE rn BETWEEN 11 AND 20

---

## Scoring

- **13-15 correct**: Excellent! You've mastered window functions
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **Window functions preserve all rows** (unlike GROUP BY)

✅ **ROW_NUMBER()** = Always unique (1,2,3,4,5...)

✅ **RANK()** = Ties get same rank, with gaps (1,2,2,4,5...)

✅ **DENSE_RANK()** = Ties get same rank, no gaps (1,2,2,3,4...)

✅ **PARTITION BY** = Creates separate groups for window calculations

✅ **ORDER BY** = Required for ROW_NUMBER, RANK, DENSE_RANK

✅ **Cannot use in WHERE** = Must use CTE or subquery to filter

✅ **Top N per group** = Use ROW_NUMBER() with PARTITION BY + CTE
