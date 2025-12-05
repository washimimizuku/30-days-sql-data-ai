# Day 7 Quiz: Multiple Aggregations

Test your understanding of combining multiple aggregate functions!

---

## Questions

### 1. What are multiple aggregations?

- A) Using the same aggregate function multiple times
- B) Using several aggregate functions (COUNT, SUM, AVG, MIN, MAX) in one query
- C) Aggregating multiple tables
- D) Using GROUP BY multiple times

### 2. Can you use COUNT, SUM, and AVG in the same SELECT statement?

- A) No, only one aggregate per query
- B) Yes, you can combine multiple aggregates
- C) Only with subqueries
- D) Only with HAVING clause

### 3. Which query calculates count, sum, and average for all products?

- A) SELECT COUNT(*), SUM(price), AVG(price) FROM products
- B) SELECT COUNT(price), SUM(price), AVG(price) FROM products GROUP BY price
- C) SELECT COUNT(*) + SUM(price) + AVG(price) FROM products
- D) SELECT AGGREGATE(COUNT, SUM, AVG) FROM products

### 4. What's required when using multiple aggregates with grouping?

- A) HAVING clause
- B) WHERE clause
- C) GROUP BY clause
- D) ORDER BY clause

### 5. Which query shows count, sum, and avg for each category?

- A) SELECT category, COUNT(*), SUM(price), AVG(price) FROM products
- B) SELECT category, COUNT(*), SUM(price), AVG(price) FROM products GROUP BY category
- C) SELECT COUNT(*), SUM(price), AVG(price) FROM products WHERE category
- D) SELECT category FROM products GROUP BY COUNT(*), SUM(price), AVG(price)

### 6. Can you aggregate different columns in the same query?

- A) No, all aggregates must use the same column
- B) Yes, each aggregate can use a different column
- C) Only with JOIN
- D) Only with subqueries

### 7. What does this query return: SELECT COUNT(*), COUNT(DISTINCT customer_id) FROM orders?

- A) Same value twice
- B) Total orders and number of unique customers
- C) An error
- D) Total orders and total customers

### 8. How do you count orders by status using CASE?

- A) SELECT COUNT(status) FROM orders
- B) SELECT COUNT(CASE WHEN status = 'completed' THEN 1 END) FROM orders
- C) SELECT COUNT(*) WHERE status = 'completed' FROM orders
- D) SELECT status, COUNT(*) FROM orders

### 9. What's the benefit of multiple aggregations?

- A) Faster queries
- B) Calculate multiple statistics in one query instead of separate queries
- C) Easier to write
- D) Uses less memory

### 10. Can you use MIN and MAX on different columns?

- A) No, they must use the same column
- B) Yes, MIN(price), MAX(stock) is valid
- C) Only with GROUP BY
- D) Only with HAVING

### 11. What's wrong with: SELECT category, name, COUNT(*), AVG(price) FROM products GROUP BY category?

- A) Nothing, it's correct
- B) name is not in GROUP BY or an aggregate function
- C) Too many aggregates
- D) Missing HAVING clause

### 12. Which calculates total revenue and average order value?

- A) SELECT SUM(total), AVG(total) FROM orders
- B) SELECT TOTAL(orders), AVERAGE(orders) FROM orders
- C) SELECT SUM(total) + AVG(total) FROM orders
- D) SELECT COUNT(*) * AVG(total) FROM orders

### 13. Can you use aggregate results in calculations?

- A) No, aggregates cannot be used in calculations
- B) Yes, like SUM(price * quantity) or MAX(salary) - MIN(salary)
- C) Only with subqueries
- D) Only with HAVING

### 14. What does SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) do?

- A) Counts completed orders
- B) Sums the total for completed orders only
- C) Returns an error
- D) Sums all orders

### 15. Which is a best practice for multiple aggregations?

- A) Use meaningful aliases for each aggregate
- B) Never use more than 3 aggregates
- C) Always use HAVING
- D) Avoid GROUP BY

---

## Answers

1. **B** - Using several aggregate functions (COUNT, SUM, AVG, MIN, MAX) in one query
   - Multiple aggregations means combining different aggregate functions

2. **B** - Yes, you can combine multiple aggregates
   - You can use as many aggregate functions as needed in one SELECT

3. **A** - SELECT COUNT(*), SUM(price), AVG(price) FROM products
   - Multiple aggregates without GROUP BY gives overall statistics

4. **C** - GROUP BY clause
   - When grouping data, GROUP BY is required with aggregates

5. **B** - SELECT category, COUNT(*), SUM(price), AVG(price) FROM products GROUP BY category
   - Group by category to get statistics for each category

6. **B** - Yes, each aggregate can use a different column
   - COUNT(*), SUM(price), AVG(quantity) is perfectly valid

7. **B** - Total orders and number of unique customers
   - COUNT(*) counts all rows, COUNT(DISTINCT col) counts unique values

8. **B** - SELECT COUNT(CASE WHEN status = 'completed' THEN 1 END) FROM orders
   - CASE with COUNT for conditional counting

9. **B** - Calculate multiple statistics in one query instead of separate queries
   - More efficient than running multiple queries

10. **B** - Yes, MIN(price), MAX(stock) is valid
    - Each aggregate can work on different columns

11. **B** - name is not in GROUP BY or an aggregate function
    - Every non-aggregated column must be in GROUP BY

12. **A** - SELECT SUM(total), AVG(total) FROM orders
    - SUM for total revenue, AVG for average order value

13. **B** - Yes, like SUM(price * quantity) or MAX(salary) - MIN(salary)
    - Can use expressions inside and with aggregates

14. **B** - Sums the total for completed orders only
    - CASE filters which rows to sum

15. **A** - Use meaningful aliases for each aggregate
    - Makes results readable: total_revenue, avg_price, etc.

---

## Scoring

- **13-15 correct**: Excellent! You've mastered multiple aggregations
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **Combine multiple aggregates** - COUNT, SUM, AVG, MIN, MAX in one query

✅ **Use with GROUP BY** - Get statistics for each group

✅ **Different columns** - Each aggregate can use different columns

✅ **Meaningful aliases** - Name aggregates clearly (total_revenue, avg_price)

✅ **Conditional aggregates** - Use CASE with COUNT/SUM for filtering

✅ **Calculations allowed** - SUM(price * quantity), MAX - MIN

✅ **More efficient** - One query instead of multiple queries

✅ **COUNT variations** - COUNT(*), COUNT(column), COUNT(DISTINCT column)

✅ **GROUP BY required** - When grouping data with aggregates

✅ **Build rich reports** - Multiple aggregations enable comprehensive analysis
