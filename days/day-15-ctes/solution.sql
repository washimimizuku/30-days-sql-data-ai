-- Day 15: CTEs - Solutions

-- Exercise 1 Solution: Simple CTE
WITH dept_avg AS (
    SELECT department, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
)
SELECT department, avg_salary
FROM dept_avg
WHERE avg_salary > 60000
ORDER BY avg_salary DESC;


-- Exercise 2 Solution: CTE with Filtering
WITH customer_totals AS (
    SELECT 
        c.customer_name,
        SUM(o.total) as total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
)
SELECT customer_name, total_spent
FROM customer_totals
WHERE total_spent > 1000
ORDER BY total_spent DESC;


-- Exercise 3 Solution: CTE for Readability
WITH category_averages AS (
    SELECT category, AVG(price) as category_avg
    FROM products
    GROUP BY category
)
SELECT 
    p.product_name,
    p.category,
    p.price,
    ca.category_avg
FROM products p
JOIN category_averages ca ON p.category = ca.category
WHERE p.price > ca.category_avg
ORDER BY p.category, p.price DESC;


-- Exercise 4 Solution: Two CTEs
WITH 
customer_orders AS (
    SELECT 
        c.customer_name,
        c.id as customer_id,
        COUNT(o.id) as order_count
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name, c.id
),
customer_spending AS (
    SELECT 
        customer_id,
        SUM(total) as total_spent
    FROM orders
    GROUP BY customer_id
)
SELECT 
    co.customer_name,
    co.order_count,
    cs.total_spent
FROM customer_orders co
JOIN customer_spending cs ON co.customer_id = cs.customer_id
ORDER BY cs.total_spent DESC;


-- Exercise 5 Solution: Three CTEs
WITH 
monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', order_date) as month,
        SUM(total) as revenue
    FROM orders
    WHERE status = 'completed'
    GROUP BY DATE_TRUNC('month', order_date)
),
revenue_with_previous AS (
    SELECT 
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) as prev_month_revenue
    FROM monthly_revenue
),
revenue_growth AS (
    SELECT 
        month,
        revenue,
        prev_month_revenue,
        ROUND((revenue - prev_month_revenue) * 100.0 / prev_month_revenue, 2) as growth_pct
    FROM revenue_with_previous
    WHERE prev_month_revenue IS NOT NULL
)
SELECT * FROM revenue_growth ORDER BY month;


-- Exercise 6 Solution: CTEs Referencing CTEs
WITH 
customer_totals AS (
    SELECT 
        c.customer_name,
        COALESCE(SUM(o.total), 0) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
),
customer_segments AS (
    SELECT 
        customer_name,
        total_spent,
        CASE 
            WHEN total_spent > 5000 THEN 'VIP'
            WHEN total_spent >= 1000 THEN 'High'
            ELSE 'Low'
        END as segment
    FROM customer_totals
),
segment_summary AS (
    SELECT 
        segment,
        COUNT(*) as customer_count,
        ROUND(AVG(total_spent), 2) as avg_spending
    FROM customer_segments
    GROUP BY segment
)
SELECT * FROM segment_summary ORDER BY avg_spending DESC;


-- Exercise 7 Solution: Complex CTE Chain
WITH 
product_sales AS (
    SELECT 
        p.id,
        p.product_name,
        p.category,
        p.price,
        p.cost,
        COALESCE(SUM(oi.quantity * oi.price), 0) as revenue,
        COALESCE(SUM(oi.quantity * p.cost), 0) as total_cost
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.id, p.product_name, p.category, p.price, p.cost
),
product_profitability AS (
    SELECT 
        *,
        revenue - total_cost as profit
    FROM product_sales
),
product_rankings AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY profit DESC) as rank_in_category
    FROM product_profitability
),
category_summary AS (
    SELECT 
        category,
        MAX(CASE WHEN rank_in_category = 1 THEN product_name END) as top_product,
        SUM(profit) as total_profit
    FROM product_rankings
    GROUP BY category
)
SELECT * FROM category_summary ORDER BY total_profit DESC;


