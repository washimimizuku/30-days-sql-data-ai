# Day 14 Quiz: Subqueries in FROM

## Instructions
Answer all 15 questions. Check your answers at the bottom.

---

### 1. What is a subquery in the FROM clause also called?
   - A) Nested query
   - B) Derived table or inline view
   - C) Temporary query
   - D) Virtual query

### 2. What is required when using a subquery in FROM?
   - A) A WHERE clause
   - B) An alias (AS alias_name)
   - C) An ORDER BY clause
   - D) A GROUP BY clause

### 3. Why use a subquery in FROM instead of a regular query?
   - A) It's faster
   - B) To perform multi-level aggregations or apply logic to aggregated results
   - C) It uses less memory
   - D) It's required by SQL

### 4. Which is correct syntax for a subquery in FROM?
   - A) `SELECT * FROM (SELECT * FROM table)`
   - B) `SELECT * FROM (SELECT * FROM table) AS t`
   - C) `SELECT * FROM [SELECT * FROM table]`
   - D) `SELECT * FROM {SELECT * FROM table}`

### 5. What does this query do?
```sql
SELECT dept, avg_sal FROM (
    SELECT department as dept, AVG(salary) as avg_sal
    FROM employees GROUP BY department
) AS d WHERE avg_sal > 60000;
```
   - A) Finds all employees with salary > 60000
   - B) Finds departments with average salary > 60000
   - C) Finds the maximum salary
   - D) Counts employees per department

### 6. Can you join multiple subqueries in FROM?
   - A) No, only one subquery allowed
   - B) Yes, you can join multiple subqueries
   - C) Only with UNION
   - D) Only with special syntax

### 7. What's the benefit of filtering in the subquery vs outer query?
   - A) No difference
   - B) Better performance - processes less data
   - C) Worse performance
   - D) Only works in subquery

### 8. Can subqueries in FROM contain other subqueries?
   - A) No, not allowed
   - B) Yes, they can be nested
   - C) Only one level deep
   - D) Only with CTEs

### 9. What does this pattern enable?
```sql
SELECT AVG(dept_avg) FROM (
    SELECT AVG(salary) as dept_avg FROM employees GROUP BY dept
) AS d;
```
   - A) Simple average
   - B) Multi-level aggregation (average of averages)
   - C) Maximum value
   - D) Count of departments

### 10. When using ROW_NUMBER() in a subquery, what can you do in the outer query?
   - A) Nothing special
   - B) Filter by rank (e.g., WHERE rank <= 3)
   - C) Only sort
   - D) Only count

### 11. What's a common use case for subqueries in FROM?
   - A) Simple SELECT statements
   - B) Ranking results then filtering by rank
   - C) Deleting data
   - D) Creating tables

### 12. Which is more readable for complex queries?
   - A) Nested subqueries in FROM
   - B) CTEs (Common Table Expressions)
   - C) They're equally readable
   - D) Neither is readable

### 13. What happens if you forget the alias?
   - A) Query works fine
   - B) Syntax error
   - C) Returns wrong results
   - D) Runs slowly

### 14. Can you use aggregate functions on subquery results?
   - A) No, not allowed
   - B) Yes, you can aggregate the derived table
   - C) Only with GROUP BY
   - D) Only with HAVING

### 15. What's the best practice for column selection in subqueries?
   - A) Always SELECT *
   - B) Only select columns you need
   - C) Select all columns for safety
   - D) Doesn't matter

---

## Answers

1. **B** - Derived table or inline view
   - Subqueries in FROM are called derived tables or inline views

2. **B** - An alias (AS alias_name)
   - You MUST give the subquery an alias to reference it

3. **B** - To perform multi-level aggregations or apply logic to aggregated results
   - Subqueries in FROM enable operations you can't do with simple queries

4. **B** - `SELECT * FROM (SELECT * FROM table) AS t`
   - Must include parentheses and an alias

5. **B** - Finds departments with average salary > 60000
   - Subquery calculates averages, outer query filters them

6. **B** - Yes, you can join multiple subqueries
   - You can join as many subqueries as needed

7. **B** - Better performance - processes less data
   - Filtering early reduces the amount of data processed

8. **B** - Yes, they can be nested
   - Subqueries can contain other subqueries (nested)

9. **B** - Multi-level aggregation (average of averages)
   - This calculates the average of department averages

10. **B** - Filter by rank (e.g., WHERE rank <= 3)
    - Common pattern: rank in subquery, filter by rank in outer query

11. **B** - Ranking results then filtering by rank
    - Very common pattern for "top N per group" queries

12. **B** - CTEs (Common Table Expressions)
    - CTEs are generally more readable than nested subqueries

13. **B** - Syntax error
    - SQL requires an alias for subqueries in FROM

14. **B** - Yes, you can aggregate the derived table
    - The derived table acts like a regular table

15. **B** - Only select columns you need
    - Better performance and clearer intent

---

## Scoring
- 13-15 correct: Excellent! You understand derived tables well.
- 10-12 correct: Good! Review the concepts you missed.
- 7-9 correct: Fair. Review the theory and practice more exercises.
- Below 7: Review the theory section and try the exercises again.
