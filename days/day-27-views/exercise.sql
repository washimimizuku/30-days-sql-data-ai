-- Day 27: Views - Exercises
-- Database: day27.db

-- ============================================================================
-- PART 1: BASIC VIEWS (Easy)
-- ============================================================================

-- Exercise 1: Simple View
-- Create a view showing only active employees (is_active = TRUE)
-- Include: id, name, email, department


-- Exercise 2: Filtered View
-- Create a view showing high earners (salary > 80000)
-- Include: name, department, salary


-- Exercise 3: Query a View
-- Query the active_employees view to find all employees in Sales department


-- Exercise 4: Drop and Recreate
-- Drop the high_earners view if it exists
-- Then recreate it with salary > 90000 instead


-- Exercise 5: View with Calculated Column
-- Create a view showing employee years of service
-- Include: name, hire_date, and calculated years_employed


-- ============================================================================
-- PART 2: VIEWS WITH JOINS (Medium)
-- ============================================================================

-- Exercise 6: Simple JOIN View
-- Create a view joining employees with departments
-- Include: employee name, email, department name, location


-- Exercise 7: Customer Orders View
-- Create a view showing customer order details
-- Include: customer name, order date, total, status


-- Exercise 8: Order Details View
-- Create a view with complete order information
-- Include: order id, customer name, product name, quantity, price


-- Exercise 9: Query JOIN View
-- Query the customer_orders view to find all orders from Seattle customers


-- Exercise 10: Multi-Table View
-- Create a view joining orders, customers, and order_items
-- Include: customer name, order date, product count, order total


-- ============================================================================
-- PART 3: AGGREGATE VIEWS (Medium-Hard)
-- ============================================================================

-- Exercise 11: Department Statistics
-- Create a view showing statistics by department
-- Include: department, employee_count, avg_salary, max_salary


-- Exercise 12: Customer Summary
-- Create a view showing customer order statistics
-- Include: customer_id, customer_name, order_count, total_spent


-- Exercise 13: Product Performance
-- Create a view showing product sales performance
-- Include: product_name, times_ordered, total_quantity, total_revenue


-- Exercise 14: Monthly Sales
-- Create a view showing sales by month
-- Include: month, order_count, total_revenue, avg_order_value


-- Exercise 15: Category Analysis
-- Create a view showing product category performance
-- Include: category, product_count, avg_price, total_revenue


-- ============================================================================
-- PART 4: PRACTICAL VIEWS (Hard)
-- ============================================================================

-- Exercise 16: Security View
-- Create a public_employees view that hides salary information
-- Include: id, name, email, department (but NOT salary)


-- Exercise 17: Dashboard View
-- Create a sales_dashboard view for reporting
-- Include: date, orders, revenue, unique_customers


-- Exercise 18: Customer Segmentation
-- Create a view categorizing customers by spending
-- Segments: VIP (>5000), Premium (>2000), Regular (>500), New (<=500)


-- Exercise 19: Employee Directory
-- Create a comprehensive employee directory view
-- Include: name, email, department, location, years_employed, status


-- Exercise 20: CREATE OR REPLACE
-- Update the sales_dashboard view to include avg_order_value
-- Use CREATE OR REPLACE VIEW
