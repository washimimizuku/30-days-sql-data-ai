#!/usr/bin/env python3
"""Setup script for Day 18: CASE Statements"""

import duckdb
from datetime import date, timedelta
from pathlib import Path
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day18.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS order_items")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS customers")
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            product_id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10, 2),
            cost DECIMAL(10, 2),
            stock INTEGER
        )
    """)
    
    conn.execute("""
        INSERT INTO products VALUES
        -- Electronics
        (1, 'Laptop Pro', 'Electronics', 1299.99, 900.00, 25),
        (2, 'Wireless Mouse', 'Electronics', 29.99, 15.00, 150),
        (3, 'USB-C Cable', 'Electronics', 12.99, 5.00, 0),
        (4, 'Monitor 27"', 'Electronics', 399.99, 250.00, 8),
        (5, 'Keyboard Mechanical', 'Electronics', 89.99, 45.00, 45),
        (6, 'Webcam HD', 'Electronics', 79.99, 40.00, 220),
        -- Books
        (7, 'SQL Mastery', 'Books', 45.00, 20.00, 60),
        (8, 'Python Guide', 'Books', 39.99, 18.00, 85),
        (9, 'Data Science 101', 'Books', 55.00, 25.00, 0),
        (10, 'Web Development', 'Books', 42.50, 19.00, 12),
        -- Clothing
        (11, 'T-Shirt Logo', 'Clothing', 24.99, 10.00, 180),
        (12, 'Hoodie Premium', 'Clothing', 59.99, 30.00, 45),
        (13, 'Jeans Classic', 'Clothing', 79.99, 35.00, 5),
        (14, 'Cap Branded', 'Clothing', 19.99, 8.00, 0),
        (15, 'Socks Pack', 'Clothing', 14.99, 6.00, 250),
        -- Furniture
        (16, 'Office Chair', 'Furniture', 249.99, 150.00, 15),
        (17, 'Standing Desk', 'Furniture', 599.99, 400.00, 3),
        (18, 'Desk Lamp', 'Furniture', 45.99, 22.00, 90),
        (19, 'Bookshelf', 'Furniture', 129.99, 70.00, 8),
        (20, 'Filing Cabinet', 'Furniture', 179.99, 100.00, 12)
    """)
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            employee_id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            salary DECIMAL(10, 2),
            performance_score INTEGER,
            hire_date DATE
        )
    """)
    
    conn.execute("""
        INSERT INTO employees VALUES
        (1, 'Alice Johnson', 'Engineering', 110000, 92, '2020-01-15'),
        (2, 'Bob Smith', 'Engineering', 95000, 85, '2019-03-20'),
        (3, 'Charlie Brown', 'Engineering', 88000, 78, '2021-06-10'),
        (4, 'Diana Prince', 'Marketing', 85000, 88, '2020-08-05'),
        (5, 'Eve Davis', 'Marketing', 72000, 65, '2021-11-12'),
        (6, 'Frank Miller', 'Sales', 78000, 91, '2019-02-28'),
        (7, 'Grace Lee', 'Sales', 82000, 87, '2020-04-18'),
        (8, 'Henry Wilson', 'Sales', 68000, 72, '2022-09-30'),
        (9, 'Iris Chen', 'Engineering', 105000, 94, '2018-07-22'),
        (10, 'Jack Taylor', 'Marketing', 55000, 45, '2022-05-14'),
        (11, 'Karen White', 'Sales', 75000, 82, '2021-01-08'),
        (12, 'Leo Martinez', 'Engineering', 58000, 58, '2022-03-15')
    """)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            customer_id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            city VARCHAR,
            state VARCHAR,
            registration_date DATE
        )
    """)
    
    conn.execute("""
        INSERT INTO customers VALUES
        (1, 'TechCorp Inc', 'Seattle', 'WA', '2023-01-15'),
        (2, 'DataSystems LLC', 'Portland', 'OR', '2023-03-20'),
        (3, 'CloudNine Co', 'San Francisco', 'CA', '2023-05-10'),
        (4, 'StartupHub', 'Austin', 'TX', '2023-07-05'),
        (5, 'Enterprise Solutions', 'New York', 'NY', '2023-09-12'),
        (6, 'Innovation Labs', 'Boston', 'MA', '2023-11-01'),
        (7, 'Digital Ventures', 'Chicago', 'IL', '2024-01-15'),
        (8, 'Future Tech', 'Denver', 'CO', '2024-02-20')
    """)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            order_id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            total DECIMAL(10, 2),
            status VARCHAR
        )
    """)
    
    # Generate orders with various statuses
    orders_data = []
    order_id = 1
    base_date = date(2024, 1, 1)
    
    # Customer 1: VIP (many orders, high value)
    for i in range(12):
        order_date = base_date + timedelta(days=i*7)
        total = random.uniform(500, 2000)
        status = random.choice(['completed', 'completed', 'completed', 'pending'])
        orders_data.append((order_id, 1, order_date, round(total, 2), status))
        order_id += 1
    
    # Customer 2: Loyal (regular orders)
    for i in range(7):
        order_date = base_date + timedelta(days=i*12)
        total = random.uniform(300, 800)
        status = random.choice(['completed', 'completed', 'shipped'])
        orders_data.append((order_id, 2, order_date, round(total, 2), status))
        order_id += 1
    
    # Customer 3: Regular (few orders)
    for i in range(3):
        order_date = base_date + timedelta(days=i*25)
        total = random.uniform(150, 400)
        status = 'completed'
        orders_data.append((order_id, 3, order_date, round(total, 2), status))
        order_id += 1
    
    # Customer 4: At risk (one old order)
    orders_data.append((order_id, 4, date(2023, 10, 15), 450.00, 'completed'))
    order_id += 1
    
    # Customer 5: Active (recent orders)
    for i in range(5):
        order_date = base_date + timedelta(days=i*15)
        total = random.uniform(600, 1500)
        status = random.choice(['completed', 'pending', 'shipped'])
        orders_data.append((order_id, 5, order_date, round(total, 2), status))
        order_id += 1
    
    # Customer 6: New (one recent order)
    orders_data.append((order_id, 6, date(2024, 3, 1), 280.00, 'completed'))
    order_id += 1
    
    # Customer 7: Never ordered (no orders)
    
    # Customer 8: Cancelled orders
    for i in range(2):
        order_date = base_date + timedelta(days=i*20)
        total = random.uniform(200, 500)
        orders_data.append((order_id, 8, order_date, round(total, 2), 'cancelled'))
        order_id += 1
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    # Create order_items table
    conn.execute("""
        CREATE TABLE order_items (
            item_id INTEGER PRIMARY KEY,
            order_id INTEGER,
            product_id INTEGER,
            quantity INTEGER,
            price DECIMAL(10, 2)
        )
    """)
    
    # Generate order items
    items_data = []
    item_id = 1
    for order in orders_data:
        oid = order[0]
        # Each order has 1-4 items
        num_items = random.randint(1, 4)
        for _ in range(num_items):
            product_id = random.randint(1, 20)
            quantity = random.randint(1, 5)
            # Get product price (simplified - using fixed prices)
            price = random.uniform(20, 500)
            items_data.append((item_id, oid, product_id, quantity, round(price, 2)))
            item_id += 1
    
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", items_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 18!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print("  - products (20 rows) - 4 categories with varying prices and stock")
    print("  - employees (12 rows) - with performance scores and salaries")
    print("  - customers (8 rows) - various activity levels")
    print(f"  - orders ({len(orders_data)} rows) - with different statuses")
    print(f"  - order_items ({len(items_data)} rows) - order details")
    print(f"\n💡 Run queries with: python ../../tools/run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
