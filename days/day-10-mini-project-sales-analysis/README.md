# Day 10: Mini Project - Sales Analysis

## Learning Objectives
- Apply all SQL skills learned so far to a real project
- Analyze sales data using JOINs, GROUP BY, and aggregations
- Build comprehensive business reports
- Practice data analysis workflows
- Solve real-world business questions

## Project Overview (5 minutes)

### The Business Scenario

You're a data analyst at **TechStore**, an online electronics retailer. The management team needs insights about sales performance, customer behavior, and product trends to make strategic decisions.

You have access to a sales database with:
- **customers** - Customer information
- **products** - Product catalog
- **orders** - Order transactions
- **order_items** - Individual items in each order
- **categories** - Product categories

### Your Mission

Answer 20 business questions using SQL queries. Each question builds on skills from Days 1-9:
- SELECT and WHERE (Days 1-2)
- ORDER BY and LIMIT (Day 3)
- Aggregate functions (Day 4)
- GROUP BY (Day 5)
- HAVING (Day 6)
- Multiple aggregations (Day 7)
- INNER JOIN (Day 8)
- LEFT JOIN (Day 9)

### Database Schema

**customers**
```sql
id              INTEGER PRIMARY KEY
customer_name   VARCHAR
email           VARCHAR
city            VARCHAR
state           VARCHAR
registration_date DATE
```

**categories**
```sql
id              INTEGER PRIMARY KEY
category_name   VARCHAR
description     VARCHAR
```

**products**
```sql
id              INTEGER PRIMARY KEY
product_name    VARCHAR
category_id     INTEGER (FK to categories)
price           DECIMAL(10,2)
cost            DECIMAL(10,2)
stock           INTEGER
```

**orders**
```sql
id              INTEGER PRIMARY KEY
customer_id     INTEGER (FK to customers)
order_date      DATE
status          VARCHAR (completed, pending, cancelled)
total           DECIMAL(10,2)
```

**order_items**
```sql
id              INTEGER PRIMARY KEY
order_id        INTEGER (FK to orders)
product_id      INTEGER (FK to products)
quantity        INTEGER
price           DECIMAL(10,2)
```

## Setup (2 minutes)

Run the setup script to create the database:
```bash
python setup.py
```

This creates `day10.db` with realistic sales data:
- 100 customers across 10 cities
- 50 products in 5 categories
- 500 orders over 12 months
- 1,500 order items

## Business Questions (50 minutes)

Work through these questions in order. Each builds on previous skills.

### Part 1: Basic Sales Metrics (10 minutes)

**Question 1: Total Revenue**
Calculate the total revenue from all completed orders.

**Expected output:** One row with total_revenue

**Skills:** Aggregate functions, WHERE filtering

---

**Question 2: Order Statistics**
Calculate:
- Total number of orders
- Number of completed orders
- Number of pending orders
- Number of cancelled orders

**Expected output:** One row with four columns

**Skills:** COUNT with CASE statements

---

**Question 3: Top 10 Customers**
Find the top 10 customers by total spending (completed orders only).
Show customer name, email, and total spent.

**Expected output:** 10 rows, ordered by spending descending

**Skills:** JOIN, GROUP BY, aggregate functions, ORDER BY, LIMIT

---

**Question 4: Monthly Revenue Trend**
Calculate total revenue by month for the past year.
Show year, month, and revenue.

**Expected output:** 12 rows (one per month)

**Skills:** Date functions, GROUP BY, aggregates

---

### Part 2: Product Analysis (10 minutes)

**Question 5: Best Selling Products**
Find the top 10 products by quantity sold.
Show product name, category, quantity sold, and revenue.

**Expected output:** 10 rows

**Skills:** Multiple JOINs, GROUP BY, aggregates, ORDER BY

---

**Question 6: Products Never Sold**
Find all products that have never been ordered.
Show product name, category, price, and stock.

**Expected output:** Variable rows (products with no sales)

**Skills:** LEFT JOIN with NULL filtering

---

**Question 7: Category Performance**
For each category, calculate:
- Number of products
- Total quantity sold
- Total revenue
- Average product price

Order by revenue descending.

**Expected output:** 5 rows (one per category)

**Skills:** Multiple JOINs, GROUP BY, multiple aggregates

---

**Question 8: Low Stock Alert**
Find products with stock less than 10 that have been sold at least once.
Show product name, category, current stock, and times ordered.

**Expected output:** Variable rows

