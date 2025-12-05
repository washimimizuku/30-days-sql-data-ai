# Day 26 Quiz: Transactions and ACID Properties

Test your understanding of transactions and ACID properties!

---

1. **What is a transaction in SQL?**
   - A) A single SQL query
   - B) A sequence of operations treated as a single unit of work
   - C) A type of table
   - D) A database backup

2. **Which command starts a transaction?**
   - A) START
   - B) BEGIN
   - C) TRANSACTION
   - D) INIT

3. **What does COMMIT do?**
   - A) Starts a transaction
   - B) Undoes all changes since BEGIN
   - C) Saves all changes permanently
   - D) Checks for errors

4. **What does ROLLBACK do?**
   - A) Saves changes
   - B) Undoes all changes since BEGIN
   - C) Starts a new transaction
   - D) Closes the database

5. **What does the 'A' in ACID stand for?**
   - A) Automatic
   - B) Atomicity
   - C) Accuracy
   - D) Authorization

6. **What does Atomicity mean?**
   - A) Transactions are fast
   - B) All operations succeed or all fail (no partial completion)
   - C) Data is stored in atoms
   - D) Only one transaction at a time

7. **What does the 'C' in ACID stand for?**
   - A) Consistency
   - B) Concurrency
   - C) Completion
   - D) Correctness

8. **What does Consistency ensure?**
   - A) Fast query execution
   - B) Database moves from one valid state to another
   - C) All transactions complete
   - D) Data is never deleted

9. **What does the 'I' in ACID stand for?**
   - A) Integration
   - B) Isolation
   - C) Implementation
   - D) Initialization

10. **What does Isolation mean?**
    - A) Transactions run faster
    - B) Concurrent transactions don't interfere with each other
    - C) Database is locked during transactions
    - D) Only one user can access the database

11. **What does the 'D' in ACID stand for?**
    - A) Deletion
    - B) Durability
    - C) Distribution
    - D) Documentation

12. **What does Durability ensure?**
    - A) Transactions are fast
    - B) Once committed, changes survive system failures
    - C) Data is never lost
    - D) Backups are automatic

13. **When should you use a transaction?**
    - A) For every single query
    - B) For multi-step operations that must be atomic
    - C) Only for SELECT queries
    - D) Never, they slow down the database

14. **What happens if an error occurs during a transaction?**
    - A) Only the failed operation is undone
    - B) The entire transaction should be rolled back
    - C) The database crashes
    - D) Nothing, errors are ignored

15. **Which is a good practice for transactions?**
    - A) Keep transactions as long as possible
    - B) Never verify changes before committing
    - C) Keep transactions short and verify before COMMIT
    - D) Use transactions for all SELECT queries

---

## Answers

1. **B** - A sequence of operations treated as a single unit of work
2. **B** - BEGIN
3. **C** - Saves all changes permanently
4. **B** - Undoes all changes since BEGIN
5. **B** - Atomicity
6. **B** - All operations succeed or all fail (no partial completion)
7. **A** - Consistency
8. **B** - Database moves from one valid state to another
9. **B** - Isolation
10. **B** - Concurrent transactions don't interfere with each other
11. **B** - Durability
12. **B** - Once committed, changes survive system failures
13. **B** - For multi-step operations that must be atomic
14. **B** - The entire transaction should be rolled back
15. **C** - Keep transactions short and verify before COMMIT
