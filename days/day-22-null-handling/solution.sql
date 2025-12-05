-- Day 22: NULL Handling and Data Manipulation
-- Solutions

-- ============================================
-- Part 1: NULL Handling
-- ============================================

-- 1.1: Find employees with NULL email
SELECT employee_id, name, email FROM employees WHERE email IS NULL;

-- 1.2: Find employees with NULL phone OR NULL email
SELECT employee_id, name, email, phone FROM employees WHERE phone IS NULL OR email IS NULL;

-- 1.3: COALESCE for NULL phones
SELECT employee_id, name, COALESCE(phone, 'No contact') as phone_or_default FROM employees;

-- 1.4: COALESCE for phone, email, or default
SELECT employee_id, name, COALESCE(phone, email, 'No contact') as contact_method FROM employees;

-- 1.5: Find products with NULL descriptions
SELECT product_id, product_name, description FROM products WHERE description IS NULL;

-- 1.6: COALESCE for NULL descriptions
SELECT product_id, product_name, COALESCE(description, 'No description') as description FROM products;

-- 1.7: Calculate total compensation
SELECT 
    employee_id, name, salary, bonus,
    salary + COALESCE(bonus, 0) as total_comp
FROM employees
WHERE salary IS NOT NULL;

-- 1.8: NULLIF to avoid division by zero
SELECT 
    product_id, product_name, price, stock_quantity,
    price / NULLIF(stock_quantity, 0) as price_per_unit
FROM products
WHERE price IS NOT NULL;

-- 1.9: Count total vs with email
SELECT 
    COUNT(*) as total_employees,
    COUNT(email) as employees_with_email
FROM employees;

-- 1.10: Average salary (ignores NULL)
SELECT AVG(salary) as avg_salary FROM employees;


-- ============================================
-- Part 2: INSERT Operations
-- ============================================

-- 2.1: Insert new employee
INSERT INTO employees VALUES
(11, 'New Employee', 'new@company.com', '555-0000', 'IT', 70000, 3000, '2024-12-01', TRUE);

-- 2.2: Insert 3 products
INSERT INTO products VALUES
(11, 'Mouse Pad', 'Electronics', 'Gaming mouse pad', 19.99, 100, 1),
(12, 'Pen Set', 'Office', NULL, 9.99, 200, 3),
(13, 'Notebook', 'Office', 'Spiral notebook', NULL, 150, 3);

-- 2.3: Insert high earners
CREATE TABLE high_earners AS SELECT * FROM employees WHERE 1=0;
INSERT INTO high_earners SELECT * FROM employees WHERE salary > 85000;

-- 2.4: Insert department summary
CREATE TABLE dept_summary (department VARCHAR, emp_count INTEGER, avg_salary DECIMAL(10,2));
INSERT INTO dept_summary
SELECT department, COUNT(*), AVG(salary)
FROM employees
WHERE department IS NOT NULL
GROUP BY department;


-- ============================================
-- Part 3: UPDATE Operations
-- ============================================

-- 3.1: Update salary for employee 4
UPDATE employees SET salary = 95000 WHERE employee_id = 4;

-- 3.2: 10% raise for Engineering
UPDATE employees SET salary = salary * 1.10 WHERE department = 'Engineering';

-- 3.3: Update NULL emails
UPDATE employees SET email = 'noemail@company.com' WHERE email IS NULL;

-- 3.4: Update NULL bonuses
UPDATE employees SET bonus = 0 WHERE bonus IS NULL;

-- 3.5: Different raises by department
UPDATE employees
SET salary = salary * CASE department
    WHEN 'Engineering' THEN 1.15
    WHEN 'Sales' THEN 1.12
    WHEN 'Marketing' THEN 1.10
    ELSE 1.05
END
WHERE salary IS NOT NULL;

-- 3.6: Set inactive for NULL department
UPDATE employees SET is_active = FALSE WHERE department IS NULL;

-- 3.7: Update product prices
UPDATE products
SET price = price * CASE category
    WHEN 'Electronics' THEN 1.10
    ELSE 1.05
END
WHERE price IS NOT NULL;


-- ============================================
-- Part 4: DELETE Operations
-- ============================================

-- 4.1: Delete employee 10
DELETE FROM employees WHERE employee_id = 10;

-- 4.2: Delete inactive employees
DELETE FROM employees WHERE is_active = FALSE;

-- 4.3: Delete products with 0 stock
DELETE FROM products WHERE stock_quantity = 0;

-- 4.4: Delete orders with NULL amount
DELETE FROM orders WHERE total_amount IS NULL;


-- ============================================
-- Part 5: Transactions
-- ============================================

-- 5.1: Transaction with ROLLBACK
BEGIN;
UPDATE employees SET salary = salary * 2;
SELECT * FROM employees;
ROLLBACK;
SELECT * FROM employees;

-- 5.2: Archive and delete
BEGIN;
CREATE TABLE orders_archive AS SELECT * FROM orders WHERE 1=0;
INSERT INTO orders_archive SELECT * FROM orders WHERE order_date < '2024-02-01';
DELETE FROM orders WHERE order_date < '2024-02-01';
COMMIT;
