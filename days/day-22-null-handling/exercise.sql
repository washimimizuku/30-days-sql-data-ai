-- Day 22: NULL Handling and Data Manipulation
-- Practice exercises

-- ============================================
-- Part 1: NULL Handling (10 min)
-- ============================================

-- 1.1: Find all employees with NULL email addresses
-- TODO: Write your query


-- 1.2: Find all employees with NULL phone OR NULL email
-- TODO: Write your query


-- 1.3: Use COALESCE to provide 'No contact' for NULL phones
-- TODO: Write your query
-- Expected columns: employee_id, name, phone_or_default


-- 1.4: Use COALESCE to show phone, email, or 'No contact' (first available)
-- TODO: Write your query
-- Expected columns: employee_id, name, contact_method


-- 1.5: Find products with NULL descriptions
-- TODO: Write your query


-- 1.6: Use COALESCE to provide default 'No description' for NULL descriptions
-- TODO: Write your query


-- 1.7: Calculate total compensation (salary + bonus), handling NULL bonuses
-- TODO: Write your query
-- Expected columns: employee_id, name, salary, bonus, total_comp


-- 1.8: Use NULLIF to avoid division by zero
-- TODO: Write your query on products table
-- Calculate price per unit in stock (price / stock_quantity)
-- Expected columns: product_id, product_name, price, stock_quantity, price_per_unit


-- 1.9: Count total employees vs employees with email
-- TODO: Write your query
-- Expected columns: total_employees, employees_with_email


-- 1.10: Calculate average salary (NULL salaries should be ignored)
-- TODO: Write your query


-- ============================================
-- Part 2: INSERT Operations (10 min)
-- ============================================

-- 2.1: Insert a new employee with all fields
-- TODO: Write your query
-- employee_id: 11, name: 'New Employee', email: 'new@company.com', phone: '555-0000'
-- department: 'IT', salary: 70000, bonus: 3000, hire_date: '2024-12-01', is_active: TRUE


-- 2.2: Insert 3 new products in one statement
-- TODO: Write your query
-- Product 11: 'Mouse Pad', 'Electronics', 'Gaming mouse pad', 19.99, 100, 1
-- Product 12: 'Pen Set', 'Office', NULL, 9.99, 200, 3
-- Product 13: 'Notebook', 'Office', 'Spiral notebook', NULL, 150, 3


-- 2.3: Insert high-salary employees (salary > 85000) into a new table
-- TODO: First create the table, then insert
-- CREATE TABLE high_earners AS SELECT * FROM employees WHERE 1=0;
-- Then INSERT INTO high_earners SELECT ...


-- 2.4: Insert a summary of employees by department
-- TODO: Create and populate dept_summary table
-- CREATE TABLE dept_summary (department VARCHAR, emp_count INTEGER, avg_salary DECIMAL(10,2));
-- Then INSERT department, COUNT(*), AVG(salary) grouped by department


-- ============================================
-- Part 3: UPDATE Operations (10 min)
-- ============================================

-- 3.1: Update salary for employee_id = 4 to 95000
-- TODO: Write your query


-- 3.2: Give 10% raise to all employees in Engineering department
-- TODO: Write your query


-- 3.3: Update NULL emails to 'noemail@company.com'
-- TODO: Write your query


-- 3.4: Update NULL bonuses to 0
-- TODO: Write your query


-- 3.5: Give different raises by department using CASE
-- TODO: Write your query
-- Engineering: 15%, Sales: 12%, Marketing: 10%, Others: 5%


-- 3.6: Set is_active to FALSE for employees with NULL department
-- TODO: Write your query


-- 3.7: Update product prices: increase by 10% for Electronics, 5% for others
-- TODO: Write your query


-- ============================================
-- Part 4: DELETE Operations (5 min)
-- ============================================

-- 4.1: Delete employee with employee_id = 10
-- TODO: Write your query


-- 4.2: Delete all inactive employees (is_active = FALSE)
-- TODO: Write your query


-- 4.3: Delete products with 0 stock
-- TODO: Write your query


-- 4.4: Delete orders with NULL total_amount
-- TODO: Write your query


-- ============================================
-- Part 5: Transactions (5 min)
-- ============================================

-- 5.1: Practice transaction with ROLLBACK
-- TODO: Write your queries
-- BEGIN;
-- UPDATE employees SET salary = salary * 2;
-- SELECT * FROM employees;  -- Check results
-- ROLLBACK;  -- Undo changes
-- SELECT * FROM employees;  -- Verify rollback


-- 5.2: Archive and delete old orders (before 2024-02-01)
-- TODO: Write your queries in a transaction
-- BEGIN;
-- CREATE TABLE orders_archive AS SELECT * FROM orders WHERE 1=0;
-- INSERT INTO orders_archive SELECT * FROM orders WHERE order_date < '2024-02-01';
-- DELETE FROM orders WHERE order_date < '2024-02-01';
-- COMMIT;

