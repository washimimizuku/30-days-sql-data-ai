# Day 18 Quiz: CASE Statements

Test your understanding of CASE statements!

---

## Questions

### 1. What is the purpose of CASE statements in SQL?

- A) To filter rows from a table
- B) To add conditional logic and return different values based on conditions
- C) To join tables together
- D) To sort query results

### 2. Which type of CASE is more flexible and commonly used?

- A) Simple CASE
- B) Searched CASE
- C) Both are equally flexible
- D) Neither, use IF instead

### 3. What happens if no WHEN condition matches and there's no ELSE clause?

- A) Returns 0
- B) Returns empty string
- C) Returns NULL
- D) Throws an error

### 4. What is the correct syntax for a searched CASE?

- A) `CASE column WHEN value THEN result END`
- B) `CASE WHEN condition THEN result ELSE default END`
- C) `IF condition THEN result ELSE default`
- D) `WHEN condition CASE result`

### 5. How do you count only completed orders using CASE?

- A) `COUNT(CASE WHEN status = 'completed' THEN 1 END)`
- B) `COUNT(*) WHERE status = 'completed'`
- C) `SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)`
- D) Both A and C work

### 6. What's wrong with this CASE statement?
```sql
CASE 
    WHEN price > 0 THEN 'Has Price'
    WHEN price > 100 THEN 'Expensive'
END
```

- A) Missing ELSE clause
- B) Wrong order - specific conditions should come first
- C) Syntax error
- D) Nothing wrong

### 7. Why use CASE with aggregations instead of WHERE?

- A) WHERE is slower
- B) WHERE filters rows; CASE lets you count/sum different conditions in one query
- C) CASE is required for aggregations
- D) They do the same thing

### 8. What does this create: `SUM(CASE WHEN quarter = 1 THEN revenue ELSE 0 END) as q1_revenue`?

- A) A filter for Q1 data
- B) A pivot column showing Q1 revenue
- C) An error
- D) A subquery

### 9. Can you use CASE in the ORDER BY clause?

- A) No, only in SELECT
- B) Yes, for custom sorting logic
- C) Only with Simple CASE
- D) Only with numeric values

### 10. What's the best practice for CASE statements?

- A) Never use ELSE
- B) Always include ELSE to avoid NULL results
- C) Use as many nested CASE as possible
- D) Only use Simple CASE

### 11. What does this return if price is 75?
```sql
CASE 
    WHEN price < 50 THEN 'Budget'
    WHEN price < 200 THEN 'Mid-Range'
    ELSE 'Premium'
END
```

- A) Budget
- B) Mid-Range
- C) Premium
- D) NULL

### 12. How do you create a flag column (1 or 0)?

- A) `CASE WHEN condition THEN 1 ELSE 0 END`
- B) `IF condition THEN 1 ELSE 0`
- C) `WHEN condition THEN 1`
- D) `FLAG(condition)`

### 13. What's wrong with this?
```sql
CASE 
    WHEN condition THEN 'Yes'
    ELSE 0
END
```

- A) Missing END keyword
- B) Type mismatch (string vs number)
- C) Wrong syntax
- D) Nothing wrong

### 14. Can you use CASE in a GROUP BY clause?

- A) No, never
- B) Yes, to group by calculated categories
- C) Only with Simple CASE
- D) Only in subqueries

### 15. What's the difference between Simple and Searched CASE?

- A) Simple CASE compares one expression to values; Searched CASE evaluates different conditions
- B) They're the same
- C) Simple CASE is faster
- D) Searched CASE can't use ELSE

---

## Answers

1. **B** - To add conditional logic and return different values based on conditions
   - CASE is SQL's if/else equivalent

2. **B** - Searched CASE
   - More flexible, can evaluate different conditions

3. **C** - Returns NULL
   - Always include ELSE to avoid unexpected NULLs

4. **B** - `CASE WHEN condition THEN result ELSE default END`
   - Standard searched CASE syntax

5. **D** - Both A and C work
   - COUNT with CASE WHEN or SUM with CASE both work

6. **B** - Wrong order - specific conditions should come first
   - The second WHEN will never be reached

7. **B** - WHERE filters rows; CASE lets you count/sum different conditions in one query
   - CASE allows multiple conditional aggregations in one query

8. **B** - A pivot column showing Q1 revenue
   - Common pattern for creating pivot tables

9. **B** - Yes, for custom sorting logic
   - CASE can be used in any clause

10. **B** - Always include ELSE to avoid NULL results
    - Best practice to handle all cases explicitly

11. **B** - Mid-Range
    - 75 is >= 50 and < 200

12. **A** - `CASE WHEN condition THEN 1 ELSE 0 END`
    - Standard flag creation pattern

13. **B** - Type mismatch (string vs number)
    - All results must be the same type

14. **B** - Yes, to group by calculated categories
    - Use same CASE in SELECT and GROUP BY

15. **A** - Simple CASE compares one expression to values; Searched CASE evaluates different conditions
    - Key difference between the two types

---

## Scoring

- **13-15 correct**: Excellent! You've mastered CASE statements
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **CASE adds conditional logic** - Like if/else in programming

✅ **Two types** - Simple (compare one expression) and Searched (multiple conditions)

✅ **Always include ELSE** - Avoid NULL results

✅ **Order matters** - Most specific conditions first

✅ **Great with aggregations** - `COUNT(CASE WHEN...)`, `SUM(CASE WHEN...)`

✅ **Create pivot tables** - Transform rows to columns

✅ **Use anywhere** - SELECT, WHERE, ORDER BY, GROUP BY

✅ **Keep types consistent** - All THEN results must be same type

✅ **Essential for categorization** - Segment data into groups

✅ **Powerful for reporting** - Dynamic, flexible queries