-- Exercise 8 Solution: Customer Segmentation
WITH customer_totals AS (
    SELECT 
        c.customer_name,
        COALESCE(SUM(o.total), 0) as total_spent
    FROM customers c
    LEFT JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
)
SELECT 
    customer_name,
    total_spent,
    CASE 
        WHEN total_spent > 5000 THEN 'VIP'
        WHEN total_spent >= 1000 THEN 'High'
        WHEN total_spent >= 500 THEN 'Medium'
        ELSE 'Low'
    END as segment
FROM customer_totals
ORDER BY total_spent DESC;


-- Exercise 9 Solution: Product Performance Dashboard
WITH 
product_sales AS (
    SELECT 
        p.id,
        p.product_name,
        p.stock,
        COALESCE(SUM(oi.quantity), 0) as units_sold,
        COALESCE(SUM(oi.quantity * oi.price), 0) as revenue,
        COALESCE(SUM(oi.quantity * (oi.price - p.cost)), 0) as profit
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.id, p.product_name, p.stock, p.cost
)
SELECT 
    product_name,
    units_sold,
    revenue,
    profit,
    CASE 
        WHEN stock = 0 THEN 'Out of Stock'
        WHEN stock < 20 THEN 'Low Stock'
        ELSE 'In Stock'
    END as stock_status
FROM product_sales
ORDER BY revenue DESC;


-- Exercise 10 Solution: Customer Lifetime Value
WITH customer_metrics AS (
    SELECT 
        c.customer_name,
        COUNT(o.id) as order_count,
        SUM(o.total) as total_spent,
        AVG(o.total) as avg_order_value,
        MIN(o.order_date) as first_purchase,
        MAX(o.order_date) as last_purchase,
        MAX(o.order_date) - MIN(o.order_date) as lifespan_days
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.customer_name
)
SELECT 
    customer_name,
    total_spent,
    order_count,
    ROUND(avg_order_value, 2) as avg_order_value,
    lifespan_days
FROM customer_metrics
ORDER BY total_spent DESC;


-- Exercise 11 Solution: Top 3 per Category
WITH ranked_products AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.price) as revenue,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.price) DESC) as rank
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.category, p.product_name
)
SELECT category, product_name, revenue, rank
FROM ranked_products
WHERE rank <= 3
ORDER BY category, rank;


-- Exercise 12 Solution: Top Customers per City
WITH ranked_customers AS (
    SELECT 
        c.city,
        c.customer_name,
        SUM(o.total) as total_spent,
        ROW_NUMBER() OVER (PARTITION BY c.city ORDER BY SUM(o.total) DESC) as rank_in_city
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.city, c.customer_name
)
SELECT city, customer_name, total_spent, rank_in_city
FROM ranked_customers
WHERE rank_in_city <= 2
ORDER BY city, rank_in_city;


-- Exercise 13 Solution: Best and Worst Performers
WITH product_profit AS (
    SELECT 
        p.product_name,
        SUM(oi.quantity * (oi.price - p.cost)) as profit
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.product_name
),
top_performers AS (
    SELECT product_name, profit, 'Top 5' as performance_type
    FROM product_profit
    ORDER BY profit DESC
    LIMIT 5
),
bottom_performers AS (
    SELECT product_name, profit, 'Bottom 5' as performance_type
    FROM product_profit
    ORDER BY profit ASC
    LIMIT 5
)
SELECT * FROM top_performers
UNION ALL
SELECT * FROM bottom_performers
ORDER BY profit DESC;


-- Exercise 14 Solution: Number Series
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 20
)
SELECT * FROM numbers;


-- Exercise 15 Solution: Date Series
WITH RECURSIVE date_series AS (
    SELECT DATE '2024-01-01' as date
    UNION ALL
    SELECT date + INTERVAL '1 day'
    FROM date_series
    WHERE date < DATE '2024-01-31'
)
SELECT * FROM date_series;


