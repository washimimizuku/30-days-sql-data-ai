-- Day 29: Working with JSON in DuckDB
-- Practice exercises for reading and querying JSON data

-- ============================================
-- Exercise 1: Reading JSON Files (5 min)
-- ============================================

-- 1.1: Read all API logs from api_logs.json
-- TODO: Use read_json_auto() to read the file
-- Expected: All 100 API log records


-- 1.2: Read e-commerce events from events.ndjson (newline-delimited)
-- TODO: Use format='newline_delimited' parameter
-- Expected: All 150 event records


-- 1.3: Count total records in each JSON file
-- TODO: Count records from api_logs.json
-- TODO: Count records from events.ndjson
-- TODO: Count records from products.json
-- TODO: Count records from users.json


-- 1.4: Show the first 5 products from products.json
-- TODO: Read products.json and limit to 5 rows
-- Expected: product_id, name, category, price


-- ============================================
-- Exercise 2: Extracting JSON Values (10 min)
-- ============================================

-- 2.1: Extract user_id from nested user object in API logs
-- TODO: Use -> or ->> operator to access user.id
-- Expected columns: timestamp, endpoint, user_id


-- 2.2: Get IP address from user.ip in API logs
-- TODO: Access nested user.ip field
-- Expected columns: request_id, user_id, ip_address


-- 2.3: Extract region from metadata in API logs
-- TODO: Access metadata.region field
-- Expected columns: endpoint, region, status_code


-- 2.4: Show timestamp, endpoint, and status_code from API logs
-- TODO: Select these three fields
-- Expected: Clean column names


-- 2.5: Extract brand from attributes in products
-- TODO: Access attributes.brand field
-- Expected columns: product_id, name, brand


-- 2.6: Get average_rating from reviews in products
-- TODO: Access reviews.average_rating field
-- Expected columns: product_id, name, rating


-- 2.7: Extract color and size from attributes in products
-- TODO: Access both attributes.color and attributes.size
-- Expected columns: product_id, name, color, size


-- 2.8: Show in_stock status from inventory in products
-- TODO: Access inventory.in_stock field
-- Expected columns: product_id, name, in_stock, quantity


-- ============================================
-- Exercise 3: Filtering JSON Data (10 min)
-- ============================================

-- 3.1: Find all API requests with status_code >= 500
-- TODO: Filter API logs for server errors
-- Expected: Only records with status_code 500+


-- 3.2: Find products with rating >= 4.5
-- TODO: Filter products by reviews.average_rating
-- Hint: Use CAST to convert to DECIMAL
-- Expected: High-rated products only


-- 3.3: Find API requests from 'us-east' region
-- TODO: Filter by metadata.region
-- Expected: Only us-east requests


-- 3.4: Find products that are in_stock
-- TODO: Filter by inventory.in_stock = true
-- Expected: Available products only


-- 3.5: Find users who have newsletter enabled
-- TODO: Filter users by preferences.newsletter = true
-- Expected: Users subscribed to newsletter


-- 3.6: Find events of type 'purchase'
-- TODO: Filter events by event_type
-- Expected: Only purchase events


-- ============================================
-- Exercise 4: Working with JSON Arrays (10 min)
-- ============================================

-- 4.1: Unnest product tags (convert array to rows)
-- TODO: Use UNNEST() on tags array
-- Expected: One row per product-tag combination


-- 4.2: Count how many tags each product has
-- TODO: Use array_length() or count after unnesting
-- Expected columns: product_id, name, tag_count


-- 4.3: Find products with 'sale' tag
-- TODO: Unnest tags and filter for 'sale'
-- Expected: Products on sale


-- 4.4: Unnest warehouse locations from inventory
-- TODO: Unnest inventory.warehouses array
-- Expected: One row per product-warehouse combination


-- 4.5: Get all favorite_categories from users
-- TODO: Unnest preferences.favorite_categories
-- Expected: User-category combinations


-- 4.6: Count items in purchase events
-- TODO: Use json_array_length() on properties.items
-- Expected columns: event_id, order_id, item_count


-- ============================================
-- Exercise 5: Advanced JSON Queries (5 min)
-- ============================================

-- 5.1: Calculate average response_time_ms by endpoint
-- TODO: Group API logs by endpoint and calculate average
-- Expected columns: endpoint, avg_response_time, request_count


-- 5.2: Find top 5 most expensive products by category
-- TODO: Use window functions or subquery
-- Expected: Top 5 products per category


-- 5.3: Count events by event_type and hour
-- TODO: Extract hour from timestamp and group
-- Expected columns: event_type, hour, event_count


-- 5.4: Find users with total_spent > $1000
-- TODO: Filter users by purchase_history.total_spent
-- Expected: High-value customers


-- 5.5: Create a relational table from JSON data
-- TODO: CREATE TABLE products_clean AS SELECT ... from products.json
-- TODO: Extract key fields into proper columns
-- Expected: A clean relational table


-- ============================================
-- Bonus Challenges
-- ============================================

-- BONUS 1: Find the most common HTTP method for each endpoint
-- Hint: Use GROUP BY and window functions


-- BONUS 2: Calculate conversion rate (purchases / page_views) by user
-- Hint: Use conditional aggregation


-- BONUS 3: Find products with reviews but no inventory
-- Hint: Check review_count > 0 and quantity = 0


-- BONUS 4: Export query results back to JSON
-- Hint: Use COPY TO with format='json'
