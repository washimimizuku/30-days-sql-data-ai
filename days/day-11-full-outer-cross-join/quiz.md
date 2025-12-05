# Day 11 Quiz: FULL OUTER JOIN and CROSS JOIN

## Instructions
Answer all 15 questions. Check your answers at the bottom.

---

## FULL OUTER JOIN Questions

### 1. What does FULL OUTER JOIN return?
   - A) Only matching rows from both tables
   - B) All rows from the left table only
   - C) All rows from both tables, with NULLs where no match exists
   - D) Only rows that don't match

### 2. Which of these is equivalent to FULL OUTER JOIN?
   - A) INNER JOIN
   - B) LEFT JOIN UNION RIGHT JOIN
   - C) CROSS JOIN
   - D) NATURAL JOIN

### 3. When should you use FULL OUTER JOIN?
   - A) When you only need matching records
   - B) When you need all records from both tables
   - C) When you want to create all combinations
   - D) When you only need left table records

### 4. What happens to unmatched rows in FULL OUTER JOIN?
   - A) They are excluded from results
   - B) They appear with NULL values for the other table's columns
   - C) They cause an error
   - D) They are duplicated

### 5. Which function is commonly used with FULL OUTER JOIN to handle NULLs?
   - A) COUNT()
   - B) SUM()
   - C) COALESCE()
   - D) MAX()

### 6. What is a common use case for FULL OUTER JOIN?
   - A) Calculating totals
   - B) Data reconciliation between two systems
   - C) Sorting data
   - D) Filtering data

### 7. How many rows will this query return if table A has 5 rows and table B has 3 rows with 2 matches?
```sql
SELECT * FROM A FULL OUTER JOIN B ON A.id = B.id;
```
   - A) 2 rows
   - B) 5 rows
   - C) 6 rows (5 + 3 - 2 matches)
   - D) 8 rows

---

## CROSS JOIN Questions

### 8. What does CROSS JOIN produce?
   - A) Only matching rows
   - B) The Cartesian product of two tables
   - C) All rows from the left table
   - D) Only unique combinations

### 9. How many rows will CROSS JOIN produce if table A has 4 rows and table B has 5 rows?
   - A) 4 rows
   - B) 5 rows
   - C) 9 rows
   - D) 20 rows

### 10. Which syntax is equivalent to CROSS JOIN?
   - A) SELECT * FROM A, B;
   - B) SELECT * FROM A INNER JOIN B;
   - C) SELECT * FROM A LEFT JOIN B;
   - D) SELECT * FROM A UNION B;

### 11. When should you use CROSS JOIN?
   - A) To find matching records
   - B) To generate all possible combinations
   - C) To filter data
   - D) To remove duplicates

### 12. What is a common use case for CROSS JOIN?
   - A) Finding missing records
   - B) Generating product variants (size × color)
   - C) Calculating averages
   - D) Sorting results

### 13. What should you be careful about with CROSS JOIN?
   - A) It only works with two tables
   - B) It can produce very large result sets
   - C) It requires a WHERE clause
   - D) It only works with numeric columns

---

## Combined Questions

### 14. What is the main difference between FULL OUTER JOIN and CROSS JOIN?
   - A) FULL OUTER JOIN requires an ON condition, CROSS JOIN doesn't
   - B) FULL OUTER JOIN is faster
   - C) CROSS JOIN only works with small tables
   - D) There is no difference

### 15. Which query would you use to find all employees AND all departments, showing which are matched?
   - A) INNER JOIN
   - B) CROSS JOIN
   - C) FULL OUTER JOIN
   - D) LEFT JOIN

---

## Answers

1. **C** - All rows from both tables, with NULLs where no match exists
   - FULL OUTER JOIN returns everything from both tables, filling in NULLs where there's no match

2. **B** - LEFT JOIN UNION RIGHT JOIN
   - FULL OUTER JOIN is conceptually equivalent to combining LEFT and RIGHT JOIN results

3. **B** - When you need all records from both tables
   - Use FULL OUTER JOIN when you want to see everything from both sides

4. **B** - They appear with NULL values for the other table's columns
   - Unmatched rows are included with NULLs for the missing side

5. **C** - COALESCE()
   - COALESCE() is commonly used to provide default values for NULLs in FULL OUTER JOIN

6. **B** - Data reconciliation between two systems
   - FULL OUTER JOIN is perfect for comparing data between systems and finding mismatches

7. **C** - 6 rows (5 + 3 - 2 matches)
   - Total unique rows: 5 from A + 3 from B - 2 that match = 6 rows

8. **B** - The Cartesian product of two tables
   - CROSS JOIN creates every possible combination of rows from both tables

9. **D** - 20 rows
   - CROSS JOIN produces rows = table A rows × table B rows = 4 × 5 = 20

10. **A** - SELECT * FROM A, B;
    - The comma syntax is the older implicit CROSS JOIN syntax

11. **B** - To generate all possible combinations
    - CROSS JOIN is used when you need every possible pairing

12. **B** - Generating product variants (size × color)
    - CROSS JOIN is perfect for creating all combinations like product variants

13. **B** - It can produce very large result sets
    - CROSS JOIN can create huge result sets (1000 × 1000 = 1,000,000 rows!)

14. **A** - FULL OUTER JOIN requires an ON condition, CROSS JOIN doesn't
    - FULL OUTER JOIN matches on a condition; CROSS JOIN creates all combinations

15. **C** - FULL OUTER JOIN
    - FULL OUTER JOIN shows all employees and all departments, matched where possible

---

## Scoring
- 13-15 correct: Excellent! You understand both join types well.
- 10-12 correct: Good! Review the concepts you missed.
- 7-9 correct: Fair. Review the theory and practice more exercises.
- Below 7: Review the theory section and try the exercises again.
