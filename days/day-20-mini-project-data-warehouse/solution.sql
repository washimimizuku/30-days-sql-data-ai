-- Day 20: Mini Project - Data Warehouse Analytics
-- Solutions

-- ============================================
-- Part 1: Dimensional Analysis
-- ============================================

-- Q1: Sales by Category and Region
SELECT 
    dp.category,
    ds.region,
    SUM(fs.total_amount) as total_sales,
    COUNT(*) as transaction_count,
    ROUND(AVG(fs.total_amount), 2) as avg_transaction_value
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
JOIN dim_store ds ON fs.store_id = ds.store_id
GROUP BY dp.category, ds.region
ORDER BY total_sales DESC;

-- Q2: Top 10 Products by Revenue
SELECT 
    dp.product_name,
    dp.category,
    dp.brand,
    SUM(fs.quantity) as total_quantity,
    SUM(fs.total_amount) as total_revenue,
    ROUND(SUM(fs.total_amount - (dp.unit_cost * fs.quantity)), 2) as profit_margin
FROM fact_sales fs
JOIN dim_product dp ON fs.product_id = dp.product_id
GROUP BY dp.product_id, dp.product_name, dp.category, dp.brand, dp.unit_cost
ORDER BY total_revenue DESC
LIMIT 10;

-- Q3: Customer Segmentation Analysis
SELECT 
    dc.segment,
    COUNT(DISTINCT dc.customer_id) as customer_count,
    SUM(fs.total_amount) as total_revenue,
    ROUND(SUM(fs.total_amount) / COUNT(DISTINCT dc.customer_id), 2) as avg_revenue_per_customer,
    ROUND(AVG(fs.total_amount), 2) as avg_transaction_value,
    COUNT(*) as total_transactions
FROM dim_customer dc
LEFT JOIN fact_sales fs ON dc.customer_id = fs.customer_id
GROUP BY dc.segment
ORDER BY total_revenue DESC;

-- Q4: Store Performance Ranking
SELECT 
    ds.region,
    ds.store_name,
    SUM(fs.total_amount) as revenue,
    ROW_NUMBER() OVER (PARTITION BY ds.region ORDER BY SUM(fs.total_amount) DESC) as rank_in_region,
    ROUND(SUM(fs.total_amount) * 100.0 / SUM(SUM(fs.total_amount)) OVER (PARTITION BY ds.region), 2) as pct_of_region_revenue
FROM fact_sales fs
JOIN dim_store ds ON fs.store_id = ds.store_id
GROUP BY ds.region, ds.store_name, ds.store_id
ORDER BY ds.region, rank_in_region;

-- Q5: Regional Market Share
SELECT 
    ds.region,
    SUM(fs.total_amount) as total_revenue,
    ROUND(SUM(fs.total_amount) * 100.0 / SUM(SUM(fs.total_amount)) OVER (), 2) as market_share_pct,
    ROW_NUMBER() OVER (ORDER BY SUM(fs.total_amount) DESC) as rank
FROM fact_sales fs
JOIN dim_store ds ON fs.store_id = ds.store_id
GROUP BY ds.region
ORDER BY total_revenue DESC;


-- ============================================
-- Part 2: Time-Series Analysis
-- ============================================

-- Q6: Monthly Revenue Trend
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', dd.date) as month,
        SUM(fs.total_amount) as revenue
    FROM fact_sales fs
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as prev_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) as growth,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / LAG(revenue) OVER (ORDER BY month), 2) as growth_pct
FROM monthly_revenue
ORDER BY month DESC
LIMIT 12;

-- Q7: Year-over-Year Comparison
WITH monthly_data AS (
    SELECT 
        dd.year,
        dd.month,
        dd.month_name,
        SUM(fs.total_amount) as revenue
    FROM fact_sales fs
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY dd.year, dd.month, dd.month_name
)
SELECT 
    m1.month_name,
    m1.revenue as this_year_revenue,
    m2.revenue as last_year_revenue,
    ROUND((m1.revenue - m2.revenue) * 100.0 / m2.revenue, 2) as yoy_growth_pct
FROM monthly_data m1
LEFT JOIN monthly_data m2 ON m1.month = m2.month AND m1.year = m2.year + 1
WHERE m1.year = 2024
ORDER BY m1.month;