**Skills:** JOIN, GROUP BY, HAVING, WHERE

---

### Part 3: Customer Insights (10 minutes)

**Question 9: Customer Segmentation**
Segment customers by total spending:
- High Value: > $1000
- Medium Value: $500-$1000
- Low Value: < $500

Count customers and total revenue for each segment.

**Expected output:** 3 rows (one per segment)

**Skills:** CASE statements, GROUP BY, aggregates

---

**Question 10: Inactive Customers**
Find customers who registered more than 6 months ago but never placed an order.
Show customer name, email, city, and registration date.

**Expected output:** Variable rows

**Skills:** LEFT JOIN, WHERE with NULL, date functions

---

**Question 11: Customer Lifetime Value**
For each customer with orders, calculate:
- Total orders
- Total spent
- Average order value
- First order date
- Last order date
- Days as customer

Show top 20 by total spent.

**Expected output:** 20 rows

**Skills:** Multiple aggregates, date calculations, ORDER BY, LIMIT

---

**Question 12: Repeat Customer Rate**
Calculate:
- Total customers with orders
- Customers with 2+ orders (repeat customers)
- Repeat customer percentage

**Expected output:** One row with three columns

**Skills:** Subqueries or CTEs, aggregates, calculations

---

### Part 4: Geographic Analysis (10 minutes)

**Question 13: Sales by City**
For each city, calculate:
- Number of customers
- Number of orders
- Total revenue
- Average order value

Order by revenue descending.

**Expected output:** 10 rows (one per city)

**Skills:** JOIN, GROUP BY, multiple aggregates

---

**Question 14: Top City by Category**
For each category, find the city with the highest sales.
Show category, city, and revenue.

**Expected output:** 5 rows (one per category)

**Skills:** Multiple JOINs, GROUP BY, subqueries or window functions

---

**Question 15: State Performance**
For each state, calculate:
- Number of customers
- Number of orders
- Total revenue
- Average revenue per customer

Order by total revenue descending.

**Expected output:** Variable rows (one per state)

**Skills:** JOIN, GROUP BY, multiple aggregates, calculations

---

### Part 5: Advanced Analysis (10 minutes)

**Question 16: Product Profitability**
For each product that has been sold, calculate:
- Total quantity sold
- Total revenue (quantity * price)
- Total cost (quantity * cost)
- Total profit (revenue - cost)
- Profit margin percentage

Show top 10 by profit.

**Expected output:** 10 rows

**Skills:** Multiple JOINs, GROUP BY, calculations, ORDER BY

---

**Question 17: Order Size Analysis**
Analyze order sizes by calculating:
- Orders with 1 item
- Orders with 2-3 items
- Orders with 4-5 items
- Orders with 6+ items

Show count and total revenue for each group.

**Expected output:** 4 rows

**Skills:** Subquery, CASE statements, GROUP BY

---

**Question 18: Customer Purchase Frequency**
For customers with 2+ orders, calculate:
- Customer name
- Total orders
- Days between first and last order
- Average days between orders

Show top 15 by order count.

**Expected output:** 15 rows

**Skills:** GROUP BY, HAVING, date calculations, ORDER BY

---

**Question 19: Category Mix per Order**
Calculate the average number of different categories per order.

**Expected output:** One row with average_categories_per_order

**Skills:** Subquery, COUNT DISTINCT, AVG

---

**Question 20: Complete Business Dashboard**
Create a comprehensive dashboard with:
- Total customers
- Active customers (with orders)
- Total products
- Products sold (at least once)
- Total orders
- Completed orders
- Total revenue (completed orders)
- Average order value
- Total profit
- Overall profit margin percentage

**Expected output:** One row with 10 columns

**Skills:** Multiple subqueries or CTEs, aggregates, calculations

---

## Bonus Challenges (Optional)

If you finish early, try these advanced questions:

**Bonus 1: Monthly Growth Rate**
Calculate month-over-month revenue growth percentage.

**Bonus 2: Customer Cohort Analysis**
Group customers by registration month and calculate their lifetime value.

**Bonus 3: Product Recommendation**
For each product, find the top 3 products most frequently bought together.

**Bonus 4: Seasonal Trends**
Analyze sales patterns by season (Winter, Spring, Summer, Fall).

**Bonus 5: Customer Churn**
Identify customers who haven't ordered in the last 90 days but were active before.

## How to Complete This Project

### Step 1: Setup (2 minutes)
```bash
cd days/day-10-mini-project-sales-analysis
python setup.py
```

