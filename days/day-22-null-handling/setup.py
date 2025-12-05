#!/usr/bin/env python3
"""Setup script for Day 22: NULL Handling and Data Manipulation"""

import duckdb
from pathlib import Path
from datetime import date

def setup():
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day22.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS orders")
    
    # Create employees table with NULLs
    conn.execute("""
        CREATE TABLE employees (
            employee_id INTEGER PRIMARY KEY,
            name VARCHAR,
            email VARCHAR,
            phone VARCHAR,
            department VARCHAR,
            salary DECIMAL(10, 2),
            bonus DECIMAL(10, 2),
            hire_date DATE,
            is_active BOOLEAN
        )
    """)
    
    # Insert employees with various NULL patterns
    conn.execute("""
        INSERT INTO employees VALUES
        (1, 'Alice Johnson', 'alice@company.com', '555-1234', 'Engineering', 95000, 5000, '2020-01-15', TRUE),
        (2, 'Bob Smith', 'bob@company.com', NULL, 'Sales', 85000, NULL, '2019-03-20', TRUE),
        (3, 'Charlie Brown', NULL, '555-5678', 'Marketing', 75000, 3000, '2021-06-10', TRUE),
        (4, 'Diana Prince', 'diana@company.com', '555-9012', 'Engineering', NULL, NULL, '2022-08-05', TRUE),
        (5, 'Eve Davis', NULL, NULL, 'Sales', 80000, 4000, '2018-11-12', FALSE),
        (6, 'Frank Miller', 'frank@company.com', '555-3456', NULL, 90000, NULL, '2020-02-28', TRUE),
        (7, 'Grace Lee', 'grace@company.com', NULL, 'Marketing', 72000, 2000, '2023-04-18', TRUE),
        (8, 'Henry Wilson', NULL, '555-7890', 'Engineering', 88000, NULL, '2019-09-30', TRUE),
        (9, 'Iris Chen', 'iris@company.com', '555-2345', 'Sales', NULL, 5000, '2021-07-22', TRUE),
        (10, 'Jack Taylor', NULL, NULL, NULL, 65000, NULL, '2023-05-14', FALSE)
    """)
    
    # Create products table with NULLs
    conn.execute("""
        CREATE TABLE products (
            product_id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            description VARCHAR,
            price DECIMAL(10, 2),
            stock_quantity INTEGER,
            supplier_id INTEGER
        )
    """)
    
    conn.execute("""
        INSERT INTO products VALUES
        (1, 'Laptop Pro', 'Electronics', 'High-performance laptop', 1299.99, 25, 1),
        (2, 'Wireless Mouse', 'Electronics', NULL, 29.99, 150, 1),
        (3, 'Office Chair', 'Furniture', 'Ergonomic office chair', 249.99, 0, 2),
        (4, 'USB-C Cable', 'Electronics', NULL, 12.99, NULL, 1),
        (5, 'Standing Desk', 'Furniture', 'Adjustable height desk', NULL, 8, 2),
        (6, 'Monitor 27"', 'Electronics', '4K UHD monitor', 399.99, 15, NULL),
        (7, 'Desk Lamp', NULL, 'LED desk lamp', 45.99, 50, 3),
        (8, 'Keyboard', 'Electronics', NULL, 89.99, 0, 1),
        (9, 'Bookshelf', 'Furniture', NULL, 129.99, NULL, 2),
        (10, 'Webcam', 'Electronics', 'HD webcam', NULL, 30, NULL)
    """)
    
    # Create orders table with NULLs
    conn.execute("""
        CREATE TABLE orders (
            order_id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            product_id INTEGER,
            quantity INTEGER,
            order_date DATE,
            ship_date DATE,
            total_amount DECIMAL(10, 2)
        )
    """)
    
    conn.execute("""
        INSERT INTO orders VALUES
        (1, 'Customer A', 1, 2, '2024-01-15', '2024-01-17', 2599.98),
        (2, 'Customer B', 2, 5, '2024-01-16', NULL, 149.95),
        (3, 'Customer C', 3, 1, '2024-01-18', '2024-01-20', 249.99),
        (4, 'Customer A', 4, 10, '2024-01-20', NULL, 129.90),
        (5, 'Customer D', 5, 1, '2024-01-22', '2024-01-25', NULL),
        (6, 'Customer B', 6, 2, '2024-01-25', NULL, 799.98),
        (7, 'Customer E', 7, 3, '2024-01-28', '2024-01-30', 137.97),
        (8, 'Customer C', 8, 1, '2024-02-01', NULL, 89.99),
        (9, 'Customer F', 9, 2, '2024-02-05', '2024-02-08', NULL),
        (10, 'Customer A', 10, 1, '2024-02-10', NULL, NULL)
    """)
    
    conn.close()
    
    print("✅ Database setup complete for Day 22!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print("  - employees (10 rows) - with NULL emails, phones, departments, salaries, bonuses")
    print("  - products (10 rows) - with NULL descriptions, prices, stock, suppliers")
    print("  - orders (10 rows) - with NULL ship dates and amounts")
    print("\n💡 Perfect for practicing NULL handling and data manipulation!")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
