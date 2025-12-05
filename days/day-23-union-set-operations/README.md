# Day 23: UNION and Set Operations

## Learning Objectives
- Understand UNION and set operations
- Learn UNION, UNION ALL, INTERSECT, EXCEPT
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### What are Set Operations?

Set operations combine the results of two or more SELECT statements. Think of them like mathematical set operations (union, intersection, difference).

**Requirements:**
- Same number of columns in each SELECT
- Compatible data types in corresponding columns
- Column names from first SELECT are used

### UNION - Combine and Remove Duplicates

Combines results from multiple queries and removes duplicate rows:

```sql
-- Combine customers from two regions
SELECT customer_name, city
FROM customers_east
UNION
SELECT customer_name, city
FROM customers_west;
```

**Result:** All unique customers from both tables

**Example with filtering:**
```sql
-- All employees and contractors
SELECT name, 'Employee' as type
FROM employees
WHERE active = true
UNION
SELECT name, 'Contractor' as type
FROM contractors
WHERE status = 'active';
```

### UNION ALL - Combine and Keep Duplicates

Combines results and keeps all rows, including duplicates (faster than UNION):

```sql
-- All transactions from multiple sources
SELECT transaction_id, amount, date
FROM transactions_2023
UNION ALL
SELECT transaction_id, amount, date
FROM transactions_2024;
```

**When to use UNION ALL:**
- You know there are no duplicates
- You want to keep duplicates
- Performance matters (no deduplication overhead)

**Performance comparison:**
```sql
-- Slower - removes duplicates
SELECT city FROM customers_east
UNION
SELECT city FROM customers_west;

-- Faster - keeps duplicates
SELECT city FROM customers_east
UNION ALL
SELECT city FROM customers_west;
```

### INTERSECT - Common Rows Only

Returns only rows that appear in both queries:

```sql
-- Customers who are also suppliers
SELECT company_name
FROM customers
INTERSECT
SELECT company_name
FROM suppliers;
```

**Result:** Only companies that are both customers AND suppliers

**More examples:**
```sql
-- Products sold in both 2023 and 2024
SELECT product_id
FROM sales_2023
INTERSECT
SELECT product_id
FROM sales_2024;

-- Employees who are also managers
SELECT employee_id
FROM employees
INTERSECT
SELECT manager_id
FROM departments;

-- Cities with both offices and warehouses
SELECT city FROM offices
INTERSECT
SELECT city FROM warehouses;
```

### EXCEPT (or MINUS) - Difference

Returns rows from the first query that are NOT in the second query:

```sql
-- Customers who have NOT placed orders
SELECT customer_id
FROM customers
EXCEPT
SELECT customer_id
FROM orders;
```

**Result:** Customers with no orders

**Note:** Some databases use `MINUS` instead of `EXCEPT` (Oracle)

**More examples:**
```sql
-- Products in inventory but never sold
SELECT product_id
FROM inventory
EXCEPT
SELECT product_id
FROM sales;

-- Employees who are not managers
SELECT employee_id
FROM employees
EXCEPT
SELECT manager_id
FROM departments;

-- All dates in range minus holidays
SELECT date
FROM date_range
EXCEPT
SELECT holiday_date
FROM holidays;
```

### Combining Multiple Set Operations

You can chain multiple set operations:

```sql
-- Customers from three regions, no duplicates
SELECT customer_id FROM customers_east
UNION
SELECT customer_id FROM customers_west
UNION
SELECT customer_id FROM customers_south;

-- Complex example
(
    SELECT product_id FROM products_2023
    UNION
    SELECT product_id FROM products_2024
)
EXCEPT
(
    SELECT product_id FROM discontinued_products
);
```

### ORDER BY with Set Operations

ORDER BY goes at the end and applies to the entire result:

```sql
SELECT name, salary FROM employees_dept1
UNION
SELECT name, salary FROM employees_dept2
ORDER BY salary DESC;  -- Applies to combined result

-- ❌ Wrong - ORDER BY in middle
SELECT name FROM employees_dept1
ORDER BY name  -- Error!
UNION
SELECT name FROM employees_dept2;

-- ✅ Correct - ORDER BY at end
SELECT name FROM employees_dept1
UNION
SELECT name FROM employees_dept2
ORDER BY name;
```

### Practical Examples

**Example 1: Contact list from multiple sources**
```sql
SELECT 
    name,
    email,
    'Customer' as source
FROM customers
WHERE email IS NOT NULL
UNION ALL
SELECT 
    name,
    email,
    'Supplier' as source
FROM suppliers
WHERE email IS NOT NULL
UNION ALL
SELECT 
    name,
    email,
    'Employee' as source
FROM employees
WHERE email IS NOT NULL
ORDER BY name;
```

**Example 2: Find inactive customers**
```sql
-- Customers who registered but never ordered
SELECT customer_id, name
FROM customers
EXCEPT
SELECT c.customer_id, c.name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;
```

**Example 3: Products in all categories**
```sql
-- Products that exist in both Electronics and Books
SELECT product_name
FROM products
WHERE category = 'Electronics'
INTERSECT
SELECT product_name
FROM products
WHERE category = 'Books';
```

## 💻 Exercises (40 minutes)

### Exercise 1: UNION

Write queries to:
1. Combine customers from `customers_north` and `customers_south` tables (remove duplicates)
2. Create a list of all cities from both `offices` and `warehouses` tables
3. Combine employee names from `full_time` and `part_time` tables with a type indicator
4. Get all product names from `products_2023` and `products_2024`