-- Exercise 16 Solution: Organization Chart
WITH RECURSIVE org_chart AS (
    SELECT 
        id,
        name as employee_name,
        manager_id,
        0 as level,
        name as path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT 
        e.id,
        e.name,
        e.manager_id,
        oc.level + 1,
        oc.path || ' > ' || e.name
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.id
)
SELECT employee_name, level, path
FROM org_chart
ORDER BY path;


-- Exercise 17 Solution: All Subordinates
WITH RECURSIVE subordinates AS (
    SELECT 
        id as manager_id,
        name as manager_name,
        id as subordinate_id,
        name as subordinate_name,
        0 as levels_below
    FROM employees
    
    UNION ALL
    
    SELECT 
        s.manager_id,
        s.manager_name,
        e.id,
        e.name,
        s.levels_below + 1
    FROM employees e
    JOIN subordinates s ON e.manager_id = s.subordinate_id
)
SELECT DISTINCT manager_name, subordinate_name, levels_below
FROM subordinates
WHERE levels_below > 0
ORDER BY manager_name, levels_below, subordinate_name;


-- Exercise 18 Solution: Customer Churn Prediction
WITH 
customer_orders AS (
    SELECT 
        c.customer_name,
        c.id as customer_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY c.id ORDER BY o.order_date) as prev_order_date
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
),
customer_metrics AS (
    SELECT 
        customer_name,
        MAX(order_date) as last_order_date,
        CURRENT_DATE - MAX(order_date) as days_since_last_order,
        AVG(order_date - prev_order_date) as avg_days_between_orders
    FROM customer_orders
    WHERE prev_order_date IS NOT NULL
    GROUP BY customer_name
)
SELECT 
    customer_name,
    days_since_last_order,
    ROUND(avg_days_between_orders) as avg_days_between_orders,
    CASE 
        WHEN days_since_last_order > avg_days_between_orders * 2 THEN 'High Risk'
        WHEN days_since_last_order > avg_days_between_orders * 1.5 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as risk_level
FROM customer_metrics
ORDER BY days_since_last_order DESC;


-- Exercise 19 Solution: Inventory Reorder Report
WITH 
product_sales_rate AS (
    SELECT 
        p.id,
        p.product_name,
        p.stock as current_stock,
        COALESCE(SUM(oi.quantity) / 365.0, 0) as daily_sales_rate
    FROM products p
    LEFT JOIN order_items oi ON p.id = oi.product_id
    GROUP BY p.id, p.product_name, p.stock
)
SELECT 
    product_name,
    current_stock,
    ROUND(daily_sales_rate, 2) as daily_sales_rate,
    CASE 
        WHEN daily_sales_rate > 0 THEN ROUND(current_stock / daily_sales_rate)
        ELSE NULL
    END as days_remaining,
    CASE 
        WHEN daily_sales_rate > 0 AND current_stock / daily_sales_rate < 30 THEN 'Yes'
        ELSE 'No'
    END as reorder_needed
FROM product_sales_rate
ORDER BY days_remaining NULLS LAST;


-- Exercise 20 Solution: Sales Reconciliation
WITH 
order_totals AS (
    SELECT id as order_id, total as order_total
    FROM orders
),
items_totals AS (
    SELECT 
        order_id,
        SUM(quantity * price) as items_total
    FROM order_items
    GROUP BY order_id
)
SELECT 
    ot.order_id,
    ot.order_total,
    COALESCE(it.items_total, 0) as items_total,
    ROUND(ot.order_total - COALESCE(it.items_total, 0), 2) as difference
FROM order_totals ot
LEFT JOIN items_totals it ON ot.order_id = it.order_id
WHERE ABS(ot.order_total - COALESCE(it.items_total, 0)) > 0.01
ORDER BY ABS(difference) DESC;
