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

So far you've learned:
- **INNER JOIN** - Only matching rows
- **LEFT JOIN** - All left rows + matches
- **RIGHT JOIN** - All right rows + matches

Today you'll learn:
- **FULL OUTER JOIN** - All rows from both tables
- **CROSS JOIN** - Every combination (Cartesian product)

### What is FULL OUTER JOIN?

FULL OUTER JOIN returns ALL rows from BOTH tables. If no match exists, NULL values are returned for the missing side.

**Think of it as:** "Give me everything from both tables, matched where possible"

**Visual representation:**
```
Table A:        Table B:        FULL OUTER JOIN:
1               1               1 (matched)
2               3               2 (only in A)
4               5               3 (only in B)
                                4 (only in A)
                                5 (only in B)
```

### FULL OUTER JOIN Syntax

```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2
  ON table1.column = table2.column;
```

**Note:** Some databases use `FULL JOIN` (shorthand for `FULL OUTER JOIN`)

### FULL OUTER JOIN Example

```sql
-- Get all employees and all departments
SELECT 
    e.name as employee_name,
    d.department_name
FROM employees e
FULL OUTER JOIN departments d
  ON e.department_id = d.id;
```

**Result includes:**
- Employees WITH departments (matched)
- Employees WITHOUT departments (department_name = NULL)
- Departments WITHOUT employees (employee_name = NULL)

**Example data:**
```
Employees:              Departments:
id | name    | dept_id    id | name
1  | John    | 1          1  | Engineering
2  | Jane    | 2          2  | Sales
3  | Bob     | NULL       3  | Marketing
4  | Alice   | 99         

FULL OUTER JOIN result:
John  | Engineering    (matched)
Jane  | Sales          (matched)
Bob   | NULL           (employee without dept)
Alice | NULL           (employee with invalid dept)
NULL  | Marketing      (department without employees)
```

### When to Use FULL OUTER JOIN

**Use Case 1: Data Reconciliation**
Find mismatches between two systems:
```sql
-- Compare employee records between two systems
SELECT 
    COALESCE(sys1.employee_id, sys2.employee_id) as employee_id,
    sys1.name as system1_name,
    sys2.name as system2_name,
    CASE 
        WHEN sys1.employee_id IS NULL THEN 'Only in System 2'
        WHEN sys2.employee_id IS NULL THEN 'Only in System 1'
        ELSE 'In Both Systems'
    END as status
FROM system1_employees sys1
FULL OUTER JOIN system2_employees sys2
  ON sys1.employee_id = sys2.employee_id;
```

**Use Case 2: Complete Inventory**
Get all products and all orders:
```sql
-- All products and all orders (even unmatched)
SELECT 
    COALESCE(p.product_name, 'Unknown Product') as product,
    COALESCE(o.order_id, 0) as order_id,
    o.order_date
FROM products p
FULL OUTER JOIN order_items oi ON p.id = oi.product_id
FULL OUTER JOIN orders o ON oi.order_id = o.id;
```

**Use Case 3: Finding Orphaned Records**
Identify data integrity issues:
```sql
-- Find orders without customers AND customers without orders
SELECT 
    c.customer_name,
    o.order_id,
    CASE 
        WHEN c.id IS NULL THEN 'Orphaned Order'
        WHEN o.id IS NULL THEN 'Customer Without Orders'
        ELSE 'Valid'
    END as status
FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id
WHERE c.id IS NULL OR o.id IS NULL;
```

### FULL OUTER JOIN vs Other JOINs

```sql
-- INNER JOIN - Only matched (2 rows)
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;
-- Result: Only employees WITH valid departments

-- LEFT JOIN - All left + matches (4 rows)
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;
-- Result: All employees (with or without departments)

-- RIGHT JOIN - All right + matches (3 rows)
SELECT e.name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;
-- Result: All departments (with or without employees)

-- FULL OUTER JOIN - Everything (5 rows)
SELECT e.name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;
-- Result: All employees AND all departments
```

### What is CROSS JOIN?