### Step 2: Work Through Questions (50 minutes)
Open `exercise.sql` and write queries for each question.

Test your queries:
```bash
duckdb day10.db < exercise.sql
```

### Step 3: Check Solutions
Compare your answers with `solution.sql`:
```bash
duckdb day10.db < solution.sql
```

### Step 4: Verify Understanding
- Can you explain each query?
- Do you understand why each JOIN type was used?
- Can you modify queries for different requirements?

## Tips for Success

### Planning Your Queries
1. **Read the question carefully** - What exactly is being asked?
2. **Identify required tables** - Which tables have the data you need?
3. **Determine JOIN types** - INNER for matching data, LEFT for "all of X"
4. **Plan your filters** - WHERE for rows, HAVING for groups
5. **Choose aggregates** - COUNT, SUM, AVG, MIN, MAX
6. **Order results** - What makes sense for the business question?

### Common Patterns

**Pattern 1: Simple Aggregation**
```sql
SELECT 
    aggregate_function(column)
FROM table
WHERE condition;
```

**Pattern 2: Grouped Aggregation**
```sql
SELECT 
    group_column,
    aggregate_function(column)
FROM table
GROUP BY group_column
ORDER BY aggregate_function(column) DESC;
```

**Pattern 3: JOIN with Aggregation**
```sql
SELECT 
    t1.column,
    aggregate_function(t2.column)
FROM table1 t1
JOIN table2 t2 ON t1.id = t2.foreign_id
GROUP BY t1.column;
```

**Pattern 4: Multiple JOINs**
```sql
SELECT 
    t1.column,
    t2.column,
    aggregate_function(t3.column)
FROM table1 t1
JOIN table2 t2 ON t1.id = t2.foreign_id
JOIN table3 t3 ON t2.id = t3.foreign_id
GROUP BY t1.column, t2.column;
```

**Pattern 5: LEFT JOIN for "All of X"**
```sql
SELECT 
    t1.column,
    COUNT(t2.id) as count
FROM table1 t1
LEFT JOIN table2 t2 ON t1.id = t2.foreign_id
GROUP BY t1.column;
```

### Debugging Tips

**Query not returning results?**
- Check your JOIN conditions
- Verify table and column names
- Test each part separately

**Wrong numbers?**
- Check for duplicate rows (use DISTINCT if needed)
- Verify your GROUP BY includes all non-aggregated columns
- Make sure you're filtering correctly (WHERE vs HAVING)

**Performance slow?**
- Add WHERE filters before JOINs when possible
- Use LIMIT while testing
- Check if you need all columns or just aggregates

## Key Takeaways

### SQL Skills Applied
- ✅ **SELECT and WHERE** - Filtering data
- ✅ **ORDER BY and LIMIT** - Sorting and restricting results
- ✅ **Aggregate Functions** - COUNT, SUM, AVG, MIN, MAX
- ✅ **GROUP BY** - Grouping data for analysis
- ✅ **HAVING** - Filtering grouped results
- ✅ **Multiple Aggregations** - Calculating multiple metrics
- ✅ **INNER JOIN** - Combining related tables
- ✅ **LEFT JOIN** - Including all records from one table
- ✅ **Date Functions** - Working with dates
- ✅ **CASE Statements** - Conditional logic

### Business Analysis Skills
- ✅ **Revenue Analysis** - Understanding sales performance
- ✅ **Customer Segmentation** - Grouping customers by behavior
- ✅ **Product Performance** - Identifying best and worst sellers
- ✅ **Geographic Analysis** - Understanding regional patterns
- ✅ **Profitability Analysis** - Calculating profit margins
- ✅ **Trend Analysis** - Identifying patterns over time

### Real-World Applications
This project simulates real data analyst work:
- Answering business questions with data
- Building reports for stakeholders
- Finding insights in sales data
- Making data-driven recommendations

### What You've Learned
- How to approach business questions systematically
- When to use different JOIN types
- How to combine multiple SQL techniques
- How to structure complex queries
- How to validate your results

## Next Steps

### Immediate
1. Complete all 20 questions
2. Try the bonus challenges
3. Review solutions and understand differences
4. Take the quiz in `quiz.md`

### Practice More
- Modify questions to ask different things
- Add your own business questions
- Try optimizing slow queries
- Export results to CSV for visualization

### Moving Forward
- Day 11: FULL OUTER JOIN and CROSS JOIN
- Day 12: Self Joins
- Continue building on these skills

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 11
