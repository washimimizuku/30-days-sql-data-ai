# Day 25 Quiz: Query Optimization

Test your understanding of query optimization techniques!

---

1. **What is the correct SQL query execution order?**
   - A) SELECT, FROM, WHERE, GROUP BY, ORDER BY
   - B) FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY
   - C) WHERE, FROM, SELECT, GROUP BY, ORDER BY
   - D) FROM, SELECT, WHERE, GROUP BY, ORDER BY

2. **What does the EXPLAIN command show?**
   - A) The query results
   - B) The query execution plan
   - C) Syntax errors in the query
   - D) The database schema

3. **Which is more efficient for filtering?**
   - A) HAVING customer_id = 100
   - B) WHERE customer_id = 100
   - C) Both are equally efficient
   - D) It depends on the database size

4. **Why should you avoid SELECT *?**
   - A) It's a syntax error
   - B) It transfers unnecessary data
   - C) It doesn't work with JOINs
   - D) It's deprecated in modern SQL

5. **Which is generally faster for existence checks?**
   - A) IN (SELECT ...)
   - B) EXISTS (SELECT 1 ...)
   - C) Both are equally fast
   - D) JOIN is always faster

6. **Why doesn't this query use an index on order_date: `WHERE YEAR(order_date) = 2024`?**
   - A) YEAR is not a valid function
   - B) Functions on indexed columns prevent index usage
   - C) The index is corrupted
   - D) You need a special function index

7. **What's the difference between UNION and UNION ALL?**
   - A) UNION removes duplicates, UNION ALL keeps them
   - B) UNION ALL removes duplicates, UNION keeps them
   - C) They are identical
   - D) UNION ALL only works with two queries

8. **What is a correlated subquery?**
   - A) A subquery that runs once
   - B) A subquery that references the outer query and runs for each row
   - C) A subquery with multiple SELECT statements
   - D) A subquery that uses UNION

9. **What is the N+1 query problem?**
   - A) Running N queries when 1 would suffice
   - B) A syntax error with N+1 in the query
   - C) Running 1 query N+1 times
   - D) A mathematical calculation in SQL

10. **Which optimization technique reduces rows processed earliest?**
    - A) Using LIMIT
    - B) Using WHERE before GROUP BY
    - C) Using ORDER BY
    - D) Using DISTINCT

11. **What is a CTE (Common Table Expression)?**
    - A) A temporary named result set using WITH
    - B) A type of index
    - C) A database constraint
    - D) A join type

12. **Why is batching operations better than row-by-row?**
    - A) It's easier to write
    - B) It reduces the number of database round trips
    - C) It uses less memory
    - D) It's required by SQL standards

13. **What does EXPLAIN ANALYZE show that EXPLAIN doesn't?**
    - A) Syntax errors
    - B) Actual execution time and statistics
    - C) Database schema
    - D) Query results

14. **Which query is better optimized?**
    - A) SELECT * FROM orders WHERE customer_id = '123'
    - B) SELECT * FROM orders WHERE customer_id = 123
    - C) Both are equally optimized
    - D) Neither will work

15. **What is the main benefit of using LIMIT?**
    - A) It makes queries easier to read
    - B) It stops processing after the specified number of rows
    - C) It improves sorting performance
    - D) It's required for pagination

---

## Answers

1. **B** - FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY
2. **B** - The query execution plan
3. **B** - WHERE customer_id = 100 (filters before grouping)
4. **B** - It transfers unnecessary data
5. **B** - EXISTS (stops at first match per row)
6. **B** - Functions on indexed columns prevent index usage
7. **A** - UNION removes duplicates, UNION ALL keeps them
8. **B** - A subquery that references the outer query and runs for each row
9. **A** - Running N queries when 1 would suffice (e.g., 1 query + N queries in loop)
10. **B** - Using WHERE before GROUP BY (filters earliest in execution)
11. **A** - A temporary named result set using WITH
12. **B** - It reduces the number of database round trips
13. **B** - Actual execution time and statistics
14. **B** - customer_id = 123 (correct type, no implicit conversion)
15. **B** - It stops processing after the specified number of rows
