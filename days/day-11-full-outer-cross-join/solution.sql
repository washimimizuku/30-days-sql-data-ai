-- Day 11: FULL OUTER JOIN and CROSS JOIN - Solutions

-- ============================================
-- PART 1: FULL OUTER JOIN SOLUTIONS
-- ============================================

-- Exercise 1 Solution: All Employees and Departments
SELECT 
    e.name,
    d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id
ORDER BY d.department_name, e.name;


-- Exercise 2 Solution: Identify Unmatched Records
SELECT 
    e.name,
    d.department_name,
    CASE 
        WHEN e.id IS NULL THEN 'Dept Without Employees'
        WHEN d.id IS NULL THEN 'Employee Without Dept'
        ELSE 'Matched'
    END as status
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id
WHERE e.id IS NULL OR d.id IS NULL
ORDER BY status, e.name, d.department_name;


-- Exercise 3 Solution: Data Reconciliation
SELECT 
    COALESCE(s1.user_id, s2.user_id) as user_id,
    s1.username as system1_username,
    s2.username as system2_username,
    CASE 
        WHEN s1.user_id IS NULL THEN 'Only in System 2'
        WHEN s2.user_id IS NULL THEN 'Only in System 1'
        ELSE 'In Both'
    END as status
FROM system1_users s1
FULL OUTER JOIN system2_users s2 ON s1.user_id = s2.user_id
ORDER BY user_id;


-- Exercise 4 Solution: Complete Employee-Department Report
SELECT 
    COALESCE(d.department_name, 'Unassigned') as department_name,
    COUNT(e.id) as employee_count
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id
GROUP BY d.department_name
ORDER BY employee_count DESC, department_name;


-- Exercise 5 Solution: Find Orphaned Records
SELECT 
    c.customer_name,
    o.id as order_id,
    CASE 
        WHEN c.id IS NULL THEN 'Orphaned Order'
        WHEN o.id IS NULL THEN 'Customer Without Orders'
    END as issue_type
FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id
WHERE c.id IS NULL OR o.id IS NULL
ORDER BY issue_type, order_id, customer_name;


-- Exercise 6 Solution: Product-Category Reconciliation
SELECT 
    c.category_name,
    p.product_name,
    CASE 
        WHEN p.id IS NULL THEN 'Category Without Products'
        WHEN c.id IS NULL THEN 'Product Without Category'
        ELSE 'Matched'
    END as match_status
FROM products p
FULL OUTER JOIN categories c ON p.category_id = c.id
ORDER BY match_status, c.category_name, p.product_name;


-- Exercise 7 Solution: Complete Inventory Check
SELECT 
    COALESCE(c.category_name, 'No Category') as category_name,
    COALESCE(p.product_name, 'No Products') as product_name,
    p.price,
    CASE 
        WHEN p.id IS NULL THEN 'Empty Category'
        WHEN c.id IS NULL THEN 'Orphaned Product'
        ELSE 'Valid'
    END as match_status
FROM products p
FULL OUTER JOIN categories c ON p.category_id = c.id
ORDER BY match_status, category_name, product_name;


-- ============================================
-- PART 2: CROSS JOIN SOLUTIONS
-- ============================================

-- Exercise 8 Solution: All Size-Color Combinations
SELECT 
    s.size_name,
    c.color_name
FROM sizes s
CROSS JOIN colors c
ORDER BY s.size_name, c.color_name;


-- Exercise 9 Solution: Product Variants
SELECT 
    p.product_name,
    s.size_name,
    c.color_name
FROM products p
CROSS JOIN sizes s
CROSS JOIN colors c
WHERE p.id <= 5
ORDER BY p.product_name, s.size_name, c.color_name;


-- Exercise 10 Solution: Generate SKUs
SELECT 
    p.product_name,
    s.size_name,
    c.color_name,
    p.product_code || '-' || s.size_code || '-' || c.color_code as sku
FROM products p
CROSS JOIN sizes s
CROSS JOIN colors c
WHERE p.id <= 3
ORDER BY p.product_name, s.size_name, c.color_name;


-- Exercise 11 Solution: Price Matrix
SELECT 
    p.product_name,
    p.price as original_price,
    d.discount_pct,
    ROUND(p.price * (1 - d.discount_pct / 100.0), 2) as discounted_price
FROM products p
CROSS JOIN (
    SELECT 0 as discount_pct
    UNION ALL SELECT 10
    UNION ALL SELECT 20
    UNION ALL SELECT 30
) d
WHERE p.id <= 5
ORDER BY p.product_name, d.discount_pct;


