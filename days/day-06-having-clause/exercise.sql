-- Day 6: HAVING Clause
-- Practice exercises for filtering groups
-- Total time: ~40 minutes

-- ============================================
-- Exercise 1: HAVING with COUNT (6 min)
-- ============================================

-- 1.1: Find departments with more than 15 employees
-- TODO: Write your query
-- Expected columns: department, employee_count


-- 1.2: Find customers with more than 5 orders
-- TODO: Write your query
-- Expected columns: customer_id, order_count


-- 1.3: Find categories with fewer than 10 products
-- TODO: Write your query
-- Expected columns: category, product_count


-- 1.4: Find cities with at least 20 employees
-- TODO: Write your query
-- Expected columns: city, employee_count


-- ============================================
-- Exercise 2: HAVING with SUM (6 min)
-- ============================================

-- 2.1: Find departments with total payroll over $1,000,000
-- TODO: Write your query
-- Expected columns: department, total_payroll


-- 2.2: Find customers who spent more than $10,000
-- TODO: Write your query
-- Expected columns: customer_id, total_spent


-- 2.3: Find products with total sales over 500 units
-- TODO: Write your query using sales table
-- Expected columns: product_id, total_quantity


-- 2.4: Find categories with total inventory value over $50,000
-- TODO: Write your query
-- Hint: SUM(price * quantity) - but we don't have quantity in products, use COUNT(*) * AVG(price) as approximation
-- Or just use SUM(price) for simplicity
-- Expected columns: category, total_value


-- ============================================
-- Exercise 3: HAVING with AVG (6 min)
-- ============================================

-- 3.1: Find departments with average salary above $80,000
-- TODO: Write your query
-- Expected columns: department, avg_salary


-- 3.2: Find categories with average price over $200
-- TODO: Write your query
-- Expected columns: category, avg_price


-- 3.3: Find customers with average order value over $500
-- TODO: Write your query
-- Expected columns: customer_id, avg_order_value


-- 3.4: Find products with average rating above 4.5
-- TODO: Write your query
-- Expected columns: category, avg_rating (group by category)


-- ============================================
-- Exercise 4: HAVING with MIN and MAX (5 min)
-- ============================================

-- 4.1: Find departments where minimum salary is above $50,000
-- TODO: Write your query
-- Expected columns: department, min_salary


-- 4.2: Find categories where maximum price is over $1000
-- TODO: Write your query
-- Expected columns: category, max_price


-- 4.3: Find departments where salary range (MAX - MIN) is over $80,000
-- TODO: Write your query
-- Expected columns: department, min_salary, max_salary, salary_range


-- ============================================
-- Exercise 5: WHERE vs HAVING (6 min)
-- ============================================

-- 5.1: Count active employees per department, only departments with > 10 active employees
-- TODO: Write your query
-- Hint: Use WHERE is_active = TRUE, then HAVING COUNT(*) > 10
-- Expected columns: department, active_count


-- 5.2: Average salary per city for employees hired after 2020, only cities with avg > $75,000
-- TODO: Write your query
-- Expected columns: city, avg_salary


-- 5.3: Total sales per product in 2024, only products with sales > $20,000
-- TODO: Write your query
-- Hint: WHERE sale_date >= '2024-01-01', then HAVING SUM(amount) > 20000
-- Expected columns: product_id, total_sales_2024


-- ============================================
-- Exercise 6: Multiple Conditions in HAVING (5 min)
-- ============================================

-- 6.1: Departments with > 15 employees AND average salary > $75,000
-- TODO: Write your query
-- Expected columns: department, employee_count, avg_salary


-- 6.2: Categories with > 20 products OR average price > $300
-- TODO: Write your query
-- Expected columns: category, product_count, avg_price


-- 6.3: Customers with > 8 orders AND total spent > $8000
-- TODO: Write your query
-- Expected columns: customer_id, order_count, total_spent


-- ============================================
-- Exercise 7: Complete Queries (6 min)
-- ============================================

-- 7.1: Active employees by department: count, avg salary
--      Only departments with > 10 active employees and avg > $70,000
--      Order by avg salary DESC
-- TODO: Write your query


-- 7.2: 2024 sales by product: total quantity, total revenue
--      Only products with > 200 units sold
--      Order by revenue DESC
-- TODO: Write your query


-- 7.3: Customer analysis: order count, total spent, avg order value
--      Only customers with > 5 orders
--      Order by total spent DESC
-- TODO: Write your query


-- ============================================
-- Bonus Challenges (Optional)
-- ============================================

-- BONUS 1: Find departments where the salary range (MAX - MIN) is greater than $100,000
-- Show: department, min_salary, max_salary, salary_range
-- Order by salary_range DESC


-- BONUS 2: Find categories where the price variance is high (MAX price > 5 * AVG price)
-- Show: category, avg_price, max_price, price_ratio (max/avg)


-- BONUS 3: Find customers whose total spending is more than 15 times their average order value
-- Show: customer_id, order_count, total_spent, avg_order, spending_ratio
-- Hint: HAVING SUM(total) > 15 * AVG(total)
