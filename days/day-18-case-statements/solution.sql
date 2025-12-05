-- Day 18: CASE Statements
-- Solutions

-- ============================================
-- Part 1: Basic CASE Statements (10 min)
-- ============================================

-- 1.1: Categorize products by price
SELECT 
    product_name,
    price,
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_category
FROM products
ORDER BY price;

-- 1.2: Show product availability
SELECT 
    product_name,
    stock,
    CASE 
        WHEN stock > 0 THEN 'In Stock'
        ELSE 'Out of Stock'
    END as availability
FROM products
ORDER BY stock DESC;

-- 1.3: Convert order status to descriptions
SELECT 
    order_id,
    status,
    CASE status
        WHEN 'pending' THEN 'Processing'
        WHEN 'shipped' THEN 'In Transit'
        WHEN 'delivered' THEN 'Complete'
        WHEN 'cancelled' THEN 'Cancelled'
        ELSE 'Unknown'
    END as status_description
FROM orders
ORDER BY order_id;

-- 1.4: Categorize employees by salary
SELECT 
    name,
    salary,
    CASE 
        WHEN salary >= 100000 THEN 'High'
        WHEN salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END as salary_band
FROM employees
ORDER BY salary DESC;

-- 1.5: Categorize products by stock level
SELECT 
    product_name,
    stock,
    CASE 
        WHEN stock = 0 THEN 'Out of Stock'
        WHEN stock <= 10 THEN 'Low Stock'
        WHEN stock <= 50 THEN 'Adequate'
        ELSE 'Well Stocked'
    END as stock_status
FROM products
ORDER BY stock;


-- ============================================
-- Part 2: CASE with Aggregations (10 min)
-- ============================================

-- 2.1: Count orders by status in one row
SELECT 
    COUNT(*) as total_orders,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending,
    COUNT(CASE WHEN status = 'shipped' THEN 1 END) as shipped,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled
FROM orders;

-- 2.2: Calculate revenue by order status
SELECT 
    SUM(total) as total_revenue,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as completed_revenue,
    SUM(CASE WHEN status = 'pending' THEN total ELSE 0 END) as pending_revenue,
    SUM(CASE WHEN status = 'cancelled' THEN total ELSE 0 END) as cancelled_revenue
FROM orders;

-- 2.3: For each category, count products by stock status
SELECT 
    category,
    COUNT(*) as total_products,
    COUNT(CASE WHEN stock > 0 THEN 1 END) as in_stock,
    COUNT(CASE WHEN stock = 0 THEN 1 END) as out_of_stock,
    ROUND(AVG(CASE WHEN stock > 0 THEN price END), 2) as avg_in_stock_price
FROM products
GROUP BY category
ORDER BY category;

-- 2.4: Count employees by performance rating
SELECT 
    COUNT(CASE WHEN performance_score >= 90 THEN 1 END) as outstanding,
    COUNT(CASE WHEN performance_score >= 70 AND performance_score < 90 THEN 1 END) as good,
    COUNT(CASE WHEN performance_score >= 50 AND performance_score < 70 THEN 1 END) as satisfactory,
    COUNT(CASE WHEN performance_score < 50 THEN 1 END) as needs_improvement
FROM employees;

-- 2.5: For each category, count products by price range
SELECT 
    category,
    COUNT(CASE WHEN price < 50 THEN 1 END) as budget_count,
    COUNT(CASE WHEN price >= 50 AND price < 200 THEN 1 END) as midrange_count,
    COUNT(CASE WHEN price >= 200 THEN 1 END) as premium_count,
    COUNT(*) as total
FROM products
GROUP BY category
ORDER BY category;


-- ============================================
-- Part 3: Complex Categorization (10 min)
-- ============================================

-- 3.1: Segment customers based on order history
WITH customer_stats AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) as order_count,
        COALESCE(SUM(CASE WHEN o.status = 'completed' THEN o.total ELSE 0 END), 0) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    order_count,
    total_spent,
    CASE 
        WHEN order_count >= 10 AND total_spent > 5000 THEN 'VIP'
        WHEN order_count >= 5 OR total_spent > 2000 THEN 'Loyal'
        WHEN order_count > 0 THEN 'Regular'
        ELSE 'New'
    END as segment
FROM customer_stats
ORDER BY total_spent DESC;

-- 3.2: Categorize products by profit margin percentage
SELECT 
    product_name,
    price,
    cost,
    ROUND((price - cost) * 100.0 / price, 2) as profit_margin_pct,
    CASE 
        WHEN (price - cost) * 100.0 / price > 50 THEN 'Excellent'
        WHEN (price - cost) * 100.0 / price >= 30 THEN 'Good'
        WHEN (price - cost) * 100.0 / price >= 15 THEN 'Fair'
        ELSE 'Poor'
    END as tier