-- Q8: Quarterly Performance Pivot
SELECT 
    ds.region,
    SUM(CASE WHEN dd.quarter = 1 THEN fs.total_amount ELSE 0 END) as q1_revenue,
    SUM(CASE WHEN dd.quarter = 2 THEN fs.total_amount ELSE 0 END) as q2_revenue,
    SUM(CASE WHEN dd.quarter = 3 THEN fs.total_amount ELSE 0 END) as q3_revenue,
    SUM(CASE WHEN dd.quarter = 4 THEN fs.total_amount ELSE 0 END) as q4_revenue
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
JOIN dim_store ds ON fs.store_id = ds.store_id
WHERE dd.year = 2024
GROUP BY ds.region
ORDER BY ds.region;

-- Q9: Daily Revenue Moving Average
WITH daily_revenue AS (
    SELECT 
        dd.date,
        SUM(fs.total_amount) as daily_revenue
    FROM fact_sales fs
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY dd.date
)
SELECT 
    date,
    daily_revenue,
    ROUND(AVG(daily_revenue) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as ma_7,
    ROUND(AVG(daily_revenue) OVER (ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW), 2) as ma_30,
    CASE 
        WHEN daily_revenue > AVG(daily_revenue) OVER (ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) THEN 'Above MA'
        ELSE 'Below MA'
    END as trend
FROM daily_revenue
ORDER BY date DESC
LIMIT 90;

-- Q10: Seasonal Pattern Analysis
SELECT 
    CASE 
        WHEN dd.month IN (12, 1, 2) THEN 'Winter'
        WHEN dd.month IN (3, 4, 5) THEN 'Spring'
        WHEN dd.month IN (6, 7, 8) THEN 'Summer'
        ELSE 'Fall'
    END as season,
    dd.day_name as day_of_week,
    ROUND(AVG(fs.total_amount), 2) as avg_daily_revenue,
    COUNT(*) as total_transactions,
    CASE 
        WHEN AVG(fs.total_amount) > AVG(AVG(fs.total_amount)) OVER () THEN 'Peak'
        ELSE 'Normal'
    END as is_peak
FROM fact_sales fs
JOIN dim_date dd ON fs.date_id = dd.date_id
GROUP BY season, dd.day_name, dd.day_of_week
ORDER BY 
    CASE season WHEN 'Winter' THEN 1 WHEN 'Spring' THEN 2 WHEN 'Summer' THEN 3 ELSE 4 END,
    dd.day_of_week;


-- ============================================
-- Part 3: Customer Analytics
-- ============================================

-- Q11: Customer Lifetime Value
WITH customer_metrics AS (
    SELECT 
        dc.customer_name,
        MIN(dd.date) as first_purchase,
        MAX(dd.date) as last_purchase,
        COUNT(*) as total_transactions,
        SUM(fs.total_amount) as total_revenue,
        ROUND(AVG(fs.total_amount), 2) as avg_order_value,
        MAX(dd.date) - MIN(dd.date) as lifetime_days
    FROM fact_sales fs
    JOIN dim_customer dc ON fs.customer_id = dc.customer_id
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY dc.customer_id, dc.customer_name
)
SELECT *
FROM customer_metrics
ORDER BY total_revenue DESC
LIMIT 20;

-- Q12: Customer Cohort Analysis
WITH cohorts AS (
    SELECT 
        DATE_TRUNC('month', dc.registration_date) as cohort_month,
        dc.customer_id,
        MAX(dd.date) as last_purchase_date
    FROM dim_customer dc
    LEFT JOIN fact_sales fs ON dc.customer_id = fs.customer_id
    LEFT JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY cohort_month, dc.customer_id
)
SELECT 
    c.cohort_month,
    COUNT(DISTINCT c.customer_id) as customers_in_cohort,
    SUM(fs.total_amount) as total_revenue,
    ROUND(SUM(fs.total_amount) / COUNT(DISTINCT c.customer_id), 2) as avg_revenue_per_customer,
    ROUND(COUNT(DISTINCT CASE WHEN c.last_purchase_date >= CURRENT_DATE - INTERVAL '30 days' THEN c.customer_id END) * 100.0 / 
          COUNT(DISTINCT c.customer_id), 2) as retention_rate
FROM cohorts c
LEFT JOIN fact_sales fs ON c.customer_id = fs.customer_id
GROUP BY c.cohort_month
ORDER BY c.cohort_month;

-- Q13: RFM Segmentation
WITH customer_rfm AS (
    SELECT 
        dc.customer_id,
        dc.customer_name,
        MAX(dd.date) as last_purchase_date,
        COUNT(*) as frequency,
        SUM(fs.total_amount) as monetary
    FROM fact_sales fs
    JOIN dim_customer dc ON fs.customer_id = dc.customer_id
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY dc.customer_id, dc.customer_name
),
rfm_scores AS (
    SELECT 
        customer_name,
        NTILE(5) OVER (ORDER BY CURRENT_DATE - last_purchase_date DESC) as recency_score,
        NTILE(5) OVER (ORDER BY frequency) as frequency_score,
        NTILE(5) OVER (ORDER BY monetary) as monetary_score
    FROM customer_rfm
)
SELECT 
    customer_name,
    recency_score,
    frequency_score,
    monetary_score,
    CASE 
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3 THEN 'Loyal'
        WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'Promising'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
        WHEN recency_score <= 2 AND frequency_score <= 2 THEN 'Lost'
        ELSE 'Regular'
    END as rfm_segment
FROM rfm_scores
ORDER BY recency_score DESC, frequency_score DESC, monetary_score DESC
LIMIT 50;

-- Q14: Customer Churn Prediction
WITH customer_activity AS (
    SELECT 
        dc.customer_id,
        dc.customer_name,
        MAX(dd.date) as last_purchase_date,
        COUNT(*) as total_purchases,
        SUM(fs.total_amount) as total_lifetime_value
    FROM fact_sales fs
    JOIN dim_customer dc ON fs.customer_id = dc.customer_id
    JOIN dim_date dd ON fs.date_id = dd.date_id
    GROUP BY dc.customer_id, dc.customer_name
)
SELECT 
    customer_name,
    last_purchase_date,
    CURRENT_DATE - last_purchase_date as days_since_last_purchase,
    total_lifetime_value,
    CASE 
        WHEN CURRENT_DATE - last_purchase_date > 90 THEN 'High Risk'
        WHEN CURRENT_DATE - last_purchase_date > 60 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as churn_risk
FROM customer_activity
WHERE total_purchases >= 3
  AND CURRENT_DATE - last_purchase_date > 60
ORDER BY days_since_last_purchase DESC;

-- Q15: Customer Purchase Frequency
WITH purchase_dates AS (
    SELECT 
        dc.customer_id,
        dc.customer_name,
        dd.date,
        LAG(dd.date) OVER (PARTITION BY dc.customer_id ORDER BY dd.date) as prev_purchase_date
    FROM fact_sales fs
    JOIN dim_customer dc ON fs.customer_id = dc.customer_id
    JOIN dim_date dd ON fs.date_id = dd.date_id
)
SELECT 
    customer_name,
    COUNT(*) as total_purchases,
    ROUND(AVG(date - prev_purchase_date), 1) as avg_days_between,
    CASE 
        WHEN AVG(date - prev_purchase_date) < 30 THEN 'Frequent'
        WHEN AVG(date - prev_purchase_date) < 90 THEN 'Regular'
        ELSE 'Occasional'
    END as purchase_pattern
FROM purchase_dates
WHERE prev_purchase_date IS NOT NULL
GROUP BY customer_id, customer_name
HAVING COUNT(*) >= 3
ORDER BY avg_days_between;


-- ============================================
-- Part 4: Product Analytics
-- ============================================

-- Q16: Product Performance Matrix
WITH product_metrics AS (
    SELECT 
        dp.product_id,
        dp.product_name,
        SUM(fs.total_amount) as revenue,
        SUM(fs.total_amount - (dp.unit_cost * fs.quantity)) as profit,
        ROUND((SUM(fs.total_amount - (dp.unit_cost * fs.quantity)) / SUM(fs.total_amount)) * 100, 2) as margin_pct
    FROM fact_sales fs
    JOIN dim_product dp ON fs.product_id = dp.product_id
    GROUP BY dp.product_id, dp.product_name, dp.unit_cost
),
classified AS (
    SELECT 
        CASE 
            WHEN revenue > AVG(revenue) OVER () AND margin_pct > AVG(margin_pct) OVER () THEN 'Star'
            WHEN revenue > AVG(revenue) OVER () AND margin_pct <= AVG(margin_pct) OVER () THEN 'Cash Cow'
            WHEN revenue <= AVG(revenue) OVER () AND margin_pct > AVG(margin_pct) OVER () THEN 'Question Mark'
            ELSE 'Dog'
        END as product_type,
        revenue
    FROM product_metrics
)
SELECT 
    product_type,
    COUNT(*) as product_count,
    ROUND(SUM(revenue), 2) as total_revenue
FROM classified
GROUP BY product_type
ORDER BY total_revenue DESC;

-- Q17: Product Sales Trend
WITH recent_sales AS (
    SELECT 
        dp.category,
        SUM(CASE WHEN dd.date >= CURRENT_DATE - INTERVAL '30 days' THEN fs.total_amount ELSE 0 END) as last_30_days,
        SUM(CASE WHEN dd.date >= CURRENT_DATE - INTERVAL '60 days' 
                 AND dd.date < CURRENT_DATE - INTERVAL '30 days' THEN fs.total_amount ELSE 0 END) as previous_30_days
    FROM fact_sales fs
    JOIN dim_product dp ON fs.product_id = dp.product_id
    JOIN dim_date dd ON fs.date_id = dd.date_id
    WHERE dd.date >= CURRENT_DATE - INTERVAL '60 days'
    GROUP BY dp.category
)
SELECT 
    category,
    last_30_days,
    previous_30_days,
    CASE 
        WHEN last_30_days > previous_30_days * 1.1 THEN 'Growing'
        WHEN last_30_days < previous_30_days * 0.9 THEN 'Declining'
        ELSE 'Stable'
    END as trend
FROM recent_sales
ORDER BY last_30_days DESC;

-- Q18: Cross-Sell Analysis
WITH order_products AS (
    SELECT DISTINCT
        fs1.date_id,
        fs1.customer_id,
        fs1.product_id as product1_id,
        fs2.product_id as product2_id
    FROM fact_sales fs1
    JOIN fact_sales fs2 ON fs1.date_id = fs2.date_id 
                        AND fs1.customer_id = fs2.customer_id 
                        AND fs1.product_id < fs2.product_id
)
SELECT 
    dp1.product_name as product1_name,
    dp2.product_name as product2_name,
    COUNT(*) as times_bought_together
FROM order_products op
JOIN dim_product dp1 ON op.product1_id = dp1.product_id
JOIN dim_product dp2 ON op.product2_id = dp2.product_id
GROUP BY dp1.product_name, dp2.product_name
HAVING COUNT(*) >= 10
ORDER BY times_bought_together DESC
LIMIT 20;

-- Q19: Pareto Analysis
WITH product_revenue AS (
    SELECT 
        dp.product_name,
        SUM(fs.total_amount) as revenue
    FROM fact_sales fs
    JOIN dim_product dp ON fs.product_id = dp.product_id
    GROUP BY dp.product_id, dp.product_name
),
cumulative AS (
    SELECT 
        product_name,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC) as cumulative_revenue,
        SUM(revenue) OVER () as total_revenue
    FROM product_revenue
)
SELECT 
    product_name,
    revenue,
    cumulative_revenue,
    ROUND(cumulative_revenue * 100.0 / total_revenue, 2) as cumulative_pct,
    CASE 
        WHEN cumulative_revenue * 100.0 / total_revenue <= 80 THEN 'Top 80%'
        ELSE 'Bottom 20%'
    END as pareto_group
FROM cumulative
ORDER BY revenue DESC;

-- Q20: Slow-Moving Products
WITH recent_sales AS (
    SELECT 
        dp.product_id,
        dp.product_name,
        dp.category,
        COUNT(*) as sales_count,
        MAX(dd.date) - MIN(dd.date) as days_span
    FROM fact_sales fs
    JOIN dim_product dp ON fs.product_id = dp.product_id
    JOIN dim_date dd ON fs.date_id = dd.date_id
    WHERE dd.date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY dp.product_id, dp.product_name, dp.category
)
SELECT 
    product_name,
    category,
    sales_count as sales_last_90_days,
    ROUND(days_span * 1.0 / NULLIF(sales_count, 0), 1) as avg_days_between_sales,
    CASE 
        WHEN sales_count < 5 THEN 'Consider Discount or Discontinue'
        WHEN sales_count < 10 THEN 'Monitor Closely'
        ELSE 'Normal'
    END as recommendation
FROM recent_sales
WHERE sales_count < 10
ORDER BY sales_count, avg_days_between_sales DESC;
