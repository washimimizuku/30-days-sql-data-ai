-- Day 13: Subqueries in WHERE
-- Filtering with subqueries

-- Connect to database:
-- duckdb ../../data/databases/day13.db

-- ============================================
-- PART 1: SCALAR SUBQUERIES
-- ============================================

-- Exercise 1: Above Average Salary (Easy)
-- Find employees with salary above the company average.
-- Expected columns: name, salary



-- Exercise 2: Above Average Price (Easy)
-- Find products with price above the average price.
-- Expected columns: product_name, price



-- Exercise 3: Above Average Order Total (Easy)
-- Find orders with total greater than the average order total.
-- Expected columns: id, customer_id, total



-- Exercise 4: Oldest in Department (Medium)
-- Find employees older than the oldest employee in the Sales department.
-- Expected columns: name, age, department_id



-- ============================================
-- PART 2: IN OPERATOR
-- ============================================

-- Exercise 5: Employees in New York Departments (Easy)
-- Find employees in departments located in 'New York'.
-- Expected columns: name, department_id



-- Exercise 6: Customers Who Have Ordered (Easy)
-- Find customers who have placed at least one order.
-- Expected columns: customer_name



-- Exercise 7: Products That Have Been Ordered (Easy)
-- Find products that appear in at least one order.
-- Expected columns: product_name



-- Exercise 8: Customers Without Orders (Medium)
-- Find customers who have NOT placed any orders using NOT IN.
-- Remember to handle NULLs properly!
-- Expected columns: customer_name



-- ============================================
-- PART 3: EXISTS OPERATOR
-- ============================================

-- Exercise 9: Employees Who Have Orders (Easy)
-- Find employees who have processed at least one order using EXISTS.
-- Expected columns: name



-- Exercise 10: Departments With Employees (Easy)
-- Find departments that have at least one employee using EXISTS.
-- Expected columns: department_name



-- Exercise 11: Customers With Large Orders (Medium)
-- Find customers who have at least one order with total > 1000 using EXISTS.
-- Expected columns: customer_name



-- Exercise 12: Products in Orders (Medium)
-- Find products that appear in at least one order using EXISTS.
-- Expected columns: product_name



-- ============================================
-- PART 4: NOT EXISTS OPERATOR
-- ============================================

-- Exercise 13: Employees Without Orders (Easy)
-- Find employees who have NOT processed any orders using NOT EXISTS.
-- Expected columns: name



-- Exercise 14: Customers Without Orders (Easy)
-- Find customers with no orders using NOT EXISTS.
-- Expected columns: customer_name



-- Exercise 15: Products Never Ordered (Medium)
-- Find products that have never been ordered using NOT EXISTS.
-- Expected columns: product_name, category



-- Exercise 16: Departments Without Employees (Medium)
-- Find departments with no employees using NOT EXISTS.
-- Expected columns: department_name, city



-- ============================================
-- PART 5: ANY AND ALL OPERATORS
-- ============================================

-- Exercise 17: Salary Greater Than Any in Sales (Medium)
-- Find employees with salary greater than ANY salary in the Sales department.
-- Expected columns: name, salary, department_id



-- Exercise 18: Salary Greater Than All in Sales (Hard)
-- Find employees with salary greater than ALL salaries in the Sales department.
-- Expected columns: name, salary, department_id



-- Exercise 19: Cheaper Than Any Electronics (Medium)
-- Find products cheaper than ANY product in the Electronics category.
-- Expected columns: product_name, price, category



-- Exercise 20: More Expensive Than All Books (Medium)
-- Find products more expensive than ALL products in the Books category.
-- Expected columns: product_name, price, category
