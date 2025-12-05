-- Day 11: FULL OUTER JOIN and CROSS JOIN
-- Complete exercises for both join types

-- Connect to database:
-- duckdb ../../data/databases/day11.db

-- ============================================
-- PART 1: FULL OUTER JOIN EXERCISES
-- ============================================

-- Exercise 1: All Employees and Departments (Easy)
-- Write a query using FULL OUTER JOIN to get all employees and all departments.
-- Show employee name and department name.
-- Expected columns: name, department_name



-- Exercise 2: Identify Unmatched Records (Medium)
-- Write a query using FULL OUTER JOIN to find:
-- - Employees without departments
-- - Departments without employees
-- Show name, department_name, and status.
-- Expected columns: name, department_name, status



-- Exercise 3: Data Reconciliation (Medium)
-- Write a query to compare system1_users and system2_users using FULL OUTER JOIN.
-- Show user_id, username from both systems, and status.
-- Expected columns: user_id, system1_username, system2_username, status



-- Exercise 4: Complete Employee-Department Report (Medium)
-- Write a query using FULL OUTER JOIN to create a complete report.
-- Count employees per department, including departments with no employees.
-- Show "Unassigned" for employees without departments.
-- Expected columns: department_name, employee_count



-- Exercise 5: Find Orphaned Records (Medium)
-- Write a query using FULL OUTER JOIN to find orders that reference 
-- non-existent customers AND customers without orders.
-- Expected columns: customer_name, order_id, issue_type



-- Exercise 6: Product-Category Reconciliation (Hard)
-- Write a query using FULL OUTER JOIN to find:
-- - Products without valid categories
-- - Categories without products
-- Show category_name, product_name, and match_status.
-- Expected columns: category_name, product_name, match_status



-- Exercise 7: Complete Inventory Check (Hard)
-- Using FULL OUTER JOIN, create a report showing all products and all categories.
-- Include products without categories and categories without products.
-- Expected columns: category_name, product_name, price, match_status



-- ============================================
-- PART 2: CROSS JOIN EXERCISES
-- ============================================

-- Exercise 8: All Size-Color Combinations (Easy)
-- Write a query using CROSS JOIN to generate all possible combinations 
-- of sizes and colors.
-- Expected columns: size_name, color_name



-- Exercise 9: Product Variants (Medium)
-- Write a query using CROSS JOIN to generate all possible product variants.
-- For the first 5 products, create combinations with all sizes and all colors.
-- Expected columns: product_name, size_name, color_name



-- Exercise 10: Generate SKUs (Medium)
-- Write a query using CROSS JOIN to generate SKU codes for product variants.
-- SKU format: PRODUCT_CODE-SIZE_CODE-COLOR_CODE
-- Use the first 3 products only.
-- Expected columns: product_name, size_name, color_name, sku



-- Exercise 11: Price Matrix (Medium)
-- Write a query using CROSS JOIN to create a price matrix.
-- Show the first 5 products with discount levels (0%, 10%, 20%, 30%).
-- Calculate discounted price for each combination.
-- Expected columns: product_name, original_price, discount_pct, discounted_price



-- Exercise 12: Employee-Department Combinations (Medium)
-- Write a query using CROSS JOIN to show all possible employee-department assignments.
-- Only show combinations where the employee is NOT already in that department.
-- Limit to first 10 employees.
-- Expected columns: employee_name, current_dept, potential_dept



-- Exercise 13: Testing Scenarios (Medium)
-- Write a query using CROSS JOIN to generate test scenarios.
-- Combine the first 3 products with the first 3 categories.
-- Generate a unique test_scenario_id for each combination.
-- Expected columns: product_name, category_name, test_scenario_id



-- ============================================
-- PART 3: COMBINED EXERCISES
-- ============================================

-- Exercise 14: Complete Product Catalog (Hard)
-- Write a query combining CROSS JOIN and LEFT JOIN:
-- - Generate all product-size-color combinations for first 3 products (CROSS JOIN)
-- - Show actual sales for each combination (LEFT JOIN to order_items)
-- - Include combinations with 0 sales
-- Expected columns: product_name, size_name, color_name, quantity_sold



-- Exercise 15: Sales Grid with Gaps (Hard)
-- Write a query to create a sales grid for months 1-6:
-- - All months (1-6)
-- - First 5 products
-- - Show quantity sold for each month-product combination (0 if no sales)
-- Expected columns: month_num, product_name, quantity_sold



-- Exercise 16: Size-Color Availability (Medium)
-- Write a query to show all size-color combinations.
-- Mark each as 'Available' or 'Not Available' based on whether 
-- any product exists in that combination.
-- Expected columns: size_name, color_name, availability_status



-- Exercise 17: Data Quality Report (Very Hard)
-- Write a query using FULL OUTER JOIN to create a data quality report:
-- - Compare products table with order_items table
-- - Find products never ordered
-- - Find order_items referencing non-existent products
-- - Count issues by type
-- Expected columns: issue_type, count



-- Exercise 18: User Sync Report (Hard)
-- Write a query using FULL OUTER JOIN to create a user synchronization report.
-- Count users in each category:
-- - Only in system1
-- - Only in system2
-- - In both systems
-- Expected columns: sync_status, user_count



-- Exercise 19: Complete Business Matrix (Very Hard)
-- Write a query to create a business analysis matrix:
-- - All categories
-- - Months 1-3
-- - Show product count and total revenue for each category-month combination
-- - Include categories/months with no activity
-- Expected columns: category_name, month_num, product_count, revenue



-- Exercise 20: Multi-Table Reconciliation (Very Hard)
-- Write a query using FULL OUTER JOIN to reconcile:
-- - Employees and departments
-- - Show counts of matched and unmatched records
-- - Calculate percentage of employees with valid departments
-- Expected columns: total_employees, employees_with_dept, employees_without_dept, 
--                   total_departments, departments_with_employees, departments_without_employees
