-- Day 29: Working with JSON in DuckDB - Solutions

-- ============================================
-- Exercise 1: Reading JSON Files (5 min)
-- ============================================

-- 1.1: Read all API logs from api_logs.json
SELECT * 
FROM read_json_auto('../../data/raw/api_logs.json')
LIMIT 10;

-- 1.2: Read e-commerce events from events.ndjson (newline-delimited)
SELECT * 
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
LIMIT 10;

-- 1.3: Count total records in each JSON file
SELECT 'api_logs' as file, COUNT(*) as record_count
FROM read_json_auto('../../data/raw/api_logs.json')
UNION ALL
SELECT 'events', COUNT(*)
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
UNION ALL
SELECT 'products', COUNT(*)
FROM read_json_auto('../../data/raw/products.json')
UNION ALL
SELECT 'users', COUNT(*)
FROM read_json_auto('../../data/raw/users.json');

-- 1.4: Show the first 5 products from products.json
SELECT 
    product_id,
    name,
    category,
    price
FROM read_json_auto('../../data/raw/products.json')
LIMIT 5;


-- ============================================
-- Exercise 2: Extracting JSON Values (10 min)
-- ============================================

-- 2.1: Extract user_id from nested user object in API logs
SELECT 
    timestamp,
    endpoint,
    user->>'id' as user_id
FROM read_json_auto('../../data/raw/api_logs.json')
LIMIT 10;

-- 2.2: Get IP address from user.ip in API logs
SELECT 
    request_id,
    user->>'id' as user_id,
    user->>'ip' as ip_address
FROM read_json_auto('../../data/raw/api_logs.json')
LIMIT 10;

-- 2.3: Extract region from metadata in API logs
SELECT 
    endpoint,
    metadata->>'region' as region,
    status_code
FROM read_json_auto('../../data/raw/api_logs.json')
LIMIT 10;

-- 2.4: Show timestamp, endpoint, and status_code from API logs
SELECT 
    timestamp,
    endpoint,
    status_code
FROM read_json_auto('../../data/raw/api_logs.json')
ORDER BY timestamp
LIMIT 10;

-- 2.5: Extract brand from attributes in products
SELECT 
    product_id,
    name,
    attributes->>'brand' as brand
FROM read_json_auto('../../data/raw/products.json')
LIMIT 10;

-- 2.6: Get average_rating from reviews in products
SELECT 
    product_id,
    name,
    CAST(reviews->>'average_rating' AS DECIMAL) as rating
FROM read_json_auto('../../data/raw/products.json')
ORDER BY rating DESC
LIMIT 10;

-- 2.7: Extract color and size from attributes in products
SELECT 
    product_id,
    name,
    attributes->>'color' as color,
    attributes->>'size' as size
FROM read_json_auto('../../data/raw/products.json')
LIMIT 10;

-- 2.8: Show in_stock status from inventory in products
SELECT 
    product_id,
    name,
    CAST(inventory->>'in_stock' AS BOOLEAN) as in_stock,
    CAST(inventory->>'quantity' AS INTEGER) as quantity
FROM read_json_auto('../../data/raw/products.json')
LIMIT 10;


-- ============================================
-- Exercise 3: Filtering JSON Data (10 min)
-- ============================================

-- 3.1: Find all API requests with status_code >= 500
SELECT 
    timestamp,
    method,
    endpoint,
    status_code,
    response_time_ms
FROM read_json_auto('../../data/raw/api_logs.json')
WHERE status_code >= 500
ORDER BY timestamp;

-- 3.2: Find products with rating >= 4.5
SELECT 
    product_id,
    name,
    category,
    price,
    CAST(reviews->>'average_rating' AS DECIMAL) as rating,
    CAST(reviews->>'count' AS INTEGER) as review_count
FROM read_json_auto('../../data/raw/products.json')
WHERE CAST(reviews->>'average_rating' AS DECIMAL) >= 4.5
ORDER BY rating DESC;

