# Day 6 Quiz: HAVING Clause

Test your understanding of HAVING and filtering groups!

---

## Questions

### 1. What is the purpose of HAVING?

- A) To filter individual rows before grouping
- B) To filter groups after GROUP BY
- C) To sort the results
- D) To join tables together

### 2. What's the key difference between WHERE and HAVING?

- A) No difference, they're the same
- B) WHERE filters rows before grouping, HAVING filters groups after grouping
- C) WHERE is faster than HAVING
- D) HAVING can only be used with COUNT

### 3. Which query finds departments with more than 10 employees?

- A) SELECT department FROM employees WHERE COUNT(*) > 10
- B) SELECT department, COUNT(*) FROM employees HAVING COUNT(*) > 10
- C) SELECT department, COUNT(*) FROM employees GROUP BY department HAVING COUNT(*) > 10
- D) SELECT department FROM employees GROUP BY department WHERE COUNT(*) > 10

### 4. Can you use HAVING without GROUP BY?

- A) Yes, always
- B) No, HAVING requires GROUP BY
- C) Only with aggregate functions
- D) Only with WHERE clause

### 5. What does this query return: SELECT department, AVG(salary) FROM employees GROUP BY department HAVING AVG(salary) > 70000?

- A) All employees with salary > 70000
- B) Departments where average salary is above 70000
- C) Total salary for each department
- D) Count of employees per department

### 6. Which is correct for filtering rows before grouping?

- A) Use HAVING
- B) Use WHERE
- C) Use both WHERE and HAVING
- D) Cannot filter before grouping

### 7. What's the SQL execution order?

- A) SELECT, WHERE, GROUP BY, HAVING
- B) WHERE, GROUP BY, HAVING, SELECT
- C) GROUP BY, WHERE, HAVING, SELECT
- D) HAVING, WHERE, GROUP BY, SELECT

### 8. Can you use multiple conditions in HAVING?

- A) No, only one condition allowed
- B) Yes, with AND, OR operators
- C) Only with WHERE clause
- D) Only with subqueries

### 9. Which query finds customers who spent more than $5000?

- A) SELECT customer_id FROM orders WHERE SUM(total) > 5000
- B) SELECT customer_id, SUM(total) FROM orders HAVING SUM(total) > 5000
- C) SELECT customer_id, SUM(total) FROM orders GROUP BY customer_id HAVING SUM(total) > 5000
- D) SELECT customer_id FROM orders GROUP BY customer_id WHERE total > 5000

### 10. What's wrong with: SELECT department, AVG(salary) FROM employees WHERE AVG(salary) > 70000 GROUP BY department?

- A) Nothing, it's correct
- B) Cannot use aggregate functions in WHERE clause
- C) Missing HAVING clause
- D) Wrong GROUP BY syntax

### 11. Can you combine WHERE and HAVING in the same query?

- A) No, only one or the other
- B) Yes, WHERE filters rows first, then HAVING filters groups
- C) Only with subqueries
- D) Only with JOIN

### 12. Which is more efficient?

- A) Always use HAVING for all filtering
- B) Use WHERE to filter rows early, then HAVING for group filtering
- C) Use only WHERE
- D) Use only HAVING

### 13. What does HAVING COUNT(*) > 5 do?

- A) Filters rows with count > 5
- B) Filters groups that have more than 5 rows
- C) Counts only 5 rows
- D) Returns an error

### 14. Which query shows departments with > 10 employees AND avg salary > $75,000?

- A) SELECT department, COUNT(*), AVG(salary) FROM employees GROUP BY department HAVING COUNT(*) > 10 AND AVG(salary) > 75000
- B) SELECT department FROM employees WHERE COUNT(*) > 10 AND AVG(salary) > 75000
- C) SELECT department, COUNT(*), AVG(salary) FROM employees HAVING COUNT(*) > 10 AND AVG(salary) > 75000
- D) SELECT department FROM employees GROUP BY department WHERE COUNT(*) > 10

### 15. When should you use HAVING?

- A) To filter individual rows
- B) To filter groups based on aggregate results
- C) To sort results
- D) To join tables

---

## Answers

1. **B** - To filter groups after GROUP BY
   - HAVING filters the grouped results, not individual rows

2. **B** - WHERE filters rows before grouping, HAVING filters groups after grouping
   - WHERE works on individual rows, HAVING works on aggregated groups

3. **C** - SELECT department, COUNT(*) FROM employees GROUP BY department HAVING COUNT(*) > 10
   - Need GROUP BY to create groups, then HAVING to filter them

4. **B** - No, HAVING requires GROUP BY
   - HAVING is specifically for filtering grouped data

5. **B** - Departments where average salary is above 70000
   - HAVING filters groups based on the aggregate condition

6. **B** - Use WHERE
   - WHERE is more efficient for filtering rows before grouping

7. **B** - WHERE, GROUP BY, HAVING, SELECT
   - Filter rows → Group → Filter groups → Calculate aggregates

8. **B** - Yes, with AND, OR operators
   - Can combine multiple conditions just like WHERE

9. **C** - SELECT customer_id, SUM(total) FROM orders GROUP BY customer_id HAVING SUM(total) > 5000
   - Need to group by customer, then filter groups with HAVING

10. **B** - Cannot use aggregate functions in WHERE clause
    - Aggregates must be in HAVING, not WHERE

11. **B** - Yes, WHERE filters rows first, then HAVING filters groups
    - They work together: WHERE → GROUP BY → HAVING

12. **B** - Use WHERE to filter rows early, then HAVING for group filtering
    - Filtering early with WHERE reduces data before grouping

13. **B** - Filters groups that have more than 5 rows
    - HAVING filters the grouped results

14. **A** - SELECT department, COUNT(*), AVG(salary) FROM employees GROUP BY department HAVING COUNT(*) > 10 AND AVG(salary) > 75000
    - Multiple conditions in HAVING with AND

15. **B** - To filter groups based on aggregate results
    - HAVING is specifically for filtering aggregated data

---

## Scoring

- **13-15 correct**: Excellent! You've mastered HAVING clause
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **HAVING filters groups** - After GROUP BY, not before

✅ **WHERE vs HAVING** - WHERE for rows, HAVING for groups

✅ **Requires GROUP BY** - HAVING only works with grouped data

✅ **Works with aggregates** - COUNT, SUM, AVG, MIN, MAX

✅ **Execution order** - WHERE → GROUP BY → HAVING → SELECT

✅ **Multiple conditions** - Use AND, OR in HAVING

✅ **Combine with WHERE** - Filter rows first, then groups

✅ **Performance** - WHERE is more efficient for row filtering

✅ **Common pattern** - GROUP BY col HAVING AGG(col) > value

✅ **Essential for analysis** - Find groups that meet criteria
