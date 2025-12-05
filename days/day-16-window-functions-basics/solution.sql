-- Day 16: Window Functions - ROW_NUMBER, RANK, DENSE_RANK
-- Solutions

-- ============================================
-- Exercise 1: Basic ROW_NUMBER (5 min)
-- ============================================

-- 1.1: Assign row numbers to all employees ordered by salary (highest first)
SELECT 
    name,
    department,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
FROM employees
ORDER BY row_num;

-- 1.2: Assign row numbers ordered by hire_date (earliest first)
SELECT 
    name,
    hire_date,
    ROW_NUMBER() OVER (ORDER BY hire_date) as row_num
FROM employees
ORDER BY row_num;

-- 1.3: Assign row numbers ordered by name alphabetically
SELECT 
    name,
    ROW_NUMBER() OVER (ORDER BY name) as row_num
FROM employees
ORDER BY row_num;

-- 1.4: Number employees within each department (reset numbering per department)
SELECT 
    name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as dept_row_num
FROM employees
ORDER BY department, dept_row_num;


-- ============================================
-- Exercise 2: RANK vs DENSE_RANK (10 min)
-- ============================================

-- 2.1: Show the difference between ROW_NUMBER, RANK, and DENSE_RANK
SELECT 
    name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num,
    RANK() OVER (ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) as dense_rank
FROM employees
ORDER BY salary DESC;

-- 2.2: Rank employees by salary within each department
SELECT 
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
FROM employees
ORDER BY department, dept_rank;

-- 2.3: Find employees who share the same salary rank
WITH ranked_employees AS (
    SELECT 
        name,
        salary,
        RANK() OVER (ORDER BY salary DESC) as salary_rank
    FROM employees
)
SELECT 
    re1.name,
    re1.salary,
    re1.salary_rank
FROM ranked_employees re1
WHERE EXISTS (
    SELECT 1 
    FROM ranked_employees re2 
    WHERE re1.salary_rank = re2.salary_rank 
    AND re1.name != re2.name
)
ORDER BY salary_rank, name;


-- ============================================
-- Exercise 3: PARTITION BY Mastery (10 min)
-- ============================================

-- 3.1: Rank employees within each department by salary
SELECT 
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rank_in_dept
FROM employees
ORDER BY department, rank_in_dept;

-- 3.2: Assign row numbers to products within each category
SELECT 
    product_name,
    category,
    price,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as row_num
FROM products
ORDER BY category, row_num;

-- 3.3: Rank salespeople within each region by total sales
SELECT 
    salesperson_name,
    region,
    SUM(amount) as total_sales,
    RANK() OVER (PARTITION BY region ORDER BY SUM(amount) DESC) as region_rank
FROM sales
GROUP BY salesperson_name, region
ORDER BY region, region_rank;

-- 3.4: Number orders for each customer by order date (most recent = 1)
SELECT 
    customer_name,
    order_date,
    order_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_name ORDER BY order_date DESC) as order_number
FROM orders
ORDER BY customer_name, order_number;


-- ============================================
-- Exercise 4: Top N per Group (10 min)
-- ============================================

-- 4.1: Find the top 3 highest-paid employees in each department
WITH ranked_employees AS (
    SELECT 
        name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as rank_in_dept
    FROM employees
)
SELECT 
    name,
    department,
    salary,
    rank_in_dept
FROM ranked_employees
WHERE rank_in_dept <= 3
ORDER BY department, rank_in_dept;

-- 4.2: Find the top 2 best-selling products in each category
WITH product_rankings AS (
    SELECT 
        category,
        product_name,
        quantity_sold as total_quantity,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY quantity_sold DESC) as rank_in_category
    FROM products
)
SELECT 
    category,
    product_name,
    total_quantity,
    rank_in_category
FROM product_rankings
WHERE rank_in_category <= 2
ORDER BY category, rank_in_category;

-- 4.3: Get the 5 most recent orders for each customer
WITH recent_orders AS (
    SELECT 
        customer_name,
        order_date,
        order_amount,
        ROW_NUMBER() OVER (PARTITION BY customer_name ORDER BY order_date DESC) as order_rank
    FROM orders
)
SELECT 
    customer_name,
    order_date,
    order_amount,
    order_rank
FROM recent_orders
WHERE order_rank <= 5
ORDER BY customer_name, order_rank;

