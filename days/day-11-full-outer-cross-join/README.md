# Day 11: FULL OUTER JOIN and CROSS JOIN

## Learning Objectives
- Understand FULL OUTER JOIN for all rows from both tables
- Master CROSS JOIN for Cartesian products
- Learn when to use each join type
- Understand the complete JOIN family
- Practice with real-world scenarios
- Build comprehensive SQL join skills

## Theory (15 minutes)

### The Complete JOIN Family

You've learned INNER, LEFT, and RIGHT JOIN. Today: **FULL OUTER JOIN** and **CROSS JOIN**.

### FULL OUTER JOIN

Returns ALL rows from BOTH tables. If no match exists, NULL values fill the gaps.

**Syntax:**
```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2 ON table1.column = table2.column;
```

**Example:**
```sql
SELECT e.name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;
```

**Result includes:**
- Matched rows (employees with departments)
- Employees without departments (department_name = NULL)
- Departments without employees (name = NULL)

**Visual:**
```
Employees: 1,2,3    Departments: 1,2,4
FULL OUTER JOIN: 1(matched), 2(matched), 3(emp only), 4(dept only)
```

### When to Use FULL OUTER JOIN

**1. Data Reconciliation** - Compare two systems:
```sql
SELECT 
    COALESCE(s1.user_id, s2.user_id) as user_id,
    s1.username as system1_name,
    s2.username as system2_name,
    CASE 
        WHEN s1.user_id IS NULL THEN 'Only in System 2'
        WHEN s2.user_id IS NULL THEN 'Only in System 1'
        ELSE 'In Both'
    END as status
FROM system1_users s1
FULL OUTER JOIN system2_users s2 ON s1.user_id = s2.user_id;
```

**2. Find Orphaned Records** - Data integrity issues:
```sql
SELECT c.customer_name, o.order_id,
    CASE 
        WHEN c.id IS NULL THEN 'Orphaned Order'
        WHEN o.id IS NULL THEN 'Customer Without Orders'
    END as issue
FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id
WHERE c.id IS NULL OR o.id IS NULL;
```

**Key Points:**
- Use COALESCE() to handle NULLs
- Use CASE to identify which side is missing
- More expensive than LEFT/RIGHT JOIN

### CROSS JOIN

Returns the Cartesian product - every row from table1 combined with every row from table2.

**Formula:** Result rows = Table A rows × Table B rows

**Syntax:**
```sql
SELECT columns
FROM table1
CROSS JOIN table2;
```

**Example:**
```sql
SELECT s.size_name, c.color_name
FROM sizes s
CROSS JOIN colors c;
```

**Result:** 3 sizes × 5 colors = 15 rows (all combinations)

### When to Use CROSS JOIN

**1. Generate Product Variants:**
```sql
SELECT 
    p.product_name,
    s.size_name,
    c.color_name,
    p.product_code || '-' || s.size_code || '-' || c.color_code as sku
FROM products p
CROSS JOIN sizes s
CROSS JOIN colors c
WHERE p.id <= 5;
```

**2. Create Complete Grids:**
```sql
-- All month-product combinations (even with no sales)
SELECT 
    m.month_num,
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) as quantity_sold
FROM (SELECT 1 as month_num UNION ALL SELECT 2 UNION ALL SELECT 3) m
CROSS JOIN products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND EXTRACT(MONTH FROM o.order_date) = m.month_num
GROUP BY m.month_num, p.product_name;
```

**3. Testing Scenarios:**
```sql
SELECT env.name, cfg.name, test.name
FROM environments env
CROSS JOIN configurations cfg
CROSS JOIN tests tst;
```

### Performance & Best Practices

**FULL OUTER JOIN:**
- More expensive than INNER/LEFT JOIN
- Use when you truly need all rows from both sides
- Always use COALESCE() for NULL handling

**CROSS JOIN:**
- Can produce HUGE result sets (1000 × 1000 = 1,000,000 rows!)
- Always add WHERE filters when possible
- Test with LIMIT first on large tables

### Common Mistakes

**1. Accidental CROSS JOIN:**
```sql
-- Wrong - forgot ON condition!
SELECT * FROM table1, table2;

-- Correct
SELECT * FROM table1 INNER JOIN table2 ON table1.id = table2.id;
```

**2. CROSS JOIN on Large Tables:**
```sql
-- Dangerous!
SELECT * FROM customers CROSS JOIN products;  -- Could be millions of rows

-- Better
SELECT * FROM customers c CROSS JOIN products p
WHERE c.city = 'Seattle' LIMIT 100;
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day11.db` with sample data.

