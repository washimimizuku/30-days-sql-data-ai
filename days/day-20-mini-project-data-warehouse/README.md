# Day 20: Mini Project - Data Warehouse Queries

## Learning Objectives
- Apply all advanced SQL skills to data warehouse scenarios
- Build complex analytical queries using CTEs, window functions, and subqueries
- Perform dimensional analysis and time-series analytics
- Create business intelligence reports
- Master real-world data warehouse query patterns

## Project Overview (5 minutes)

### The Business Scenario

You're a BI analyst at **GlobalRetail**, a multinational e-commerce company. The data warehouse team has built a star schema with fact and dimension tables. Your job is to write complex analytical queries to answer strategic business questions.

### Data Warehouse Schema

**Fact Table:**
- **fact_sales** - Transaction-level sales data
  - sale_id, date_id, customer_id, product_id, store_id
  - quantity, unit_price, discount_amount, total_amount

**Dimension Tables:**
- **dim_date** - Date dimension
  - date_id, date, year, quarter, month, month_name, day, day_of_week, is_weekend, is_holiday
  
- **dim_customer** - Customer dimension
  - customer_id, customer_name, email, city, state, country, segment, registration_date
  
- **dim_product** - Product dimension
  - product_id, product_name, category, subcategory, brand, unit_cost, list_price
  
- **dim_store** - Store dimension
  - store_id, store_name, city, state, country, region, store_type, open_date

### Skills Applied

This project combines everything from Days 1-19:
- JOINs (Days 8-12)
- Aggregations (Days 4-7)
- Subqueries and CTEs (Days 13-15)
- Window Functions (Days 16-17)
- CASE Statements (Day 18)
- Date Functions (Day 19)

## Setup (2 minutes)

Run the setup script:
```bash
python setup.py
```

This creates `day20.db` with a realistic data warehouse:
- 10,000+ sales transactions
- 1,000 customers across 50 cities
- 200 products in 10 categories
- 20 stores in 5 regions
- 2 years of daily data

## Business Questions (50 minutes)

Work through these analytical queries. Each builds on advanced SQL concepts.

### Part 1: Dimensional Analysis (10 minutes)

**Question 1: Sales by Product Category and Region**
Create a report showing total sales by product category and store region.
Include:
- Category name
- Region name
- Total sales
- Number of transactions
- Average transaction value

Order by total sales descending.

**Expected output:** Multiple rows with category-region combinations

**Skills:** Multi-table JOINs, GROUP BY, aggregations

---

**Question 2: Top 10 Products by Revenue**
Find the top 10 products by total revenue.
Show:
- Product name
- Category
- Brand
- Total quantity sold
- Total revenue
- Profit margin (revenue - cost)

**Expected output:** 10 rows

**Skills:** JOINs, aggregations, calculations, ORDER BY, LIMIT

---

**Question 3: Customer Segmentation Analysis**
Analyze customers by segment (VIP, Premium, Standard).
For each segment show:
- Number of customers
- Total revenue
- Average revenue per customer
- Average transaction value
- Total transactions

**Expected output:** 3 rows (one per segment)

**Skills:** GROUP BY, multiple aggregations

---

### Part 2: Time-Series Analysis (10 minutes)

**Question 4: Monthly Revenue Trend**
Calculate monthly revenue for the past 12 months with month-over-month growth.
Show:
- Month
- Revenue
- Previous month revenue
- Absolute growth
- Percentage growth

**Expected output:** 12 rows

**Skills:** Date functions, LAG window function, calculations

---

**Question 5: Year-over-Year Comparison**
Compare this year's monthly revenue to last year's.
Show:
- Month
- This year revenue
- Last year revenue
- YoY growth percentage

**Expected output:** 12 rows (current year months)

**Skills:** Date functions, self-join or CASE, aggregations

---

**Question 6: Quarterly Performance by Region**
Create a pivot showing quarterly revenue by region.
Rows: Regions
Columns: Q1, Q2, Q3, Q4
Values: Revenue

**Expected output:** 5 rows (one per region)

**Skills:** CASE statements, aggregations, pivoting

---

