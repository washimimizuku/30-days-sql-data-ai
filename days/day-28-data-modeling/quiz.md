# Day 28 Quiz: Data Modeling - Star Schema

Test your understanding of dimensional modeling and star schema design!

---

1. **What is a star schema?**
   - A) A normalized database design for OLTP
   - B) A dimensional model with one fact table and multiple dimension tables
   - C) A type of index structure
   - D) A query optimization technique

2. **What does a fact table contain?**
   - A) Descriptive attributes about entities
   - B) Quantitative measurements and metrics
   - C) Only primary keys
   - D) Configuration settings

3. **What do dimension tables contain?**
   - A) Measurements and metrics
   - B) Descriptive attributes and context
   - C) Only foreign keys
   - D) Transaction logs

4. **Which is a characteristic of fact tables?**
   - A) Small and wide (many columns)
   - B) Large and narrow (few columns)
   - C) Contains only text data
   - D) Never has foreign keys

5. **Which is a characteristic of dimension tables?**
   - A) Millions of rows
   - B) Smaller with descriptive attributes
   - C) Only numeric data
   - D) No primary keys

6. **What is the main benefit of star schema?**
   - A) More complex queries
   - B) Slower query performance
   - C) Optimized for analytics with fewer JOINs
   - D) Better for real-time transactions

7. **What is denormalization?**
   - A) Removing all data redundancy
   - B) Combining tables to reduce JOINs and improve query speed
   - C) Creating more tables
   - D) Deleting duplicate records

8. **When should you use star schema?**
   - A) For OLTP transactional systems
   - B) For OLAP analytics and data warehouses
   - C) For small databases only
   - D) Never, it's outdated

9. **What is a surrogate key?**
   - A) A natural business key
   - B) An artificial integer key used as primary key
   - C) A foreign key
   - D) A composite key

10. **What is a date dimension?**
    - A) A table storing only dates
    - B) A dimension table with pre-calculated date attributes (year, quarter, month, etc.)
    - C) A timestamp column
    - D) A calendar application

11. **What does SCD stand for?**
    - A) Simple Column Data
    - B) Slowly Changing Dimension
    - C) Star Column Design
    - D) System Change Detection

12. **What is SCD Type 1?**
    - A) Keep full history with new rows
    - B) Overwrite old values (no history)
    - C) Add columns for previous values
    - D) Never update dimensions

13. **What is the grain of a fact table?**
    - A) The size in bytes
    - B) The level of detail each row represents
    - C) The number of columns
    - D) The data type

14. **Which query pattern is typical for star schema?**
    - A) Complex nested subqueries
    - B) Fact table JOINed with dimension tables, then aggregated
    - C) Only SELECT without JOINs
    - D) Recursive queries

15. **What is the difference between OLTP and OLAP?**
    - A) OLTP is for analytics, OLAP is for transactions
    - B) OLTP is for transactions (normalized), OLAP is for analytics (denormalized)
    - C) They are the same thing
    - D) OLTP is faster than OLAP

---

## Answers

1. **B** - A dimensional model with one fact table and multiple dimension tables
2. **B** - Quantitative measurements and metrics
3. **B** - Descriptive attributes and context
4. **B** - Large and narrow (few columns)
5. **B** - Smaller with descriptive attributes
6. **C** - Optimized for analytics with fewer JOINs
7. **B** - Combining tables to reduce JOINs and improve query speed
8. **B** - For OLAP analytics and data warehouses
9. **B** - An artificial integer key used as primary key
10. **B** - A dimension table with pre-calculated date attributes
11. **B** - Slowly Changing Dimension
12. **B** - Overwrite old values (no history)
13. **B** - The level of detail each row represents
14. **B** - Fact table JOINed with dimension tables, then aggregated
15. **B** - OLTP is for transactions (normalized), OLAP is for analytics (denormalized)