-- 3.3: Find API requests from 'us-east' region
SELECT 
    timestamp,
    endpoint,
    method,
    status_code,
    metadata->>'region' as region
FROM read_json_auto('../../data/raw/api_logs.json')
WHERE metadata->>'region' = 'us-east'
ORDER BY timestamp;

-- 3.4: Find products that are in_stock
SELECT 
    product_id,
    name,
    category,
    price,
    CAST(inventory->>'quantity' AS INTEGER) as quantity
FROM read_json_auto('../../data/raw/products.json')
WHERE CAST(inventory->>'in_stock' AS BOOLEAN) = true
ORDER BY quantity DESC;

-- 3.5: Find users who have newsletter enabled
SELECT 
    user_id,
    username,
    email,
    profile->>'first_name' as first_name,
    profile->>'last_name' as last_name
FROM read_json_auto('../../data/raw/users.json')
WHERE CAST(preferences->>'newsletter' AS BOOLEAN) = true;

-- 3.6: Find events of type 'purchase'
SELECT 
    event_id,
    event_type,
    timestamp,
    user_id,
    properties->>'order_id' as order_id,
    CAST(properties->>'total_amount' AS DECIMAL) as total_amount
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
WHERE event_type = 'purchase'
ORDER BY timestamp;


-- ============================================
-- Exercise 4: Working with JSON Arrays (10 min)
-- ============================================

-- 4.1: Unnest product tags (convert array to rows)
SELECT 
    product_id,
    name,
    UNNEST(tags) as tag
FROM read_json_auto('../../data/raw/products.json')
WHERE array_length(tags) > 0
ORDER BY product_id;

-- 4.2: Count how many tags each product has
SELECT 
    product_id,
    name,
    array_length(tags) as tag_count
FROM read_json_auto('../../data/raw/products.json')
ORDER BY tag_count DESC;

-- 4.3: Find products with 'sale' tag
SELECT 
    product_id,
    name,
    category,
    price,
    tags
FROM read_json_auto('../../data/raw/products.json')
WHERE list_contains(tags, 'sale')
ORDER BY price DESC;

-- 4.4: Unnest warehouse locations from inventory
SELECT 
    product_id,
    name,
    UNNEST(json_extract(inventory, '$.warehouses')) as warehouse
FROM read_json_auto('../../data/raw/products.json')
LIMIT 20;

-- Alternative: Extract specific warehouse fields
SELECT 
    product_id,
    name,
    json_extract_string(UNNEST(json_extract(inventory, '$.warehouses')), '$.location') as warehouse_location,
    CAST(json_extract_string(UNNEST(json_extract(inventory, '$.warehouses')), '$.quantity') AS INTEGER) as warehouse_quantity
FROM read_json_auto('../../data/raw/products.json')
LIMIT 20;

-- 4.5: Get all favorite_categories from users
SELECT 
    user_id,
    username,
    UNNEST(json_extract(preferences, '$.favorite_categories')) as favorite_category
FROM read_json_auto('../../data/raw/users.json')
ORDER BY user_id;

-- 4.6: Count items in purchase events
SELECT 
    event_id,
    user_id,
    properties->>'order_id' as order_id,
    json_array_length(json_extract(properties, '$.items')) as item_count,
    CAST(properties->>'total_amount' AS DECIMAL) as total_amount
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
WHERE event_type = 'purchase'
ORDER BY item_count DESC;


-- ============================================
-- Exercise 5: Advanced JSON Queries (5 min)
-- ============================================

-- 5.1: Calculate average response_time_ms by endpoint
SELECT 
    endpoint,
    COUNT(*) as request_count,
    ROUND(AVG(response_time_ms), 2) as avg_response_time,
    MIN(response_time_ms) as min_response_time,
    MAX(response_time_ms) as max_response_time
FROM read_json_auto('../../data/raw/api_logs.json')
GROUP BY endpoint
ORDER BY avg_response_time DESC;

-- 5.2: Find top 5 most expensive products by category
WITH ranked_products AS (
    SELECT 
        product_id,
        name,
        category,
        price,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as rank
    FROM read_json_auto('../../data/raw/products.json')
)
SELECT 
    category,
    name,
    price,
    rank
