-- Day 21: String Functions
-- Practice exercises

-- ============================================
-- Part 1: Basic String Functions (10 min)
-- ============================================

-- 1.1: Create full names by concatenating first_name and last_name
-- TODO: Write your query
-- Expected columns: employee_id, full_name


-- 1.2: Convert all emails to lowercase
-- TODO: Write your query
-- Expected columns: employee_id, first_name, last_name, email_lower


-- 1.3: Convert all first names to uppercase
-- TODO: Write your query
-- Expected columns: employee_id, first_name_upper, last_name


-- 1.4: Extract the first 3 characters of each department name
-- TODO: Write your query
-- Expected columns: department, dept_code


-- 1.5: Find the length of each employee's full name (first + space + last)
-- TODO: Write your query
-- Expected columns: employee_id, full_name, name_length


-- ============================================
-- Part 2: String Manipulation (10 min)
-- ============================================

-- 2.1: Extract username from email (part before @)
-- TODO: Write your query
-- Expected columns: employee_id, email, username
-- Hint: SUBSTRING(email, 1, POSITION('@' IN email) - 1)


-- 2.2: Extract domain from email (part after @)
-- TODO: Write your query
-- Expected columns: employee_id, email, domain
-- Hint: SUBSTRING(email, POSITION('@' IN email) + 1)


-- 2.3: Remove all dashes from phone numbers
-- TODO: Write your query
-- Expected columns: employee_id, phone, phone_no_dashes
-- Hint: REPLACE(phone, '-', '')


-- 2.4: Extract area code from phone (first 3 digits)
-- TODO: Write your query
-- Expected columns: employee_id, phone, area_code
-- Hint: Use SUBSTRING and REPLACE to clean first


-- 2.5: Get the first letter of first name and last name (initials)
-- TODO: Write your query
-- Expected columns: employee_id, full_name, initials
-- Hint: SUBSTRING(first_name, 1, 1) || SUBSTRING(last_name, 1, 1)


-- ============================================
-- Part 3: Data Cleaning (10 min)
-- ============================================

-- 3.1: Trim whitespace from all emails
-- TODO: Write your query
-- Expected columns: employee_id, email, email_trimmed


-- 3.2: Standardize all emails to lowercase and trimmed
-- TODO: Write your query
-- Expected columns: employee_id, email_clean


-- 3.3: Create proper case names (First letter uppercase, rest lowercase)
-- TODO: Write your query
-- Expected columns: employee_id, first_name_proper, last_name_proper
-- Hint: UPPER(SUBSTRING(name, 1, 1)) || LOWER(SUBSTRING(name, 2))


-- 3.4: Standardize phone numbers to format: XXX-XXX-XXXX
-- TODO: Write your query
-- Remove all non-numeric characters first, then format
-- Expected columns: employee_id, phone, phone_standardized


-- 3.5: Find employees with invalid emails (no @ symbol)
-- TODO: Write your query
-- Expected columns: employee_id, first_name, last_name, email
-- Hint: POSITION('@' IN email) = 0


-- ============================================
-- Part 4: Type Conversion (5 min)
-- ============================================

-- 4.1: Convert salary_string to INTEGER and add 5000
-- TODO: Write your query
-- Expected columns: employee_id, full_name, current_salary, new_salary


-- 4.2: Convert salary_string to DECIMAL and calculate 10% bonus
-- TODO: Write your query
-- Expected columns: employee_id, full_name, salary, bonus


-- 4.3: Extract year from customer_since and convert to INTEGER
-- TODO: Write your query on customers table
-- Expected columns: customer_id, full_name, customer_since, year_joined


-- 4.4: Convert product price_string to DECIMAL and calculate with tax (8%)
-- TODO: Write your query on products table
-- Expected columns: product_id, product_name, price, price_with_tax


-- ============================================
-- Part 5: Advanced Patterns (5 min)
-- ============================================

-- 5.1: Create email addresses from names (firstname.lastname@company.com)
-- TODO: Write your query
-- Assume all names should be lowercase
-- Expected columns: employee_id, full_name, generated_email


-- 5.2: Extract product category code from product_code (first 4 characters)
-- TODO: Write your query on products table
-- Expected columns: product_id, product_code, category_code, product_name


-- 5.3: Create display names in format: "Last, First" (proper case)
-- TODO: Write your query
-- Expected columns: employee_id, display_name


-- 5.4: Find products with descriptions longer than 50 characters
-- TODO: Write your query on products table
-- Expected columns: product_id, product_name, description, description_length


-- 5.5: Create formatted addresses for customers
-- TODO: Write your query on customers table
-- Format: "Address, City, State ZIP"
-- Expected columns: customer_id, full_name, formatted_address

