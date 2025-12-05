# Day 9: LEFT and RIGHT JOIN

## Learning Objectives
- Understand LEFT JOIN for keeping all left table rows
- Understand RIGHT JOIN for keeping all right table rows
- Learn to find missing/unmatched records
- Master NULL handling in outer joins
- Practice with real queries
- Build practical SQL skills

## Theory (15 minutes)

### What is LEFT JOIN?

LEFT JOIN returns ALL rows from the left table, and matching rows from the right table. If no match exists, NULL values are returned for right table columns.

**Think of it as:** "Give me everything from the left table, plus matching data from the right table if it exists"

### LEFT JOIN Syntax

```sql
SELECT columns
FROM left_table
LEFT JOIN right_table
  ON left_table.column = right_table.column;
```

### LEFT JOIN Example

```sql
-- Get all employees with their department (if they have one)
SELECT 
    e.name,
    e.salary,
    d.department_name
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.id;
```

**Result includes:**
- Employees WITH departments (matched)
- Employees WITHOUT departments (department_name = NULL)

**Example data:**
```
Employees:              Departments:
id | name    | dept_id    id | name
1  | John    | 1          1  | Engineering
2  | Jane    | 2          2  | Sales
3  | Bob     | NULL       
4  | Alice   | 99         

LEFT JOIN result:
John  | 75000 | Engineering
Jane  | 80000 | Sales
Bob   | 70000 | NULL         (no department)
Alice | 85000 | NULL         (dept 99 doesn't exist)
```

### Finding Unmatched Records

Use LEFT JOIN with WHERE to find records without matches:

```sql
-- Find employees WITHOUT departments
SELECT 
    e.name,
    e.salary
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.id
WHERE d.id IS NULL;
```

**This is a common pattern for finding:**
- Customers who never ordered
- Products never sold
- Employees without departments
- Orders without payments

### LEFT JOIN vs INNER JOIN

```sql
-- INNER JOIN - Only matched rows
SELECT e.name, d.department_name
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id;
-- Result: Only employees WITH departments

-- LEFT JOIN - All left rows
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.id;
-- Result: ALL employees (with or without departments)
```

### LEFT JOIN with WHERE

Filter AFTER joining:

```sql
-- All employees in Engineering (including those without dept)
SELECT e.name, d.department_name
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.id
WHERE d.department_name = 'Engineering' 
   OR d.department_name IS NULL;

-- All employees with salary > 70000
SELECT e.name, e.salary, d.department_name
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.id
WHERE e.salary > 70000;
```

### LEFT JOIN Multiple Tables

Chain multiple LEFT JOINs:

```sql
-- All employees with department and location (if they exist)
SELECT 
    e.name,
    d.department_name,
    l.city
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.id
LEFT JOIN locations l
  ON d.location_id = l.id;
```

### What is RIGHT JOIN?

RIGHT JOIN returns ALL rows from the right table, and matching rows from the left table. If no match exists, NULL values are returned for left table columns.

**Think of it as:** "Give me everything from the right table, plus matching data from the left table if it exists"

### RIGHT JOIN Syntax

```sql
SELECT columns
FROM left_table
RIGHT JOIN right_table
  ON left_table.column = right_table.column;
```

### RIGHT JOIN Example

```sql
-- Get all departments with their employees (if they have any)
SELECT 
    e.name,
    d.department_name
FROM employees e
RIGHT JOIN departments d
  ON e.department_id = d.id;
```

**Result includes:**
- Departments WITH employees (matched)
- Departments WITHOUT employees (employee name = NULL)

### RIGHT JOIN vs LEFT JOIN

These are equivalent (just reversed):

```sql
-- RIGHT JOIN
SELECT e.name, d.department_name
FROM employees e
RIGHT JOIN departments d
  ON e.department_id = d.id;

-- Same as LEFT JOIN (reversed tables)
SELECT e.name, d.department_name
FROM departments d
LEFT JOIN employees e
  ON e.department_id = d.id;
```

**Note:** LEFT JOIN is more common and readable. Most developers prefer LEFT JOIN and rarely use RIGHT JOIN.

### Finding Unmatched Records with RIGHT JOIN

```sql
-- Find departments WITHOUT employees
SELECT 
    d.department_name,
    d.location
FROM employees e
RIGHT JOIN departments d
  ON e.department_id = d.id
WHERE e.id IS NULL;
```

