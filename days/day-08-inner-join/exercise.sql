-- Day 8: INNER JOIN
-- Practice exercises for joining tables
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: Basic INNER JOIN (8 min)
-- ============================================

-- 1.1: Join employees with departments, show name and department_name
-- TODO: Write your query
-- Expected columns: name, department_name


-- 1.2: Join products with categories, show product_name and category_name
-- TODO: Write your query
-- Expected columns: product_name, category_name


-- 1.3: Join orders with customers, show order_id, order_date, and customer_name
-- TODO: Write your query
-- Expected columns: order_id, order_date, customer_name


-- 1.4: Join employees with departments, show employee name, salary, and department_name
-- TODO: Write your query
-- Expected columns: name, salary, department_name


-- ============================================
-- Exercise 2: Using Table Aliases (6 min)
-- ============================================

-- 2.1: Join employees (e) with departments (d), select e.name, e.salary, d.department_name
-- TODO: Write your query using aliases


-- 2.2: Join products (p) with categories (c), select p.product_name, p.price, c.category_name
-- TODO: Write your query using aliases


-- 2.3: Join orders (o) with customers (c), select o.id, c.customer_name, o.total
-- TODO: Write your query using aliases


-- ============================================
-- Exercise 3: INNER JOIN with WHERE (8 min)
-- ============================================

-- 3.1: Join employees with departments, only show Engineering department
-- TODO: Write your query
-- Hint: WHERE d.department_name = 'Engineering'
-- Expected columns: name, department_name, salary


-- 3.2: Join products with categories, only show products with price > 100
-- TODO: Write your query
-- Expected columns: product_name, category_name, price


-- 3.3: Join orders with customers, only show orders from 2024
-- TODO: Write your query
-- Hint: WHERE o.order_date >= '2024-01-01'
-- Expected columns: order_id, customer_name, order_date, total


-- 3.4: Join employees with departments, only show active employees with salary > 70000
-- TODO: Write your query
-- Expected columns: name, department_name, salary


-- ============================================
-- Exercise 4: Multiple Table JOINs (8 min)
-- ============================================

-- 4.1: Join employees → departments → locations
--      Show: employee name, department name, city
-- TODO: Write your query
-- Expected columns: name, department_name, city


-- 4.2: Join order_items → orders → customers
--      Show: order_id, customer_name, product_id, quantity
-- TODO: Write your query
-- Expected columns: order_id, customer_name, product_id, quantity


-- 4.3: Join products → categories, show product_name, category_name, price
--      Only products in stock, order by price DESC
-- TODO: Write your query
-- Expected columns: product_name, category_name, price


-- ============================================
-- Exercise 5: INNER JOIN with Aggregates (6 min)
-- ============================================

-- 5.1: Count employees per department
-- TODO: Write your query
-- Hint: GROUP BY d.department_name
-- Expected columns: department_name, employee_count


-- 5.2: Sum total sales per customer
-- TODO: Write your query
-- Hint: SUM(o.total), GROUP BY c.customer_name
-- Expected columns: customer_name, total_spent


-- 5.3: Count products per category
-- TODO: Write your query
-- Expected columns: category_name, product_count


-- ============================================
-- Exercise 6: Complex Queries (4 min)
-- ============================================

-- 6.1: Top 10 customers by total spending
--      Join orders with customers, aggregate, order by total DESC, limit 10
-- TODO: Write your query
-- Expected columns: customer_name, total_spent


-- 6.2: Department report: dept name, location city, employee count, avg salary
--      Join employees → departments → locations, group by dept and city
-- TODO: Write your query
-- Expected columns: department_name, city, employee_count, avg_salary


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Order details with full information
-- Join order_items → products → categories → orders → customers
-- Show: customer_name, product_name, category_name, quantity, price
-- Order by customer_name


-- BONUS 2: Employee directory with full details
-- Join employees → departments → locations
-- Show: name, department_name, city, country, salary
-- Only active employees, order by salary DESC


-- BONUS 3: Product sales summary
-- Join order_items → products → categories
-- Show: category_name, product_name, times_ordered, total_quantity, total_revenue
-- Group by category and product, order by total_revenue DESC