-- 4.4: Find the highest and lowest paid employee in each department
WITH salary_ranks AS (
    SELECT 
        name,
        department,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) as high_rank,
        RANK() OVER (PARTITION BY department ORDER BY salary ASC) as low_rank
    FROM employees
)
SELECT 
    name,
    department,
    salary,
    CASE 
        WHEN high_rank = 1 THEN 'Highest'
        WHEN low_rank = 1 THEN 'Lowest'
    END as position
FROM salary_ranks
WHERE high_rank = 1 OR low_rank = 1
ORDER BY department, salary DESC;


-- ============================================
-- Exercise 5: Advanced Patterns (5 min)
-- ============================================

-- 5.1: Divide employees into 4 salary quartiles
SELECT 
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary) as salary_quartile
FROM employees
ORDER BY salary_quartile, salary;

-- 5.2: Calculate the percentile rank of each employee's salary
SELECT 
    name,
    salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 4) as percentile_rank,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary) * 100, 2) as percentile_pct
FROM employees
ORDER BY salary DESC;

-- 5.3: Find duplicate emails and number each occurrence
SELECT 
    name,
    email,
    hire_date,
    ROW_NUMBER() OVER (PARTITION BY email ORDER BY hire_date) as occurrence_number
FROM employees
ORDER BY email, occurrence_number;

-- 5.4: Find gaps in order IDs
WITH expected_ids AS (
    SELECT 
        order_id,
        ROW_NUMBER() OVER (ORDER BY order_id) as expected_id
    FROM orders
),
id_range AS (
    SELECT 
        MIN(order_id) as min_id,
        MAX(order_id) as max_id
    FROM orders
),
all_ids AS (
    SELECT UNNEST(GENERATE_SERIES((SELECT min_id FROM id_range), (SELECT max_id FROM id_range))) as id
)
SELECT 
    ai.id as missing_order_id
FROM all_ids ai
LEFT JOIN orders o ON ai.id = o.order_id
WHERE o.order_id IS NULL
ORDER BY ai.id;

-- 5.5: Create a sales leaderboard showing all three ranking methods
SELECT 
    salesperson_name,
    SUM(amount) as total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) as row_num,
    RANK() OVER (ORDER BY SUM(amount) DESC) as rank,
    DENSE_RANK() OVER (ORDER BY SUM(amount) DESC) as dense_rank
FROM sales
GROUP BY salesperson_name
ORDER BY total_sales DESC;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Find the median salary for each department
WITH salary_ranks AS (
    SELECT 
        department,
        salary,
        NTILE(2) OVER (PARTITION BY department ORDER BY salary) as half
    FROM employees
)
SELECT 
    department,
    AVG(salary) as median_salary
FROM salary_ranks
WHERE half = 1
GROUP BY department
ORDER BY department;

-- Alternative approach using PERCENT_RANK
WITH percentile_ranks AS (
    SELECT 
        department,
        salary,
        PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) as pct_rank
    FROM employees
)
SELECT 
    department,
    AVG(salary) as median_salary
FROM percentile_ranks
WHERE pct_rank BETWEEN 0.4 AND 0.6
GROUP BY department
ORDER BY department;

-- BONUS 2: Identify the top 10% of earners in the company
WITH salary_percentiles AS (
    SELECT 
        name,
        department,
        salary,
        PERCENT_RANK() OVER (ORDER BY salary DESC) as percentile
    FROM employees
)
SELECT 
    name,
    department,
    salary,
    ROUND(percentile * 100, 2) as top_percentile
FROM salary_percentiles
WHERE percentile <= 0.10
ORDER BY salary DESC;

-- BONUS 3: Find employees whose salary is above their department average
WITH dept_averages AS (
    SELECT 
        name,
        department,
        salary,
        AVG(salary) OVER (PARTITION BY department) as dept_avg_salary
    FROM employees
)
SELECT 
    name,
    department,
    salary,
    ROUND(dept_avg_salary, 2) as dept_avg,
    ROUND(salary - dept_avg_salary, 2) as above_avg_by
FROM dept_averages
WHERE salary > dept_avg_salary
ORDER BY department, above_avg_by DESC;

-- BONUS 4: Create a running rank that resets each month
SELECT 
    order_date,
    order_amount,
    EXTRACT(YEAR FROM order_date) || '-' || LPAD(CAST(EXTRACT(MONTH FROM order_date) AS VARCHAR), 2, '0') as month,
    RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date) 
        ORDER BY order_amount DESC
    ) as rank_in_month
FROM orders
ORDER BY order_date, rank_in_month;
