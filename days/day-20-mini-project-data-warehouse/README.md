# Day 20: Mini Project - Data Warehouse Analytics

## 📖 Project Overview

You're a BI analyst at **GlobalRetail**, an e-commerce company. Your job is to write complex analytical queries on a data warehouse to answer strategic business questions.

**Time:** 2 hours  
**Difficulty:** Advanced  
**Skills:** All SQL concepts from Days 1-19

---

## 🗄️ Data Warehouse Schema

### Star Schema Design

**Fact Table:**
- **fact_sales** - Transaction-level sales data
  - sale_id, date_id, customer_id, product_id, store_id
  - quantity, unit_price, discount_amount, total_amount

**Dimension Tables:**
- **dim_date** - Date dimension (year, quarter, month, day, is_weekend, is_holiday)
- **dim_customer** - Customer dimension (name, city, state, segment, registration_date)
- **dim_product** - Product dimension (name, category, brand, unit_cost, list_price)
- **dim_store** - Store dimension (name, city, region, store_type, open_date)

---

## 🚀 Setup

```bash
python setup.py
```

This creates a realistic data warehouse with:
- 10,000+ sales transactions
- 1,000 customers across 50 cities
- 200 products in 10 categories
- 20 stores in 5 regions
- 2 years of daily data

---

## 📊 Business Questions (20 Questions)

### Part 1: Dimensional Analysis (5 questions)

**Q1: Sales by Category and Region**
Total sales, transaction count, and average transaction value by product category and store region.

**Q2: Top 10 Products by Revenue**
Product name, category, brand, quantity sold, revenue, and profit margin.

**Q3: Customer Segmentation Analysis**
Analyze customers by segment (VIP, Premium, Standard) - count, revenue, avg revenue per customer.

**Q4: Store Performance Ranking**
Rank stores by revenue within each region, show percentage of region's revenue.

**Q5: Regional Market Share**
Calculate each region's market share percentage and rank.

### Part 2: Time-Series Analysis (5 questions)

**Q6: Monthly Revenue Trend**
Monthly revenue for past 12 months with month-over-month growth percentage.

**Q7: Year-over-Year Comparison**
Compare this year's monthly revenue to last year's with YoY growth.

**Q8: Quarterly Performance Pivot**
Create pivot showing quarterly revenue by region (rows: regions, columns: Q1-Q4).

**Q9: Daily Revenue Moving Average**
Calculate 7-day and 30-day moving averages of daily revenue for last 90 days.

**Q10: Seasonal Pattern Analysis**
Analyze sales patterns by season and day of week, identify peak periods.

### Part 3: Customer Analytics (5 questions)

**Q11: Customer Lifetime Value**
Calculate CLV for top 20 customers - first/last purchase, total transactions, revenue, lifetime days.

**Q12: Customer Cohort Analysis**
Group customers by registration month, analyze revenue and retention rate.

**Q13: RFM Segmentation**
Perform RFM (Recency, Frequency, Monetary) analysis, assign segments (Champions, Loyal, At Risk).

**Q14: Customer Churn Prediction**
Identify at-risk customers: previously active (3+ purchases), no purchase in 60+ days.

**Q15: Customer Purchase Frequency**
Analyze average days between purchases for each customer, identify patterns.

### Part 4: Product Analytics (5 questions)

**Q16: Product Performance Matrix**
Classify products: Star (high revenue + margin), Cash Cow, Question Mark, Dog.

**Q17: Product Sales Trend**
Compare last 30 days vs previous 30 days sales by category, identify trends.

**Q18: Cross-Sell Analysis**
Find product pairs frequently bought together (minimum 10 co-purchases).

**Q19: Pareto Analysis (80/20 Rule)**
Identify products generating 80% of revenue using cumulative percentage.

**Q20: Slow-Moving Products**
Identify products with low sales velocity that may need discounting.

---

## 💡 Query Patterns for Data Warehouses

### Star Schema JOIN
```sql
SELECT d.dimension_column, SUM(f.measure) as total
FROM fact_sales f
JOIN dim_table d ON f.dim_id = d.id
GROUP BY d.dimension_column;
```

### Time-Series with LAG
```sql
WITH monthly AS (
    SELECT DATE_TRUNC('month', dd.date) as month, SUM(fs.total_amount) as revenue
    FROM fact_sales fs
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY month
)
SELECT month, revenue,
    LAG(revenue) OVER (ORDER BY month) as prev_month,
    revenue - LAG(revenue) OVER (ORDER BY month) as growth
FROM monthly;
```

### Ranking within Groups
```sql
SELECT dimension, measure,
    ROW_NUMBER() OVER (PARTITION BY dimension ORDER BY measure DESC) as rank
FROM fact_table;
```

### Pivot with CASE
```sql
SELECT dimension,
    SUM(CASE WHEN quarter = 1 THEN amount ELSE 0 END) as q1,
    SUM(CASE WHEN quarter = 2 THEN amount ELSE 0 END) as q2
FROM fact_table
GROUP BY dimension;
```

---

## 🎯 Tips for Success

### Understanding Star Schema
- **Fact table** = Measurements (sales, quantities, amounts)
- **Dimension tables** = Context (who, what, when, where)
- **Always JOIN fact to dimensions** for meaningful analysis

### Query Strategy
1. **Start simple** - Test each JOIN separately
2. **Use CTEs** - Break complex queries into steps
3. **Filter early** - Use WHERE before aggregating
4. **Check row counts** - Ensure JOINs don't multiply rows

### Common Patterns
- **Period-over-period** - Use LAG or self-join
- **Cumulative metrics** - Window functions with running totals
- **Top N per group** - ROW_NUMBER() with PARTITION BY
- **Pivoting** - CASE with SUM/COUNT
- **Cohort analysis** - Group by time period

---

## ✅ Key Takeaways

### Data Warehouse Concepts
- Star schema design (fact + dimension tables)
- Dimensional analysis (slice and dice)
- Time-series analysis (trends, growth, seasonality)
- Customer analytics (segmentation, cohorts, CLV)
- Product analytics (performance, cross-sell)

### SQL Skills Applied
- Complex JOINs (multiple dimension tables)
- CTEs (breaking complex queries)
- Window functions (rankings, running totals, LAG/LEAD)
- Aggregations (multiple measures)
- CASE statements (pivoting, categorization)
- Date functions (time-based filtering)

---

## 🚀 Next Steps

Tomorrow: String Functions - Text manipulation and pattern matching.
