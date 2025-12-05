# Day 23 Quiz: UNION and Set Operations

Test your understanding of set operations!

---

## Questions

### 1. What does UNION do?

- A) Joins two tables
- B) Combines results and removes duplicates
- C) Combines results and keeps duplicates
- D) Finds common rows

### 2. What's the difference between UNION and UNION ALL?

- A) No difference
- B) UNION removes duplicates, UNION ALL keeps them
- C) UNION is faster
- D) UNION ALL removes duplicates

### 3. Which is faster: UNION or UNION ALL?

- A) UNION
- B) UNION ALL
- C) Same speed
- D) Depends on data

### 4. What does INTERSECT return?

- A) All rows from both queries
- B) Rows that appear in both queries
- C) Rows from first query only
- D) Rows that differ

### 5. What does EXCEPT return?

- A) All rows
- B) Common rows
- C) Rows in first query but not in second
- D) Rows in second query but not in first

### 6. What's required for set operations to work?

- A) Same table names
- B) Same number of columns and compatible types
- C) Same column names
- D) Same number of rows

### 7. Which column names are used in UNION result?

- A) From second SELECT
- B) From first SELECT
- C) Combination of both
- D) Auto-generated

### 8. When should you use UNION ALL instead of UNION?

- A) When you need unique rows
- B) When duplicates don't matter or are expected
- C) Never
- D) Always

### 9. How do you find employees who left the company?

- A) employees_2023 UNION employees_2024
- B) employees_2023 INTERSECT employees_2024
- C) employees_2023 EXCEPT employees_2024
- D) employees_2024 EXCEPT employees_2023

### 10. How do you combine quarterly sales tables?

- A) Use UNION to remove duplicates
- B) Use UNION ALL (no duplicates expected)
- C) Use INTERSECT
- D) Use EXCEPT

### 11. What happens if column counts don't match?

- A) NULL fills missing columns
- B) Error
- C) Ignores extra columns
- D) Works fine

### 12. Can you use ORDER BY with UNION?

- A) No
- B) Yes, at the end of the entire query
- C) Yes, in each SELECT
- D) Only with UNION ALL

### 13. How do you find products available in both channels?

- A) products_online UNION products_store
- B) products_online INTERSECT products_store
- C) products_online EXCEPT products_store
- D) products_online UNION ALL products_store

### 14. What's the XOR operation (exclusive OR)?

- A) (A UNION B)
- B) (A INTERSECT B)
- C) (A EXCEPT B) UNION (B EXCEPT A)
- D) (A UNION ALL B)

### 15. When combining employee and customer lists, what should you add?

- A) Nothing
- B) A type indicator column
- C) An ID column
- D) A timestamp

---

## Answers

1. **B** - Combines results and removes duplicates
   - UNION merges query results and eliminates duplicate rows

2. **B** - UNION removes duplicates, UNION ALL keeps them
   - Key difference between the two operations

3. **B** - UNION ALL
   - No duplicate removal means better performance

4. **B** - Rows that appear in both queries
   - INTERSECT finds common rows

5. **C** - Rows in first query but not in second
   - EXCEPT finds the difference

6. **B** - Same number of columns and compatible types
   - Required for all set operations

7. **B** - From first SELECT
   - First query determines column names

8. **B** - When duplicates don't matter or are expected
   - Use UNION ALL for better performance when appropriate

9. **C** - employees_2023 EXCEPT employees_2024
   - Finds rows in 2023 but not in 2024

10. **B** - Use UNION ALL (no duplicates expected)
    - Quarterly tables shouldn't have duplicates

11. **B** - Error
    - Column counts must match

12. **B** - Yes, at the end of the entire query
    - ORDER BY applies to final result

13. **B** - products_online INTERSECT products_store
    - INTERSECT finds common products

14. **C** - (A EXCEPT B) UNION (B EXCEPT A)
    - Items in A or B but not both

15. **B** - A type indicator column
    - Helps identify source of each row

---

## Scoring

- **13-15 correct**: Excellent! You've mastered set operations
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **UNION** - Combines and removes duplicates (slower)

✅ **UNION ALL** - Combines and keeps duplicates (faster)

✅ **INTERSECT** - Finds common rows

✅ **EXCEPT** - Finds difference (A - B)

✅ **Requirements** - Same column count and compatible types

✅ **Column names** - From first SELECT

✅ **Performance** - UNION ALL is faster when duplicates OK

✅ **Use cases** - Combine partitioned data, find overlaps, identify gaps

✅ **Add indicators** - Include source/type columns when combining

✅ **ORDER BY** - Place at end of entire query
