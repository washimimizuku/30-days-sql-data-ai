# Day 29 Quiz: Working with JSON in DuckDB

Test your understanding of JSON operations in DuckDB!

---

## Questions

### 1. What function reads JSON files automatically detecting the schema?

- A) read_json()
- B) read_json_auto()
- C) load_json()
- D) import_json()

### 2. What's the difference between -> and ->> operators?

- A) -> returns text, ->> returns JSON
- B) -> returns JSON, ->> returns text
- C) They are the same
- D) -> is for arrays, ->> is for objects

### 3. How do you read a newline-delimited JSON file (NDJSON)?

- A) read_json_auto('file.ndjson')
- B) read_json_auto('file.ndjson', format='ndjson')
- C) read_json_auto('file.ndjson', format='newline_delimited')
- D) read_ndjson('file.ndjson')

### 4. Which function converts a JSON array to rows?

- A) EXPLODE()
- B) FLATTEN()
- C) UNNEST()
- D) EXPAND()

### 5. How do you access a nested JSON field like user.profile.name?

- A) json->'user'->'profile'->>'name'
- B) json->user->profile->name
- C) json['user']['profile']['name']
- D) json.user.profile.name

### 6. What does json_array_length() return?

- A) The size in bytes of the array
- B) The number of elements in a JSON array
- C) The depth of nested arrays
- D) The number of keys in a JSON object

### 7. How do you convert a JSON string value to an integer?

- A) Use -> operator
- B) Use ->> operator and CAST
- C) Use json_to_int()
- D) It converts automatically

### 8. What's the best practice for frequently queried JSON data?

- A) Always query directly from JSON files
- B) Extract to relational columns and create a table
- C) Keep everything as JSON for flexibility
- D) Use external JSON databases

### 9. Which is true about DuckDB's JSON support?

- A) Can only read JSON from databases
- B) Requires importing JSON before querying
- C) Can query JSON files directly without importing
- D) Only supports simple JSON structures

### 10. How do you filter products with a specific tag in a tags array?

- A) WHERE tags = 'sale'
- B) WHERE tags CONTAINS 'sale'
- C) WHERE list_contains(tags, 'sale')
- D) WHERE 'sale' IN tags

### 11. What format parameter is used for newline-delimited JSON?

- A) format='ndjson'
- B) format='newline'
- C) format='newline_delimited'
- D) format='lines'

### 12. How do you create a table from JSON data?

- A) CREATE TABLE name FROM 'file.json'
- B) CREATE TABLE name AS SELECT * FROM read_json_auto('file.json')
- C) IMPORT TABLE name FROM 'file.json'
- D) LOAD JSON 'file.json' INTO name

### 13. What's the advantage of using JSON for semi-structured data?

- A) Faster queries than relational tables
- B) Flexible schema that can vary between records
- C) Uses less storage space
- D) Easier to index

### 14. How do you export query results back to JSON?

- A) EXPORT TO 'file.json'
- B) SAVE AS JSON 'file.json'
- C) COPY (...) TO 'file.json' (FORMAT JSON)
- D) WRITE JSON 'file.json'

### 15. When should you use JSON vs relational tables?

- A) Always use JSON for modern applications
- B) Always use relational tables for performance
- C) Use JSON for varying schemas, relational for consistent structure
- D) Use JSON only for small datasets

---

## Answers

1. **B** - read_json_auto()
   - Automatically detects schema from JSON structure

2. **B** - -> returns JSON, ->> returns text
   - -> keeps JSON type, ->> extracts as text/string

3. **C** - read_json_auto('file.ndjson', format='newline_delimited')
   - Specifies the newline-delimited format

4. **C** - UNNEST()
   - Converts array elements to rows

5. **A** - json->'user'->'profile'->>'name'
   - Chain -> for nested objects, use ->> for final text value

6. **B** - The number of elements in a JSON array
   - Returns count of array elements

7. **B** - Use ->> operator and CAST
   - ->> extracts as text, then CAST converts to integer

8. **B** - Extract to relational columns and create a table
   - Better performance for repeated queries

9. **C** - Can query JSON files directly without importing
   - DuckDB's key feature for JSON

10. **C** - WHERE list_contains(tags, 'sale')
    - DuckDB function for checking array membership

11. **C** - format='newline_delimited'
    - Official parameter name in DuckDB

12. **B** - CREATE TABLE name AS SELECT * FROM read_json_auto('file.json')
    - Standard SQL CREATE TABLE AS SELECT syntax

13. **B** - Flexible schema that can vary between records
    - Main advantage of semi-structured data

14. **C** - COPY (...) TO 'file.json' (FORMAT JSON)
    - DuckDB's export syntax

15. **C** - Use JSON for varying schemas, relational for consistent structure
    - Choose based on data characteristics

---

## Scoring

- **13-15 correct**: Excellent! You've mastered JSON in DuckDB
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **read_json_auto()** - Reads JSON files with automatic schema detection

✅ **-> vs ->>** - -> returns JSON, ->> returns text

✅ **format='newline_delimited'** - For NDJSON files

✅ **UNNEST()** - Converts JSON arrays to rows

✅ **Chain operators** - json->'field1'->'field2'->>'value'

✅ **CAST for numbers** - JSON values are strings, cast for math

✅ **Create tables** - Extract frequently queried JSON to relational tables

✅ **list_contains()** - Check if array contains a value

✅ **Direct file queries** - No need to import JSON first

✅ **Best of both worlds** - Combine JSON flexibility with SQL power
