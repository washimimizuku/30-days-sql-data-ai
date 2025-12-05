-- Day 12: Self Joins
-- Joining a table to itself

-- Connect to database:
-- duckdb ../../data/databases/day12.db

-- ============================================
-- PART 1: EMPLOYEE-MANAGER RELATIONSHIPS
-- ============================================

-- Exercise 1: Employees with Managers (Easy)
-- Write a query to show all employees with their manager's name.
-- Use LEFT JOIN to include employees without managers.
-- Expected columns: employee_name, manager_name



-- Exercise 2: Count Direct Reports (Easy)
-- Write a query to show each manager with their count of direct reports.
-- Only include managers who have at least one direct report.
-- Expected columns: manager_name, direct_reports



-- Exercise 3: Employees Without Managers (Easy)
-- Write a query to find all employees who don't have a manager (top-level executives).
-- Expected columns: name, salary, hire_date



-- Exercise 4: Manager's Manager (Medium)
-- Write a query to show each employee with their manager and their manager's manager.
-- Expected columns: employee_name, manager_name, manager_of_manager



-- Exercise 5: Employees Earning More Than Manager (Medium)
-- Write a query to find employees who earn more than their manager.
-- Show employee name, employee salary, manager name, manager salary, and difference.
-- Expected columns: employee_name, employee_salary, manager_name, manager_salary, difference



-- Exercise 6: Same Department Colleagues (Medium)
-- Write a query to find pairs of employees who work in the same department.
-- Avoid duplicates and self-matches using id < id.
-- Expected columns: employee1, employee2, department_id



-- Exercise 7: Salary Comparison (Medium)
-- Write a query to compare each employee's salary to the average salary in their department.
-- Show employee name, salary, department average, and difference.
-- Expected columns: name, salary, dept_avg_salary, difference_from_avg



-- ============================================
-- PART 2: PRODUCT COMPARISONS
-- ============================================

-- Exercise 8: Products in Same Category (Easy)
-- Write a query to find pairs of products in the same category.
-- Avoid duplicates and self-matches.
-- Expected columns: product1, product2, category



-- Exercise 9: Similar Priced Products (Medium)
-- Write a query to find pairs of products with prices within $10 of each other.
-- Show both products, their prices, and the price difference.
-- Expected columns: product1, price1, product2, price2, price_difference



-- Exercise 10: Product Price Comparison (Medium)
-- Write a query to compare each product's price to the average price in its category.
-- Show product name, price, category average, and percentage difference.
-- Expected columns: product_name, price, category_avg_price, pct_difference



-- Exercise 11: Product Profit Margin Comparison (Hard)
-- Write a query to compare each product's profit margin to the average in its category.
-- Profit margin = (price - cost) / price * 100
-- Expected columns: product_name, profit_margin, category_avg_margin, difference



-- ============================================
-- PART 3: CUSTOMER RELATIONSHIPS
-- ============================================

-- Exercise 12: Customers in Same City (Easy)
-- Write a query to find pairs of customers in the same city.
-- Avoid duplicates and self-matches.
-- Expected columns: customer1, customer2, city



-- Exercise 13: Customers in Same State (Medium)
-- Write a query to count how many other customers are in the same state as each customer.
-- Expected columns: customer_name, state, other_customers_in_state



-- Exercise 14: Customer Registration Comparison (Medium)
-- Write a query to find pairs of customers who registered on the same day.
-- Expected columns: customer1, customer2, registration_date



-- ============================================
-- PART 4: ORDER SEQUENCES
-- ============================================

-- Exercise 15: Consecutive Orders (Medium)
-- Write a query to find consecutive orders from the same customer.
-- Show both order IDs, dates, and days between orders.
-- Expected columns: customer_id, first_order_id, first_order_date, second_order_id, second_order_date, days_between



-- Exercise 16: Quick Repeat Orders (Hard)
-- Write a query to find customers who placed another order within 7 days.
-- Show customer name, both order dates, and days between.
-- Expected columns: customer_name, first_order_date, second_order_date, days_between



-- Exercise 17: Order Value Comparison (Medium)
-- Write a query to compare each customer's orders to their own average order value.
-- Show order ID, order total, customer average, and difference.
-- Expected columns: order_id, order_total, customer_avg, difference_from_avg



-- ============================================
-- PART 5: PRODUCT RELATIONSHIPS
-- ============================================

-- Exercise 18: Products Bought Together (Hard)
-- Write a query to find pairs of products that were bought together in the same order.
-- Show product names and how many times they were bought together.
-- Only include pairs bought together at least 3 times.
-- Expected columns: product1, product2, times_together



-- Exercise 19: Frequently Bought Together (Hard)
-- Write a query to find the top 10 product pairs most frequently bought together.
-- Expected columns: product1, product2, times_together



-- Exercise 20: Customers Who Bought Same Product (Medium)
-- Write a query to find pairs of customers who bought the same product.
-- Show customer names and product name.
-- Limit to 20 results.
-- Expected columns: customer1, customer2, product_name
