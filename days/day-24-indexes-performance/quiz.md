# Day 24 Quiz: Indexes and Performance

Test your understanding of indexes and query optimization!

---

1. **What is the primary purpose of a database index?**
   - A) To enforce data integrity
   - B) To speed up data retrieval operations
   - C) To reduce storage space
   - D) To automatically update data

2. **What happens when you create an index on a table?**
   - A) Queries become faster but writes become slower
   - B) Both queries and writes become faster
   - C) The table size decreases
   - D) All queries automatically use the index

3. **Which columns are good candidates for indexing?**
   - A) Columns with few unique values (low cardinality)
   - B) Columns that are rarely queried
   - C) Columns frequently used in WHERE, JOIN, and ORDER BY clauses
   - D) All columns in every table

4. **What is a composite index?**
   - A) An index that combines multiple tables
   - B) An index on multiple columns
   - C) An index that uses compression
   - D) An index that stores computed values

5. **In a composite index on (customer_id, order_date), which query can use the index efficiently?**
   - A) WHERE order_date = '2024-01-01'
   - B) WHERE customer_id = 100
   - C) WHERE order_date > '2024-01-01' AND customer_id = 100
   - D) Both B and C

6. **What does the EXPLAIN command do?**
   - A) Executes a query and returns results
   - B) Shows the query execution plan
   - C) Creates an index automatically
   - D) Fixes slow queries

7. **Why doesn't this query use an index on order_date: `WHERE YEAR(order_date) = 2024`?**
   - A) The syntax is incorrect
   - B) Functions on indexed columns prevent index usage
   - C) YEAR is not a valid function
   - D) The index is corrupted

8. **What is a covering index?**
   - A) An index that covers all tables in a database
   - B) An index that includes all columns needed by a query
   - C) An index that is hidden from users
   - D) An index that automatically updates

9. **Which query pattern can use an index on the email column?**
   - A) WHERE email LIKE '%@gmail.com'
   - B) WHERE email LIKE '%john%'
   - C) WHERE email LIKE 'john%'
   - D) WHERE LOWER(email) = 'john@example.com'

10. **What is the trade-off of having many indexes on a table?**
    - A) Faster reads, slower writes
    - B) Slower reads, faster writes
    - C) More storage, less CPU usage
    - D) No trade-offs, more indexes are always better

11. **What does cardinality mean in the context of indexes?**
    - A) The size of the index in bytes
    - B) The number of unique values in a column
    - C) The number of indexes on a table
    - D) The speed of index lookups

12. **Which index type enforces uniqueness?**
    - A) B-Tree index
    - B) Composite index
    - C) Unique index
    - D) Covering index

13. **When might a full table scan be faster than using an index?**
    - A) Never, indexes are always faster
    - B) When the table is very small
    - C) When selecting most rows from the table
    - D) Both B and C

14. **What is the correct order for columns in a composite index?**
    - A) Alphabetical order
    - B) Most selective (highest cardinality) first
    - C) Least selective first
    - D) Order doesn't matter

15. **Which statement about indexes is FALSE?**
    - A) Indexes speed up SELECT queries
    - B) Indexes slow down INSERT, UPDATE, and DELETE operations
    - C) Every column should have an index
    - D) Indexes require additional storage space

---

## Answers

1. **B** - To speed up data retrieval operations
2. **A** - Queries become faster but writes become slower
3. **C** - Columns frequently used in WHERE, JOIN, and ORDER BY clauses
4. **B** - An index on multiple columns
5. **D** - Both B and C (can use first column alone or both columns)
6. **B** - Shows the query execution plan
7. **B** - Functions on indexed columns prevent index usage
8. **B** - An index that includes all columns needed by a query
9. **C** - WHERE email LIKE 'john%' (no leading wildcard)
10. **A** - Faster reads, slower writes
11. **B** - The number of unique values in a column
12. **C** - Unique index
13. **D** - Both B and C (small tables or selecting most rows)
14. **B** - Most selective (highest cardinality) first
15. **C** - Every column should have an index (FALSE - over-indexing is bad)