### Part 3: Customer Analytics (10 minutes)

**Question 7: Customer Lifetime Value (CLV)**
Calculate CLV for each customer.
Show:
- Customer name
- First purchase date
- Last purchase date
- Total transactions
- Total revenue
- Average order value
- Customer lifetime (days)

Order by total revenue descending, show top 20.

**Expected output:** 20 rows

**Skills:** JOINs, aggregations, date calculations

---

**Question 8: Customer Cohort Analysis**
Group customers by registration month and analyze their behavior.
Show:
- Cohort (registration month)
- Customers in cohort
- Total revenue from cohort
- Average revenue per customer
- Retention rate (% who purchased in last 30 days)

**Expected output:** Multiple rows (one per month)

**Skills:** CTEs, date functions, aggregations, calculations

---

**Question 9: RFM Segmentation**
Perform RFM (Recency, Frequency, Monetary) analysis.
Calculate:
- Recency score (1-5 based on days since last purchase)
- Frequency score (1-5 based on transaction count)
- Monetary score (1-5 based on total spent)
- RFM segment (Champions, Loyal, At Risk, etc.)

Show top 50 customers by combined RFM score.

**Expected output:** 50 rows

**Skills:** CTEs, CASE statements, NTILE or custom scoring

---

### Part 4: Product Performance (10 minutes)

**Question 10: Product Performance Matrix**
Classify products into a 2x2 matrix:
- High Revenue + High Margin = "Star"
- High Revenue + Low Margin = "Cash Cow"
- Low Revenue + High Margin = "Question Mark"
- Low Revenue + Low Margin = "Dog"

Show counts and total revenue for each quadrant.

**Expected output:** 4 rows

**Skills:** CTEs, CASE statements, aggregations

---

**Question 11: Product Sales Trend**
For each product category, calculate:
- Total sales last 30 days
- Total sales previous 30 days (31-60 days ago)
- Trend (Growing, Declining, Stable)

**Expected output:** 10 rows (one per category)

**Skills:** Date filtering, CTEs, CASE statements

---

**Question 12: Cross-Sell Analysis**
Find product pairs frequently bought together.
Show:
- Product 1
- Product 2
- Times bought together
- Percentage of Product 1 purchases that include Product 2

Minimum 10 co-purchases, show top 20 pairs.

**Expected output:** 20 rows

**Skills:** Self-join, aggregations, calculations

---

### Part 5: Store Performance (10 minutes)

**Question 13: Store Performance Ranking**
Rank stores by revenue within each region.
Show:
- Region
- Store name
- Revenue
- Rank in region
- Percentage of region's revenue

**Expected output:** 20 rows (all stores)

**Skills:** Window functions (ROW_NUMBER, SUM), PARTITION BY

---

**Question 14: Store Efficiency Analysis**
Analyze store efficiency.
Show:
- Store name
- Total revenue
- Number of transactions
- Average transaction value
- Revenue per day since opening
- Efficiency rating (based on revenue per day)

**Expected output:** 20 rows

**Skills:** Date calculations, aggregations, CASE statements

---

**Question 15: Regional Market Share**
Calculate each region's market share and growth.
Show:
- Region
- Total revenue
- Market share percentage
- YoY growth percentage
- Rank by revenue

**Expected output:** 5 rows

**Skills:** Window functions, aggregations, calculations

---

### Part 6: Advanced Analytics (10 minutes)

**Question 16: Moving Average Analysis**
Calculate 7-day and 30-day moving averages of daily revenue.
Show:
- Date
- Daily revenue
- 7-day MA
- 30-day MA
- Trend (above/below 30-day MA)

Show last 90 days.

**Expected output:** 90 rows

**Skills:** Window functions with frames, CASE statements

---

**Question 17: Pareto Analysis (80/20 Rule)**
Identify products that generate 80% of revenue.
Show:
- Product name
- Revenue
- Cumulative revenue
- Cumulative percentage
- Pareto group (Top 80% or Bottom 20%)

**Expected output:** 200 rows (all products)

**Skills:** Window functions (SUM OVER), running totals, CASE

---