CROSS JOIN returns the Cartesian product of two tables - every row from the first table combined with every row from the second table.

**Think of it as:** "Give me every possible combination"

**Visual representation:**
```
Table A:    Table B:    CROSS JOIN:
A1          B1          A1, B1
A2          B2          A1, B2
                        A2, B1
                        A2, B2
```

**Formula:** Result rows = Table A rows × Table B rows

### CROSS JOIN Syntax

```sql
-- Explicit syntax
SELECT columns
FROM table1
CROSS JOIN table2;

-- Implicit syntax (older style)
SELECT columns
FROM table1, table2;
```

### CROSS JOIN Example

```sql
-- All combinations of sizes and colors
SELECT 
    s.size_name,
    c.color_name
FROM sizes s
CROSS JOIN colors c;
```

**Example data:**
```
Sizes:          Colors:         CROSS JOIN:
Small           Red             Small, Red
Medium          Blue            Small, Blue
Large           Green           Small, Green
                                Medium, Red
                                Medium, Blue
                                Medium, Green
                                Large, Red
                                Large, Blue
                                Large, Green
```

**Result:** 3 sizes × 3 colors = 9 rows

### When to Use CROSS JOIN

**Use Case 1: Generate All Combinations**
```sql
-- All possible product variants (size × color)
SELECT 
    p.product_name,
    s.size_name,
    c.color_name,
    p.base_price + s.price_modifier + c.price_modifier as final_price
FROM products p
CROSS JOIN sizes s
CROSS JOIN colors c
WHERE p.has_variants = true;
```

**Use Case 2: Create Date Series**
```sql
-- Generate all dates for the year
SELECT 
    m.month_num,
    d.day_num,
    DATE '2024-01-01' + INTERVAL (m.month_num - 1) MONTH + INTERVAL (d.day_num - 1) DAY as date
FROM (SELECT generate_series(1, 12) as month_num) m
CROSS JOIN (SELECT generate_series(1, 31) as day_num) d
WHERE d.day_num <= days_in_month(m.month_num);
```

**Use Case 3: Testing Scenarios**
```sql
-- Test all combinations of settings
SELECT 
    env.environment_name,
    cfg.config_name,
    tst.test_name
FROM environments env
CROSS JOIN configurations cfg
CROSS JOIN tests tst;
```

**Use Case 4: Scheduling**
```sql
-- All possible employee-shift combinations
SELECT 
    e.employee_name,
    s.shift_name,
    s.start_time,
    s.end_time
FROM employees e
CROSS JOIN shifts s
WHERE e.department = s.department;
```

### CROSS JOIN with Filtering

Add WHERE to filter the Cartesian product:

```sql
-- All product-category combinations where price matches range
SELECT 
    p.product_name,
    c.category_name,
    p.price
FROM products p
CROSS JOIN categories c
WHERE p.price BETWEEN c.min_price AND c.max_price;
```

### Practical Example: Product Catalog

```sql
-- Generate complete product catalog with all variants
SELECT 
    p.product_name,
    s.size_name,
    c.color_name,
    m.material_name,
    p.base_price + s.price_add + c.price_add + m.price_add as price,
    CONCAT(p.sku, '-', s.size_code, '-', c.color_code, '-', m.material_code) as sku
FROM base_products p
CROSS JOIN sizes s
CROSS JOIN colors c
CROSS JOIN materials m
WHERE p.category = 'Clothing';
```

### Practical Example: Sales Analysis Grid

```sql
-- Create a grid of all months and all products (even if no sales)
SELECT 
    m.month_name,
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) as quantity_sold,
    COALESCE(SUM(oi.quantity * oi.price), 0) as revenue
FROM (
    SELECT generate_series(1, 12) as month_num,
           to_char(DATE '2024-01-01' + INTERVAL (generate_series(1, 12) - 1) MONTH, 'Month') as month_name
) m
CROSS JOIN products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id 
    AND EXTRACT(MONTH FROM o.order_date) = m.month_num
GROUP BY m.month_num, m.month_name, p.product_name
ORDER BY m.month_num, revenue DESC;
```

