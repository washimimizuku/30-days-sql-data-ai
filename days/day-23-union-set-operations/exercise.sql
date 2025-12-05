-- Day 23: UNION and Set Operations
-- Practice exercises

-- ============================================
-- Part 1: UNION (10 min)
-- ============================================

-- 1.1: Combine all employees from 2023 and 2024 (remove duplicates)
-- TODO: Write your query using UNION


-- 1.2: Combine all customers from East and West regions (remove duplicates)
-- TODO: Write your query using UNION


-- 1.3: Create a unified product list from online and store (remove duplicates)
-- TODO: Write your query using UNION


-- 1.4: Combine employees and add a source column
-- TODO: Write your query
-- Add 'Year 2023' or 'Year 2024' as source column


-- 1.5: Combine customers and add region column
-- TODO: Write your query
-- Add 'East' or 'West' as region column


-- ============================================
-- Part 2: UNION ALL (10 min)
-- ============================================

-- 2.1: Combine all employees from 2023 and 2024 (keep duplicates)
-- TODO: Write your query using UNION ALL


-- 2.2: Combine all orders from Q1 and Q2 (keep all records)
-- TODO: Write your query using UNION ALL


-- 2.3: Count total rows with UNION vs UNION ALL for employees
-- TODO: Write two queries and compare counts


-- 2.4: Combine products with source indicator using UNION ALL
-- TODO: Write your query
-- Add 'Online' or 'Store' as channel column


-- 2.5: Create a complete contact list (employees + customers) with type
-- TODO: Write your query using UNION ALL
-- Expected columns: name, email, contact_type


-- ============================================
-- Part 3: INTERSECT (10 min)
-- ============================================

-- 3.1: Find employees who worked in both 2023 and 2024
-- TODO: Write your query using INTERSECT
-- Hint: Compare email addresses


-- 3.2: Find customers who appear in both East and West regions
-- TODO: Write your query using INTERSECT


-- 3.3: Find products available both online and in store
-- TODO: Write your query using INTERSECT


-- 3.4: Find common emails between employees_2023 and customers_east
-- TODO: Write your query using INTERSECT


-- 3.5: Find departments that exist in both 2023 and 2024 employee lists
-- TODO: Write your query using INTERSECT


-- ============================================
-- Part 4: EXCEPT (5 min)
-- ============================================

-- 4.1: Find employees who left (in 2023 but not in 2024)
-- TODO: Write your query using EXCEPT


-- 4.2: Find new employees (in 2024 but not in 2023)
-- TODO: Write your query using EXCEPT


-- 4.3: Find products only available online (not in store)
-- TODO: Write your query using EXCEPT


-- 4.4: Find products only available in store (not online)
-- TODO: Write your query using EXCEPT


-- 4.5: Find customers only in East region (not in West)
-- TODO: Write your query using EXCEPT


-- ============================================
-- Part 5: Complex Combinations (5 min)
-- ============================================

-- 5.1: Combine Q1 and Q2 orders, then find customers who ordered in both quarters
-- TODO: Write your query using UNION ALL and INTERSECT


-- 5.2: Find all unique departments across both years
-- TODO: Write your query using UNION


-- 5.3: Create a report showing employee changes
-- TODO: Write your query
-- Show: employees who left, stayed, and joined
-- Hint: Use multiple EXCEPT queries with UNION ALL


-- 5.4: Find products available in exactly one channel (online XOR store)
-- TODO: Write your query
-- Hint: (online EXCEPT store) UNION (store EXCEPT online)


-- 5.5: Create a comprehensive contact directory
-- TODO: Write your query
-- Combine all unique emails from employees (both years) and customers (both regions)
-- Add source type for each

