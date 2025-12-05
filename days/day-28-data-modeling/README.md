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

---

## 💻 Hands-On Exercises (40 min)

### Setup

Run the setup script to create a complete star schema:

```bash
python setup.py
```

This creates:
- **fact_sales** - 5,000 sales transactions
- **dim_date** - 730 days (2023-2024)
- **dim_customer** - 200 customers
- **dim_product** - 128 products
- **dim_store** - 25 stores

### Exercise 1: Explore the Star Schema (5 min)

1. Show all tables in the database
2. Describe the structure of fact_sales
3. Count rows in each dimension table
4. Show sample data from fact_sales with all dimensions

### Exercise 2: Basic Dimensional Queries (10 min)

1. Calculate total revenue by category
2. Find top 10 customers by total spend
3. Show monthly sales trends for 2024
4. Calculate revenue by store region
5. Find best-selling products by quantity

### Exercise 3: Time-Series Analysis (10 min)

1. Calculate revenue by quarter
2. Compare sales between weekdays and weekends
3. Find the best performing month
4. Calculate year-over-year growth
5. Identify seasonal patterns

### Exercise 4: Advanced Analytics (10 min)

1. Calculate profit margin by category
2. Find customer segments by lifetime value
3. Analyze discount impact on sales
4. Calculate store performance metrics
5. Identify cross-selling opportunities

### Exercise 5: Star Schema Benefits (5 min)

1. Write a query joining all dimensions
2. Calculate running totals by date
3. Rank products within categories
4. Create a sales dashboard query
5. Compare query performance vs normalized schema

---

## 🎯 Practice

Complete all exercises in `exercise.sql`:

```bash
# From days/day-28-data-modeling/
python ../../tools/run_sql.py ../../data/databases/day28.db exercise.sql
```

---

## 💡 Real-World Patterns

### Common Star Schema Queries

**Pattern 1: Revenue by Dimension**
```sql
SELECT 
    p.category,
    SUM(f.total_amount) as revenue,
    COUNT(DISTINCT f.customer_id) as unique_customers,
    SUM(f.quantity) as units_sold
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;
```

**Pattern 2: Time-Series Analysis**
```sql
SELECT 
    d.year,
    d.month_name,
    SUM(f.total_amount) as monthly_revenue,
    COUNT(*) as transaction_count
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;
```

**Pattern 3: Multi-Dimensional Analysis**
```sql
SELECT 
    d.year,
    d.quarter,
    p.category,
    s.region,
    SUM(f.total_amount) as revenue,
    SUM(f.profit_amount) as profit,
    ROUND(SUM(f.profit_amount) / SUM(f.total_amount) * 100, 2) as profit_margin_pct
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_store s ON f.store_id = s.store_id
WHERE d.year = 2024
GROUP BY d.year, d.quarter, p.category, s.region
ORDER BY revenue DESC;
```

**Pattern 4: Customer Segmentation**
```sql
SELECT 
    c.segment,
    COUNT(DISTINCT c.customer_id) as customer_count,
    SUM(f.total_amount) as total_revenue,
    AVG(f.total_amount) as avg_transaction,
    SUM(f.total_amount) / COUNT(DISTINCT c.customer_id) as revenue_per_customer
FROM fact_sales f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_revenue DESC;
```

### Performance Optimization Tips

1. **Index foreign keys** in fact table
2. **Partition fact table** by date for large datasets
3. **Pre-aggregate** common metrics in summary tables
4. **Use columnar storage** (DuckDB does this automatically)
5. **Materialize** frequently used joins as views
6. **Keep dimensions small** - Denormalize hierarchies

### When to Use Star Schema

✅ **Use Star Schema for:**
- Data warehouses and analytics
- Business intelligence reporting
- OLAP (Online Analytical Processing)
- Historical data analysis
- Aggregation-heavy queries

❌ **Don't Use Star Schema for:**
- OLTP (Online Transaction Processing)
- Real-time transactional systems
- Frequent updates/deletes
- Normalized operational databases

## Key Takeaways

- **Star schema = 1 fact + N dimensions** - Optimized for analytics
- **Fact tables contain measures** - Quantitative data (revenue, quantity, profit)
- **Dimension tables contain attributes** - Descriptive data (who, what, when, where)
- **Denormalization improves query speed** - Fewer JOINs needed
- **Date dimension is essential** - Pre-calculated date attributes save computation
- **Surrogate keys recommended** - Integer keys for better performance
- **Design for business questions** - Schema should support common analytics
- **Separate OLTP from OLAP** - Different schemas for different purposes

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 29