### Combining FULL OUTER JOIN and CROSS JOIN

```sql
-- Compare expected vs actual inventory across all locations
SELECT 
    l.location_name,
    p.product_name,
    COALESCE(i.quantity, 0) as actual_quantity,
    e.expected_quantity,
    e.expected_quantity - COALESCE(i.quantity, 0) as variance
FROM locations l
CROSS JOIN products p
LEFT JOIN inventory i ON l.id = i.location_id AND p.id = i.product_id
FULL OUTER JOIN expected_inventory e ON l.id = e.location_id AND p.id = e.product_id;
```

### Performance Considerations

**FULL OUTER JOIN:**
- More expensive than INNER or LEFT JOIN
- Requires scanning both tables completely
- Use when you truly need all rows from both sides

**CROSS JOIN:**
- Can produce HUGE result sets (rows × rows)
- Use with caution on large tables
- Always add WHERE filters when possible
- Example: 1,000 × 1,000 = 1,000,000 rows!

### Best Practices

**FULL OUTER JOIN:**
1. Use COALESCE for NULL handling
2. Add CASE statements to identify source
3. Consider if LEFT/RIGHT JOIN would suffice
4. Use for data reconciliation and auditing

**CROSS JOIN:**
1. Always consider the result size
2. Add WHERE filters to reduce rows
3. Use for generating combinations
4. Test with LIMIT first on large tables

### Common Mistakes

**Mistake 1: Accidental CROSS JOIN**
```sql
-- Wrong - forgot JOIN condition (becomes CROSS JOIN!)
SELECT *
FROM table1, table2;

-- Correct
SELECT *
FROM table1
INNER JOIN table2 ON table1.id = table2.foreign_id;
```

**Mistake 2: CROSS JOIN on Large Tables**
```sql
-- Dangerous - could produce millions of rows
SELECT *
FROM customers
CROSS JOIN products;  -- 10,000 × 5,000 = 50,000,000 rows!

-- Better - add filters
SELECT *
FROM customers c
CROSS JOIN products p
WHERE c.city = 'Seattle' AND p.category = 'Electronics'
LIMIT 100;
```

