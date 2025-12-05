# Day 7: Multiple Aggregations

## Learning Objectives
- Combine multiple aggregate functions in one query
- Calculate different statistics simultaneously
- Use aggregates with GROUP BY for detailed analysis
- Master complex reporting queries
- Understand aggregate function combinations
- Build comprehensive analytical reports

## Theory (15 minutes)

### What are Multiple Aggregations?

Multiple aggregations means using several aggregate functions (COUNT, SUM, AVG, MIN, MAX) in the same SELECT statement to calculate different statistics at once.

**Think of it as:** "Calculate multiple statistics in one query instead of running separate queries"

### Basic Multiple Aggregations

```sql
-- Calculate multiple statistics for all products
SELECT 
    COUNT(*) as total_products,
    SUM(price) as total_value,
    AVG(price) as average_price,
    MIN(price) as cheapest,
    MAX(price) as most_expensive
FROM products;
```

**Result:**
```
total_products | total_value | average_price | cheapest | most_expensive
100           | 25000.00    | 250.00        | 9.99     | 1999.99
```

### Multiple Aggregations with GROUP BY

Combine multiple aggregates with grouping for detailed analysis:

```sql
-- Statistics by category
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(price) as total_value,
    AVG(price) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM products
GROUP BY category
ORDER BY total_value DESC;
```

**Result:**
```
category     | product_count | total_value | avg_price | min_price | max_price
Electronics  | 25           | 15000.00    | 600.00    | 99.99     | 1999.99
Clothing     | 40           | 6000.00     | 150.00    | 19.99     | 299.99
Books        | 35           | 4000.00     | 114.29    | 9.99      | 49.99
```

### Aggregating Different Columns

You can aggregate different columns in the same query:

```sql
-- Order statistics
SELECT 
    COUNT(*) as total_orders,
    COUNT(DISTINCT customer_id) as unique_customers,
    SUM(total) as total_revenue,
    AVG(total) as avg_order_value,
    MIN(order_date) as first_order,
    MAX(order_date) as last_order
FROM orders;
```

### Combining Aggregates with Calculations

Use aggregate results in calculations:

```sql
-- Product inventory analysis
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(stock) as total_stock,
    AVG(stock) as avg_stock,
    SUM(price * stock) as inventory_value,
    AVG(price * stock) as avg_product_value
FROM products
GROUP BY category;
```

### COUNT with Different Conditions

Use COUNT in multiple ways:

```sql
-- Customer order analysis
SELECT 
    customer_id,
    COUNT(*) as total_orders,
    COUNT(DISTINCT order_date) as days_ordered,
    SUM(total) as total_spent,
    AVG(total) as avg_order_value,
    MIN(total) as smallest_order,
    MAX(total) as largest_order
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;
```

### Aggregates with CASE Statements

Combine aggregates with conditional logic:

```sql
-- Order status summary
SELECT 
    COUNT(*) as total_orders,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_orders,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_orders,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled_orders,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as completed_revenue,
    AVG(CASE WHEN status = 'completed' THEN total END) as avg_completed_value
FROM orders;
```

### Multiple Aggregations with Filtering

Use WHERE to filter before aggregating:

```sql
-- Recent order statistics (last 30 days)
SELECT 
    COUNT(*) as recent_orders,
    COUNT(DISTINCT customer_id) as active_customers,
    SUM(total) as revenue,
    AVG(total) as avg_order_value,
    MIN(total) as min_order,
    MAX(total) as max_order
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days';
```

### Grouping with Multiple Aggregations

Group by multiple columns with aggregates:

```sql
-- Sales by category and month
SELECT 
    category,
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    COUNT(*) as order_count,
    SUM(quantity) as total_quantity,
    SUM(price * quantity) as revenue,
    AVG(price * quantity) as avg_sale_value
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY category, year, month
ORDER BY year, month, revenue DESC;
```

### Practical Example: Sales Dashboard

