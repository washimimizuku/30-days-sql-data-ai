# Day 29: Working with JSON in DuckDB

## 📖 Learning Objectives (15 min)

By the end of today, you will:
- Read JSON files directly with DuckDB
- Extract values from nested JSON objects
- Work with JSON arrays and unnest them
- Convert semi-structured JSON to relational tables
- Query real-world API logs and event data
- Master JSON operators and functions
- Understand when to use JSON vs relational data

---

## 📚 Theory (15 minutes)

### Why JSON in DuckDB?

Modern data comes in many formats. APIs return JSON, logs are JSON, NoSQL databases export JSON. DuckDB lets you query JSON files directly without importing them first!

**Benefits:**
- Query JSON files like tables
- No ETL needed for exploration
- Combine JSON with relational data
- Extract only what you need

### Reading JSON Files

DuckDB can read JSON files directly:

```sql
-- Read JSON array file (auto-detect schema)
SELECT * FROM read_json_auto('../../data/raw/api_logs.json');

-- Read newline-delimited JSON (NDJSON)
SELECT * FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited');

-- Read with explicit schema
SELECT * FROM read_json('../../data/raw/users.json', 
    columns={
        user_id: 'INTEGER', 
        username: 'VARCHAR', 
        profile: 'JSON'
    });
```

**File formats supported:**
- Standard JSON array: `[{...}, {...}]`
- Newline-delimited JSON (NDJSON): `{...}\n{...}\n`
- Single JSON object: `{...}`

### JSON Data Type

```sql
CREATE TABLE events (
    id INTEGER,
    event_name VARCHAR,
    metadata JSON
);

INSERT INTO events VALUES 
(1, 'page_view', '{"page": "/home", "duration": 45}'),
(2, 'click', '{"button": "signup", "x": 100, "y": 200}');
```

### Extracting JSON Values

**Arrow operator (->):** Returns JSON
**Double arrow (->>):** Returns text

```sql
SELECT 
    metadata->'page' as page_json,        -- Returns JSON
    metadata->>'page' as page_text        -- Returns text
FROM events;
```

### JSON Functions

**json_extract():**
```sql
SELECT json_extract(metadata, '$.page') FROM events;
```

**json_extract_path():**
```sql
SELECT json_extract_path(metadata, 'page') FROM events;
```

**json_array_length():**
```sql
SELECT json_array_length('["a", "b", "c"]');  -- Returns 3
```

### Nested JSON

```sql
-- Access nested values
SELECT 
    metadata->'user'->>'name' as user_name,
    metadata->'user'->>'email' as user_email
FROM events;
```

### JSON Arrays

```sql
-- Array element access
SELECT 
    tags[1] as first_tag,
    tags[2] as second_tag
FROM products;

-- Unnest array
SELECT unnest(json_extract(data, '$.items')) as item
FROM orders;
```

### Converting JSON to Columns

```sql
SELECT 
    id,
    metadata->>'page' as page,
    CAST(metadata->>'duration' AS INTEGER) as duration
FROM events;
```

### Real-World Examples with Our Data

**Example 1: Query API logs directly from file**
```sql
SELECT 
    timestamp,
    method,
    endpoint,
    status_code,
    response_time_ms,
    user->>'id' as user_id,
    metadata->>'region' as region
FROM read_json_auto('../../data/raw/api_logs.json')
WHERE status_code >= 400
ORDER BY response_time_ms DESC
LIMIT 10;
```

**Example 2: Analyze e-commerce events**
```sql
SELECT 
    event_type,
    COUNT(*) as event_count,
    COUNT(DISTINCT user_id) as unique_users
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
GROUP BY event_type
ORDER BY event_count DESC;
```

**Example 3: Extract nested product data**
```sql
SELECT 
    product_id,
    name,
    price,
    attributes->>'brand' as brand,
    attributes->>'color' as color,
    reviews->>'average_rating' as rating,
    CAST(reviews->>'count' AS INTEGER) as review_count
FROM read_json_auto('../../data/raw/products.json')
WHERE CAST(reviews->>'average_rating' AS DECIMAL) >= 4.5;
```

**Example 4: Unnest JSON arrays**
```sql
-- Get all product tags (array to rows)
SELECT 
    product_id,
    name,
    UNNEST(tags) as tag
FROM read_json_auto('../../data/raw/products.json')
WHERE array_length(tags) > 0;
```

### Common Patterns

