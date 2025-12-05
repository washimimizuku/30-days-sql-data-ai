-- Day 26: Transactions and ACID - Solutions
-- Database: day26.db

-- ============================================================================
-- PART 1: BASIC TRANSACTIONS (Easy)
-- ============================================================================

-- Exercise 1: Simple Transaction
BEGIN;
INSERT INTO accounts VALUES (11, 'ACC011', 'Test User', 1000.00);
COMMIT;

-- Verify:
SELECT * FROM accounts WHERE id = 11;


-- Exercise 2: Transaction with Rollback
BEGIN;
UPDATE accounts SET balance = balance + 500 WHERE id = 1;
SELECT * FROM accounts WHERE id = 1;  -- View the change
ROLLBACK;  -- Undo the change

-- Verify it was rolled back:
SELECT * FROM accounts WHERE id = 1;


-- Exercise 3: Multiple Inserts
BEGIN;
INSERT INTO products VALUES (16, 'Mouse Pad', 100, 14.99);
INSERT INTO products VALUES (17, 'USB Hub', 50, 34.99);
INSERT INTO products VALUES (18, 'Cable Organizer', 75, 19.99);
COMMIT;

-- Verify:
SELECT * FROM products WHERE id >= 16;


-- Exercise 4: Verify Before Commit
BEGIN;
UPDATE employees SET salary = salary * 1.05 WHERE department = 'Sales';
-- Verify changes:
SELECT name, department, salary FROM employees WHERE department = 'Sales';
COMMIT;


-- ============================================================================
-- PART 2: MONEY TRANSFERS (Medium)
-- ============================================================================

-- Exercise 5: Simple Transfer
BEGIN;
UPDATE accounts SET balance = balance - 200 WHERE id = 1;
UPDATE accounts SET balance = balance + 200 WHERE id = 2;
COMMIT;

-- Verify:
SELECT id, account_number, balance FROM accounts WHERE id IN (1, 2);


-- Exercise 6: Transfer with Verification
BEGIN;
-- Check balances before:
SELECT id, balance FROM accounts WHERE id IN (3, 4);

-- Perform transfer:
UPDATE accounts SET balance = balance - 500 WHERE id = 3;
UPDATE accounts SET balance = balance + 500 WHERE id = 4;

-- Check balances after:
SELECT id, balance FROM accounts WHERE id IN (3, 4);

COMMIT;


-- Exercise 7: Multiple Transfers
BEGIN;
-- Transfer 1: $100 from 5 to 6
UPDATE accounts SET balance = balance - 100 WHERE id = 5;
UPDATE accounts SET balance = balance + 100 WHERE id = 6;

-- Transfer 2: $150 from 7 to 8
UPDATE accounts SET balance = balance - 150 WHERE id = 7;
UPDATE accounts SET balance = balance + 150 WHERE id = 8;

COMMIT;

-- Verify all:
SELECT id, balance FROM accounts WHERE id IN (5, 6, 7, 8);


-- Exercise 8: Safe Transfer with Check
BEGIN;
UPDATE accounts SET balance = balance - 1000 WHERE id = 2;
UPDATE accounts SET balance = balance + 1000 WHERE id = 9;

-- Check if account 2 went negative:
SELECT balance FROM accounts WHERE id = 2;

-- If balance < 0, ROLLBACK
-- If balance >= 0, COMMIT
COMMIT;


-- ============================================================================
-- PART 3: ORDER PROCESSING (Medium-Hard)
-- ============================================================================

-- Exercise 9: Create Order with Items
BEGIN;
INSERT INTO orders VALUES (21, 5, CURRENT_DATE, 'pending', 159.97);
INSERT INTO order_items VALUES (51, 21, 2, 2, 29.99);
INSERT INTO order_items VALUES (52, 21, 7, 10, 9.99);
COMMIT;

-- Verify:
SELECT * FROM orders WHERE id = 21;
SELECT * FROM order_items WHERE order_id = 21;


-- Exercise 10: Order with Inventory Update
BEGIN;
INSERT INTO orders VALUES (22, 3, CURRENT_DATE, 'pending', 299.99);
INSERT INTO order_items VALUES (53, 22, 4, 1, 299.99);
UPDATE products SET stock = stock - 1 WHERE id = 4;
COMMIT;

-- Verify:
SELECT * FROM orders WHERE id = 22;
SELECT * FROM products WHERE id = 4;


-- Exercise 11: Complete Order Processing
BEGIN;
-- Create order
INSERT INTO orders VALUES (23, 7, CURRENT_DATE, 'pending', 449.97);

-- Add order items
INSERT INTO order_items VALUES (54, 23, 1, 1, 999.99);
INSERT INTO order_items VALUES (55, 23, 2, 2, 29.99);
INSERT INTO order_items VALUES (56, 23, 3, 1, 79.99);

-- Update inventory
UPDATE products SET stock = stock - 1 WHERE id = 1;
UPDATE products SET stock = stock - 2 WHERE id = 2;
UPDATE products SET stock = stock - 1 WHERE id = 3;

-- Update order status
UPDATE orders SET status = 'processing' WHERE id = 23;

COMMIT;


-- Exercise 12: Order Cancellation
BEGIN;
DELETE FROM order_items WHERE order_id = 1;
DELETE FROM orders WHERE id = 1;
ROLLBACK;  -- Cancel the deletion

-- Verify order still exists:
SELECT * FROM orders WHERE id = 1;


-- ============================================================================
-- PART 4: ACID PROPERTIES (Medium)
-- ============================================================================

