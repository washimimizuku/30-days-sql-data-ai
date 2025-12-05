# Day 15 Quiz: CTEs (Common Table Expressions)

## Instructions
Answer all 15 questions. Check your answers at the bottom.

---

### 1. What does CTE stand for?
   - A) Common Table Entry
   - B) Common Table Expression
   - C) Computed Table Expression
   - D) Conditional Table Expression

### 2. What keyword starts a CTE definition?
   - A) SELECT
   - B) FROM
   - C) WITH
   - D) CTE

### 3. What is the main benefit of CTEs over subqueries?
   - A) They're faster
   - B) More readable and can be referenced multiple times
   - C) They use less memory
   - D) They're required by SQL

### 4. How do you define multiple CTEs in one query?
   - A) Multiple WITH keywords
   - B) Separate with commas after WITH
   - C) Use UNION
   - D) Not possible

### 5. Can a CTE reference another CTE defined earlier?
   - A) No, never
   - B) Yes, if defined before it
   - C) Only with special syntax
   - D) Only in recursive CTEs

### 6. What is the syntax for a basic CTE?
   - A) `WITH cte_name (SELECT ...)`
   - B) `WITH cte_name AS (SELECT ...)`
   - C) `CTE cte_name AS (SELECT ...)`
   - D) `WITH (SELECT ...) AS cte_name`

### 7. What keyword is needed for recursive CTEs?
   - A) LOOP
   - B) RECURSIVE
   - C) REPEAT
   - D) ITERATE

### 8. What separates the base case from recursive case in recursive CTEs?
   - A) UNION
   - B) UNION ALL
   - C) JOIN
   - D) INTERSECT

### 9. Can you reference a CTE multiple times in the main query?
   - A) No, only once
   - B) Yes, that's a key advantage
   - C) Only with special syntax
   - D) Only in subqueries

### 10. Which is more readable for complex queries?
   - A) Nested subqueries
   - B) CTEs
   - C) They're equally readable
   - D) Neither is readable

### 11. What's a common use case for recursive CTEs?
   - A) Simple aggregations
   - B) Hierarchical data like org charts
   - C) Filtering data
   - D) Sorting results

### 12. How do CTEs compare to views?
   - A) CTEs are permanent, views are temporary
   - B) CTEs are temporary (query-scoped), views are permanent
   - C) They're the same thing
   - D) CTEs are slower

### 13. What happens if you try to reference a CTE before it's defined?
   - A) It works fine
   - B) Error - must define before referencing
   - C) Returns NULL
   - D) Runs slowly

### 14. Can CTEs improve query performance?
   - A) Always faster
   - B) Sometimes - by avoiding repeated calculations
   - C) Always slower
   - D) No performance impact

### 15. What's the best practice for naming CTEs?
   - A) Use cte1, cte2, cte3
   - B) Use descriptive names like customer_totals
   - C) Use single letters
   - D) Names don't matter

---

## Answers

1. **B** - Common Table Expression
   - CTE stands for Common Table Expression

2. **C** - WITH
   - CTEs start with the WITH keyword

3. **B** - More readable and can be referenced multiple times
   - CTEs make queries more readable and can be reused in the same query

4. **B** - Separate with commas after WITH
   - Use one WITH, then separate CTEs with commas

5. **B** - Yes, if defined before it
   - CTEs can reference previously defined CTEs

6. **B** - `WITH cte_name AS (SELECT ...)`
   - Standard CTE syntax uses WITH name AS (query)

7. **B** - RECURSIVE
   - Recursive CTEs require the RECURSIVE keyword

8. **B** - UNION ALL
   - UNION ALL separates base case from recursive case

9. **B** - Yes, that's a key advantage
   - Unlike subqueries, CTEs can be referenced multiple times

10. **B** - CTEs
    - CTEs are generally more readable than nested subqueries

11. **B** - Hierarchical data like org charts
    - Recursive CTEs excel at hierarchical/tree structures

12. **B** - CTEs are temporary (query-scoped), views are permanent
    - CTEs exist only during query execution, views are stored

13. **B** - Error - must define before referencing
    - CTEs must be defined in order of dependency

14. **B** - Sometimes - by avoiding repeated calculations
    - CTEs can improve performance by materializing results once

15. **B** - Use descriptive names like customer_totals
    - Descriptive names make queries self-documenting

---

## Scoring
- 13-15 correct: Excellent! You understand CTEs well.
- 10-12 correct: Good! Review the concepts you missed.
- 7-9 correct: Fair. Review the theory and practice more exercises.
- Below 7: Review the theory section and try the exercises again.
