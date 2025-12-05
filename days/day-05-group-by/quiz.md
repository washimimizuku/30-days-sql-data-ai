# Day 5 Quiz: GROUP BY Basics

Test your understanding of GROUP BY and grouping data!

---

## Questions

### 1. What is the purpose of GROUP BY?

- A) To filter rows based on conditions
- B) To group rows with the same values and aggregate them
- C) To sort the results
- D) To join tables together

### 2. Which aggregate function is most commonly used with GROUP BY?

- A) DISTINCT
- B) COUNT, SUM, AVG, MIN, MAX
- C) WHERE
- D) ORDER BY

### 3. What's the rule for columns in SELECT when using GROUP BY?

- A) Any column can be in SELECT
- B) Every column must be in GROUP BY or inside an aggregate function
- C) Only aggregate functions allowed
- D) No restrictions

### 4. Which query counts employees in each department?

- A) SELECT COUNT(*) FROM employees
- B) SELECT department, COUNT(*) FROM employees
- C) SELECT department, COUNT(*) FROM employees GROUP BY department
- D) SELECT COUNT(*) GROUP BY department FROM employees

### 5. What does this query return: SELECT department, AVG(salary) FROM employees GROUP BY department?

- A) Average salary of all employees
- B) Average salary for each department
- C) Total salary for each department
- D) Count of employees per department

### 6. Can you group by multiple columns?

- A) No, only one column allowed
- B) Yes, you can group by multiple columns
- C) Only with HAVING clause
- D) Only with WHERE clause

### 7. What's the execution order: WHERE, GROUP BY, SELECT?

- A) SELECT, WHERE, GROUP BY
- B) WHERE, GROUP BY, SELECT
- C) GROUP BY, WHERE, SELECT
- D) WHERE, SELECT, GROUP BY

### 8. What's wrong with: SELECT department, name, COUNT(*) FROM employees GROUP BY department?

- A) Nothing, it's correct
- B) name is not in GROUP BY or an aggregate function
- C) COUNT syntax is wrong
- D) Missing WHERE clause

### 9. How do you find total payroll per department?

- A) SELECT department, COUNT(salary) FROM employees GROUP BY department
- B) SELECT department, AVG(salary) FROM employees GROUP BY department
- C) SELECT department, SUM(salary) FROM employees GROUP BY department
- D) SELECT SUM(salary) FROM employees

### 10. Can you use WHERE with GROUP BY?

- A) No, they cannot be used together
- B) Yes, WHERE filters rows before grouping
- C) Only with HAVING
- D) Only in subqueries

### 11. What does GROUP BY department, city do?

- A) Groups by department only
- B) Groups by city only
- C) Groups by unique combinations of department and city
- D) Returns an error

### 12. Which query shows count, average, min, and max salary per department?

- A) SELECT department, COUNT(*), AVG(salary), MIN(salary), MAX(salary) FROM employees
- B) SELECT department, COUNT(*), AVG(salary), MIN(salary), MAX(salary) FROM employees GROUP BY department
- C) SELECT COUNT(*), AVG(salary), MIN(salary), MAX(salary) FROM employees GROUP BY department
- D) SELECT department FROM employees GROUP BY COUNT(*), AVG(salary)

### 13. When should you use GROUP BY?

- A) When you want to filter rows
- B) When you want to aggregate data by categories or groups
- C) When you want to sort results
- D) When you want to join tables

### 14. What comes after GROUP BY in SQL execution order?

- A) WHERE
- B) FROM
- C) SELECT (with aggregates calculated)
- D) ORDER BY

### 15. Which is a valid use of GROUP BY?

- A) SELECT city, COUNT(*) FROM employees GROUP BY city
- B) SELECT city, name, COUNT(*) FROM employees GROUP BY city
- C) SELECT COUNT(*) FROM employees GROUP BY name
- D) Both A and C

---

## Answers

1. **B** - To group rows with the same values and aggregate them
   - GROUP BY combines rows with matching values for summary calculations

2. **B** - COUNT, SUM, AVG, MIN, MAX
   - These aggregate functions are almost always used with GROUP BY

3. **B** - Every column must be in GROUP BY or inside an aggregate function
   - This is the fundamental rule of GROUP BY

4. **C** - SELECT department, COUNT(*) FROM employees GROUP BY department
   - Groups by department and counts rows in each group

5. **B** - Average salary for each department
   - Calculates AVG for each unique department value

6. **B** - Yes, you can group by multiple columns
   - Groups by unique combinations of all specified columns

7. **B** - WHERE, GROUP BY, SELECT
   - Filter first, then group, then select and aggregate

8. **B** - name is not in GROUP BY or an aggregate function
   - Every non-aggregated column must be in GROUP BY

9. **C** - SELECT department, SUM(salary) FROM employees GROUP BY department
   - SUM adds up all salaries in each department

10. **B** - Yes, WHERE filters rows before grouping
    - WHERE filters data before GROUP BY processes it

11. **C** - Groups by unique combinations of department and city
    - Creates groups for each dept-city pair

12. **B** - SELECT department, COUNT(*), AVG(salary), MIN(salary), MAX(salary) FROM employees GROUP BY department
    - Multiple aggregates with GROUP BY

13. **B** - When you want to aggregate data by categories or groups
    - GROUP BY is for summarizing data by segments

14. **C** - SELECT (with aggregates calculated)
    - After grouping, SELECT calculates aggregates

15. **D** - Both A and C
    - Both are syntactically valid (though C might not be useful)

---

## Scoring

- **13-15 correct**: Excellent! You've mastered GROUP BY
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **GROUP BY groups rows** - Combines rows with same values

✅ **Used with aggregates** - COUNT, SUM, AVG, MIN, MAX

✅ **Column rule** - Every SELECT column must be in GROUP BY or aggregated

✅ **Multiple columns** - Can group by multiple columns for detailed analysis

✅ **WHERE before GROUP BY** - Filter rows before grouping

✅ **Execution order** - WHERE → GROUP BY → SELECT → ORDER BY

✅ **Multiple aggregates** - Can use several in one query

✅ **Essential for analysis** - Summarize data by categories

✅ **Common pattern** - SELECT group_col, AGG(value) FROM table GROUP BY group_col

✅ **Next: HAVING** - Filter groups after aggregation (Day 6!)