### Database Schema

**employees** table: id, name, department_id, salary
**departments** table: id, department_name, location
**products** table: id, product_name, category_id, price
**categories** table: id, category_name
**sizes** table: id, size_name, size_code
**colors** table: id, color_name, color_code
**orders** table: id, customer_id, order_date, total
**customers** table: id, customer_name, email
**system1_users** table: user_id, username, email
**system2_users** table: user_id, username, email

### Part 1: FULL OUTER JOIN Exercises (7 exercises)

### Exercise 1: All Employees and Departments (Easy)
Write a query using FULL OUTER JOIN to get all employees and all departments.
Show employee name and department name.

### Exercise 2: Identify Unmatched Records (Medium)
Write a query using FULL OUTER JOIN to find employees without departments and departments without employees.
Show name, department_name, and status using CASE.

### Exercise 3: Data Reconciliation (Medium)
Compare system1_users and system2_users using FULL OUTER JOIN.
Show user_id, username from both systems, and status.

### Exercise 4: Complete Employee-Department Report (Medium)
Create a complete report with count of employees per department.
Include departments with no employees (show 0).

### Exercise 5: Find Orphaned Records (Medium)
Find orders that reference non-existent customers AND customers without orders.

### Exercise 6: Product-Category Reconciliation (Hard)
Find products without valid categories and categories without products.
Show category_name, product_name, and match_status.

### Exercise 7: Complete Inventory Check (Hard)
Create a report showing all products and all categories with match status.

### Part 2: CROSS JOIN Exercises (6 exercises)

### Exercise 8: All Size-Color Combinations (Easy)
Generate all possible combinations of sizes and colors using CROSS JOIN.

### Exercise 9: Product Variants (Medium)
Generate all possible product variants for the first 5 products.
Combine with all sizes and all colors.

### Exercise 10: Generate SKUs (Medium)
Generate SKU codes for product variants using format: PRODUCT_CODE-SIZE_CODE-COLOR_CODE.
Use the first 3 products only.

### Exercise 11: Price Matrix (Medium)
Create a price matrix showing the first 5 products with discount levels (0%, 10%, 20%, 30%).
Calculate discounted price for each combination.

### Exercise 12: Employee-Department Combinations (Medium)
Show all possible employee-department assignments where the employee is NOT already in that department.
Limit to first 10 employees.

### Exercise 13: Testing Scenarios (Medium)
Generate test scenarios combining the first 3 products with the first 3 categories.
Add a test_scenario_id using ROW_NUMBER().

### Part 3: Combined Exercises (7 exercises)

### Exercise 14: Complete Product Catalog (Hard)
Combine CROSS JOIN and LEFT JOIN to generate all product-size-color combinations for first 3 products.
Show actual sales for each combination (0 if no sales).

### Exercise 15: Sales Grid with Gaps (Hard)
Create a sales grid for months 1-6 and first 5 products.
Show quantity sold for each month-product combination (0 if no sales).

### Exercise 16: Size-Color Availability (Medium)
Show all size-color combinations marked as 'Available' or 'Not Available'.

### Exercise 17: Data Quality Report (Very Hard)
Create a data quality report comparing products table with order_items table.
Count products never ordered and order_items referencing non-existent products.

### Exercise 18: User Sync Report (Hard)
Create a user synchronization report counting users in each category:
- Only in system1
- Only in system2
- In both systems

### Exercise 19: Complete Business Matrix (Very Hard)
Create a business analysis matrix for all categories and months 1-3.
Show product count and total revenue for each category-month combination.

### Exercise 20: Multi-Table Reconciliation (Very Hard)
Reconcile employees and departments showing:
- Total employees and departments
- Employees with/without valid departments
- Departments with/without employees

## Key Takeaways

- **FULL OUTER JOIN returns all rows from both tables** - matched where possible, NULL otherwise
- **Use FULL OUTER JOIN for data reconciliation** - finding mismatches between systems
- **Use FULL OUTER JOIN for complete reports** - including all records from both sides
- **CROSS JOIN creates Cartesian product** - every combination of rows
- **CROSS JOIN result size = rows × rows** - can be huge, use carefully!
- **Use CROSS JOIN to generate combinations** - product variants, test scenarios, calendars
- **Always add WHERE filters to CROSS JOIN** - reduce result size when possible
- **COALESCE handles NULLs in FULL OUTER JOIN** - provide default values
- **CASE statements identify sources** - "Only in A", "Only in B", "In Both"
- **Test with LIMIT first** - especially for CROSS JOIN on large tables

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 12
