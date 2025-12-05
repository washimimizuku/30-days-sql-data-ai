# Day 12 Quiz: Self Joins

## Instructions
Answer all 15 questions. Check your answers at the bottom.

---

### 1. What is a self join?
   - A) Joining two different tables
   - B) Joining a table to itself using different aliases
   - C) A special type of INNER JOIN
   - D) Joining without a condition

### 2. Why must you use different aliases in a self join?
   - A) To make the query faster
   - B) To distinguish between the two "copies" of the same table
   - C) It's optional but recommended
   - D) To avoid syntax errors only

### 3. What is the most common use case for self joins?
   - A) Calculating totals
   - B) Hierarchical data like employee-manager relationships
   - C) Filtering data
   - D) Sorting results

### 4. Which query shows employees with their managers?
   - A) `SELECT * FROM employees e JOIN employees m ON e.id = m.id`
   - B) `SELECT * FROM employees e JOIN employees m ON e.manager_id = m.id`
   - C) `SELECT * FROM employees e JOIN managers m ON e.manager_id = m.id`
   - D) `SELECT * FROM employees WHERE manager_id IS NOT NULL`

### 5. Why use LEFT JOIN instead of INNER JOIN for employee-manager queries?
   - A) LEFT JOIN is faster
   - B) To include employees without managers (like the CEO)
   - C) INNER JOIN doesn't work with self joins
   - D) There's no difference

### 6. How do you avoid self-matches in a self join?
   - A) Use DISTINCT
   - B) Use WHERE t1.id != t2.id
   - C) Use GROUP BY
   - D) Use LIMIT

### 7. How do you avoid duplicate pairs like (A,B) and (B,A)?
   - A) Use WHERE t1.id != t2.id
   - B) Use WHERE t1.id < t2.id
   - C) Use DISTINCT
   - D) Use GROUP BY

### 8. What does this query find?
```sql
SELECT e.name, m.name
FROM employees e
JOIN employees m ON e.manager_id = m.id
WHERE e.salary > m.salary;
```
   - A) All employees and their managers
   - B) Employees earning more than their manager
   - C) Managers with high salaries
   - D) Employees without managers

### 9. What does this query do?
```sql
SELECT p1.name, p2.name
FROM products p1
JOIN products p2 ON p1.category = p2.category
WHERE p1.id < p2.id;
```
   - A) Find all products
   - B) Find duplicate products
   - C) Find pairs of products in the same category
   - D) Find products without categories

### 10. How do you find products bought together in the same order?
   - A) Self join on order_items matching order_id
   - B) Self join on products matching category
   - C) Join orders to products
   - D) Use GROUP BY on products

### 11. What is this query finding?
```sql
SELECT o1.id, o2.id, o2.order_date - o1.order_date as days
FROM orders o1
JOIN orders o2 ON o1.customer_id = o2.customer_id
WHERE o2.order_date > o1.order_date;
```
   - A) All orders
   - B) Consecutive orders from the same customer
   - C) Orders on the same date
   - D) Cancelled orders

### 12. When comparing each employee's salary to their department average, what do you need?
   - A) Self join on department_id with GROUP BY
   - B) Simple GROUP BY
   - C) Window function only
   - D) Subquery only

### 13. What's a performance consideration with self joins?
   - A) They're always fast
   - B) They can be expensive on large tables
   - C) They only work on small tables
   - D) They require special indexes

### 14. Which is NOT a common self join use case?
   - A) Hierarchical data (org charts)
   - B) Finding similar records (same category)
   - C) Sequence analysis (consecutive orders)
   - D) Calculating simple totals

### 15. What should you index for employee-manager self joins?
   - A) The name column
   - B) The manager_id column
   - C) The salary column
   - D) All columns

---

## Answers

1. **B** - Joining a table to itself using different aliases
   - Self join means joining a table to itself, requiring different aliases to distinguish the "copies"

2. **B** - To distinguish between the two "copies" of the same table
   - Aliases are required to tell which "copy" of the table you're referring to

3. **B** - Hierarchical data like employee-manager relationships
   - The classic use case is when a table has relationships within itself

4. **B** - `SELECT * FROM employees e JOIN employees m ON e.manager_id = m.id`
   - Join where employee's manager_id matches manager's id

5. **B** - To include employees without managers (like the CEO)
   - LEFT JOIN includes rows from the left table even when there's no match

6. **B** - Use WHERE t1.id != t2.id
   - This prevents matching a row to itself

7. **B** - Use WHERE t1.id < t2.id
   - Using < instead of != ensures you only get one direction of the pair

8. **B** - Employees earning more than their manager
   - Self join with WHERE clause comparing salaries

9. **C** - Find pairs of products in the same category
   - Self join on category with id < id to avoid duplicates

10. **A** - Self join on order_items matching order_id
    - Join order_items to itself where order_id matches but product_id differs

11. **B** - Consecutive orders from the same customer
    - Self join on customer_id where second date is after first date

12. **A** - Self join on department_id with GROUP BY
    - Need to join employees to themselves on department and aggregate

13. **B** - They can be expensive on large tables
    - Self joins can be slow on large tables, especially without proper indexes

14. **D** - Calculating simple totals
    - Simple aggregations don't need self joins

15. **B** - The manager_id column
    - Index the foreign key column used in the join condition

---

## Scoring
- 13-15 correct: Excellent! You understand self joins well.
- 10-12 correct: Good! Review the concepts you missed.
- 7-9 correct: Fair. Review the theory and practice more exercises.
- Below 7: Review the theory section and try the exercises again.
