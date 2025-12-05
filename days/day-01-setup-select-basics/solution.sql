-- Day 1: Setup and SELECT Basics - Solutions

-- Exercise 1: Basic SELECT

-- Select all columns
SELECT * FROM employees;

-- Select only name and salary
SELECT name, salary FROM employees;

-- Select name, department, and hire_date
SELECT name, department, hire_date FROM employees;


-- Exercise 2: Column Aliases

SELECT 
    name AS employee_name,
    salary AS monthly_salary,
    salary * 12 AS annual_salary
FROM employees;


-- Exercise 3: Calculations

SELECT 
    name,
    salary,
    salary * 1.10 AS new_salary,
    salary * 0.10 AS raise_amount
FROM employees;

-- Alternative with ROUND for cleaner output
SELECT 
    name,
    salary,
    ROUND(salary * 1.10, 2) AS new_salary,
    ROUND(salary * 0.10, 2) AS raise_amount
FROM employees;


-- Exercise 4: DISTINCT

-- Get all unique departments
SELECT DISTINCT department FROM employees;

-- Get all unique cities
SELECT DISTINCT city FROM employees;

-- Get unique combinations of department and city
SELECT DISTINCT department, city FROM employees;