### Practical Examples

**Example 1: Customers and Orders**
```sql
-- All customers with their order count (including customers with 0 orders)
SELECT 
    c.customer_name,
    c.email,
    COUNT(o.id) as order_count,
    COALESCE(SUM(o.total), 0) as total_spent
FROM customers c
LEFT JOIN orders o
  ON c.id = o.customer_id
GROUP BY c.customer_name, c.email
ORDER BY total_spent DESC;
```

**Example 2: Products and Sales**
```sql
-- All products with total sold (including never-sold products)
SELECT 
    p.product_name,
    p.price,
    COALESCE(SUM(oi.quantity), 0) as total_sold
FROM products p
LEFT JOIN order_items oi
  ON p.id = oi.product_id
GROUP BY p.product_name, p.price
ORDER BY total_sold DESC;
```

**Example 3: Finding Inactive Customers**
```sql
-- Customers who never placed an order
SELECT 
    c.customer_name,
    c.email,
    c.registration_date
FROM customers c
LEFT JOIN orders o
  ON c.id = o.customer_id
WHERE o.id IS NULL;
```

**Example 4: Products Never Ordered**
```sql
-- Products that have never been sold
SELECT 
    p.product_name,
    p.price,
    p.category
FROM products p
LEFT JOIN order_items oi
  ON p.id = oi.product_id
WHERE oi.id IS NULL;
```

**Example 5: Complete Customer Report**
```sql
-- All customers with order statistics
SELECT 
    c.customer_name,
    c.email,
    COUNT(o.id) as order_count,
    COALESCE(SUM(o.total), 0) as total_spent,
    COALESCE(AVG(o.total), 0) as avg_order_value,
    MAX(o.order_date) as last_order_date
FROM customers c
LEFT JOIN orders o
  ON c.id = o.customer_id
GROUP BY c.customer_name, c.email
ORDER BY total_spent DESC;
```

### NULL Handling in Outer Joins

When no match exists, right table columns are NULL:

```sql
-- Use COALESCE to provide defaults
SELECT 
    e.name,
    COALESCE(d.department_name, 'No Department') as department,
    COALESCE(d.location, 'Unknown') as location
FROM employees e
LEFT JOIN departments d
  ON e.department_id = d.id;
```

### Combining INNER and LEFT JOINs

```sql
-- All employees with departments (required) and locations (optional)
SELECT 
    e.name,
    d.department_name,  -- Required (INNER JOIN)
    l.city              -- Optional (LEFT JOIN)
FROM employees e
INNER JOIN departments d
  ON e.department_id = d.id
LEFT JOIN locations l
  ON d.location_id = l.id;
```

### Common Use Cases

**LEFT JOIN is perfect for:**
1. **Finding missing relationships**
   - Customers without orders
   - Products never sold
   - Employees without departments

2. **Including all records with optional details**
   - All customers (with or without orders)
   - All products (with or without sales)
   - All employees (with or without departments)

3. **Counting with zeros**
   - Customer order counts (including 0)
   - Product sales (including 0)
   - Department employee counts (including 0)