```sql
-- Complete sales dashboard
SELECT 
    -- Order metrics
    COUNT(*) as total_orders,
    COUNT(DISTINCT customer_id) as unique_customers,
    
    -- Revenue metrics
    SUM(total) as total_revenue,
    AVG(total) as avg_order_value,
    MIN(total) as min_order_value,
    MAX(total) as max_order_value,
    
    -- Time metrics
    MIN(order_date) as first_order_date,
    MAX(order_date) as last_order_date,
    
    -- Status breakdown
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_count,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_count,
    SUM(CASE WHEN status = 'completed' THEN total ELSE 0 END) as completed_revenue
FROM orders;
```

### Practical Example: Customer Analysis

```sql
-- Customer purchase behavior
SELECT 
    customer_id,
    customer_name,
    
    -- Order metrics
    COUNT(o.id) as total_orders,
    COUNT(DISTINCT DATE(order_date)) as days_purchased,
    
    -- Spending metrics
    SUM(total) as lifetime_value,
    AVG(total) as avg_order_value,
    MIN(total) as smallest_purchase,
    MAX(total) as largest_purchase,
    
    -- Time metrics
    MIN(order_date) as first_purchase,
    MAX(order_date) as last_purchase,
    MAX(order_date) - MIN(order_date) as customer_lifespan_days
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY customer_id, customer_name
HAVING COUNT(o.id) > 0
ORDER BY lifetime_value DESC;
```

### Practical Example: Product Performance

```sql
-- Product sales performance
SELECT 
    p.product_name,
    p.category,
    p.price,
    
    -- Sales metrics
    COUNT(oi.id) as times_ordered,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.quantity * oi.price) as total_revenue,
    AVG(oi.quantity) as avg_quantity_per_order,
    
    -- Customer metrics
    COUNT(DISTINCT o.customer_id) as unique_customers,
    
    -- Performance metrics
    MIN(o.order_date) as first_sale,
    MAX(o.order_date) as last_sale
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id
GROUP BY p.product_name, p.category, p.price
ORDER BY total_revenue DESC;
```

### Common Patterns

**Pattern 1: Count and Sum**
```sql
SELECT 
    category,
    COUNT(*) as product_count,
    SUM(price) as total_value
FROM products
GROUP BY category;
```

**Pattern 2: Count, Sum, and Average**
```sql
SELECT 
    category,
    COUNT(*) as count,
    SUM(price) as total,
    AVG(price) as average
FROM products
GROUP BY category;
```

**Pattern 3: All Five Aggregates**
```sql
SELECT 
    category,
    COUNT(*) as count,
    SUM(price) as total,
    AVG(price) as average,
    MIN(price) as minimum,
    MAX(price) as maximum
FROM products
GROUP BY category;
```

**Pattern 4: Conditional Aggregates**
```sql
SELECT 
    category,
    COUNT(*) as total,
    COUNT(CASE WHEN price > 100 THEN 1 END) as expensive,
    COUNT(CASE WHEN price <= 100 THEN 1 END) as affordable,
    SUM(CASE WHEN price > 100 THEN price ELSE 0 END) as expensive_value
FROM products
GROUP BY category;
```

### Best Practices

1. **Name your aggregates clearly**
   ```sql
   -- Good
   SELECT COUNT(*) as total_orders, SUM(total) as total_revenue
   
   -- Bad
   SELECT COUNT(*), SUM(total)
   ```

2. **Use DISTINCT when needed**
   ```sql
   SELECT 
       COUNT(*) as total_orders,
       COUNT(DISTINCT customer_id) as unique_customers
   FROM orders;
   ```

3. **Handle NULLs appropriately**
   ```sql
   SELECT 
       COUNT(*) as total_products,
       COUNT(discount) as products_with_discount,
       AVG(COALESCE(discount, 0)) as avg_discount
   FROM products;
   ```

4. **Order results meaningfully**
   ```sql
   SELECT category, SUM(price) as total_value
   FROM products
   GROUP BY category
   ORDER BY total_value DESC;  -- Most valuable first
   ```

### Common Mistakes to Avoid

**Mistake 1: Forgetting GROUP BY**
```sql
-- Wrong - will error
SELECT category, COUNT(*), AVG(price)
FROM products;

-- Correct
SELECT category, COUNT(*), AVG(price)
FROM products
GROUP BY category;
```

