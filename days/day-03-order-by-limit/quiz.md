# Day 3 Quiz: ORDER BY and LIMIT

Test your understanding of sorting and limiting results!

---

## Questions

### 1. What is the purpose of ORDER BY?

- A) To filter rows based on conditions
- B) To sort query results by one or more columns
- C) To limit the number of rows returned
- D) To join tables together

### 2. What is the default sort direction for ORDER BY?

- A) DESC (descending)
- B) ASC (ascending)
- C) RANDOM
- D) No default, must be specified

### 3. Which query sorts employees by salary from highest to lowest?

- A) SELECT * FROM employees ORDER BY salary
- B) SELECT * FROM employees ORDER BY salary ASC
- C) SELECT * FROM employees ORDER BY salary DESC
- D) SELECT * FROM employees SORT BY salary DESC

### 4. What does LIMIT do?

- A) Filters rows based on conditions
- B) Sorts the results
- C) Restricts the number of rows returned
- D) Skips a specified number of rows

### 5. What's wrong with: SELECT * FROM employees LIMIT 10?

- A) LIMIT syntax is incorrect
- B) Nothing, it's perfectly fine
- C) Without ORDER BY, results are unpredictable
- D) Should use OFFSET with LIMIT

### 6. How do you get rows 11-20 for pagination?

- A) LIMIT 10 OFFSET 10
- B) LIMIT 11-20
- C) OFFSET 10 LIMIT 10
- D) LIMIT 20 OFFSET 10

### 7. What does this query return: ORDER BY department, salary DESC?

- A) Sorts by department DESC, then salary DESC
- B) Sorts by department ASC, then salary DESC within each department
- C) Sorts by salary DESC only
- D) Returns an error

### 8. What is the pagination formula for OFFSET?

- A) OFFSET = page_number * page_size
- B) OFFSET = (page_number - 1) * page_size
- C) OFFSET = page_number + page_size
- D) OFFSET = page_size / page_number

### 9. Which is the correct syntax?

- A) SELECT * FROM employees OFFSET 10 LIMIT 10
- B) SELECT * FROM employees LIMIT 10 OFFSET 10
- C) SELECT * FROM employees LIMIT OFFSET 10 10
- D) SELECT * FROM employees 10 LIMIT 10 OFFSET

### 10. How do you sort by multiple columns with different directions?

- A) ORDER BY col1 ASC, col2 DESC
- B) ORDER BY col1, col2 DESC ASC
- C) ORDER BY ASC col1, DESC col2
- D) Cannot mix ASC and DESC

### 11. Where do NULL values typically appear with ORDER BY salary ASC?

- A) At the end
- B) At the beginning
- C) Randomly distributed
- D) NULLs are excluded

### 12. What's the best practice when using LIMIT?

- A) Never use ORDER BY with LIMIT
- B) Always use ORDER BY with LIMIT for predictable results
- C) Use LIMIT without WHERE clause
- D) LIMIT should always be 10

### 13. Which query gets the top 5 most expensive products?

- A) SELECT * FROM products LIMIT 5
- B) SELECT * FROM products ORDER BY price LIMIT 5
- C) SELECT * FROM products ORDER BY price DESC LIMIT 5
- D) SELECT * FROM products WHERE price LIMIT 5

### 14. What does ORDER BY name, hire_date DESC do?

- A) Sorts by name DESC, then hire_date DESC
- B) Sorts by name ASC, then hire_date DESC
- C) Sorts by hire_date DESC only
- D) Returns an error

### 15. For page 3 with 20 items per page, what OFFSET should you use?

- A) OFFSET 20
- B) OFFSET 40
- C) OFFSET 60
- D) OFFSET 3

---

## Answers

1. **B** - To sort query results by one or more columns
   - ORDER BY arranges rows in a specified order

2. **B** - ASC (ascending)
   - If you don't specify ASC or DESC, ASC is assumed

3. **C** - SELECT * FROM employees ORDER BY salary DESC
   - DESC sorts from highest to lowest

4. **C** - Restricts the number of rows returned
   - LIMIT caps the result set to a specified number

5. **C** - Without ORDER BY, results are unpredictable
   - LIMIT without ORDER BY returns arbitrary rows

6. **A** - LIMIT 10 OFFSET 10
   - Skip first 10 rows, return next 10

7. **B** - Sorts by department ASC, then salary DESC within each department
   - First column uses default ASC, second uses explicit DESC

8. **B** - OFFSET = (page_number - 1) * page_size
   - Page 1: (1-1)*10=0, Page 2: (2-1)*10=10, Page 3: (3-1)*10=20

9. **B** - SELECT * FROM employees LIMIT 10 OFFSET 10
   - LIMIT must come before OFFSET

10. **A** - ORDER BY col1 ASC, col2 DESC
    - Each column can have its own sort direction

11. **B** - At the beginning
    - With ASC, NULLs typically appear first; with DESC, they appear last

12. **B** - Always use ORDER BY with LIMIT for predictable results
    - Without ORDER BY, you get random rows each time

13. **C** - SELECT * FROM products ORDER BY price DESC LIMIT 5
    - Sort by price descending, then limit to top 5

14. **B** - Sorts by name ASC, then hire_date DESC
    - First column defaults to ASC, second is explicit DESC

15. **B** - OFFSET 40
    - Formula: (3 - 1) * 20 = 40

---

## Scoring

- **13-15 correct**: Excellent! You've mastered ORDER BY and LIMIT
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **ORDER BY sorts results** - By one or more columns

✅ **ASC is default** - Ascending order (lowest to highest)

✅ **DESC reverses order** - Descending (highest to lowest)

✅ **LIMIT restricts rows** - Returns only specified number

✅ **OFFSET skips rows** - Used for pagination

✅ **Always use ORDER BY with LIMIT** - For predictable results

✅ **Multiple columns** - Each can have different sort direction

✅ **Pagination formula** - OFFSET = (page - 1) * page_size

✅ **Syntax order** - LIMIT comes before OFFSET

✅ **NULL handling** - NULLs appear first with ASC, last with DESC
