# Day 19 Quiz: Date and Time Functions

Test your understanding of date and time functions!

---

## Questions

### 1. What is the difference between DATE and TIMESTAMP?

- A) They are the same
- B) DATE stores only the date (YYYY-MM-DD), TIMESTAMP stores date and time
- C) TIMESTAMP is faster
- D) DATE includes timezone information

### 2. How do you get the current date in SQL?

- A) `NOW()`
- B) `CURRENT_DATE`
- C) `TODAY()`
- D) `GET_DATE()`

### 3. What does `EXTRACT(YEAR FROM order_date)` return?

- A) The full date
- B) The year as a 4-digit number
- C) The year and month
- D) An error

### 4. What does `DATE_TRUNC('month', '2024-03-15')` return?

- A) `2024-03-15`
- B) `2024-03-01`
- C) `2024-01-01`
- D) `03`

### 5. How do you add 7 days to a date?

- A) `date + 7`
- B) `date + INTERVAL '7 days'`
- C) `ADD_DAYS(date, 7)`
- D) Both A and B work

### 6. What does `CURRENT_DATE - order_date` return?

- A) A date
- B) An integer (number of days)
- C) A timestamp
- D) An interval

### 7. How do you filter for orders from the last 30 days?

- A) `WHERE order_date > 30`
- B) `WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'`
- C) `WHERE order_date BETWEEN NOW() AND 30`
- D) `WHERE DAYS(order_date) < 30`

### 8. What does `EXTRACT(DOW FROM date)` return?

- A) Day of week as a name (Monday, Tuesday, etc.)
- B) Day of week as a number (0=Sunday, 6=Saturday)
- C) Day of month
- D) Day of year

### 9. Which function is best for grouping by month?

- A) `EXTRACT(MONTH FROM date)`
- B) `DATE_TRUNC('month', date)`
- C) `MONTH(date)`
- D) `GET_MONTH(date)`

### 10. How do you get orders from the current month?

- A) `WHERE EXTRACT(MONTH FROM order_date) = EXTRACT(MONTH FROM CURRENT_DATE)`
- B) `WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', CURRENT_DATE)`
- C) Both A and B work
- D) Neither works

### 11. What does `EXTRACT(QUARTER FROM date)` return?

- A) 1, 2, 3, or 4
- B) Q1, Q2, Q3, or Q4
- C) The month number
- D) The quarter start date

### 12. How do you calculate age from birth_date?

- A) `CURRENT_DATE - birth_date`
- B) `(CURRENT_DATE - birth_date) / 365`
- C) `AGE(birth_date)`
- D) Both B and C work

### 13. What's wrong with this: `WHERE order_date > '2024-01-01'`?

- A) Nothing wrong
- B) Should use DATE type: `WHERE order_date > DATE '2024-01-01'`
- C) Wrong comparison operator
- D) Missing parentheses

### 14. What does `DATE_TRUNC('week', date)` return?

- A) The week number
- B) The Monday of that week
- C) The Sunday of that week
- D) The day of week

### 15. How do you handle NULL dates in calculations?

- A) Ignore them
- B) Check with `WHERE date IS NOT NULL` before calculating
- C) Use COALESCE
- D) Both B and C work

---

## Answers

1. **B** - DATE stores only the date (YYYY-MM-DD), TIMESTAMP stores date and time
   - DATE: 2024-01-15, TIMESTAMP: 2024-01-15 14:30:00

2. **B** - `CURRENT_DATE`
   - NOW() returns timestamp, CURRENT_DATE returns date

3. **B** - The year as a 4-digit number
   - EXTRACT pulls out specific parts of dates

4. **B** - `2024-03-01`
   - DATE_TRUNC truncates to the start of the specified period

5. **D** - Both A and B work
   - Can add days directly or use INTERVAL

6. **B** - An integer (number of days)
   - Date subtraction returns the number of days between

7. **B** - `WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'`
   - Standard pattern for recent date filtering

8. **B** - Day of week as a number (0=Sunday, 6=Saturday)
   - DOW = Day Of Week, returns 0-6

9. **B** - `DATE_TRUNC('month', date)`
   - Better for grouping as it returns the month start date

10. **B** - `WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', CURRENT_DATE)`
    - Most reliable method, though A also works

11. **A** - 1, 2, 3, or 4
    - Returns quarter number as integer

12. **D** - Both B and C work
    - Division by 365 gives approximate years, AGE gives exact

13. **B** - Should use DATE type: `WHERE order_date > DATE '2024-01-01'`
    - Best practice to explicitly cast to DATE

14. **B** - The Monday of that week
    - Weeks start on Monday in DATE_TRUNC

15. **D** - Both B and C work
    - Always handle NULLs to avoid errors

---

## Scoring

- **13-15 correct**: Excellent! You've mastered date/time functions
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **DATE vs TIMESTAMP** - DATE is date only, TIMESTAMP includes time

✅ **CURRENT_DATE** - Gets today's date

✅ **EXTRACT** - Pulls out parts (YEAR, MONTH, DAY, QUARTER, DOW, etc.)

✅ **DATE_TRUNC** - Truncates to period start (year, month, week, day)

✅ **INTERVAL** - Add/subtract time periods (`+ INTERVAL '7 days'`)

✅ **Date arithmetic** - Subtraction returns days as integer

✅ **Filtering patterns** - Last N days, current month, date ranges

✅ **Grouping** - Use DATE_TRUNC for month/week/quarter grouping

✅ **Handle NULLs** - Always check for NULL dates

✅ **Use DATE type** - Not strings for date comparisons
