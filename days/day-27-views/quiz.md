# Day 27 Quiz: Views

Test your understanding of SQL views!

---

1. **What is a view in SQL?**
   - A) A physical table that stores data
   - B) A virtual table based on a SELECT query
   - C) A type of index
   - D) A database backup

2. **What command creates a view?**
   - A) MAKE VIEW
   - B) CREATE VIEW
   - C) NEW VIEW
   - D) BUILD VIEW

3. **Do views store data?**
   - A) Yes, they store a copy of the data
   - B) No, they run the query each time
   - C) Only if the view has aggregations
   - D) Only for simple views

4. **How do you query a view?**
   - A) Using special VIEW syntax
   - B) Just like a regular table with SELECT
   - C) Views cannot be queried
   - D) Only with stored procedures

5. **What is a benefit of using views?**
   - A) They make queries slower
   - B) They simplify complex queries and improve reusability
   - C) They require more storage space
   - D) They prevent data updates

6. **Which command updates an existing view?**
   - A) UPDATE VIEW
   - B) ALTER VIEW
   - C) CREATE OR REPLACE VIEW
   - D) MODIFY VIEW

7. **How do you remove a view?**
   - A) DELETE VIEW
   - B) REMOVE VIEW
   - C) DROP VIEW
   - D) DESTROY VIEW

8. **Can views hide sensitive columns?**
   - A) No, views must include all columns
   - B) Yes, views can exclude sensitive columns for security
   - C) Only with special permissions
   - D) Only in production databases

9. **Can you create a view with JOINs?**
   - A) No, views can only query single tables
   - B) Yes, views can include JOINs
   - C) Only INNER JOINs
   - D) Only with two tables maximum

10. **Can you create a view with GROUP BY?**
    - A) No, aggregations are not allowed in views
    - B) Yes, views can include GROUP BY and aggregations
    - C) Only COUNT() is allowed
    - D) Only without HAVING clause

11. **What happens when you query a view?**
    - A) It retrieves stored data from the view
    - B) It executes the underlying SELECT query
    - C) It creates a temporary table
    - D) It locks the database

12. **Can you update data through a view?**
    - A) Yes, always
    - B) Usually no, views are typically read-only
    - C) Only for simple views
    - D) Only with special syntax

13. **What is a good use case for views?**
    - A) Storing large amounts of data
    - B) Simplifying frequently used complex queries
    - C) Replacing all tables
    - D) Improving write performance

14. **What does DROP VIEW IF EXISTS do?**
    - A) Drops the view and shows an error if it doesn't exist
    - B) Drops the view without error if it doesn't exist
    - C) Checks if the view exists but doesn't drop it
    - D) Drops all views in the database

15. **Which is a best practice for views?**
    - A) Create views for every possible query
    - B) Use views to simplify common queries and hide sensitive data
    - C) Never use views, they're too slow
    - D) Always include all columns from all tables

---

## Answers

1. **B** - A virtual table based on a SELECT query
2. **B** - CREATE VIEW
3. **B** - No, they run the query each time
4. **B** - Just like a regular table with SELECT
5. **B** - They simplify complex queries and improve reusability
6. **C** - CREATE OR REPLACE VIEW
7. **C** - DROP VIEW
8. **B** - Yes, views can exclude sensitive columns for security
9. **B** - Yes, views can include JOINs
10. **B** - Yes, views can include GROUP BY and aggregations
11. **B** - It executes the underlying SELECT query
12. **B** - Usually no, views are typically read-only
13. **B** - Simplifying frequently used complex queries
14. **B** - Drops the view without error if it doesn't exist
15. **B** - Use views to simplify common queries and hide sensitive data
