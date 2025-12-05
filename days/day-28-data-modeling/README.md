# Day 28: Data Modeling - Star Schema

## Learning Objectives
- Understand data modeling principles
- Master star schema design (fact and dimension tables)
- Learn normalization vs denormalization
- Design efficient database schemas
- Apply dimensional modeling concepts
- Build analytics-ready data structures

## Theory (15 minutes)

### What is Data Modeling?

Data modeling is designing how data is stored, organized, and related in a database. Good data modeling:
- Improves query performance
- Ensures data integrity
- Makes data easy to understand
- Supports business requirements

### Star Schema

Star schema is a dimensional modeling approach optimized for analytics. It consists of:
- **1 Fact Table** - Contains measurements/metrics (center of star)
- **N Dimension Tables** - Contains descriptive attributes (points of star)

**Visual:**
```
        dim_date
            |
dim_customer - FACT_SALES - dim_product
            |
        dim_store
```

### Fact Tables

Contain quantitative data (measurements, metrics, facts):
- Sales amounts
- Quantities
- Counts
- Durations

**Characteristics:**
- Large (millions/billions of rows)
- Narrow (few columns)
- Foreign keys to dimensions
- Additive measures

**Example:**
```sql
CREATE TABLE fact_sales (
    sale_id INTEGER PRIMARY KEY,
    date_id INTEGER,          -- FK to dim_date
    customer_id INTEGER,      -- FK to dim_customer
    product_id INTEGER,       -- FK to dim_product
    store_id INTEGER,         -- FK to dim_store
    quantity INTEGER,         -- Measure
    unit_price DECIMAL,       -- Measure
    discount DECIMAL,         -- Measure
    total_amount DECIMAL      -- Measure
);
```

### Dimension Tables

Contain descriptive attributes (who, what, when, where, why):
- Customer details
- Product details
- Date attributes
- Location details

**Characteristics:**
- Smaller (thousands of rows)
- Wider (many columns)
- Descriptive text
- Slowly changing

**Example:**
```sql
CREATE TABLE dim_customer (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR,
    email VARCHAR,
    city VARCHAR,
    state VARCHAR,
    country VARCHAR,
    segment VARCHAR,
    registration_date DATE
);

CREATE TABLE dim_product (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR,
    category VARCHAR,
    subcategory VARCHAR,
    brand VARCHAR,
    unit_cost DECIMAL,
    list_price DECIMAL
);

CREATE TABLE dim_date (
    date_id INTEGER PRIMARY KEY,
    date DATE,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name VARCHAR,
    day INTEGER,
    day_of_week INTEGER,
    day_name VARCHAR,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN
);
```

### Star Schema Benefits

1. **Simple to understand** - Clear business logic
2. **Fast queries** - Optimized for analytics
3. **Easy to extend** - Add dimensions without changing fact
4. **Denormalized** - Fewer JOINs needed

### Star Schema vs Normalized Schema

**Normalized (OLTP):**
```sql
-- Many tables, many JOINs
customers → orders → order_items → products → categories
```

**Star Schema (OLAP):**
```sql
-- Few JOINs, fast aggregations
fact_sales → dim_customer
          → dim_product (includes category)
          → dim_date
```

### Querying Star Schema

**Basic pattern:**
```sql
SELECT 
    d.dimension_attribute,
    SUM(f.measure) as total
FROM fact_table f
JOIN dim_table d ON f.dim_id = d.id
WHERE d.filter_condition
GROUP BY d.dimension_attribute;
```

**Example:**
```sql
SELECT 
    p.category,
    d.year,
    SUM(f.total_amount) as revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_date d ON f.date_id = d.date_id
WHERE d.year = 2024
GROUP BY p.category, d.year;
```

### Normalization Levels

**1NF (First Normal Form):**
- Atomic values (no lists in cells)
- Each row unique

**2NF (Second Normal Form):**
- 1NF + No partial dependencies

**3NF (Third Normal Form):**
- 2NF + No transitive dependencies

**For OLTP:** Normalize to 3NF (reduce redundancy)
**For OLAP:** Denormalize (star schema, faster queries)

### Slowly Changing Dimensions (SCD)

**Type 1 - Overwrite:**
```sql
UPDATE dim_customer 
SET city = 'Seattle' 
WHERE customer_id = 123;
-- Loses history
```

**Type 2 - Add Row:**
```sql
INSERT INTO dim_customer VALUES (
    123, 'John', 'Seattle', '2024-01-01', '9999-12-31', TRUE
);
-- Keeps history with effective dates
```

**Type 3 - Add Column:**
```sql
ALTER TABLE dim_customer ADD COLUMN previous_city VARCHAR;
-- Keeps one level of history
```

### Best Practices

1. **Surrogate keys** - Use integers for dimension keys
2. **Date dimension** - Pre-calculate date attributes
3. **Denormalize dimensions** - Include hierarchies
4. **Grain definition** - Define fact table granularity
5. **Additive measures** - Prefer measures that can be summed
6. **Index foreign keys** - On fact table dimension keys

## Exercises (40 minutes)

### Setup
```bash
python setup.py
```

### Part 1: Design Star Schema (20 minutes)

**Exercise 1-10:** Design a complete star schema for an e-commerce business with fact_sales and appropriate dimensions. Include CREATE TABLE statements with proper keys and data types.

**Exercise 11-20:** Write queries to analyze the star schema: revenue by category, customer segments, time-series analysis, top products, regional performance.

### Part 2: Normalization vs Denormalization (20 minutes)

**Exercise 21-25:** Convert normalized tables to star schema design.

**Exercise 26-30:** Write analytical queries on star schema and compare to normalized approach.

## Key Takeaways

- **Star schema = 1 fact + N dimensions** - Optimized for analytics
- **Fact tables contain measures** - Quantitative data
- **Dimension tables contain attributes** - Descriptive data
- **Denormalization improves query speed** - Fewer JOINs
- **Date dimension is essential** - Pre-calculated date attributes
- **Surrogate keys recommended** - Integer keys for performance
- **Design for business questions** - Schema supports analytics

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 29
