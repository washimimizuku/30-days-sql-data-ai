# Day 30: Capstone Project - Complete Analytics Database

## 🎓 Congratulations!

You've reached the final day of the 30 Days of SQL bootcamp! This capstone project brings together **everything** you've learned from Days 1-29.

## 📖 Project Overview

You're a data analyst at **RetailCo**, a growing e-commerce company. The company has built a complete operational database, and your job is to extract insights using SQL to help drive business decisions.

### Database Schema

The database contains 8 interconnected tables:

**Core Tables:**
- `categories` - Product categories
- `products` - Product catalog with pricing and inventory
- `customers` - Customer information and segments
- `stores` - Physical store locations
- `employees` - Store employees and managers

**Transaction Tables:**
- `orders` - Customer orders with status and payment info
- `order_items` - Individual items in each order
- `reviews` - Product reviews and ratings

### Data Volume
- 300 customers across multiple segments
- 100+ products in 6 categories
- 20 stores across 5 regions
- 100 employees
- 2,000 orders with 6,000+ line items
- 500 product reviews

---

## 🎯 Learning Objectives

By completing this capstone, you will demonstrate mastery of:

✅ **Days 1-3:** SELECT, WHERE, ORDER BY, LIMIT
✅ **Days 4-7:** Aggregate functions, GROUP BY, HAVING
✅ **Days 8-12:** All JOIN types (INNER, LEFT, RIGHT, FULL, SELF)
✅ **Days 13-15:** Subqueries and CTEs
✅ **Days 16-17:** Window functions (ROW_NUMBER, RANK, LAG, LEAD)
✅ **Day 18:** CASE statements
✅ **Days 19, 21:** Date and string functions
✅ **Day 22:** NULL handling
✅ **Day 23:** UNION and set operations
✅ **Days 24-25:** Query optimization
✅ **Day 28:** Data modeling concepts

---

## 💻 Capstone Challenges (90-120 min)

### Setup

```bash
python setup.py
```

This creates a complete e-commerce database with realistic data.

---

### Part 1: Business Intelligence Queries (30 min)

**Challenge 1: Sales Performance Dashboard**
Create a comprehensive sales dashboard showing:
- Total revenue, orders, and average order value
- Revenue by category
- Top 10 customers by spend
- Monthly sales trends
- Best performing stores

**Challenge 2: Customer Analytics**
Analyze customer behavior:
- Customer segmentation analysis
- Customer lifetime value distribution
- Repeat purchase rate
- Customer acquisition by month
- Inactive customers (no purchase in 6+ months)

**Challenge 3: Product Analytics**
Understand product performance:
- Best-selling products by revenue and quantity
- Products with low stock (below reorder level)
- Average rating by category
- Products with no reviews
- Price vs. rating correlation

---

### Part 2: Advanced Analytics (30 min)

**Challenge 4: Time-Series Analysis**
Perform temporal analysis:
- Year-over-year growth
- Month-over-month trends
- Seasonal patterns
- Day-of-week analysis
- Moving averages

**Challenge 5: Cohort Analysis**
Analyze customer cohorts:
- Customers by registration month
- Retention rates by cohort
- Revenue by cohort over time
- First purchase to second purchase time

**Challenge 6: Employee Performance**
Evaluate employee metrics:
- Sales by employee
- Top performing employees
- Employee productivity by store
- Manager performance comparison

---

### Part 3: Complex Business Questions (30 min)

**Challenge 7: Profitability Analysis**
Calculate profit metrics:
- Profit margin by category
- Most profitable products
- Profit by store and region
- Impact of discounts on profitability

**Challenge 8: Inventory Management**
Optimize inventory:
- Products needing reorder
- Slow-moving inventory
- Stock turnover rate
- Inventory value by category

**Challenge 9: Customer Segmentation**
Create customer segments:
- RFM analysis (Recency, Frequency, Monetary)
- High-value customer identification
- At-risk customers
- Customer personas

---

### Part 4: Executive Summary (20 min)

**Challenge 10: Executive Dashboard**
Create a single comprehensive query that provides:
- Key business metrics (KPIs)
- Top performers (products, customers, stores)
- Growth trends
- Areas of concern
- Actionable recommendations

---

## 🎯 Evaluation Criteria

Your queries will be evaluated on:

1. **Correctness** - Do they produce accurate results?
2. **Efficiency** - Are they optimized for performance?
3. **Readability** - Are they well-formatted and commented?
4. **Completeness** - Do they answer all parts of the question?
5. **Insight** - Do they provide actionable business insights?

---

## 💡 Tips for Success

### Query Writing Best Practices

1. **Start Simple** - Build complex queries incrementally
2. **Use CTEs** - Break down complex logic into readable steps
3. **Comment Your Code** - Explain your reasoning
4. **Test Incrementally** - Verify each part before combining
5. **Format Consistently** - Use proper indentation

### Example Structure

```sql
-- Challenge: Calculate customer lifetime value by segment
-- Approach: Join customers with orders, aggregate, segment

WITH customer_orders AS (
    -- Step 1: Get total spend per customer
    SELECT 
        c.customer_id,
        c.customer_segment,
        COUNT(o.order_id) as order_count,
        SUM(o.total_amount) as lifetime_value
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_segment
)
SELECT 
    customer_segment,
    COUNT(*) as customer_count,
    AVG(lifetime_value) as avg_lifetime_value,
    MAX(lifetime_value) as max_lifetime_value
FROM customer_orders
GROUP BY customer_segment
ORDER BY avg_lifetime_value DESC;
```

---

## 🚀 Going Further

After completing the capstone:

1. **Optimize Your Queries** - Use EXPLAIN to analyze performance
2. **Create Views** - Save commonly used queries as views
3. **Build Dashboards** - Export results for visualization
4. **Add Indexes** - Improve query performance
5. **Document Insights** - Write up your findings

---

## 🎉 Congratulations!

You've completed the 30 Days of SQL for Data & AI bootcamp!

### What You've Accomplished

✅ Mastered SQL fundamentals
✅ Learned advanced analytical techniques
✅ Built real-world data analysis skills
✅ Created a portfolio-worthy capstone project

### Next Steps

1. **Review Your Work** - Compare with solutions
2. **Refine Your Queries** - Optimize and improve
3. **Build Your Portfolio** - Showcase your capstone
4. **Keep Practicing** - Apply SQL to real projects
5. **Share Your Success** - Help others learn SQL

---

## 📚 Resources

- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Style Guide](https://www.sqlstyle.guide/)
- [Data Analysis Best Practices](https://mode.com/sql-tutorial/)

---

## 🏆 You Did It!

You've invested 30 hours learning SQL and building real analytical skills. This capstone project demonstrates your ability to:

- Design and query complex databases
- Extract business insights from data
- Write efficient, production-quality SQL
- Think analytically about business problems

**You're now ready for:**
- Data Analyst roles
- Business Intelligence positions
- Data Engineering projects
- Advanced analytics with Spark SQL and dbt
- The 100 Days of Data & AI bootcamp

**Keep learning, keep building, and keep analyzing data!** 🚀