-- Exercise 12 Solution: Employee-Department Combinations
SELECT 
    e.name as employee_name,
    COALESCE(d1.department_name, 'None') as current_dept,
    d2.department_name as potential_dept
FROM employees e
LEFT JOIN departments d1 ON e.department_id = d1.id
CROSS JOIN departments d2
WHERE e.department_id IS NULL OR e.department_id != d2.id
AND e.id <= 10
ORDER BY e.name, d2.department_name;


-- Exercise 13 Solution: Testing Scenarios
SELECT 
    p.product_name,
    c.category_name,
    ROW_NUMBER() OVER (ORDER BY p.id, c.id) as test_scenario_id
FROM products p
CROSS JOIN categories c
WHERE p.id <= 3 AND c.id <= 3
ORDER BY test_scenario_id;


-- ============================================
-- PART 3: COMBINED SOLUTIONS
-- ============================================

-- Exercise 14 Solution: Complete Product Catalog
SELECT 
    p.product_name,
    s.size_name,
    c.color_name,
    COALESCE(SUM(oi.quantity), 0) as quantity_sold
FROM products p
CROSS JOIN sizes s
CROSS JOIN colors c
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE p.id <= 3
GROUP BY p.product_name, s.size_name, c.color_name
ORDER BY p.product_name, s.size_name, c.color_name;


-- Exercise 15 Solution: Sales Grid with Gaps
SELECT 
    m.month_num,
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) as quantity_sold
FROM (
    SELECT 1 as month_num
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
) m
CROSS JOIN products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id 
    AND EXTRACT(MONTH FROM o.order_date) = m.month_num
WHERE p.id <= 5
GROUP BY m.month_num, p.product_name
ORDER BY m.month_num, p.product_name;


-- Exercise 16 Solution: Size-Color Availability
SELECT 
    s.size_name,
    c.color_name,
    CASE 
        WHEN COUNT(p.id) > 0 THEN 'Available'
        ELSE 'Not Available'
    END as availability_status
FROM sizes s
CROSS JOIN colors c
LEFT JOIN products p ON 1=1  -- Simplified: in real scenario would check actual inventory
GROUP BY s.size_name, c.color_name
ORDER BY s.size_name, c.color_name;


-- Exercise 17 Solution: Data Quality Report
SELECT 
    issue_type,
    COUNT(*) as count
FROM (
    SELECT 
        CASE 
            WHEN p.id IS NULL THEN 'Order Item Without Product'
            WHEN oi.id IS NULL THEN 'Product Never Ordered'
        END as issue_type
    FROM products p
    FULL OUTER JOIN order_items oi ON p.id = oi.product_id
    WHERE p.id IS NULL OR oi.id IS NULL
) issues
GROUP BY issue_type
ORDER BY issue_type;


-- Exercise 18 Solution: User Sync Report
SELECT 
    sync_status,
    COUNT(*) as user_count
FROM (
    SELECT 
        CASE 
            WHEN s1.user_id IS NULL THEN 'Only in System 2'
            WHEN s2.user_id IS NULL THEN 'Only in System 1'
            ELSE 'In Both Systems'
        END as sync_status
    FROM system1_users s1
    FULL OUTER JOIN system2_users s2 ON s1.user_id = s2.user_id
) sync
GROUP BY sync_status
ORDER BY sync_status;


-- Exercise 19 Solution: Complete Business Matrix
SELECT 
    COALESCE(c.category_name, 'Unknown') as category_name,
    m.month_num,
    COUNT(DISTINCT p.id) as product_count,
    COALESCE(SUM(oi.quantity * oi.price), 0) as revenue
FROM (
    SELECT 1 as month_num
    UNION ALL SELECT 2
    UNION ALL SELECT 3
) m
CROSS JOIN categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id 
    AND EXTRACT(MONTH FROM o.order_date) = m.month_num
GROUP BY c.category_name, m.month_num
ORDER BY m.month_num, revenue DESC;


-- Exercise 20 Solution: Multi-Table Reconciliation
SELECT 
    COUNT(DISTINCT e.id) as total_employees,
    COUNT(DISTINCT CASE WHEN e.department_id IS NOT NULL AND d.id IS NOT NULL THEN e.id END) as employees_with_dept,
    COUNT(DISTINCT CASE WHEN e.department_id IS NULL OR d.id IS NULL THEN e.id END) as employees_without_dept,
    COUNT(DISTINCT d.id) as total_departments,
    COUNT(DISTINCT CASE WHEN e.id IS NOT NULL THEN d.id END) as departments_with_employees,
    COUNT(DISTINCT CASE WHEN e.id IS NULL THEN d.id END) as departments_without_employees
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;