**Mistake 2: Aggregating aggregates**
```sql
-- Wrong - can't nest aggregates directly
SELECT category, SUM(AVG(price))
FROM products
GROUP BY category;

-- Correct - use subquery
SELECT SUM(avg_price)
FROM (
    SELECT category, AVG(price) as avg_price
    FROM products
    GROUP BY category
);
```

**Mistake 3: Using non-grouped columns**
```sql
-- Wrong - product_name not in GROUP BY
SELECT category, product_name, COUNT(*)
FROM products
GROUP BY category;

-- Correct
SELECT category, COUNT(*)
FROM products
GROUP BY category;
```

### Performance Tips

1. **Filter before aggregating** - Use WHERE instead of HAVING when possible
2. **Index grouped columns** - GROUP BY columns should be indexed
3. **Limit result sets** - Use LIMIT for large aggregations
4. **Use appropriate data types** - Smaller types aggregate faster

## Exercises (40 minutes)

### Setup
Run the setup script first:
```bash
python setup.py
```

This creates `day07.db` with sample data.

### Database Schema

**products** table:
- id, product_name, category, price, stock, cost

**orders** table:
- id, customer_id, order_date, total, status

**order_items** table:
- id, order_id, product_id, quantity, price

**customers** table:
- id, customer_name, email, city, registration_date

**employees** table:
- id, name, department, salary, hire_date, commission

### Exercise 1: Basic Multiple Aggregations (Easy)
Write a query to calculate for all products:
- Total count
- Sum of prices
- Average price
- Minimum price
- Maximum price

**Expected columns:** total_products, total_value, avg_price, min_price, max_price

### Exercise 2: Aggregations by Category (Easy)
Write a query to calculate for each category:
- Product count
- Total value (sum of prices)
- Average price

Order by total value descending.

**Expected columns:** category, product_count, total_value, avg_price

### Exercise 3: Complete Category Statistics (Medium)
Write a query to get all five aggregates for each category:
- Count, Sum, Average, Min, Max of prices

Order by category name.

**Expected columns:** category, product_count, total_value, avg_price, min_price, max_price

### Exercise 4: Order Summary Statistics (Easy)
Write a query to calculate for all orders:
- Total orders
- Total revenue (sum of totals)
- Average order value
- Smallest order
- Largest order

**Expected columns:** total_orders, total_revenue, avg_order_value, min_order, max_order

### Exercise 5: Orders by Status (Medium)
Write a query to calculate for each order status:
- Number of orders
- Total revenue
- Average order value

Order by total revenue descending.

**Expected columns:** status, order_count, total_revenue, avg_order_value

### Exercise 6: Customer Order Statistics (Medium)
Write a query to calculate for each customer:
- Number of orders
- Total spent
- Average order value
- Smallest order
- Largest order

Only include customers with at least one order. Order by total spent descending.

**Expected columns:** customer_name, order_count, total_spent, avg_order_value, min_order, max_order

### Exercise 7: Product Inventory Value (Medium)
Write a query to calculate for each category:
- Total products
- Total stock quantity
- Total inventory value (sum of price * stock)
- Average inventory value per product

**Expected columns:** category, product_count, total_stock, inventory_value, avg_product_value

### Exercise 8: Conditional Aggregations (Medium)
Write a query to count orders by status using CASE:
- Total orders
- Completed orders count
- Pending orders count
- Cancelled orders count

**Expected columns:** total_orders, completed, pending, cancelled

### Exercise 9: Revenue by Status (Medium)
Write a query to calculate revenue by order status using CASE:
- Total revenue (all orders)
- Completed revenue
- Pending revenue
- Cancelled revenue

**Expected columns:** total_revenue, completed_revenue, pending_revenue, cancelled_revenue

### Exercise 10: Product Price Ranges (Medium)
Write a query to count products by price range using CASE:
- Total products
- Budget products (price < 50)
- Mid-range products (price 50-200)
- Premium products (price > 200)

**Expected columns:** total_products, budget_count, midrange_count, premium_count