FROM products
ORDER BY profit_margin_pct DESC;

-- 3.3: Calculate employee bonuses based on performance
SELECT 
    name,
    salary,
    performance_score,
    CASE 
        WHEN performance_score >= 90 THEN salary * 0.15
        WHEN performance_score >= 70 THEN salary * 0.10
        WHEN performance_score >= 50 THEN salary * 0.05
        ELSE 0
    END as bonus_amount
FROM employees
ORDER BY bonus_amount DESC;

-- 3.4: Calculate dynamic pricing based on stock levels
SELECT 
    product_name,
    price,
    stock,
    CASE 
        WHEN stock = 0 THEN price * 1.2
        WHEN stock < 10 THEN price * 1.1
        WHEN stock > 100 THEN price * 0.9
        ELSE price
    END as dynamic_price,
    CASE 
        WHEN stock = 0 THEN 'Out of Stock Premium'
        WHEN stock < 10 THEN 'Low Stock Markup'
        WHEN stock > 100 THEN 'Clearance Discount'
        ELSE 'Regular Price'
    END as pricing_reason
FROM products
ORDER BY stock;


-- ============================================
-- Part 4: Pivot Tables (5 min)
-- ============================================

-- 4.1: Create a pivot showing revenue by category and order status
SELECT 
    p.category,
    SUM(CASE WHEN o.status = 'completed' THEN oi.quantity * oi.price ELSE 0 END) as completed_revenue,
    SUM(CASE WHEN o.status = 'pending' THEN oi.quantity * oi.price ELSE 0 END) as pending_revenue,
    SUM(CASE WHEN o.status = 'shipped' THEN oi.quantity * oi.price ELSE 0 END) as shipped_revenue,
    SUM(CASE WHEN o.status = 'cancelled' THEN oi.quantity * oi.price ELSE 0 END) as cancelled_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.category
ORDER BY p.category;

-- 4.2: Show count of products by category and stock status
SELECT 
    category,
    COUNT(CASE WHEN stock = 0 THEN 1 END) as out_of_stock,
    COUNT(CASE WHEN stock > 0 AND stock <= 10 THEN 1 END) as low_stock,
    COUNT(CASE WHEN stock > 10 AND stock <= 50 THEN 1 END) as adequate,
    COUNT(CASE WHEN stock > 50 THEN 1 END) as well_stocked
FROM products
GROUP BY category
ORDER BY category;


-- ============================================
-- Part 5: Advanced Applications (5 min)
-- ============================================

-- 5.1: Nested CASE for advanced customer segmentation
WITH customer_stats AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) as order_count,
        COALESCE(SUM(CASE WHEN o.status = 'completed' THEN o.total ELSE 0 END), 0) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    order_count,
    total_spent,
    CASE 
        WHEN order_count = 0 THEN 'Never Ordered'
        WHEN order_count < 5 THEN 
            CASE 
                WHEN total_spent > 1000 THEN 'High Value New'
                ELSE 'Regular New'
            END
        ELSE 
            CASE 
                WHEN total_spent > 5000 THEN 'VIP'
                WHEN total_spent > 2000 THEN 'Loyal'
                ELSE 'Regular'
            END
    END as segment
FROM customer_stats
ORDER BY total_spent DESC;

-- 5.2: Use CASE in ORDER BY to sort products with custom logic
SELECT 
    product_name,
    category,
    price
FROM products
ORDER BY 
    CASE category
        WHEN 'Electronics' THEN 1
        WHEN 'Books' THEN 2
        WHEN 'Clothing' THEN 3
        ELSE 4
    END,
    price DESC;

-- 5.3: Use CASE in WHERE to filter with category-specific rules
SELECT 
    product_name,
    category,
    price
FROM products
WHERE 
    CASE 
        WHEN category = 'Electronics' THEN price > 100
        WHEN category = 'Books' THEN price > 20
        WHEN category = 'Clothing' THEN price > 30
        ELSE price > 50
    END
ORDER BY category, price DESC;

-- 5.4: Use CASE in GROUP BY to group by price tier
SELECT 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END as price_tier,
    COUNT(*) as product_count,
    ROUND(AVG(price), 2) as avg_price,
    ROUND(SUM(price * stock), 2) as total_value
FROM products
GROUP BY 
    CASE 
        WHEN price < 50 THEN 'Budget'
        WHEN price < 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END
ORDER BY 
    CASE 
        WHEN price < 50 THEN 1
        WHEN price < 200 THEN 2
        ELSE 3
    END;
