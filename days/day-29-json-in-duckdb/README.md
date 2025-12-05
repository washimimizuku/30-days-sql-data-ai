# Day 29: Working with JSON in DuckDB

## Learning Objectives
- Work with JSON data in DuckDB
- Extract values from JSON objects and arrays
- Query nested JSON structures
- Convert between JSON and relational data
- Use JSON functions effectively
- Handle semi-structured data

## Theory (15 minutes)

### JSON in DuckDB

DuckDB has excellent JSON support for working with semi-structured data.

### Reading JSON Files

```sql
-- Read JSON file
SELECT * FROM read_json_auto('data.json');

-- Read with schema
SELECT * FROM read_json('data.json', 
    columns={id: 'INTEGER', name: 'VARCHAR', data: 'JSON'});
```

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

### Practical Examples

**Example 1: E-commerce events**
```sql
SELECT 
    event_date,
    event_type,
    properties->>'product_id' as product_id,
    CAST(properties->>'price' AS DECIMAL) as price
FROM events
WHERE event_type = 'purchase';
```

**Example 2: API responses**
```sql
SELECT 
    response->>'status' as status,
    response->'data'->>'user_id' as user_id,
    json_array_length(response->'data'->'items') as item_count
FROM api_logs;
```

### Best Practices

1. **Use JSON for semi-structured data** - When schema varies
2. **Extract to columns for analysis** - Better performance
3. **Index extracted values** - Create computed columns
4. **Validate JSON** - Check structure before querying
5. **Consider normalization** - For frequently queried fields

## Exercises (40 minutes)

### Setup
```bash
python setup.py
```

### Part 1: Basic JSON Operations (15 minutes)

**Exercise 1-10:** Extract values from JSON objects, access nested properties, work with JSON arrays, convert JSON to columns.

### Part 2: Advanced JSON Queries (15 minutes)

**Exercise 11-20:** Query nested JSON, filter by JSON values, aggregate JSON data, unnest arrays, join JSON with relational data.

### Part 3: Real-World JSON (10 minutes)

**Exercise 21-30:** Analyze API logs, process event data, extract metrics from JSON, create reports from semi-structured data.

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
