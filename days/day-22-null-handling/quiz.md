# Day 22 Quiz: NULL Handling and Data Manipulation

Test your understanding of NULL handling and DML operations!

---

## Questions

### 1. What does NULL represent in SQL?

- A) Zero
- B) Empty string
- C) Missing or unknown data
- D) False

### 2. How do you check if a column is NULL?

- A) WHERE column = NULL
- B) WHERE column IS NULL
- C) WHERE column == NULL
- D) WHERE NULL(column)

### 3. What does COALESCE(phone, email, 'None') return?

- A) Always 'None'
- B) The first non-NULL value from phone, email, or 'None'
- C) Concatenation of phone and email
- D) NULL if both are NULL

### 4. What does NULLIF(10, 10) return?

- A) 10
- B) 0
- C) NULL
- D) Error

### 5. What does COUNT(*) vs COUNT(column) do with NULL values?

- A) Both count NULL values
- B) Both ignore NULL values
- C) COUNT(*) counts all rows, COUNT(column) ignores NULL
- D) They're the same

### 6. What is the correct INSERT syntax?

- A) INSERT employees VALUES (1, 'John')
- B) INSERT INTO employees VALUES (1, 'John')
- C) INSERT employees SET id=1, name='John'
- D) ADD INTO employees VALUES (1, 'John')

### 7. What happens if you run UPDATE without WHERE clause?

- A) Error
- B) Updates only first row
- C) Updates ALL rows
- D) Nothing happens

### 8. How do you update multiple columns?

- A) UPDATE table SET col1=val1 AND col2=val2
- B) UPDATE table SET col1=val1, col2=val2
- C) UPDATE table col1=val1, col2=val2
- D) UPDATE table (col1, col2) VALUES (val1, val2)

### 9. What does DELETE FROM table; do?

- A) Deletes the table
- B) Deletes all rows in the table
- C) Deletes first row
- D) Error - needs WHERE clause

### 10. What is the purpose of BEGIN...COMMIT?

- A) Start a new database
- B) Group operations into a transaction
- C) Speed up queries
- D) Create a backup

### 11. What does ROLLBACK do?

- A) Deletes the database
- B) Undoes changes since BEGIN
- C) Commits changes
- D) Restarts the database

### 12. What does AVG() do with NULL values?

- A) Treats them as 0
- B) Ignores them
- C) Returns NULL
- D) Throws an error

### 13. How do you safely divide avoiding division by zero?

- A) value / 0
- B) value / NULLIF(divisor, 0)
- C) value / COALESCE(divisor, 1)
- D) Both B and C work

### 14. What's the best practice before running UPDATE/DELETE?

- A) Make a backup
- B) Test with SELECT first
- C) Use a transaction
- D) All of the above

### 15. How do you insert multiple rows at once?

- A) Multiple INSERT statements
- B) INSERT INTO table VALUES (row1), (row2), (row3)
- C) INSERT MULTIPLE INTO table
- D) Can't insert multiple rows at once

---

## Answers

1. **C** - Missing or unknown data
   - NULL is not zero, empty string, or false

2. **B** - WHERE column IS NULL
   - Never use = NULL, always use IS NULL

3. **B** - The first non-NULL value from phone, email, or 'None'
   - COALESCE returns first non-NULL argument

4. **C** - NULL
   - NULLIF returns NULL if both arguments are equal

5. **C** - COUNT(*) counts all rows, COUNT(column) ignores NULL
   - Important distinction for counting

6. **B** - INSERT INTO employees VALUES (1, 'John')
   - Standard INSERT syntax

7. **C** - Updates ALL rows
   - Always use WHERE clause unless intentional

8. **B** - UPDATE table SET col1=val1, col2=val2
   - Comma-separated column assignments

9. **B** - Deletes all rows in the table
   - Dangerous without WHERE clause!

10. **B** - Group operations into a transaction
    - Ensures atomicity of multiple operations

11. **B** - Undoes changes since BEGIN
    - Reverts all changes in the transaction

12. **B** - Ignores them
    - Most aggregates ignore NULL (except COUNT(*))

13. **B** - value / NULLIF(divisor, 0)
    - NULLIF returns NULL if divisor is 0, avoiding error

14. **D** - All of the above
    - Best practices for safe data manipulation

15. **B** - INSERT INTO table VALUES (row1), (row2), (row3)
    - Efficient way to insert multiple rows

---

## Scoring

- **13-15 correct**: Excellent! You've mastered NULL handling and DML
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **NULL** - Represents missing/unknown data

✅ **IS NULL / IS NOT NULL** - Check for NULL (never use = NULL)

✅ **COALESCE** - Return first non-NULL value

✅ **NULLIF** - Return NULL if values match (avoid division by zero)

✅ **INSERT** - Add new rows (single, multiple, or from SELECT)

✅ **UPDATE** - Modify existing rows (always use WHERE!)

✅ **DELETE** - Remove rows (always use WHERE!)

✅ **Transactions** - BEGIN...COMMIT for safe multi-step operations

✅ **Test first** - Use SELECT before UPDATE/DELETE

✅ **Aggregates** - Most ignore NULL except COUNT(*)