**Mistake 3: Using FULL OUTER JOIN When Not Needed**
```sql
-- Overkill - LEFT JOIN would work
SELECT e.name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;

-- Better - if you only care about employees
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;
```

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day11.db` with sample data.

### Database Schema

**employees** table:
- id, name, department_id, salary

**departments** table:
- id, department_name, location

**products** table:
- id, product_name, category_id, price

**categories** table:
- id, category_name

**sizes** table:
- id, size_name, size_code

**colors** table:
- id, color_name, color_code

**orders** table:
- id, customer_id, order_date, total

**customers** table:
- id, customer_name, email

**system1_users** table:
- user_id, username, email

**system2_users** table:
- user_id, username, email

### Part 1: FULL OUTER JOIN Exercises

### Exercise 1: All Employees and Departments (Easy)
Write a query using FULL OUTER JOIN to get all employees and all departments.
Show employee name and department name.

**Expected columns:** name, department_name

**Hint:** Some employees may not have departments, some departments may not have employees

### Exercise 2: Identify Unmatched Records (Medium)
Write a query using FULL OUTER JOIN to find:
- Employees without departments
- Departments without employees

Show name, department_name, and status ("Employee Without Dept", "Dept Without Employees", or "Matched").

**Expected columns:** name, department_name, status

**Hint:** Use CASE with IS NULL checks

### Exercise 3: Data Reconciliation (Medium)
Write a query to compare system1_users and system2_users using FULL OUTER JOIN.
Show user_id, username from both systems, and status ("Only in System 1", "Only in System 2", "In Both").

**Expected columns:** user_id, system1_username, system2_username, status

### Exercise 4: Complete Employee-Department Report (Medium)
Write a query using FULL OUTER JOIN to create a complete report:
- All employees (with or without departments)
- All departments (with or without employees)
- Count of employees per department
- Show "Unassigned" for employees without departments
- Show "No Employees" for empty departments

**Expected columns:** department_name, employee_count, status

### Exercise 5: Find Orphaned Records (Medium)
Write a query using FULL OUTER JOIN to find orders that reference non-existent customers AND customers without orders.

**Expected columns:** customer_name, order_id, issue_type

**Hint:** Use WHERE to filter for NULL on either side

### Exercise 6: Product-Category Reconciliation (Hard)
Write a query using FULL OUTER JOIN to find:
- Products without valid categories
- Categories without products
- Count for each situation

**Expected columns:** category_name, product_count, orphaned_products, empty_categories

### Exercise 7: Complete Inventory Check (Hard)
Using FULL OUTER JOIN, create a report showing:
- All products and all categories
- Products in each category
- Products without categories
- Categories without products

**Expected columns:** category_name, product_name, match_status

### Part 2: CROSS JOIN Exercises

### Exercise 8: All Size-Color Combinations (Easy)
Write a query using CROSS JOIN to generate all possible combinations of sizes and colors.

**Expected columns:** size_name, color_name

**Hint:** If you have 3 sizes and 4 colors, you should get 12 rows

### Exercise 9: Product Variants (Medium)
Write a query using CROSS JOIN to generate all possible product variants.
For each product, create combinations with all sizes and all colors.

**Expected columns:** product_name, size_name, color_name

**Hint:** Result should be products × sizes × colors

### Exercise 10: Generate SKUs (Medium)
Write a query using CROSS JOIN to generate SKU codes for all product variants.
SKU format: PRODUCT_CODE-SIZE_CODE-COLOR_CODE

**Expected columns:** product_name, size_name, color_name, sku

**Hint:** Use CONCAT or || to build SKU

### Exercise 11: Price Matrix (Medium)
Write a query using CROSS JOIN to create a price matrix.
Show all products with all possible discount levels (0%, 10%, 20%, 30%).

**Expected columns:** product_name, original_price, discount_pct, discounted_price

**Hint:** Create a subquery or CTE with discount percentages

### Exercise 12: Employee-Shift Combinations (Medium)
Write a query using CROSS JOIN to show all possible employee-department assignments.
Only show combinations where the employee is not already in that department.

**Expected columns:** employee_name, current_dept, potential_dept

**Hint:** Use WHERE to filter out current assignments

### Exercise 13: Testing Scenarios (Medium)
Write a query using CROSS JOIN to generate all test scenarios.
Combine all products with all categories (for testing purposes).

**Expected columns:** product_name, category_name, test_scenario_id

**Hint:** Use ROW_NUMBER() to generate scenario IDs

### Exercise 14: Calendar Grid (Hard)
Write a query using CROSS JOIN to create a calendar grid.
Generate all combinations of months (1-12) and days (1-31).

**Expected columns:** month_num, day_num, date_string

**Hint:** Use generate_series or a numbers table

### Exercise 15: Product Availability Matrix (Hard)
Write a query using CROSS JOIN to create a matrix of all products and all dates in the current month.
Show which products were ordered on which dates.

**Expected columns:** date, product_name, orders_count

**Hint:** CROSS JOIN products with dates, LEFT JOIN to orders

### Part 3: Combined Exercises

### Exercise 16: Complete Product Catalog (Hard)
Write a query combining CROSS JOIN and LEFT JOIN:
- Generate all product-size-color combinations (CROSS JOIN)
- Show actual sales for each combination (LEFT JOIN to order_items)
- Include combinations with 0 sales

**Expected columns:** product_name, size_name, color_name, quantity_sold

### Exercise 17: Sales Grid with Gaps (Hard)
Write a query to create a complete sales grid:
- All months (1-12)
- All products
- Show sales for each month-product combination (0 if no sales)

**Expected columns:** month_num, product_name, quantity_sold, revenue

**Hint:** CROSS JOIN months and products, LEFT JOIN to sales data

### Exercise 18: Employee-Department Matrix (Hard)
Write a query to show which employees could work in which departments:
- Use CROSS JOIN to show all possible assignments
- Use FULL OUTER JOIN to include current assignments
- Mark current assignments differently

**Expected columns:** employee_name, department_name, assignment_type

### Exercise 19: Data Quality Report (Very Hard)
Write a query using FULL OUTER JOIN to create a data quality report:
- Compare products table with order_items table
- Find products never ordered
- Find order_items referencing non-existent products
- Count issues by type

**Expected columns:** issue_type, count, example_ids

### Exercise 20: Complete Business Matrix (Very Hard)
Write a query to create a complete business analysis matrix:
- All categories
- All months
- Show products, orders, and revenue for each category-month combination
- Include categories/months with no activity

**Expected columns:** category_name, month_num, product_count, order_count, revenue

**Hint:** Multiple CROSS JOINs and LEFT JOINs

### Part 4: Advanced Challenges

### Exercise 21: Size-Color Availability (Medium)
Write a query to show which size-color combinations are actually available in inventory.
Use CROSS JOIN to generate all combinations, then filter for available ones.

**Expected columns:** size_name, color_name, available (true/false)

### Exercise 22: Missing Combinations (Hard)
Write a query to find size-color combinations that should exist but don't have any products.
Use CROSS JOIN to generate expected combinations, LEFT JOIN to actual products.

**Expected columns:** size_name, color_name, product_count

**Hint:** Filter for product_count = 0

### Exercise 23: User Sync Report (Hard)
Write a query using FULL OUTER JOIN to create a user synchronization report:
- Compare system1_users and system2_users
- Show users only in system1
- Show users only in system2
- Show users in both with different data
- Count each category

**Expected columns:** sync_status, user_count

### Exercise 24: Product Variant Sales Analysis (Very Hard)
Write a query to analyze sales by product variant:
- Generate all possible variants (CROSS JOIN products, sizes, colors)
- Join to actual sales data
- Show variants with sales and without sales
- Calculate percentage of variants that have sold

**Expected columns:** total_variants, variants_sold, variants_not_sold, sold_percentage

### Exercise 25: Complete Reconciliation Report (Very Hard)
Write a query using FULL OUTER JOIN to reconcile multiple tables:
- Employees and departments
- Products and categories
- Orders and customers
- Show counts of matched and unmatched records for each pair

**Expected columns:** table_pair, matched_count, left_unmatched, right_unmatched

### Exercise 26: Time Series with Gaps (Hard)
Write a query to create a complete time series:
- Generate all dates in a range (CROSS JOIN or generate_series)
- Show orders for each date (LEFT JOIN)
- Include dates with 0 orders

**Expected columns:** date, order_count, total_revenue

### Exercise 27: Product Comparison Matrix (Hard)
Write a query using CROSS JOIN to compare all products with each other:
- Show product pairs
- Calculate price difference
- Only show pairs where products are in the same category

**Expected columns:** product1_name, product2_name, price_difference

**Hint:** CROSS JOIN products with itself, filter for same category

### Exercise 28: Complete Inventory Grid (Very Hard)
Write a query to create a complete inventory grid:
- All products
- All sizes
- All colors
- Show actual inventory quantity (0 if not in stock)
- Show total value

**Expected columns:** product_name, size_name, color_name, quantity, value

### Exercise 29: Multi-System Reconciliation (Very Hard)
Write a query using multiple FULL OUTER JOINs to reconcile three systems:
- system1_users
- system2_users
- A third system (create with subquery)
- Show which users exist in which systems

**Expected columns:** user_id, in_system1, in_system2, in_system3, sync_status

### Exercise 30: Complete Business Dashboard (Very Hard)
Write a query combining CROSS JOIN and FULL OUTER JOIN to create a dashboard:
- All categories × all months (CROSS JOIN)
- All products (FULL OUTER JOIN)
- Show sales data for each combination
- Include categories/months/products with no activity
- Calculate totals and percentages

**Expected columns:** category_name, month_num, product_count, order_count, revenue, pct_of_total

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
