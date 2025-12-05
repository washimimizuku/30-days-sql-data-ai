-- Day 5: GROUP BY - Solutions

-- Exercise 1: Count by department
SELECT department, COUNT(*) as employee_count
FROM employees
GROUP BY department;

-- Exercise 2: Average salary by department
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department;

-- Exercise 3: Total sales by product
SELECT product, SUM(amount) as total_sales
FROM sales
GROUP BY product;

-- Exercise 4: HAVING clause
SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;

-- Exercise 5: Multiple aggregations
SELECT 
    department,
    COUNT(*) as count,
    AVG(salary) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees
GROUP BY department;