-- Exercise 13: Atomicity Demo
BEGIN;
-- This will fail because account 1 doesn't have $10000
UPDATE accounts SET balance = balance - 10000 WHERE id = 1;
UPDATE accounts SET balance = balance + 10000 WHERE id = 2;
-- Transaction fails, both updates are rolled back
ROLLBACK;

-- Verify neither account changed:
SELECT id, balance FROM accounts WHERE id IN (1, 2);


-- Exercise 14: Consistency Demo
BEGIN;
-- This violates CHECK constraint (salary > 0)
UPDATE employees SET salary = -1000 WHERE id = 1;
-- DuckDB will reject this and rollback automatically
ROLLBACK;

-- Verify salary unchanged:
SELECT id, name, salary FROM employees WHERE id = 1;


-- Exercise 15: Batch Update with Verification
BEGIN;
-- Store original total
SELECT SUM(salary) as original_total FROM employees WHERE department = 'Engineering';

-- Update salaries
UPDATE employees SET salary = salary * 1.10 WHERE department = 'Engineering';

-- Check new total
SELECT SUM(salary) as new_total FROM employees WHERE department = 'Engineering';

-- Calculate increase
SELECT 
    (SELECT SUM(salary) FROM employees WHERE department = 'Engineering') -
    (SELECT SUM(salary) FROM employees WHERE department = 'Engineering') / 1.10 as increase;

-- If increase < $50000, COMMIT; otherwise ROLLBACK
COMMIT;


-- Exercise 16: Data Integrity
BEGIN;
-- Calculate sum of order items for order 5
SELECT SUM(quantity * price) as calculated_total
FROM order_items
WHERE order_id = 5;

-- Update order total to match
UPDATE orders 
SET total = (
    SELECT SUM(quantity * price) 
    FROM order_items 
    WHERE order_id = 5
)
WHERE id = 5;

-- Verify
SELECT id, total FROM orders WHERE id = 5;

COMMIT;


-- ============================================================================
-- PART 5: ADVANCED TRANSACTIONS (Hard)
-- ============================================================================

-- Exercise 17: Conditional Transaction
BEGIN;
-- Check balance
SELECT balance FROM accounts WHERE id = 6;

-- If balance >= 1000, proceed with transfer
UPDATE accounts SET balance = balance - 1000 WHERE id = 6;
UPDATE accounts SET balance = balance + 1000 WHERE id = 10;

-- Check if account 6 went negative
SELECT balance FROM accounts WHERE id = 6;

-- If negative, ROLLBACK; if positive, COMMIT
COMMIT;


-- Exercise 18: Multi-Table Update
BEGIN;
-- Increase product prices by 10%
UPDATE products SET price = price * 1.10;

-- Update order_items prices for pending orders
UPDATE order_items 
SET price = price * 1.10
WHERE order_id IN (SELECT id FROM orders WHERE status = 'pending');

-- Recalculate order totals for pending orders
UPDATE orders o
SET total = (
    SELECT SUM(quantity * price)
    FROM order_items oi
    WHERE oi.order_id = o.id
)
WHERE status = 'pending';

COMMIT;


-- Exercise 19: Safe Data Migration
BEGIN;
-- Create archive table
CREATE TABLE orders_archive AS
SELECT * FROM orders WHERE 1=0;  -- Copy structure only

-- Copy delivered orders
INSERT INTO orders_archive
SELECT * FROM orders WHERE status = 'delivered';

-- Verify counts
SELECT 
    (SELECT COUNT(*) FROM orders WHERE status = 'delivered') as original_count,
    (SELECT COUNT(*) FROM orders_archive) as archive_count;

-- If counts match, COMMIT
COMMIT;


-- Exercise 20: Complex Business Logic
BEGIN;
-- Calculate current total
SELECT SUM(salary) as current_total FROM employees WHERE department = 'Sales';

-- Give 5% bonus
UPDATE employees 
SET salary = salary * 1.05 
WHERE department = 'Sales';

-- Calculate new total
SELECT SUM(salary) as new_total FROM employees WHERE department = 'Sales';

-- Create audit table if not exists
CREATE TABLE IF NOT EXISTS salary_audit (
    audit_date DATE,
    department VARCHAR,
    employee_count INTEGER,
    total_increase DECIMAL(10,2)
);

-- Insert audit record
INSERT INTO salary_audit
SELECT 
    CURRENT_DATE,
    'Sales',
    COUNT(*),
    SUM(salary) * 0.05 / 1.05  -- Calculate the increase amount
FROM employees 
WHERE department = 'Sales';

-- Verify everything
SELECT * FROM salary_audit WHERE audit_date = CURRENT_DATE;

COMMIT;


-- ============================================================================
-- BONUS: TRANSACTION PATTERNS
-- ============================================================================

-- Pattern 1: Safe Update with Verification
BEGIN;
UPDATE table_name SET column = value WHERE condition;
SELECT * FROM table_name WHERE condition;  -- Verify
-- If correct: COMMIT
-- If wrong: ROLLBACK
COMMIT;


-- Pattern 2: Multi-Step Operation
BEGIN;
INSERT INTO parent_table (...) VALUES (...);
INSERT INTO child_table (...) VALUES (...);
UPDATE related_table SET ...;
COMMIT;


-- Pattern 3: Conditional Logic
BEGIN;
-- Perform operation
UPDATE accounts SET balance = balance - amount WHERE id = sender;
-- Check result
SELECT balance FROM accounts WHERE id = sender;
-- If balance < 0: ROLLBACK
-- If balance >= 0: COMMIT
COMMIT;