### Exercise 11: Customer Activity by City (Medium)
Write a query to calculate for each city:
- Number of customers
- Number of orders
- Total revenue
- Average order value

Order by total revenue descending.

**Expected columns:** city, customer_count, order_count, total_revenue, avg_order_value

### Exercise 12: Monthly Order Statistics (Medium)
Write a query to calculate for each month:
- Number of orders
- Total revenue
- Average order value
- Number of unique customers

**Hint:** Use EXTRACT(YEAR FROM ...) and EXTRACT(MONTH FROM ...)

**Expected columns:** year, month, order_count, total_revenue, avg_order_value, unique_customers

### Exercise 13: Product Sales Performance (Hard)
Write a query to calculate for each product:
- Times ordered
- Total quantity sold
- Total revenue
- Average quantity per order

Only include products that have been ordered. Order by total revenue descending.

**Expected columns:** product_name, times_ordered, total_quantity, total_revenue, avg_quantity

### Exercise 14: Category Sales Analysis (Hard)
Write a query to calculate for each category:
- Number of products
- Number of products sold (at least once)
- Total quantity sold
- Total revenue
- Average revenue per product sold

**Expected columns:** category, total_products, products_sold, total_quantity, total_revenue, avg_revenue_per_product

### Exercise 15: Customer Lifetime Value (Hard)
Write a query to calculate for each customer:
- Total orders
- Total spent
- Average order value
- First order date
- Last order date
- Days as customer (last order - first order)

Only include customers with orders. Order by total spent descending.

**Expected columns:** customer_name, order_count, total_spent, avg_order_value, first_order, last_order, days_active

### Exercise 16: Employee Compensation Analysis (Medium)
Write a query to calculate for each department:
- Number of employees
- Total salary cost
- Average salary
- Minimum salary
- Maximum salary
- Total commission

**Expected columns:** department, employee_count, total_salary, avg_salary, min_salary, max_salary, total_commission

### Exercise 17: Product Profitability (Hard)
Write a query to calculate for each product:
- Total quantity sold
- Total revenue (quantity * price)
- Total cost (quantity * cost)
- Total profit (revenue - cost)
- Profit margin percentage

Only include sold products. Order by total profit descending.

**Expected columns:** product_name, quantity_sold, revenue, cost, profit, profit_margin_pct

### Exercise 18: Daily Sales Summary (Medium)
Write a query to calculate for each date:
- Number of orders
- Total revenue
- Average order value
- Number of unique customers
- Number of items sold

Order by date descending.

**Expected columns:** order_date, order_count, total_revenue, avg_order_value, unique_customers, items_sold

### Exercise 19: Customer Segmentation (Hard)
Write a query to segment customers by total spending:
- High value (>1000): count and total revenue
- Medium value (500-1000): count and total revenue
- Low value (<500): count and total revenue

**Expected columns:** segment, customer_count, total_revenue

**Hint:** Use CASE in GROUP BY or use subquery

### Exercise 20: Product Stock Analysis (Medium)
Write a query to analyze stock levels by category:
- Total products
- Products in stock (stock > 0)
- Products out of stock (stock = 0)
- Total stock quantity
- Average stock per product

**Expected columns:** category, total_products, in_stock_count, out_of_stock_count, total_stock, avg_stock

### Exercise 21: Order Item Statistics (Medium)
Write a query to calculate for each order:
- Number of items
- Total quantity
- Total value
- Average item price

Order by total value descending.

**Expected columns:** order_id, item_count, total_quantity, total_value, avg_item_price

### Exercise 22: Category Performance Matrix (Hard)
Write a query to create a performance matrix for each category:
- Number of products
- Number of orders containing category products
- Total quantity sold
- Total revenue
- Average price
- Average quantity per order

**Expected columns:** category, product_count, order_count, total_quantity, total_revenue, avg_price, avg_quantity_per_order

### Exercise 23: Customer Purchase Frequency (Hard)
Write a query to analyze customer purchase frequency:
- Customer name
- Total orders
- Total spent
- Average order value
- Days between first and last order
- Average days between orders

Only include customers with 2+ orders.

