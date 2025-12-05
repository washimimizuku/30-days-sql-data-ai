# Day 9 Quiz: LEFT and RIGHT JOIN

Test your understanding of outer joins!

---

## Questions

### 1. What does LEFT JOIN return?

- A) Only matching rows from both tables
- B) All rows from left table, matching rows from right table (NULL if no match)
- C) All rows from right table only
- D) All rows from both tables

### 2. How do you find customers who never placed an order?

- A) INNER JOIN customers with orders
- B) LEFT JOIN customers to orders WHERE orders.id IS NULL
- C) RIGHT JOIN customers to orders
- D) FULL OUTER JOIN

### 3. What happens to right table columns when there's no match in LEFT JOIN?

- A) Row is excluded
- B) Returns empty string
- C) Returns NULL
- D) Returns 0

### 4. Which is correct for finding products never sold?

- A) SELECT * FROM products INNER JOIN order_items
- B) SELECT * FROM products LEFT JOIN order_items ON ... WHERE order_items.id IS NULL
- C) SELECT * FROM products WHERE id NOT IN order_items
- D) SELECT * FROM products RIGHT JOIN order_items

### 5. What's the difference between LEFT JOIN and INNER JOIN?

- A) No difference
- B) LEFT JOIN includes all left table rows, INNER JOIN only matches
- C) LEFT JOIN is faster
- D) INNER JOIN includes all rows

### 6. How do you show 0 instead of NULL for customers with no orders?

- A) COALESCE(COUNT(orders.id), 0)
- B) IFNULL(orders.id, 0)
- C) NVL(orders.id, 0)
- D) COUNT(orders.id) returns 0 automatically

### 7. What does RIGHT JOIN return?

- A) All rows from left table
- B) All rows from right table, matching rows from left table (NULL if no match)
- C) Only matching rows
- D) All rows from both tables

### 8. Which is more commonly used?

- A) RIGHT JOIN
- B) LEFT JOIN
- C) Both equally
- D) Neither, use INNER JOIN

### 9. How do you find departments without employees?

- A) LEFT JOIN departments to employees WHERE employees.id IS NULL
- B) RIGHT JOIN employees to departments WHERE employees.id IS NULL
- C) INNER JOIN departments with employees
- D) Both A and B are correct

### 10. Can you chain multiple LEFT JOINs?

- A) No, only one LEFT JOIN allowed
- B) Yes, you can chain multiple LEFT JOINs
- C) Only with subqueries
- D) Only with UNION

### 11. What does this return: SELECT c.name, COUNT(o.id) FROM customers c LEFT JOIN orders o ON c.id = o.customer_id GROUP BY c.name?

- A) Only customers with orders
- B) All customers with their order count (0 for customers without orders)
- C) Only customers without orders
- D) An error

### 12. When should you use LEFT JOIN?

- A) When you need only matching rows
- B) When you need all rows from one table regardless of matches
- C) When you want to delete data
- D) When you want to update data

### 13. What's wrong with: SELECT * FROM customers c LEFT JOIN orders o WHERE o.total > 100?

- A) Nothing, it's correct
- B) Missing ON clause
- C) Should use INNER JOIN
- D) Cannot use WHERE with LEFT JOIN

### 14. How do you convert NULL to "No Department" in results?

- A) COALESCE(department_name, 'No Department')
- B) IFNULL(department_name, 'No Department')
- C) NVL(department_name, 'No Department')
- D) All of the above (depending on database)

### 15. Which query finds all products (with or without sales)?

- A) SELECT * FROM products INNER JOIN order_items
- B) SELECT * FROM products LEFT JOIN order_items ON products.id = order_items.product_id
- C) SELECT * FROM products WHERE id IN order_items
- D) SELECT * FROM products RIGHT JOIN order_items

---

## Answers

1. **B** - All rows from left table, matching rows from right table (NULL if no match)
2. **B** - LEFT JOIN customers to orders WHERE orders.id IS NULL
3. **C** - Returns NULL
4. **B** - SELECT * FROM products LEFT JOIN order_items ON ... WHERE order_items.id IS NULL
5. **B** - LEFT JOIN includes all left table rows, INNER JOIN only matches
6. **A** - COALESCE(COUNT(orders.id), 0) or just COUNT(orders.id) which returns 0
7. **B** - All rows from right table, matching rows from left table (NULL if no match)
8. **B** - LEFT JOIN (more intuitive and commonly used)
9. **D** - Both A and B are correct
10. **B** - Yes, you can chain multiple LEFT JOINs
11. **B** - All customers with their order count (0 for customers without orders)
12. **B** - When you need all rows from one table regardless of matches
13. **B** - Missing ON clause
14. **D** - All of the above (COALESCE is most portable)
15. **B** - SELECT * FROM products LEFT JOIN order_items ON products.id = order_items.product_id

---

## Scoring

- **13-15 correct**: Excellent! You've mastered LEFT and RIGHT JOIN
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more
- **Below 7**: Review the theory section

---

## Key Takeaways

✅ **LEFT JOIN keeps all left rows** - Matching right data or NULL

✅ **Find unmatched records** - LEFT JOIN with WHERE right.id IS NULL

✅ **RIGHT JOIN keeps all right rows** - Less common than LEFT JOIN

✅ **NULL handling** - Use COALESCE for defaults

✅ **Perfect for reporting** - Include all records even without relationships

✅ **Use with aggregates** - COUNT, SUM work great with LEFT JOIN

✅ **Chain multiple LEFT JOINs** - For complex queries

✅ **More common than INNER JOIN** - For analytical queries

✅ **Essential for finding gaps** - Missing data, inactive records

✅ **Always consider NULLs** - Critical in outer joins
