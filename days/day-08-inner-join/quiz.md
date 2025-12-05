# Day 8 Quiz: INNER JOIN

Test your understanding of INNER JOIN!

---

## Questions

### 1. What does INNER JOIN do?

- A) Returns all rows from both tables
- B) Combines rows from two tables based on a matching condition
- C) Deletes matching rows
- D) Creates a new table

### 2. What does INNER JOIN return?

- A) All rows from the left table
- B) All rows from the right table
- C) Only rows with matches in BOTH tables
- D) All rows from both tables

### 3. Which is the correct INNER JOIN syntax?

- A) SELECT * FROM table1 INNER JOIN table2
- B) SELECT * FROM table1 INNER JOIN table2 ON table1.id = table2.id
- C) SELECT * FROM table1, table2 INNER JOIN
- D) SELECT * INNER JOIN table1 ON table2

### 4. What is the purpose of the ON clause?

- A) To filter results
- B) To specify the join condition
- C) To sort results
- D) To group results

### 5. Why use table aliases?

- A) Required by SQL
- B) Makes queries shorter and more readable
- C) Improves performance
- D) Prevents errors

### 6. Which query joins employees with departments?

- A) SELECT * FROM employees, departments
- B) SELECT * FROM employees INNER JOIN departments ON employees.department_id = departments.id
- C) SELECT * FROM employees WHERE department_id = departments.id
- D) SELECT * FROM employees JOIN departments

### 7. Can you join more than two tables?

- A) No, only two tables allowed
- B) Yes, by chaining multiple INNER JOINs
- C) Only with subqueries
- D) Only with UNION

### 8. What happens to rows without matches in INNER JOIN?

- A) They are included with NULL values
- B) They are excluded from results
- C) They cause an error
- D) They are duplicated

### 9. Which is correct for joining three tables?

- A) FROM t1 INNER JOIN t2 ON ... INNER JOIN t3 ON ...
- B) FROM t1, t2, t3 INNER JOIN
- C) FROM t1 INNER JOIN t2, t3 ON ...
- D) INNER JOIN t1, t2, t3

### 10. Can you use WHERE with INNER JOIN?

- A) No, they cannot be used together
- B) Yes, WHERE filters after joining
- C) Only with LEFT JOIN
- D) Only in subqueries

### 11. What's wrong with: SELECT id, name FROM employees e INNER JOIN departments d ON e.department_id = d.id?

- A) Nothing, it's correct
- B) 'id' is ambiguous - exists in both tables
- C) Missing WHERE clause
- D) Wrong JOIN syntax

### 12. Which query counts employees per department?

- A) SELECT department_name, COUNT(*) FROM employees INNER JOIN departments
- B) SELECT d.department_name, COUNT(e.id) FROM departments d INNER JOIN employees e ON d.id = e.department_id GROUP BY d.department_name
- C) SELECT COUNT(*) FROM employees, departments
- D) SELECT department_name FROM employees GROUP BY department_name

### 13. What does this return: SELECT * FROM orders o INNER JOIN customers c ON o.customer_id = c.id WHERE o.total > 1000?

- A) All orders
- B) All customers
- C) Orders over $1000 with customer information
- D) Customers who spent over $1000

### 14. When should you use INNER JOIN?

- A) When you need all rows from one table
- B) When you need only matching rows from both tables
- C) When you want to delete data
- D) When you want to update data

### 15. Which is a best practice for INNER JOIN?

- A) Always use SELECT *
- B) Use table aliases and qualify column names
- C) Never use WHERE clause
- D) Avoid GROUP BY

---

## Answers

1. **B** - Combines rows from two tables based on a matching condition
   - INNER JOIN merges related data from multiple tables

2. **C** - Only rows with matches in BOTH tables
   - If no match exists, the row is excluded

3. **B** - SELECT * FROM table1 INNER JOIN table2 ON table1.id = table2.id
   - ON clause specifies the join condition

4. **B** - To specify the join condition
   - ON defines how tables are related

5. **B** - Makes queries shorter and more readable
   - Aliases like 'e' for employees, 'd' for departments

6. **B** - SELECT * FROM employees INNER JOIN departments ON employees.department_id = departments.id
   - Proper INNER JOIN with ON clause

7. **B** - Yes, by chaining multiple INNER JOINs
   - Can join as many tables as needed

8. **B** - They are excluded from results
   - INNER JOIN only returns matches

9. **A** - FROM t1 INNER JOIN t2 ON ... INNER JOIN t3 ON ...
   - Chain joins with separate ON clauses

10. **B** - Yes, WHERE filters after joining
    - WHERE filters the joined results

11. **B** - 'id' is ambiguous - exists in both tables
    - Must qualify: e.id or d.id

12. **B** - SELECT d.department_name, COUNT(e.id) FROM departments d INNER JOIN employees e ON d.id = e.department_id GROUP BY d.department_name
    - Join, then group and count

13. **C** - Orders over $1000 with customer information
    - Joins orders with customers, then filters

14. **B** - When you need only matching rows from both tables
    - Most common join type for related data

15. **B** - Use table aliases and qualify column names
    - Makes queries clear and prevents ambiguity

---

## Scoring

- **13-15 correct**: Excellent! You've mastered INNER JOIN
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **INNER JOIN combines tables** - Based on matching condition

✅ **Returns only matches** - Rows must exist in BOTH tables

✅ **ON clause required** - Specifies join condition

✅ **Use table aliases** - Makes queries readable (e, d, p, c)

✅ **Qualify column names** - Use e.id, d.name to avoid ambiguity

✅ **Chain multiple joins** - Can join many tables

✅ **Combine with WHERE** - Filter after joining

✅ **Use with GROUP BY** - Aggregate joined data

✅ **Most common join** - Essential for relational databases

✅ **Index join columns** - Foreign keys should be indexed
