-- Day 21: String Functions
-- Solutions

-- ============================================
-- Part 1: Basic String Functions (10 min)
-- ============================================

-- 1.1: Create full names
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) as full_name
FROM employees;

-- Alternative using || operator
SELECT 
    employee_id,
    first_name || ' ' || last_name as full_name
FROM employees;

-- 1.2: Convert all emails to lowercase
SELECT 
    employee_id,
    first_name,
    last_name,
    LOWER(email) as email_lower
FROM employees;

-- 1.3: Convert all first names to uppercase
SELECT 
    employee_id,
    UPPER(first_name) as first_name_upper,
    last_name
FROM employees;

-- 1.4: Extract first 3 characters of department
SELECT DISTINCT
    department,
    SUBSTRING(department, 1, 3) as dept_code
FROM employees
ORDER BY department;

-- 1.5: Find length of full name
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) as full_name,
    LENGTH(CONCAT(first_name, ' ', last_name)) as name_length
FROM employees
ORDER BY name_length DESC;


-- ============================================
-- Part 2: String Manipulation (10 min)
-- ============================================

-- 2.1: Extract username from email
SELECT 
    employee_id,
    email,
    SUBSTRING(email, 1, POSITION('@' IN email) - 1) as username
FROM employees;

-- 2.2: Extract domain from email
SELECT 
    employee_id,
    email,
    SUBSTRING(email, POSITION('@' IN email) + 1) as domain
FROM employees;

-- 2.3: Remove all dashes from phone numbers
SELECT 
    employee_id,
    phone,
    REPLACE(phone, '-', '') as phone_no_dashes
FROM employees;

-- 2.4: Extract area code from phone
SELECT 
    employee_id,
    phone,
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '(', ''), ')', ''), 1, 3) as area_code
FROM employees;

-- 2.5: Get initials
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) as full_name,
    SUBSTRING(first_name, 1, 1) || SUBSTRING(last_name, 1, 1) as initials
FROM employees;


-- ============================================
-- Part 3: Data Cleaning (10 min)
-- ============================================

-- 3.1: Trim whitespace from emails
SELECT 
    employee_id,
    email,
    TRIM(email) as email_trimmed
FROM employees;

-- 3.2: Standardize emails (lowercase and trimmed)
SELECT 
    employee_id,
    LOWER(TRIM(email)) as email_clean
FROM employees;

-- 3.3: Create proper case names
SELECT 
    employee_id,
    UPPER(SUBSTRING(first_name, 1, 1)) || LOWER(SUBSTRING(first_name, 2)) as first_name_proper,
    UPPER(SUBSTRING(last_name, 1, 1)) || LOWER(SUBSTRING(last_name, 2)) as last_name_proper
FROM employees;

-- 3.4: Standardize phone numbers to XXX-XXX-XXXX
SELECT 
    employee_id,
    phone,
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '(', ''), ')', ''), '.', ''), 1, 3) || '-' ||
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '(', ''), ')', ''), '.', ''), 4, 3) || '-' ||
    SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), ' ', ''), '(', ''), ')', ''), '.', ''), 7, 4) as phone_standardized
FROM employees;

-- 3.5: Find employees with invalid emails
SELECT 
    employee_id,
    first_name,
    last_name,
    email
FROM employees
WHERE POSITION('@' IN email) = 0;


-- ============================================
-- Part 4: Type Conversion (5 min)
-- ============================================

-- 4.1: Convert salary to INTEGER and add 5000
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) as full_name,
    CAST(salary_string AS INTEGER) as current_salary,
    CAST(salary_string AS INTEGER) + 5000 as new_salary
FROM employees;

-- 4.2: Convert salary to DECIMAL and calculate 10% bonus
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) as full_name,
    CAST(salary_string AS DECIMAL(10, 2)) as salary,
    ROUND(CAST(salary_string AS DECIMAL(10, 2)) * 0.10, 2) as bonus
FROM employees;

-- 4.3: Extract year from customer_since
SELECT 
    customer_id,
    full_name,
    customer_since,
    CAST(SUBSTRING(customer_since, 1, 4) AS INTEGER) as year_joined
FROM customers;

-- 4.4: Convert price to DECIMAL and calculate with tax
SELECT 
    product_id,
    product_name,
    CAST(price_string AS DECIMAL(10, 2)) as price,
    ROUND(CAST(price_string AS DECIMAL(10, 2)) * 1.08, 2) as price_with_tax
FROM products;


-- ============================================
-- Part 5: Advanced Patterns (5 min)
-- ============================================

-- 5.1: Create email addresses from names
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) as full_name,
    LOWER(first_name) || '.' || LOWER(last_name) || '@company.com' as generated_email
FROM employees;

-- 5.2: Extract category code from product_code
SELECT 
    product_id,
    product_code,
    SUBSTRING(product_code, 1, 4) as category_code,
    product_name
FROM products;

-- 5.3: Create display names in "Last, First" format
SELECT 
    employee_id,
    UPPER(SUBSTRING(last_name, 1, 1)) || LOWER(SUBSTRING(last_name, 2)) || ', ' ||
    UPPER(SUBSTRING(first_name, 1, 1)) || LOWER(SUBSTRING(first_name, 2)) as display_name
FROM employees;

-- 5.4: Find products with long descriptions
SELECT 
    product_id,
    product_name,
    description,
    LENGTH(description) as description_length
FROM products
WHERE LENGTH(description) > 50
ORDER BY description_length DESC;

-- 5.5: Create formatted addresses
SELECT 
    customer_id,
    full_name,
    address || ', ' || city || ', ' || state || ' ' || zip_code as formatted_address
FROM customers;
