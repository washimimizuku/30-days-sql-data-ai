#!/usr/bin/env python3
"""Setup script for Day 26: Transactions and ACID"""

import duckdb
from pathlib import Path
from datetime import datetime, timedelta
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day26.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Remove existing database
    if db_path.exists():
        db_path.unlink()
    
    conn = duckdb.connect(str(db_path))
    
    print("Creating tables...")
    
    # Accounts table for transaction practice
    conn.execute("""
        CREATE TABLE accounts (
            id INTEGER PRIMARY KEY,
            account_number VARCHAR,
            customer_name VARCHAR,
            balance DECIMAL(10,2) CHECK (balance >= 0)
        )
    """)
    
    # Orders table
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            status VARCHAR,
            total DECIMAL(10,2)
        )
    """)
    
    # Order items table
    conn.execute("""
        CREATE TABLE order_items (
            id INTEGER PRIMARY KEY,
            order_id INTEGER,
            product_id INTEGER,
            quantity INTEGER,
            price DECIMAL(10,2)
        )
    """)
    
    # Products table
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            stock INTEGER CHECK (stock >= 0),
            price DECIMAL(10,2)
        )
    """)
    
    # Employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            salary DECIMAL(10,2) CHECK (salary > 0)
        )
    """)
    
    print("Inserting accounts (10 rows)...")
    accounts_data = [
        (1, 'ACC001', 'Alice Johnson', 5000.00),
        (2, 'ACC002', 'Bob Smith', 3500.00),
        (3, 'ACC003', 'Carol White', 7200.00),
        (4, 'ACC004', 'David Brown', 2100.00),
        (5, 'ACC005', 'Eve Davis', 8900.00),
        (6, 'ACC006', 'Frank Miller', 4300.00),
        (7, 'ACC007', 'Grace Wilson', 6700.00),
        (8, 'ACC008', 'Henry Moore', 3200.00),
        (9, 'ACC009', 'Ivy Taylor', 5500.00),
        (10, 'ACC010', 'Jack Anderson', 4800.00)
    ]
    conn.executemany("INSERT INTO accounts VALUES (?, ?, ?, ?)", accounts_data)
    
    print("Inserting products (15 rows)...")
    products_data = [
        (1, 'Laptop', 50, 999.99),
        (2, 'Mouse', 200, 29.99),
        (3, 'Keyboard', 150, 79.99),
        (4, 'Monitor', 75, 299.99),
        (5, 'Headphones', 120, 149.99),
        (6, 'Webcam', 80, 89.99),
        (7, 'USB Cable', 300, 9.99),
        (8, 'Desk Lamp', 60, 39.99),
        (9, 'Chair', 40, 249.99),
        (10, 'Desk', 25, 399.99),
        (11, 'Notebook', 500, 4.99),
        (12, 'Pen Set', 400, 12.99),
        (13, 'Backpack', 90, 59.99),
        (14, 'Water Bottle', 150, 19.99),
        (15, 'Phone Stand', 100, 24.99)
    ]
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?)", products_data)
    
    print("Inserting orders (20 rows)...")
    statuses = ['pending', 'processing', 'shipped', 'delivered']
    orders_data = []
    for i in range(1, 21):
        order_date = datetime(2024, 1, 1) + timedelta(days=random.randint(0, 180))
        orders_data.append((
            i,
            random.randint(1, 10),
            order_date.strftime('%Y-%m-%d'),
            random.choice(statuses),
            round(random.uniform(50, 1000), 2)
        ))
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    print("Inserting order items (50 rows)...")
    order_items_data = []
    for i in range(1, 51):
        order_id = random.randint(1, 20)
        product_id = random.randint(1, 15)
        quantity = random.randint(1, 5)
        price = round(random.uniform(10, 500), 2)
        order_items_data.append((i, order_id, product_id, quantity, price))
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    print("Inserting employees (12 rows)...")
    departments = ['Sales', 'Engineering', 'Marketing', 'HR']
    employees_data = [
        (1, 'John Doe', 'Sales', 65000.00),
        (2, 'Jane Smith', 'Engineering', 85000.00),
        (3, 'Mike Johnson', 'Sales', 62000.00),
        (4, 'Sarah Williams', 'Engineering', 90000.00),
        (5, 'Tom Brown', 'Marketing', 58000.00),
        (6, 'Lisa Davis', 'HR', 55000.00),
        (7, 'Chris Wilson', 'Engineering', 88000.00),
        (8, 'Amy Taylor', 'Sales', 67000.00),
        (9, 'David Lee', 'Marketing', 60000.00),
        (10, 'Emma Martinez', 'Engineering', 92000.00),
        (11, 'Ryan Garcia', 'HR', 57000.00),
        (12, 'Olivia Rodriguez', 'Sales', 64000.00)
    ]
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?)", employees_data)
    
    # Get table sizes
    accounts_count = conn.execute("SELECT COUNT(*) FROM accounts").fetchone()[0]
    orders_count = conn.execute("SELECT COUNT(*) FROM orders").fetchone()[0]
    order_items_count = conn.execute("SELECT COUNT(*) FROM order_items").fetchone()[0]
    products_count = conn.execute("SELECT COUNT(*) FROM products").fetchone()[0]
    employees_count = conn.execute("SELECT COUNT(*) FROM employees").fetchone()[0]
    
    conn.close()
    
    print("\n✅ Database setup complete for Day 26")
    print(f"\n📁 Database location: {db_path}")
    print(f"\n📊 Table sizes:")
    print(f"   - accounts: {accounts_count} rows")
    print(f"   - orders: {orders_count} rows")
    print(f"   - order_items: {order_items_count} rows")
    print(f"   - products: {products_count} rows")
    print(f"   - employees: {employees_count} rows")
    print(f"\n💡 This database is designed for transaction practice")
    print(f"   Use BEGIN, COMMIT, and ROLLBACK to practice safe data modifications")

if __name__ == "__main__":
    setup()