FROM ranked_products
WHERE rank <= 5
ORDER BY category, rank;

-- 5.3: Count events by event_type and hour
SELECT 
    event_type,
    EXTRACT(HOUR FROM CAST(timestamp AS TIMESTAMP)) as hour,
    COUNT(*) as event_count
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
GROUP BY event_type, hour
ORDER BY event_type, hour;

-- 5.4: Find users with total_spent > $1000
SELECT 
    user_id,
    username,
    email,
    profile->>'first_name' as first_name,
    profile->>'last_name' as last_name,
    CAST(purchase_history->>'total_orders' AS INTEGER) as total_orders,
    CAST(purchase_history->>'total_spent' AS DECIMAL) as total_spent
FROM read_json_auto('../../data/raw/users.json')
WHERE CAST(purchase_history->>'total_spent' AS DECIMAL) > 1000
ORDER BY total_spent DESC;

-- 5.5: Create a relational table from JSON data
CREATE OR REPLACE TABLE products_clean AS
SELECT 
    product_id,
    name,
    category,
    price,
    attributes->>'brand' as brand,
    attributes->>'color' as color,
    attributes->>'size' as size,
    CAST(attributes->>'weight_kg' AS DECIMAL) as weight_kg,
    CAST(reviews->>'average_rating' AS DECIMAL) as average_rating,
    CAST(reviews->>'count' AS INTEGER) as review_count,
    CAST(inventory->>'in_stock' AS BOOLEAN) as in_stock,
    CAST(inventory->>'quantity' AS INTEGER) as quantity,
    tags
FROM read_json_auto('../../data/raw/products.json');

-- Verify the table
SELECT * FROM products_clean LIMIT 10;


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Find the most common HTTP method for each endpoint
WITH method_counts AS (
    SELECT 
        endpoint,
        method,
        COUNT(*) as count,
        ROW_NUMBER() OVER (PARTITION BY endpoint ORDER BY COUNT(*) DESC) as rank
    FROM read_json_auto('../../data/raw/api_logs.json')
    GROUP BY endpoint, method
)
SELECT 
    endpoint,
    method as most_common_method,
    count as request_count
FROM method_counts
WHERE rank = 1
ORDER BY count DESC;

-- BONUS 2: Calculate conversion rate (purchases / page_views) by user
WITH user_events AS (
    SELECT 
        user_id,
        SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) as page_views,
        SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) as purchases
    FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
    GROUP BY user_id
)
SELECT 
    user_id,
    page_views,
    purchases,
    CASE 
        WHEN page_views > 0 THEN ROUND(purchases::DECIMAL / page_views * 100, 2)
        ELSE 0 
    END as conversion_rate_pct
FROM user_events
WHERE page_views > 0
ORDER BY conversion_rate_pct DESC;

-- BONUS 3: Find products with reviews but no inventory
SELECT 
    product_id,
    name,
    category,
    price,
    CAST(reviews->>'count' AS INTEGER) as review_count,
    CAST(reviews->>'average_rating' AS DECIMAL) as rating,
    CAST(inventory->>'quantity' AS INTEGER) as quantity
FROM read_json_auto('../../data/raw/products.json')
WHERE CAST(reviews->>'count' AS INTEGER) > 0
  AND CAST(inventory->>'quantity' AS INTEGER) = 0
ORDER BY review_count DESC;

-- BONUS 4: Export query results back to JSON
COPY (
    SELECT 
        endpoint,
        COUNT(*) as total_requests,
        AVG(response_time_ms) as avg_response_time,
        SUM(CASE WHEN status_code >= 500 THEN 1 ELSE 0 END) as error_count
    FROM read_json_auto('../../data/raw/api_logs.json')
    GROUP BY endpoint
) TO '../../data/processed/api_summary.json' (FORMAT JSON, ARRAY true);

-- Verify the export
SELECT * FROM read_json_auto('../../data/processed/api_summary.json');