**Pattern 1: JSON to Table**
```sql
-- Create a relational table from JSON
CREATE TABLE products_table AS
SELECT 
    product_id,
    name,
    category,
    price,
    attributes->>'brand' as brand,
    attributes->>'color' as color,
    CAST(reviews->>'average_rating' AS DECIMAL) as rating,
    CAST(reviews->>'count' AS INTEGER) as review_count
FROM read_json_auto('../../data/raw/products.json');
```

**Pattern 2: Combine JSON with Relational Data**
```sql
-- Join JSON file with database table
SELECT 
    e.event_type,
    e.user_id,
    e.properties->>'product_id' as product_id,
    u.username
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited') e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_type = 'purchase';
```

**Pattern 3: Aggregate JSON Data**
```sql
-- Aggregate metrics from JSON
SELECT 
    endpoint,
    COUNT(*) as request_count,
    AVG(response_time_ms) as avg_response_time,
    SUM(CASE WHEN status_code >= 500 THEN 1 ELSE 0 END) as error_count
FROM read_json_auto('../../data/raw/api_logs.json')
GROUP BY endpoint
ORDER BY error_count DESC;
```

**Pattern 4: Flatten Nested Arrays**
```sql
-- Flatten nested purchase items
SELECT 
    event_id,
    user_id,
    properties->>'order_id' as order_id,
    UNNEST(json_extract(properties, '$.items')) as item
FROM read_json_auto('../../data/raw/events.ndjson', format='newline_delimited')
WHERE event_type = 'purchase';
```

### Best Practices

1. **Use read_json_auto() for exploration** - Auto-detects schema
2. **Extract to columns for repeated queries** - Better performance
3. **Use CAST for numeric operations** - JSON values are strings
4. **Unnest arrays for analysis** - Convert to rows
5. **Create tables from JSON** - For frequently accessed data
6. **Combine with relational data** - Best of both worlds
7. **Use format='newline_delimited'** - For NDJSON files

### Performance Tips

- **Create tables from JSON** if querying repeatedly
- **Extract only needed fields** - Don't SELECT *
- **Filter early** - Use WHERE on JSON fields
- **Index extracted columns** - After creating tables
- **Use COPY TO** - Export results back to JSON if needed

---

## 💻 Hands-On Exercises (40 min)

### Setup

Run the setup script to create JSON files:

```bash
python setup.py
```

This creates 4 JSON files in `data/raw/`:
- `api_logs.json` - 100 API request logs
- `events.ndjson` - 150 e-commerce events  
- `products.json` - 50 products with nested data
- `users.json` - 30 user profiles

### Exercise 1: Reading JSON Files (5 min)

1. Read all API logs from `api_logs.json`
2. Read e-commerce events from `events.ndjson` (newline-delimited)
3. Count total records in each JSON file
4. Show the first 5 products from `products.json`

### Exercise 2: Extracting JSON Values (10 min)

Using `api_logs.json`:
1. Extract user_id from nested user object
2. Get IP address from user.ip
3. Extract region from metadata
4. Show timestamp, endpoint, and status_code

Using `products.json`:
5. Extract brand from attributes
6. Get average_rating from reviews
7. Extract color and size from attributes
8. Show in_stock status from inventory

### Exercise 3: Filtering JSON Data (10 min)

1. Find all API requests with status_code >= 500
2. Find products with rating >= 4.5
3. Find API requests from 'us-east' region
4. Find products that are in_stock
5. Find users who have newsletter enabled
6. Find events of type 'purchase'

### Exercise 4: Working with JSON Arrays (10 min)

1. Unnest product tags (convert array to rows)
2. Count how many tags each product has
3. Find products with 'sale' tag
4. Unnest warehouse locations from inventory
5. Get all favorite_categories from users
6. Count items in purchase events

### Exercise 5: Advanced JSON Queries (5 min)

1. Calculate average response_time_ms by endpoint
2. Find top 5 most expensive products by category
3. Count events by event_type and hour
4. Find users with total_spent > $1000
5. Create a relational table from JSON data

---

## 🎯 Practice

Complete all exercises in `exercise.sql`:

```bash
# From days/day-29-json-in-duckdb/
python ../../tools/run_sql.py ../../data/databases/day29.db exercise.sql
```

---

## 💡 Key Concepts & Patterns

## Key Takeaways

- **DuckDB has excellent JSON support** - Native JSON type and functions
- **Arrow operators extract values** - -> for JSON, ->> for text
- **Unnest arrays for analysis** - Convert arrays to rows
- **Extract to columns** - Better performance than querying JSON
- **JSON for semi-structured data** - When schema varies
- **read_json_auto() reads files** - Automatic schema detection
- **Combine JSON with SQL** - Powerful for modern data analysis

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 30