**Question 18: Customer Churn Prediction**
Identify customers at risk of churning.
Criteria:
- Previously active (3+ purchases)
- No purchase in last 60 days
- Average days between purchases < 45

Show:
- Customer name
- Last purchase date
- Days since last purchase
- Average days between purchases
- Total lifetime value
- Churn risk score

**Expected output:** Variable rows

**Skills:** CTEs, LAG, aggregations, CASE statements

---

**Question 19: Seasonal Pattern Analysis**
Analyze sales patterns by season and day of week.
Show:
- Season (Spring, Summer, Fall, Winter)
- Day of week
- Average daily revenue
- Total transactions
- Peak indicator (above average or not)

**Expected output:** 28 rows (4 seasons × 7 days)

**Skills:** Date functions, CASE statements, aggregations

---

**Question 20: Complete Executive Dashboard**
Create a comprehensive executive dashboard with:
- Total revenue (current month, last month, YoY)
- Total customers (active, new this month, churned)
- Total transactions (current month, growth %)
- Top 5 products by revenue
- Top 5 customers by revenue
- Revenue by region
- Revenue by category
- Key metrics and trends

**Expected output:** Multiple result sets or single formatted report

**Skills:** CTEs, UNION ALL, all aggregation and analytical functions

---

## Bonus Challenges (Optional)

**Bonus 1: Customer Journey Analysis**
Map the typical customer journey from first to last purchase, including:
- Average time to second purchase
- Average number of categories explored
- Purchase frequency evolution

**Bonus 2: Inventory Optimization**
Identify slow-moving products that should be discounted or discontinued based on:
- Sales velocity
- Profit margin
- Days of inventory

**Bonus 3: Price Elasticity Analysis**
Analyze how discounts affect sales volume and revenue.

**Bonus 4: Geographic Expansion Analysis**
Identify cities/states with high customer concentration but no stores.

**Bonus 5: Predictive Basket Size**
Predict average basket size by customer segment, day of week, and season.

## How to Complete This Project

### Step 1: Setup (2 minutes)
```bash
cd days/day-20-mini-project-data-warehouse
python setup.py
```

### Step 2: Explore the Schema (3 minutes)
```sql
-- Check table structures
.schema fact_sales
.schema dim_date
.schema dim_customer
.schema dim_product
.schema dim_store

-- Sample data
SELECT * FROM fact_sales LIMIT 5;
SELECT * FROM dim_date LIMIT 5;
```

### Step 3: Work Through Questions (50 minutes)
Open `exercise.sql` and write queries for each question.

Test your queries:
```bash
duckdb day20.db < exercise.sql
```

### Step 4: Check Solutions
Compare with `solution.sql`:
```bash
duckdb day20.db < solution.sql
```

## Query Patterns for Data Warehouses

### Pattern 1: Star Schema JOIN
```sql
SELECT 
    d.dimension_column,
    SUM(f.measure) as total
FROM fact_table f
JOIN dim_table d ON f.dim_id = d.id
GROUP BY d.dimension_column;
```

### Pattern 2: Multi-Dimensional Analysis
```sql
SELECT 
    d1.column as dimension1,
    d2.column as dimension2,
    SUM(f.measure) as total
FROM fact_table f
JOIN dim_table1 d1 ON f.dim1_id = d1.id
JOIN dim_table2 d2 ON f.dim2_id = d2.id
GROUP BY d1.column, d2.column;
```

### Pattern 3: Time-Series with LAG
```sql
WITH monthly_data AS (
    SELECT 
        DATE_TRUNC('month', date) as month,
        SUM(amount) as total
    FROM fact_table
    GROUP BY month
)
SELECT 
    month,
    total,
    LAG(total) OVER (ORDER BY month) as prev_month,
    total - LAG(total) OVER (ORDER BY month) as growth
FROM monthly_data;
```

### Pattern 4: Ranking within Groups
```sql
SELECT 
    dimension,
    measure,
    ROW_NUMBER() OVER (PARTITION BY dimension ORDER BY measure DESC) as rank
FROM fact_table
WHERE rank <= 10;
```

### Pattern 5: Running Totals
```sql
SELECT 
    date,
    amount,
    SUM(amount) OVER (ORDER BY date) as running_total
FROM fact_table;
```

