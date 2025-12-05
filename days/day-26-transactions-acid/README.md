# Day 26: Transactions and ACID Properties

## Learning Objectives
- Understand transactions and ACID properties
- Master BEGIN, COMMIT, ROLLBACK
- Learn when to use transactions
- Practice safe data modifications
- Handle transaction errors

## Theory (15 minutes)

### What are Transactions?

A transaction is a sequence of SQL operations treated as a single unit of work. Either all operations succeed (COMMIT) or all fail (ROLLBACK).

**Basic Transaction:**
```sql
BEGIN;  -- Start transaction

INSERT INTO accounts (id, balance) VALUES (1, 1000);
INSERT INTO accounts (id, balance) VALUES (2, 500);

COMMIT;  -- Save all changes
```

**Transaction with Rollback:**
```sql
BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- If something went wrong:
ROLLBACK;  -- Undo all changes

-- If everything is correct:
-- COMMIT;  -- Save all changes
```

### Transaction Commands

| Command | Purpose |
|---------|---------|
| BEGIN | Start a transaction |
| COMMIT | Save all changes permanently |
| ROLLBACK | Undo all changes since BEGIN |

### Why Use Transactions?

**Without transaction (dangerous):**
```sql
-- Transfer $100 from account A to B
UPDATE accounts SET balance = balance - 100 WHERE id = 'A';
-- If system crashes here, money disappears!
UPDATE accounts SET balance = balance + 100 WHERE id = 'B';
```

**With transaction (safe):**
```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 'A';
UPDATE accounts SET balance = balance + 100 WHERE id = 'B';
COMMIT;
-- Both updates happen or neither happens
```

### ACID Properties

**A - Atomicity (All or Nothing)**

All operations in a transaction succeed or all fail.

```sql
BEGIN;
-- Transfer money between accounts
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
-- Both updates happen or neither happens
```

**C - Consistency (Valid State)**

Database moves from one valid state to another. Constraints are maintained.

```sql
BEGIN;
-- This violates CHECK constraint (salary > 0)
UPDATE employees SET salary = -1000 WHERE id = 1;
-- Transaction automatically rolls back
COMMIT;
```

**I - Isolation (No Interference)**

Concurrent transactions don't interfere with each other.

```sql
-- Transaction 1
BEGIN;
UPDATE inventory SET quantity = quantity - 1 WHERE product_id = 100;
-- Other transactions don't see this change until COMMIT
COMMIT;
```

**D - Durability (Permanent)**

Once committed, changes survive system failures.

```sql
BEGIN;
INSERT INTO orders (id, total) VALUES (1, 500);
COMMIT;
-- Even if system crashes, this order is saved
```

### Practical Examples

**Example 1: Money Transfer**
```sql
BEGIN;

-- Deduct from sender
UPDATE accounts 
SET balance = balance - 100 
WHERE account_id = 'A123';

-- Add to receiver
UPDATE accounts 
SET balance = balance + 100 
WHERE account_id = 'B456';

-- Verify balances
SELECT account_id, balance 
FROM accounts 
WHERE account_id IN ('A123', 'B456');

-- If correct, commit
COMMIT;
```

**Example 2: Order Processing**
```sql
BEGIN;

-- Create order
INSERT INTO orders (customer_id, total, status)
VALUES (100, 250.00, 'pending');

-- Add order items
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES 
    (1001, 50, 2, 100.00),
    (1001, 75, 1, 50.00);

-- Update inventory
UPDATE products SET stock = stock - 2 WHERE id = 50;
UPDATE products SET stock = stock - 1 WHERE id = 75;

COMMIT;
```

**Example 3: Batch Update with Verification**
```sql
BEGIN;

-- Update salaries
UPDATE employees 
SET salary = salary * 1.10 
WHERE department = 'Sales';

-- Verify changes
SELECT department, COUNT(*), AVG(salary)
FROM employees
WHERE department = 'Sales'
GROUP BY department;

-- If looks good:
COMMIT;

-- If something wrong:
-- ROLLBACK;
```