### Exercise 2: UNION ALL

Write queries to:
1. Combine all transactions from `transactions_q1`, `q2`, `q3`, `q4` (keep duplicates)
2. Get all log entries from `logs_2023` and `logs_2024`
3. Combine sales from multiple regions keeping all records
4. Create a complete audit trail from multiple audit tables

### Exercise 3: INTERSECT

Write queries to:
1. Find customers who are also suppliers (appear in both tables)
2. Find products sold in both 2023 AND 2024
3. Find employees who are also in the managers table
4. Find cities that have both offices AND warehouses
5. Find email addresses that appear in both customers and newsletter_subscribers

### Exercise 4: EXCEPT

Write queries to:
1. Find customers who have NOT placed any orders
2. Find products in inventory that have never been sold
3. Find employees who are NOT managers
4. Find registered users who have NOT made a purchase
5. Find all dates in January EXCEPT weekends

### Exercise 5: Complex Set Operations

Write queries to:
1. Combine customers from 3 regions, remove duplicates, order by name
2. Find products in (Electronics OR Books) but NOT in discontinued products
3. Find employees in (dept1 OR dept2 OR dept3) who are NOT managers
4. Create a master contact list from customers, suppliers, and employees

### Exercise 6: Practical Applications

Write queries to:
1. Find inactive customers (registered but never ordered)
2. Find products that need restocking (in catalog but not in inventory)
3. Find orphaned records (orders with no matching customer)
4. Create a unified report of all revenue sources (sales, subscriptions, services)

## Setup
Run the setup script first:
```bash
python setup.py
```

This creates the database with sample data.

## 💡 Key Concepts

### Set Operations Summary

| Operation | Description | Duplicates | Use Case |
|-----------|-------------|------------|----------|
| UNION | Combine, remove duplicates | Removed | Merge unique records |
| UNION ALL | Combine, keep duplicates | Kept | Merge all records (faster) |
| INTERSECT | Common rows only | Removed | Find overlap |
| EXCEPT | First minus second | Removed | Find differences |

### UNION vs UNION ALL

```sql
-- UNION - Slower, removes duplicates
SELECT city FROM table1  -- Returns: NY, LA, Chicago
UNION
SELECT city FROM table2  -- Returns: LA, Chicago, Boston
-- Result: NY, LA, Chicago, Boston (4 rows)

-- UNION ALL - Faster, keeps duplicates
SELECT city FROM table1  -- Returns: NY, LA, Chicago
UNION ALL
SELECT city FROM table2  -- Returns: LA, Chicago, Boston
-- Result: NY, LA, Chicago, LA, Chicago, Boston (6 rows)
```

### When to Use Each Operation

**UNION:**
- Merging similar data from multiple sources
- Creating master lists
- Combining historical and current data
- When duplicates should be removed

**UNION ALL:**
- Appending data (no duplicates expected)
- Performance-critical queries
- Combining partitioned data
- When duplicates are meaningful

**INTERSECT:**
- Finding common elements
- Validating data consistency
- Finding overlaps between datasets
- "Both/And" scenarios

**EXCEPT:**
- Finding missing records
- Data validation
- Finding differences
- "Not in" scenarios (alternative to NOT IN)

### Performance Tips

1. **UNION ALL is faster than UNION** - No deduplication needed
2. **Use EXCEPT instead of NOT IN** - Often more efficient
3. **Indexes help** - On columns used in set operations
4. **Column order matters** - Must match across queries
5. **Data types must be compatible** - Or use CAST

### Common Patterns

```sql
-- Pattern 1: Master list from multiple sources
SELECT id, name, 'Source1' as source FROM table1
UNION ALL
SELECT id, name, 'Source2' as source FROM table2;

-- Pattern 2: Find records in A but not B
SELECT id FROM table_a
EXCEPT
SELECT id FROM table_b;

-- Pattern 3: Find records in both A and B
SELECT id FROM table_a
INTERSECT
SELECT id FROM table_b;

-- Pattern 4: Combine with filtering
SELECT id FROM table1 WHERE active = true
UNION
SELECT id FROM table2 WHERE status = 'active';
```

### Common Mistakes

```sql
-- ❌ Wrong - Different number of columns
SELECT id, name FROM table1
UNION
SELECT id FROM table2;  -- Error!

-- ✅ Correct - Same number of columns
SELECT id, name FROM table1
UNION
SELECT id, name FROM table2;

-- ❌ Wrong - ORDER BY in wrong place
SELECT name FROM table1 ORDER BY name
UNION
SELECT name FROM table2;  -- Error!

-- ✅ Correct - ORDER BY at end
SELECT name FROM table1
UNION
SELECT name FROM table2
ORDER BY name;

-- ❌ Wrong - Incompatible types
SELECT id FROM table1  -- id is INTEGER
UNION
SELECT name FROM table2;  -- name is VARCHAR - Error!

-- ✅ Correct - Cast to compatible type
SELECT CAST(id AS VARCHAR) FROM table1
UNION
SELECT name FROM table2;
```

## Key Takeaways
- UNION combines results and removes duplicates
- UNION ALL is faster and keeps duplicates
- INTERSECT finds common rows between queries
- EXCEPT finds rows in first query but not in second
- All queries must have same number of columns
- Use UNION ALL when possible for better performance
- ORDER BY goes at the end of the entire operation

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 24
