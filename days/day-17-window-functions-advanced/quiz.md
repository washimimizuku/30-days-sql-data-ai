# Day 17 Quiz: Window Functions - LAG, LEAD, Moving Averages

Test your understanding of advanced window functions!

---

## Questions

### 1. What does LAG() do?

- A) Accesses the next row in the result set
- B) Accesses the previous row in the result set
- C) Calculates the average of previous rows
- D) Sorts rows in descending order

### 2. What is the default offset for LAG() if not specified?

- A) 0
- B) 1
- C) 2
- D) NULL

### 3. What does LEAD() do?

- A) Accesses the previous row
- B) Accesses the next row
- C) Calculates a running total
- D) Finds the first value in a partition

### 4. How do you calculate a 7-day moving average?

- A) `AVG(value) OVER (ORDER BY date)`
- B) `AVG(value) OVER (ORDER BY date ROWS BETWEEN 7 PRECEDING AND CURRENT ROW)`
- C) `AVG(value) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`
- D) `SUM(value) OVER (ORDER BY date) / 7`

### 5. What does `ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING` create?

- A) A 2-row window
- B) A 4-row window
- C) A 5-row window (centered)
- D) A 3-row window

### 6. How do you calculate a running total?

- A) `SUM(value) OVER (ORDER BY date)`
- B) `LAG(value) OVER (ORDER BY date)`
- C) `AVG(value) OVER (ORDER BY date)`
- D) `COUNT(value) OVER (ORDER BY date)`

### 7. What does PARTITION BY do with LAG()?

- A) Filters rows before applying LAG
- B) Resets LAG within each group
- C) Sorts the results
- D) Calculates the average per partition

### 8. What is the correct way to use LAST_VALUE()?

- A) `LAST_VALUE(value) OVER (ORDER BY date)`
- B) `LAST_VALUE(value) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)`
- C) `LAST_VALUE(value) OVER (PARTITION BY category)`
- D) `LAST_VALUE(value) OVER ()`

### 9. How do you calculate percentage change from previous row?

- A) `(current - previous) / previous`
- B) `(current - previous) * 100.0 / previous`
- C) `(previous - current) * 100.0 / current`
- D) `current / previous * 100`

### 10. What does `LAG(value, 7)` return?

- A) The value from 7 rows ahead
- B) The value from 7 rows back
- C) The average of the last 7 rows
- D) The sum of the last 7 rows

### 11. What happens if LAG() references a row that doesn't exist?

- A) Returns 0
- B) Returns NULL (unless default specified)
- C) Throws an error
- D) Returns the current row's value

### 12. Which frame specification includes all rows from start to current?

- A) `ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING`
- B) `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`
- C) `ROWS BETWEEN 1 PRECEDING AND CURRENT ROW`
- D) `ROWS BETWEEN CURRENT ROW AND CURRENT ROW`

### 13. How do you identify a local peak (higher than both neighbors)?

- A) `value > LAG(value) AND value > LEAD(value)`
- B) `value > AVG(value) OVER ()`
- C) `value = MAX(value) OVER ()`
- D) `value > FIRST_VALUE(value)`

### 14. What does FIRST_VALUE() return?

- A) The first row in the entire table
- B) The first value in the window/partition
- C) The minimum value
- D) The most recent value

### 15. What is a common use case for LAG() with PARTITION BY customer_id?

- A) Calculate total sales per customer
- B) Find the customer's previous order
- C) Count orders per customer
- D) Sort customers by order date

---

## Answers

1. **B** - Accesses the previous row in the result set
   - LAG looks backward in the ordered result set

2. **B** - 1
   - Default offset is 1 (previous row)

3. **B** - Accesses the next row
   - LEAD looks forward in the ordered result set

4. **C** - `AVG(value) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`
   - 6 preceding + current = 7 rows total

5. **C** - A 5-row window (centered)
   - 2 before + current + 2 after = 5 rows

6. **A** - `SUM(value) OVER (ORDER BY date)`
   - Running total accumulates from start to current

7. **B** - Resets LAG within each group
   - Each partition gets its own LAG calculation

8. **B** - `LAST_VALUE(value) OVER (ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)`
   - LAST_VALUE needs explicit frame to work correctly

9. **B** - `(current - previous) * 100.0 / previous`
   - Standard percentage change formula

10. **B** - The value from 7 rows back
    - Offset of 7 means 7 rows previous

11. **B** - Returns NULL (unless default specified)
    - Can provide default value as third parameter

12. **B** - `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`
    - From start of partition to current row

13. **A** - `value > LAG(value) AND value > LEAD(value)`
    - Higher than both previous and next

14. **B** - The first value in the window/partition
    - First value according to ORDER BY

15. **B** - Find the customer's previous order
    - PARTITION BY customer_id isolates each customer's orders

---

## Scoring

- **13-15 correct**: Excellent! You've mastered advanced window functions
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **LAG()** - Access previous rows (look back)

✅ **LEAD()** - Access next rows (look forward)

✅ **Moving Average** - `AVG() OVER (... ROWS BETWEEN n PRECEDING AND CURRENT ROW)`

✅ **Running Total** - `SUM() OVER (ORDER BY date)`

✅ **PARTITION BY** - Resets window calculations per group

✅ **Frame Specification** - Controls which rows are included in window

✅ **FIRST_VALUE/LAST_VALUE** - Get first/last value in window

✅ **LAST_VALUE needs frame** - Must specify `UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`

✅ **Default values** - LAG/LEAD can specify default for missing rows

✅ **Time series analysis** - Perfect for trends, changes, patterns