### Pattern 6: Pivot with CASE
```sql
SELECT 
    dimension,
    SUM(CASE WHEN category = 'A' THEN amount ELSE 0 END) as category_a,
    SUM(CASE WHEN category = 'B' THEN amount ELSE 0 END) as category_b
FROM fact_table
GROUP BY dimension;
```

## Tips for Success

### Understanding Star Schema
- **Fact table** = Measurements/metrics (sales, quantities, amounts)
- **Dimension tables** = Context (who, what, when, where)
- **Always JOIN fact to dimensions** for meaningful analysis

### Query Optimization
1. **Filter early** - Use WHERE on dimensions before aggregating
2. **Use date dimension** - Pre-calculated date attributes are faster
3. **Aggregate in CTEs** - Break complex queries into steps
4. **Index foreign keys** - Fact table dimension keys should be indexed

### Common Patterns
- **Period-over-period** - Use LAG or self-join
- **Cumulative metrics** - Use window functions with running totals
- **Top N per group** - Use ROW_NUMBER() with PARTITION BY
- **Pivoting** - Use CASE with SUM/COUNT
- **Cohort analysis** - Group by time period, analyze behavior

### Debugging Tips
- **Start simple** - Test each JOIN separately
- **Check row counts** - Ensure JOINs don't multiply rows unexpectedly
- **Validate dates** - Use date dimension for consistent date logic
- **Test with LIMIT** - Verify logic before running full query

## Key Takeaways

### Data Warehouse Concepts
- ✅ **Star schema design** - Fact table surrounded by dimension tables
- ✅ **Dimensional analysis** - Slice and dice by multiple dimensions
- ✅ **Time-series analysis** - Trends, growth, seasonality
- ✅ **Customer analytics** - Segmentation, cohorts, lifetime value
- ✅ **Product analytics** - Performance, cross-sell, trends

### SQL Skills Applied
- ✅ **Complex JOINs** - Multiple dimension tables
- ✅ **CTEs** - Breaking complex queries into steps
- ✅ **Window functions** - Rankings, running totals, LAG/LEAD
- ✅ **Aggregations** - Multiple measures simultaneously
- ✅ **CASE statements** - Pivoting, categorization, scoring
- ✅ **Date functions** - Time-based filtering and grouping
- ✅ **Subqueries** - Nested analytics

### Business Intelligence Skills
- ✅ **KPI calculation** - Revenue, growth, margins
- ✅ **Trend analysis** - Identifying patterns over time
- ✅ **Segmentation** - Grouping by behavior or attributes
- ✅ **Ranking** - Top performers, bottom performers
- ✅ **Cohort analysis** - Tracking groups over time
- ✅ **Predictive indicators** - Churn risk, growth potential

### Real-World Applications
This project simulates real BI analyst work:
- Answering executive questions with data
- Building dashboards and reports
- Finding insights in large datasets
- Supporting data-driven decisions
- Optimizing business performance

## Next Steps

### Immediate
1. Complete all 20 questions
2. Try the bonus challenges
3. Review solutions and understand differences
4. Optimize slow queries
5. Take the quiz in `quiz.md`

### Practice More
- Create your own business questions
- Add more complex calculations
- Build a complete dashboard query
- Export results for visualization
- Try different aggregation levels

### Moving Forward
- Day 21: String Functions and Data Types
- Day 22: NULL Handling and Data Manipulation
- Continue building on these analytical skills

## Resources

- [DuckDB Documentation](https://duckdb.org/docs/)
- [Star Schema Design](https://en.wikipedia.org/wiki/Star_schema)
- [Data Warehouse Concepts](https://www.kimballgroup.com/)
- [SQL for Analytics](https://mode.com/sql-tutorial/)

## Summary

You've now applied all advanced SQL skills to realistic data warehouse scenarios. This project demonstrates your ability to:
- Work with dimensional models
- Write complex analytical queries
- Perform business intelligence analysis
- Solve real-world data problems

These skills are essential for BI analysts, data analysts, and anyone working with analytical databases.

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 21
