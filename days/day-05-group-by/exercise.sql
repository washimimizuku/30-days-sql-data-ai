-- Day 5: GROUP BY Basics
-- Practice exercises for grouping and aggregating data
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: GROUP BY with COUNT (6 min)
-- ============================================

-- 1.1: Count employees in each department
-- TODO: Write your query
-- Expected columns: department, employee_count


-- 1.2: Count products in each category
-- TODO: Write your query
-- Expected columns: category, product_count


-- 1.3: Count orders per customer
-- TODO: Write your query
-- Expected columns: customer_id, order_count


-- 1.4: Count employees in each city
-- TODO: Write your query
-- Expected columns: city, employee_count


-- ============================================
-- Exercise 2: GROUP BY with SUM (6 min)
-- ============================================

-- 2.1: Calculate total payroll per department
-- TODO: Write your query
-- Expected columns: department, total_payroll


-- 2.2: Calculate total sales amount per product
-- TODO: Write your query using sales table
-- Expected columns: product_name, total_sales


-- 2.3: Calculate total revenue per customer
-- TODO: Write your query using orders table
-- Expected columns: customer_id, total_revenue


-- 2.4: Calculate total quantity sold per region
-- TODO: Write your query using sales table
-- Expected columns: region, total_quantity


-- ============================================
-- Exercise 3: GROUP BY with AVG (6 min)
-- ============================================

-- 3.1: Calculate average salary per department
-- TODO: Write your query
-- Expected columns: department, avg_salary (rounded to 2 decimals)


-- 3.2: Calculate average price per category
-- TODO: Write your query
-- Expected columns: category, avg_price


-- 3.3: Calculate average order value per customer
-- TODO: Write your query
-- Expected columns: customer_id, avg_order_value


-- 3.4: Calculate average age per department
-- TODO: Write your query
-- Expected columns: department, avg_age


-- ============================================
-- Exercise 4: GROUP BY with MIN and MAX (6 min)
-- ============================================

-- 4.1: Find lowest and highest salary in each department
-- TODO: Write your query
-- Expected columns: department, min_salary, max_salary


-- 4.2: Find cheapest and most expensive product in each category
-- TODO: Write your query
-- Expected columns: category, min_price, max_price


-- 4.3: Find earliest and latest hire date per department
-- TODO: Write your query
-- Expected columns: department, earliest_hire, latest_hire


-- 4.4: Find smallest and largest order per customer
-- TODO: Write your query
-- Expected columns: customer_id, min_order, max_order


-- ============================================
-- Exercise 5: Multiple Aggregates (6 min)
-- ============================================

-- 5.1: For each department: count, avg salary, min salary, max salary
-- TODO: Write your query
-- Expected columns: department, employee_count, avg_salary, min_salary, max_salary


-- 5.2: For each category: count products, avg price, total inventory value
-- TODO: Write your query
-- Hint: total value = SUM(price * quantity)
-- Expected columns: category, product_count, avg_price, total_value


-- 5.3: For each customer: count orders, total spent, avg order value
-- TODO: Write your query
-- Expected columns: customer_id, order_count, total_spent, avg_order_value


-- ============================================
-- Exercise 6: GROUP BY Multiple Columns (6 min)
-- ============================================

-- 6.1: Count employees by department AND city
-- TODO: Write your query
-- Expected columns: department, city, employee_count


-- 6.2: Sum sales by product AND region
-- TODO: Write your query using sales table
-- Expected columns: product_name, region, total_sales


-- 6.3: Average salary by department AND job_title
-- TODO: Write your query
-- Expected columns: department, job_title, avg_salary


-- ============================================
-- Exercise 7: GROUP BY with WHERE (4 min)
-- ============================================

-- 7.1: Average salary per department (only active employees)
-- TODO: Write your query
-- Hint: Use WHERE is_active = TRUE before GROUP BY
-- Expected columns: department, avg_salary


-- 7.2: Total sales per product (only sales from 2024)
-- TODO: Write your query
-- Hint: Use WHERE sale_date >= '2024-01-01'
-- Expected columns: product_name, total_sales_2024


-- 7.3: Count employees per city (only hired after 2020)
-- TODO: Write your query
-- Expected columns: city, employee_count


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Department report with all statistics, ordered by total payroll DESC
-- Columns: department, count, avg_salary, total_payroll, min_salary, max_salary
-- Hint: Use ORDER BY after GROUP BY


-- BONUS 2: Product performance by category
-- Show: category, product_count, total_sold (sum of quantity from sales), avg_price
-- Order by total_sold DESC


-- BONUS 3: Customer analysis - top 10 customers by total spent
-- Show: customer_id, order_count, total_spent, avg_order_value
-- Order by total_spent DESC, limit to 10
