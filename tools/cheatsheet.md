# SQL Quick Reference Cheatsheet

## Basic SELECT
```sql
SELECT column1, column2 FROM table;
SELECT * FROM table;
SELECT DISTINCT column FROM table;
```

## WHERE Clause
```sql
SELECT * FROM users WHERE age > 18;
SELECT * FROM users WHERE name = 'Alice';
SELECT * FROM users WHERE age BETWEEN 18 AND 65;
SELECT * FROM users WHERE city IN ('NYC', 'LA');
SELECT * FROM users WHERE name LIKE 'A%';
```

## ORDER BY & LIMIT
```sql
SELECT * FROM users ORDER BY age DESC;
SELECT * FROM users ORDER BY age ASC LIMIT 10;
```

## Aggregate Functions
```sql
SELECT COUNT(*) FROM users;
SELECT AVG(age) FROM users;
SELECT SUM(amount) FROM sales;
SELECT MIN(price), MAX(price) FROM products;
```

## GROUP BY
```sql
SELECT city, COUNT(*) FROM users GROUP BY city;
SELECT city, AVG(age) FROM users GROUP BY city HAVING AVG(age) > 30;
```

## JOINs
```sql
-- INNER JOIN
SELECT * FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;

-- LEFT JOIN
SELECT * FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;
```

## Window Functions
```sql
SELECT name, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) as rank
FROM employees;
```

## CTEs
```sql
WITH high_earners AS (
    SELECT * FROM employees WHERE salary > 100000
)
SELECT * FROM high_earners;
```