4. **Reporting with optional data**
   - Customer report (some have orders, some don't)
   - Product catalog (some sold, some not)
   - Employee directory (some have departments, some don't)

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day09.db` with sample data.

### Database Schema

**customers** table:
- id, customer_name, email, city, registration_date

**orders** table:
- id, customer_id, order_date, total, status

**products** table:
- id, product_name, category, price, stock

**order_items** table:
- id, order_id, product_id, quantity, price

**employees** table:
- id, name, department_id, salary, hire_date

**departments** table:
- id, department_name, location, budget

### Exercise 1: Basic LEFT JOIN (Easy)
Write a query to get all customers with their order count (including customers with 0 orders).

**Expected columns:** customer_name, email, order_count

**Hint:** Use LEFT JOIN and COUNT()

### Exercise 2: Find Unmatched Records (Easy)
Write a query to find all customers who have NEVER placed an order.

**Expected columns:** customer_name, email, registration_date

**Hint:** Use LEFT JOIN with WHERE ... IS NULL

### Exercise 3: Products Never Sold (Easy)
Write a query to find all products that have never been ordered.

**Expected columns:** product_name, category, price

**Hint:** LEFT JOIN products to order_items, filter for NULL

### Exercise 4: All Customers with Total Spent (Medium)
Write a query to get all customers with their total amount spent (show 0 for customers with no orders).

**Expected columns:** customer_name, total_spent (use COALESCE for 0)

**Hint:** Use LEFT JOIN, SUM(), and COALESCE()

### Exercise 5: Customer Order Statistics (Medium)
Write a query to get all customers with:
- Number of orders
- Total spent
- Average order value
- Last order date

Show 0/NULL appropriately for customers without orders.

**Expected columns:** customer_name, order_count, total_spent, avg_order_value, last_order_date

### Exercise 6: Products with Sales Count (Medium)
Write a query to get all products with the total quantity sold (show 0 for never-sold products).

**Expected columns:** product_name, category, price, total_quantity_sold

**Hint:** Use COALESCE to convert NULL to 0

### Exercise 7: Employees with Departments (Medium)
Write a query to get all employees with their department name (show "No Department" for employees without a department).

**Expected columns:** name, salary, department_name (use COALESCE)

### Exercise 8: Departments with Employee Count (Medium)
Write a query to get all departments with their employee count (including departments with 0 employees).

**Expected columns:** department_name, location, employee_count

**Hint:** Use RIGHT JOIN or reverse the LEFT JOIN

### Exercise 9: Find Inactive Customers (Medium)
Write a query to find customers who registered more than 6 months ago but never placed an order.

**Expected columns:** customer_name, email, registration_date, days_since_registration

**Hint:** Use LEFT JOIN with WHERE ... IS NULL and date functions

### Exercise 10: Products by Category with Sales (Medium)
Write a query to get all products grouped by category with:
- Number of products
- Number of products sold (at least once)
- Number of products never sold

**Expected columns:** category, total_products, products_sold, products_never_sold

### Exercise 11: Customer City Analysis (Medium)
Write a query to get all cities with:
- Number of customers
- Number of customers who placed orders
- Number of customers who never ordered

**Expected columns:** city, total_customers, active_customers, inactive_customers

### Exercise 12: Multiple LEFT JOINs (Medium)
Write a query to get all customers with their order count and total items purchased.

**Expected columns:** customer_name, order_count, total_items

**Hint:** LEFT JOIN customers → orders → order_items

### Exercise 13: Product Inventory Report (Hard)
Write a query to get all products with:
- Current stock
- Total quantity sold
- Revenue generated
- Status: "Never Sold", "Low Stock" (stock < 10), or "In Stock"

**Expected columns:** product_name, stock, quantity_sold, revenue, status

### Exercise 14: Customer Segmentation (Hard)
Write a query to segment all customers into:
- "High Value" (total spent > 1000)
- "Medium Value" (total spent 100-1000)
- "Low Value" (total spent 1-99)
- "No Orders" (never ordered)

**Expected columns:** customer_name, total_spent, segment

### Exercise 15: Department Budget Analysis (Hard)
Write a query to get all departments with:
- Total employee salaries
- Budget
- Budget remaining (budget - salaries)
- Status: "Over Budget", "Under Budget", or "No Employees"

**Expected columns:** department_name, total_salaries, budget, remaining, status

### Exercise 16: Find Orphaned Records (Hard)
Write a query to find all orders that reference non-existent customers (data integrity check).

**Expected columns:** order_id, customer_id, order_date, total

**Hint:** Use RIGHT JOIN or reverse LEFT JOIN

### Exercise 17: Product Performance by Category (Hard)
Write a query to get all categories with:
- Total products
- Products sold at least once
- Total revenue
- Average price
- Best selling product name

**Expected columns:** category, total_products, products_sold, total_revenue, avg_price, best_product

### Exercise 18: Customer Lifetime Value (Hard)
Write a query to get all customers with:
- First order date
- Last order date
- Days as customer (last order - first order)
- Total orders
- Total spent
- Average days between orders

Show NULL appropriately for customers without orders.

**Expected columns:** customer_name, first_order, last_order, days_active, order_count, total_spent, avg_days_between

### Exercise 19: Employees Without Departments (Easy)
Write a query to find all employees who are not assigned to any department.

**Expected columns:** name, salary, hire_date

### Exercise 20: Departments Without Employees (Easy)
Write a query to find all departments that have no employees.

**Expected columns:** department_name, location, budget

### Exercise 21: All Employees with Department Info (Medium)
Write a query to get all employees with department name and location (show "Unassigned" for missing values).

**Expected columns:** name, salary, department_name, location

### Exercise 22: Customer Order Frequency (Hard)
Write a query to get all customers with:
- Total orders
- Total spent
- Average order value
- Order frequency: "Frequent" (>5 orders), "Regular" (2-5), "One-time" (1), "Never" (0)

**Expected columns:** customer_name, order_count, total_spent, avg_order_value, frequency

### Exercise 23: Product Stock Alert (Medium)
Write a query to get all products with stock less than 20 OR never sold, showing:
- Product name
- Stock level
- Times sold
- Alert type: "Never Sold", "Low Stock", or "Both"

**Expected columns:** product_name, stock, times_sold, alert_type

### Exercise 24: Complete Customer Report (Hard)
Write a query to create a complete customer report with:
- Customer name and email
- Registration date
- Days since registration
- Number of orders
- Total spent
- Average order value
- Last order date
- Days since last order (NULL if never ordered)
- Status: "Active" (ordered in last 30 days), "Inactive" (ordered but not recently), "Never Ordered"

**Expected columns:** customer_name, email, registration_date, days_registered, order_count, total_spent, avg_order_value, last_order_date, days_since_last_order, status

### Exercise 25: Category Performance Matrix (Hard)
Write a query to get all categories with:
- Total products
- Products in stock (stock > 0)
- Products out of stock
- Products sold
- Products never sold
- Total revenue
- Average product price

**Expected columns:** category, total_products, in_stock, out_of_stock, sold_products, never_sold, total_revenue, avg_price

### Exercise 26: Employee Department Summary (Medium)
Write a query to get all departments with:
- Number of employees
- Average salary
- Total salary cost
- Highest paid employee name

Include departments with 0 employees.

**Expected columns:** department_name, employee_count, avg_salary, total_salary, highest_paid

### Exercise 27: Customer Purchase Patterns (Hard)
Write a query to analyze customer purchase patterns:
- Customer name
- Total orders
- Total items purchased
- Average items per order
- Most purchased category
- Total spent

Include customers with 0 orders.

**Expected columns:** customer_name, order_count, total_items, avg_items_per_order, favorite_category, total_spent

### Exercise 28: Product Availability Report (Medium)
Write a query to get all products with:
- Product name
- Stock level
- Times ordered
- Last order date
- Days since last order
- Availability status: "In Stock & Selling", "In Stock & Not Selling", "Out of Stock", "Never Sold"

**Expected columns:** product_name, stock, times_ordered, last_order_date, days_since_last_order, status

### Exercise 29: Cross-Department Analysis (Hard)
Write a query to compare all departments:
- Department name
- Employee count
- Average salary
- Budget utilization percentage
- Status: "Over Budget", "Well Utilized" (80-100%), "Under Utilized" (<80%), "No Employees"

**Expected columns:** department_name, employee_count, avg_salary, budget_utilization_pct, status

### Exercise 30: Complete Business Dashboard (Very Hard)
Write a query to create a complete business dashboard showing:
- Total customers
- Active customers (placed at least one order)
- Inactive customers
- Total products
- Products sold
- Products never sold
- Total orders
- Total revenue
- Average order value
- Total employees
- Employees with departments
- Employees without departments

**Hint:** Use multiple subqueries or CTEs with LEFT JOINs

**Expected columns:** total_customers, active_customers, inactive_customers, total_products, products_sold, products_never_sold, total_orders, total_revenue, avg_order_value, total_employees, employees_with_dept, employees_without_dept

## Key Takeaways

- **LEFT JOIN keeps all left table rows** - matching right table data or NULL
- **RIGHT JOIN keeps all right table rows** - matching left table data or NULL
- **Find unmatched records** - Use LEFT JOIN with WHERE right_table.id IS NULL
- **LEFT JOIN is more common** - Most developers prefer LEFT JOIN over RIGHT JOIN
- **Use COALESCE for defaults** - Convert NULL to 0 or default values
- **Perfect for reporting** - Include all records even without relationships
- **Essential for data analysis** - Find missing data, calculate with zeros
- **Combine with aggregates** - COUNT, SUM, AVG work great with LEFT JOIN
- **Multiple LEFT JOINs** - Chain them for complex queries
- **NULL handling is critical** - Always consider NULL values in outer joins

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 10
