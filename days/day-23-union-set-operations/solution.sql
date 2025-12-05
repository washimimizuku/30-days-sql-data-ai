-- Day 23: UNION and Set Operations
-- Solutions

-- ============================================
-- Part 1: UNION
-- ============================================

-- 1.1: Combine employees (remove duplicates)
SELECT employee_id, name, email, department, salary FROM employees_2023
UNION
SELECT employee_id, name, email, department, salary FROM employees_2024;

-- 1.2: Combine customers (remove duplicates)
SELECT customer_id, name, email, city, state FROM customers_east
UNION
SELECT customer_id, name, email, city, state FROM customers_west;

-- 1.3: Unified product list
SELECT product_id, product_name, category, price FROM products_online
UNION
SELECT product_id, product_name, category, price FROM products_store;

-- 1.4: Employees with source
SELECT employee_id, name, email, department, 'Year 2023' as source FROM employees_2023
UNION
SELECT employee_id, name, email, department, 'Year 2024' as source FROM employees_2024;

-- 1.5: Customers with region
SELECT customer_id, name, email, city, state, 'East' as region FROM customers_east
UNION
SELECT customer_id, name, email, city, state, 'West' as region FROM customers_west;


-- ============================================
-- Part 2: UNION ALL
-- ============================================

-- 2.1: Combine employees (keep duplicates)
SELECT employee_id, name, email, department, salary FROM employees_2023
UNION ALL
SELECT employee_id, name, email, department, salary FROM employees_2024;

-- 2.2: Combine orders
SELECT order_id, customer_id, order_date, total FROM orders_q1
UNION ALL
SELECT order_id, customer_id, order_date, total FROM orders_q2;

-- 2.3: Compare counts
-- UNION (removes duplicates)
SELECT COUNT(*) as union_count FROM (
    SELECT email FROM employees_2023
    UNION
    SELECT email FROM employees_2024
);

-- UNION ALL (keeps duplicates)
SELECT COUNT(*) as union_all_count FROM (
    SELECT email FROM employees_2023
    UNION ALL
    SELECT email FROM employees_2024
);

-- 2.4: Products with channel
SELECT product_id, product_name, category, price, 'Online' as channel FROM products_online
UNION ALL
SELECT product_id, product_name, category, price, 'Store' as channel FROM products_store;

-- 2.5: Complete contact list
SELECT name, email, 'Employee' as contact_type FROM employees_2023
UNION ALL
SELECT name, email, 'Employee' as contact_type FROM employees_2024
UNION ALL
SELECT name, email, 'Customer' as contact_type FROM customers_east
UNION ALL
SELECT name, email, 'Customer' as contact_type FROM customers_west;


-- ============================================
-- Part 3: INTERSECT
-- ============================================

-- 3.1: Employees in both years
SELECT email FROM employees_2023
INTERSECT
SELECT email FROM employees_2024;

-- 3.2: Customers in both regions
SELECT email FROM customers_east
INTERSECT
SELECT email FROM customers_west;

-- 3.3: Products in both channels
SELECT product_id FROM products_online
INTERSECT
SELECT product_id FROM products_store;

-- 3.4: Common emails (employees and customers)
SELECT email FROM employees_2023
INTERSECT
SELECT email FROM customers_east;

-- 3.5: Common departments
SELECT department FROM employees_2023
INTERSECT
SELECT department FROM employees_2024;


-- ============================================
-- Part 4: EXCEPT
-- ============================================

-- 4.1: Employees who left
SELECT email FROM employees_2023
EXCEPT
SELECT email FROM employees_2024;

-- 4.2: New employees
SELECT email FROM employees_2024
EXCEPT
SELECT email FROM employees_2023;

-- 4.3: Products only online
SELECT product_id FROM products_online
EXCEPT
SELECT product_id FROM products_store;

-- 4.4: Products only in store
SELECT product_id FROM products_store
EXCEPT
SELECT product_id FROM products_online;

-- 4.5: Customers only in East
SELECT email FROM customers_east
EXCEPT
SELECT email FROM customers_west;


-- ============================================
-- Part 5: Complex Combinations
-- ============================================

-- 5.1: Customers who ordered in both quarters
SELECT customer_id FROM orders_q1
INTERSECT
SELECT customer_id FROM orders_q2;

-- 5.2: All unique departments
SELECT department FROM employees_2023
UNION
SELECT department FROM employees_2024;

-- 5.3: Employee changes report
SELECT email, 'Left' as status FROM employees_2023
EXCEPT
SELECT email, 'Left' FROM employees_2024
UNION ALL
SELECT email, 'Stayed' FROM employees_2023
INTERSECT
SELECT email, 'Stayed' FROM employees_2024
UNION ALL
SELECT email, 'Joined' FROM employees_2024
EXCEPT
SELECT email, 'Joined' FROM employees_2023;

-- 5.4: Products in exactly one channel (XOR)
SELECT product_id, 'Online Only' as availability FROM products_online
EXCEPT
SELECT product_id, 'Online Only' FROM products_store
UNION
SELECT product_id, 'Store Only' FROM products_store
EXCEPT
SELECT product_id, 'Store Only' FROM products_online;

-- 5.5: Comprehensive contact directory
SELECT DISTINCT email, 'Employee' as source FROM (
    SELECT email FROM employees_2023
    UNION
    SELECT email FROM employees_2024
)
UNION
SELECT DISTINCT email, 'Customer' FROM (
    SELECT email FROM customers_east
    UNION
    SELECT email FROM customers_west
)
ORDER BY email;