**Example 4: Safe Data Migration**
```sql
BEGIN;

-- Copy data
INSERT INTO employees_new
SELECT * FROM employees_old;

-- Verify count matches
SELECT 
    (SELECT COUNT(*) FROM employees_old) as old_count,
    (SELECT COUNT(*) FROM employees_new) as new_count;

-- If counts match:
COMMIT;
```

### When to Use Transactions

**✅ Use transactions for:**
- Money transfers
- Order processing (order + items + inventory)
- Multi-table updates that must stay in sync
- Batch operations that should be atomic
- Data migrations
- Any operation where partial completion would be bad

**❌ Don't need transactions for:**
- Single INSERT/UPDATE/DELETE
- Read-only queries (SELECT)
- Operations that can safely fail partially

### Transaction Best Practices

1. **Keep transactions short** - Don't hold locks too long
2. **Test before commit** - Use SELECT to verify changes
3. **Handle errors** - Always ROLLBACK on failure
4. **Be atomic** - Group related operations together
5. **Avoid user interaction** - Don't wait for user input during transaction

### Common Patterns

**Pattern 1: Safe Update**
```sql
BEGIN;
UPDATE table SET column = value WHERE condition;
SELECT * FROM table WHERE condition;  -- Verify
COMMIT;  -- or ROLLBACK if wrong
```

**Pattern 2: Multi-Table Insert**
```sql
BEGIN;
INSERT INTO parent_table (...) VALUES (...);
INSERT INTO child_table (...) VALUES (...);
INSERT INTO child_table (...) VALUES (...);
COMMIT;
```

**Pattern 3: Conditional Transaction**
```sql
BEGIN;

UPDATE inventory SET quantity = quantity - 5 WHERE product_id = 100;

-- Check if quantity went negative
SELECT quantity FROM inventory WHERE product_id = 100;

-- If negative, rollback
-- ROLLBACK;

-- If positive, commit
-- COMMIT;
```

### DuckDB Transaction Notes

**Important:** DuckDB has some transaction limitations:
- Transactions are per-connection
- DDL operations (CREATE, ALTER, DROP) auto-commit
- Some operations may not be fully transactional

**What works:**
```sql
BEGIN;
INSERT INTO table VALUES (...);
UPDATE table SET ...;
DELETE FROM table WHERE ...;
COMMIT;
```

**What auto-commits:**
```sql
BEGIN;
CREATE TABLE new_table (...);  -- Auto-commits!
-- Transaction is already committed
```

## Exercises (40 minutes)

### Setup
```bash
python setup.py
```

Creates `day26.db` with:
- **accounts** (10 rows): id, account_number, customer_name, balance
- **orders** (20 rows): id, customer_id, order_date, status, total
- **order_items** (50 rows): id, order_id, product_id, quantity, price
- **products** (15 rows): id, product_name, stock, price
- **employees** (12 rows): id, name, department, salary

### Instructions

Complete 20 exercises in `exercise.sql`:

**Part 1: Basic Transactions (1-4)** - BEGIN, COMMIT, ROLLBACK  
**Part 2: Money Transfers (5-8)** - Account balance updates  
**Part 3: Order Processing (9-12)** - Multi-table operations  
**Part 4: ACID Properties (13-16)** - Atomicity, consistency, isolation  
**Part 5: Advanced Transactions (17-20)** - Complex scenarios

Check `solution.sql` for complete solutions.

## Key Takeaways

- Transactions group multiple operations into atomic units
- BEGIN starts a transaction, COMMIT saves, ROLLBACK undoes
- ACID properties ensure data integrity:
  - **Atomicity**: All or nothing
  - **Consistency**: Valid state to valid state
  - **Isolation**: No interference between transactions
  - **Durability**: Changes are permanent after commit
- Use transactions for multi-step operations (transfers, orders)
- Keep transactions short to avoid locking issues
- Always verify changes before COMMIT
- ROLLBACK on errors to maintain data integrity
- Test transactions thoroughly before production use

## Resources
- [DuckDB Transactions](https://duckdb.org/docs/sql/statements/transactions)
- [ACID Properties Explained](https://en.wikipedia.org/wiki/ACID)

## Next Steps
- Complete the exercises
- Check your solutions
- Take the quiz in `quiz.md`
- Move to Day 27: Views