**Expected columns:** customer_name, order_count, total_spent, avg_order_value, total_days, avg_days_between_orders

**Hint:** avg_days_between_orders = total_days / (order_count - 1)

### Exercise 24: Product Category Comparison (Medium)
Write a query to compare each category to overall averages:
- Category name
- Category average price
- Overall average price (all products)
- Difference from overall average

**Expected columns:** category, category_avg_price, overall_avg_price, difference

**Hint:** Use subquery or window function

### Exercise 25: Monthly Revenue Trends (Hard)
Write a query to calculate monthly trends:
- Year and month
- Number of orders
- Total revenue
- Average order value
- Number of new customers (first order in that month)

Order by year and month.

**Expected columns:** year, month, order_count, total_revenue, avg_order_value, new_customers

### Exercise 26: Employee Performance (Hard)
Write a query to calculate for each employee:
- Total compensation (salary + commission)
- Number of months employed
- Average monthly compensation
- Commission percentage of total compensation

Order by total compensation descending.

**Expected columns:** name, total_compensation, months_employed, avg_monthly_compensation, commission_percentage

### Exercise 27: Product Mix Analysis (Hard)
Write a query to analyze the product mix for each order:
- Order ID
- Number of different products
- Number of different categories
- Total items
- Total value
- Average price per item

Order by total value descending.

**Expected columns:** order_id, unique_products, unique_categories, total_items, total_value, avg_price_per_item

### Exercise 28: Customer City Performance (Hard)
Write a query to rank cities by customer value:
- City name
- Number of customers
- Number of active customers (placed orders)
- Total orders
- Total revenue
- Average revenue per customer
- Average orders per active customer

Order by total revenue descending.

**Expected columns:** city, total_customers, active_customers, total_orders, total_revenue, avg_revenue_per_customer, avg_orders_per_active

### Exercise 29: Complete Product Report (Very Hard)
Write a query to create a complete product report:
- Product name and category
- Current price and stock
- Times ordered
- Total quantity sold
- Total revenue
- Average quantity per order
- Number of unique customers
- First sale date
- Last sale date
- Days since last sale

Only include products with sales. Order by total revenue descending.

**Expected columns:** product_name, category, price, stock, times_ordered, quantity_sold, revenue, avg_quantity, unique_customers, first_sale, last_sale, days_since_last_sale

### Exercise 30: Business Intelligence Dashboard (Very Hard)
Write a query to create a complete business dashboard with multiple aggregations:
- Total products, average price, total inventory value
- Total customers, active customers percentage
- Total orders, completed orders, pending orders, cancelled orders
- Total revenue, completed revenue, average order value
- Total employees, average salary, total salary cost

**Hint:** Use multiple subqueries or CROSS JOIN to combine different aggregations

**Expected columns:** total_products, avg_product_price, inventory_value, total_customers, active_customer_pct, total_orders, completed_orders, pending_orders, cancelled_orders, total_revenue, completed_revenue, avg_order_value, total_employees, avg_salary, total_salary_cost

## Key Takeaways

- **Multiple aggregates in one query** - Calculate COUNT, SUM, AVG, MIN, MAX together
- **Combine with GROUP BY** - Get statistics for each group
- **Use meaningful aliases** - Name aggregates clearly (total_revenue, avg_price)
- **Aggregate different columns** - Each aggregate can use different columns
- **Conditional aggregates** - Use CASE with COUNT/SUM for conditional counting
- **Handle NULLs properly** - Use COALESCE when needed
- **Order results meaningfully** - Sort by the most important metric
- **Filter before aggregating** - Use WHERE for better performance
- **Avoid common mistakes** - Remember GROUP BY, don't nest aggregates
- **Build comprehensive reports** - Multiple aggregations enable rich analytics

## Resources
- [DuckDB Documentation](https://duckdb.org/docs/)
- [SQL Tutorial](https://www.sqltutorial.org/)
- [DuckDB SQL Reference](https://duckdb.org/docs/sql/introduction)

## Next Steps
- Complete the exercises
- Check your solution
- Take the quiz in `quiz.md`
- Move to Day 8
