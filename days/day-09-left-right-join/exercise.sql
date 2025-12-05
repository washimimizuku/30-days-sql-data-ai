-- Day 9: LEFT and RIGHT JOIN
-- Practice exercises for outer joins
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: Basic LEFT JOIN (6 min)
-- ============================================

-- 1.1: Get all customers with their order count (including customers with 0 orders)
-- TODO: Write your query
-- Hint: LEFT JOIN customers to orders, use COUNT(o.id)
-- Expected columns: customer_name, order_count


-- 1.2: Get all products with total quantity sold (show 0 for never-sold products)
-- TODO: Write your query
-- Hint: Use COALESCE(SUM(oi.quantity), 0)
-- Expected columns: product_name, total_quantity_sold


-- 1.3: Get all employees with their department name (show "No Department" for unassigned)
-- TODO: Write your query
-- Hint: Use COALESCE(d.department_name, 'No Department')
-- Expected columns: name, salary, department_name


-- ============================================
-- Exercise 2: Finding Unmatched Records (8 min)
-- ============================================

-- 2.1: Find all customers who have NEVER placed an order
-- TODO: Write your query
-- Hint: LEFT JOIN with WHERE o.id IS NULL
-- Expected columns: customer_name, email, registration_date


-- 2.2: Find all products that have NEVER been ordered
-- TODO: Write your query
-- Expected columns: product_name, category, price


-- 2.3: Find all employees who are NOT assigned to any department
-- TODO: Write your query
-- Expected columns: name, salary, hire_date


-- 2.4: Find all departments that have NO employees
-- TODO: Write your query
-- Hint: Use RIGHT JOIN or reverse LEFT JOIN
-- Expected columns: department_name, location, budget


-- ============================================
-- Exercise 3: LEFT JOIN with Aggregates (8 min)
-- ============================================

-- 3.1: Get all customers with total amount spent (show 0 for customers with no orders)
-- TODO: Write your query
-- Hint: Use COALESCE(SUM(o.total), 0)
-- Expected columns: customer_name, total_spent


-- 3.2: Get all departments with employee count (including departments with 0 employees)
-- TODO: Write your query
-- Expected columns: department_name, employee_count


-- 3.3: Get all products with times ordered (show 0 for never-ordered products)
-- TODO: Write your query
-- Expected columns: product_name, times_ordered


-- ============================================
-- Exercise 4: Customer Analysis (8 min)
-- ============================================

-- 4.1: Get all customers with order statistics:
--      order_count, total_spent, avg_order_value, last_order_date
--      Show 0/NULL appropriately for customers without orders
-- TODO: Write your query
-- Expected columns: customer_name, order_count, total_spent, avg_order_value, last_order_date


-- 4.2: Find customers who registered more than 365 days ago but never ordered
-- TODO: Write your query
-- Hint: Use CURRENT_DATE - registration_date
-- Expected columns: customer_name, registration_date, days_since_registration


-- ============================================
-- Exercise 5: Product Analysis (6 min)
-- ============================================

-- 5.1: Get all products by category with sales statistics:
--      category, total_products, products_sold (at least once), products_never_sold
-- TODO: Write your query
-- Hint: Use COUNT(DISTINCT p.id) and COUNT(DISTINCT CASE WHEN oi.id IS NOT NULL THEN p.id END)
-- Expected columns: category, total_products, products_sold, products_never_sold


-- 5.2: Get all products with stock < 20 OR never sold
-- TODO: Write your query
-- Expected columns: product_name, stock, times_ordered


-- ============================================
-- Exercise 6: Multiple LEFT JOINs (4 min)
-- ============================================

-- 6.1: Get all customers with order count and total items purchased
-- TODO: Write your query
-- Hint: LEFT JOIN customers → orders → order_items
-- Expected columns: customer_name, order_count, total_items


-- 6.2: Get all employees with department and location (show "Unknown" for missing values)
-- TODO: Write your query
-- Expected columns: name, department_name, location


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Customer segmentation
-- Segment all customers: "High Value" (>1000), "Medium" (100-1000), "Low" (1-99), "No Orders" (0)
-- Expected columns: customer_name, total_spent, segment


-- BONUS 2: Complete product report
-- Show: product_name, stock, quantity_sold, revenue, status
-- Status: "Never Sold", "Low Stock" (stock < 10), or "In Stock"


-- BONUS 3: Department budget analysis
-- Show: department_name, total_salaries, budget, remaining, status
-- Status: "Over Budget", "Under Budget", or "No Employees"
