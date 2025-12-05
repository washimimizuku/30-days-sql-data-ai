-- Day 26: Transactions and ACID - Exercises
-- Database: day26.db

-- ============================================================================
-- PART 1: BASIC TRANSACTIONS (Easy)
-- ============================================================================

-- Exercise 1: Simple Transaction
-- Start a transaction, insert a new account, and commit
-- Account: id=11, account_number='ACC011', customer_name='Test User', balance=1000.00


-- Exercise 2: Transaction with Rollback
-- Start a transaction, update an account balance, view it, then rollback
-- Update account id=1 to add $500 to balance


-- Exercise 3: Multiple Inserts
-- Use a transaction to insert 3 new products at once
-- Products: (16, 'Mouse Pad', 100, 14.99), (17, 'USB Hub', 50, 34.99), (18, 'Cable Organizer', 75, 19.99)


-- Exercise 4: Verify Before Commit
-- Start transaction, update employee salaries in Sales by 5%, verify with SELECT, then commit


-- ============================================================================
-- PART 2: MONEY TRANSFERS (Medium)
-- ============================================================================

-- Exercise 5: Simple Transfer
-- Transfer $200 from account id=1 to account id=2
-- Use a transaction to ensure both updates happen together


-- Exercise 6: Transfer with Verification
-- Transfer $500 from account id=3 to account id=4
-- Include SELECT statements to verify balances before and after


-- Exercise 7: Multiple Transfers
-- In one transaction, perform these transfers:
-- - $100 from account 5 to account 6
-- - $150 from account 7 to account 8
-- All transfers must succeed or all must fail


-- Exercise 8: Safe Transfer with Check
-- Transfer $1000 from account id=2 to account id=9
-- After transfer, check if account 2 balance is still >= 0
-- If negative, rollback; if positive, commit


-- ============================================================================
-- PART 3: ORDER PROCESSING (Medium-Hard)
-- ============================================================================

-- Exercise 9: Create Order with Items
-- Use a transaction to:
-- 1. Insert new order: id=21, customer_id=5, order_date=today, status='pending', total=159.97
-- 2. Insert order items: (51, 21, 2, 2, 29.99), (52, 21, 7, 10, 9.99)


-- Exercise 10: Order with Inventory Update
-- Create order and update product stock:
-- 1. Insert order: id=22, customer_id=3, order_date=today, status='pending', total=299.99
-- 2. Insert order item: (53, 22, 4, 1, 299.99)
-- 3. Decrease product id=4 stock by 1


-- Exercise 11: Complete Order Processing
-- Process a complete order in one transaction:
-- 1. Create order (id=23, customer_id=7, today, 'pending', 449.97)
-- 2. Add 3 order items
-- 3. Update inventory for all 3 products
-- 4. Update order status to 'processing'


-- Exercise 12: Order Cancellation
-- Cancel an order (rollback scenario):
-- 1. Start transaction
-- 2. Delete order items for order id=1
-- 3. Delete order id=1
-- 4. Rollback (practice canceling)


-- ============================================================================
-- PART 4: ACID PROPERTIES (Medium)
-- ============================================================================

-- Exercise 13: Atomicity Demo
-- Demonstrate all-or-nothing:
-- Try to transfer $10000 from account 1 to account 2
-- This should fail because account 1 doesn't have enough
-- Show that neither account is modified


-- Exercise 14: Consistency Demo
-- Try to update employee salary to negative value
-- Show that CHECK constraint prevents this
-- Transaction should rollback automatically


-- Exercise 15: Batch Update with Verification
-- Update all Engineering employees' salaries by 10%
-- Use transaction to verify total salary increase is reasonable
-- Commit if total increase < $50000, otherwise rollback


-- Exercise 16: Data Integrity
-- Ensure order total matches sum of order items:
-- 1. Calculate sum of order items for order id=5
-- 2. Update order total to match
-- 3. Verify and commit


-- ============================================================================
-- PART 5: ADVANCED TRANSACTIONS (Hard)
-- ============================================================================

-- Exercise 17: Conditional Transaction
-- Transfer money only if sender has sufficient balance:
-- 1. Check account 6 balance
-- 2. If balance >= 1000, transfer $1000 to account 10
-- 3. If balance < 1000, don't transfer (rollback)


-- Exercise 18: Multi-Table Update
-- Update product prices and recalculate order totals:
-- 1. Increase all product prices by 10%
-- 2. Update order_items prices for pending orders
-- 3. Recalculate order totals
-- Use transaction to keep everything in sync


-- Exercise 19: Safe Data Migration
-- Copy all 'delivered' orders to a new archive table:
-- 1. Create orders_archive table
-- 2. Copy delivered orders
-- 3. Verify count matches
-- 4. Commit if counts match


-- Exercise 20: Complex Business Logic
-- Process end-of-month for Sales department:
-- 1. Calculate total sales (sum of salaries)
-- 2. Give 5% bonus to all Sales employees
-- 3. Insert audit record of changes
-- 4. Verify total increase
-- 5. Commit if everything looks correct
