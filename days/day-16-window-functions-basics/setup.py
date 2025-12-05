#!/usr/bin/env python3
"""Setup script for Day 16: Window Functions - ROW_NUMBER, RANK, DENSE_RANK"""

import duckdb
from datetime import date, timedelta
from pathlib import Path

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day16.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS sales")
    conn.execute("DROP TABLE IF EXISTS orders")
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            employee_id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            salary DECIMAL(10, 2),
            hire_date DATE,
            city VARCHAR,
            email VARCHAR
        )
    """)
    
    # Insert employee data with some duplicate salaries for ranking examples
    conn.execute("""
        INSERT INTO employees VALUES
        (1, 'Alice Johnson', 'Engineering', 95000, '2020-01-15', 'Seattle', 'alice@company.com'),
        (2, 'Bob Smith', 'Engineering', 105000, '2019-03-20', 'Seattle', 'bob@company.com'),
        (3, 'Charlie Brown', 'Engineering', 95000, '2021-06-10', 'Portland', 'charlie@company.com'),
        (4, 'Diana Prince', 'Marketing', 85000, '2020-08-05', 'Seattle', 'diana@company.com'),
        (5, 'Eve Davis', 'Marketing', 90000, '2019-11-12', 'Portland', 'eve@company.com'),
        (6, 'Frank Miller', 'Marketing', 85000, '2022-02-28', 'Seattle', 'frank@company.com'),
        (7, 'Grace Lee', 'Sales', 78000, '2021-04-18', 'Portland', 'grace@company.com'),
        (8, 'Henry Wilson', 'Sales', 82000, '2020-09-30', 'Seattle', 'henry@company.com'),
        (9, 'Iris Chen', 'Sales', 88000, '2019-07-22', 'Seattle', 'iris@company.com'),
        (10, 'Jack Taylor', 'Engineering', 110000, '2018-05-14', 'Portland', 'jack@company.com'),
        (11, 'Karen White', 'Marketing', 92000, '2021-01-08', 'Seattle', 'karen@company.com'),
        (12, 'Leo Martinez', 'Sales', 78000, '2022-03-15', 'Portland', 'leo@company.com'),
        (13, 'Maria Garcia', 'Engineering', 98000, '2020-10-20', 'Seattle', 'maria@company.com'),
        (14, 'Nathan Scott', 'Marketing', 87000, '2021-08-12', 'Portland', 'nathan@company.com'),
        (15, 'Olivia Moore', 'Sales', 85000, '2019-12-05', 'Seattle', 'olivia@company.com'),
        -- Add some duplicates for testing
        (16, 'Paul Anderson', 'Engineering', 95000, '2022-01-10', 'Seattle', 'paul@company.com'),
        (17, 'Quinn Roberts', 'Sales', 78000, '2021-11-20', 'Portland', 'quinn@company.com'),
        (18, 'Rachel Green', 'Marketing', 85000, '2020-04-15', 'Seattle', 'rachel@company.com')
    """)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            product_id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10, 2),
            quantity_sold INTEGER
        )
    """)
    
    conn.execute("""
        INSERT INTO products VALUES
        (1, 'Laptop Pro', 'Electronics', 1299.99, 450),
        (2, 'Wireless Mouse', 'Electronics', 29.99, 1200),
        (3, 'USB-C Cable', 'Electronics', 12.99, 2500),
        (4, 'Monitor 27"', 'Electronics', 399.99, 680),
        (5, 'Keyboard Mechanical', 'Electronics', 89.99, 890),
        (6, 'Office Chair', 'Furniture', 249.99, 320),
        (7, 'Standing Desk', 'Furniture', 599.99, 180),
        (8, 'Desk Lamp', 'Furniture', 45.99, 550),
        (9, 'Bookshelf', 'Furniture', 129.99, 210),
        (10, 'Filing Cabinet', 'Furniture', 179.99, 150),
        (11, 'Notebook Set', 'Stationery', 15.99, 1800),
        (12, 'Pen Pack', 'Stationery', 8.99, 3200),
        (13, 'Sticky Notes', 'Stationery', 5.99, 2800),
        (14, 'Planner 2024', 'Stationery', 24.99, 950),
        (15, 'Desk Organizer', 'Stationery', 18.99, 720)
    """)
    
    # Create sales table
    conn.execute("""
        CREATE TABLE sales (
            sale_id INTEGER PRIMARY KEY,
            salesperson_name VARCHAR,
            region VARCHAR,
            sale_date DATE,
            amount DECIMAL(10, 2)
        )
    """)
    
    # Generate sales data
    base_date = date(2024, 1, 1)
    sales_data = []
    sale_id = 1
    
    salespeople = [
        ('Grace Lee', 'West', [5000, 7500, 6200, 8100, 5800]),
        ('Henry Wilson', 'West', [6500, 7200, 8900, 7100, 6800]),
        ('Iris Chen', 'West', [9200, 8500, 9800, 10200, 9500]),
        ('Leo Martinez', 'East', [4500, 5200, 4800, 5500, 4900]),
        ('Olivia Moore', 'East', [7800, 8200, 7500, 8800, 8100]),
        ('Quinn Roberts', 'East', [5500, 6100, 5800, 6400, 5900]),
    ]
    
    for name, region, amounts in salespeople:
        for i, amount in enumerate(amounts):
            sales_data.append((sale_id, name, region, base_date + timedelta(days=i*30), amount))
            sale_id += 1
    
    conn.executemany("INSERT INTO sales VALUES (?, ?, ?, ?, ?)", sales_data)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            order_id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            order_date DATE,
            order_amount DECIMAL(10, 2)
        )
    """)
    
    # Generate orders with some gaps in IDs
    orders_data = [
        (1, 'Customer A', '2024-01-05', 150.00),
        (2, 'Customer B', '2024-01-08', 275.50),
        (3, 'Customer A', '2024-01-12', 89.99),
        (5, 'Customer C', '2024-01-15', 420.00),  # Gap: missing ID 4
        (6, 'Customer B', '2024-01-18', 310.25),
        (7, 'Customer A', '2024-01-22', 195.00),
        (9, 'Customer C', '2024-01-25', 550.00),  # Gap: missing ID 8
        (10, 'Customer B', '2024-01-28', 125.75),
        (11, 'Customer A', '2024-02-02', 380.00),
        (12, 'Customer C', '2024-02-05', 290.50),
        (13, 'Customer B', '2024-02-08', 445.00),
        (15, 'Customer A', '2024-02-12', 210.00),  # Gap: missing ID 14
        (16, 'Customer C', '2024-02-15', 175.25),
        (17, 'Customer B', '2024-02-18', 520.00),
        (18, 'Customer A', '2024-02-22', 95.50),
    ]
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?)", orders_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 16!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print("  - employees (18 rows) - with duplicate salaries for ranking")
    print("  - products (15 rows) - across 3 categories")
    print("  - sales (30 rows) - 6 salespeople across 2 regions")
    print("  - orders (15 rows) - with gaps in order_id for gap detection")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
