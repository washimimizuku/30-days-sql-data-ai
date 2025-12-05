#!/usr/bin/env python3
"""Setup script for Day 27: Views"""

import duckdb
from pathlib import Path
from datetime import datetime, timedelta
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day27.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Remove existing database
    if db_path.exists():
        db_path.unlink()
    
    conn = duckdb.connect(str(db_path))
    
    print("Creating tables...")
    
    # Departments table
    conn.execute("""
        CREATE TABLE departments (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            location VARCHAR
        )
    """)
    
    # Employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            email VARCHAR,
            department VARCHAR,
            salary DECIMAL(10,2),
            is_active BOOLEAN,
            hire_date DATE
        )
    """)
    
    # Customers table
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            email VARCHAR,
            city VARCHAR
        )
    """)
    
    # Orders table
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            total DECIMAL(10,2),
            status VARCHAR
        )
    """)
    
    # Products table
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10,2)
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
    
    print("Inserting departments (5 rows)...")
    departments_data = [
        (1, 'Sales', 'Seattle'),
        (2, 'Engineering', 'San Francisco'),
        (3, 'Marketing', 'New York'),
        (4, 'HR', 'Seattle'),
        (5, 'Finance', 'Chicago')
    ]
    conn.executemany("INSERT INTO departments VALUES (?, ?, ?)", departments_data)
    
    print("Inserting employees (15 rows)...")
    departments = ['Sales', 'Engineering', 'Marketing', 'HR', 'Finance']
    employees_data = [
        (1, 'Alice Johnson', 'alice@company.com', 'Sales', 75000, True, '2020-01-15'),
        (2, 'Bob Smith', 'bob@company.com', 'Engineering', 95000, True, '2019-03-20'),
        (3, 'Carol White', 'carol@company.com', 'Sales', 72000, True, '2021-06-10'),
        (4, 'David Brown', 'david@company.com', 'Engineering', 105000, True, '2018-11-05'),
        (5, 'Eve Davis', 'eve@company.com', 'Marketing', 68000, True, '2020-09-12'),
        (6, 'Frank Miller', 'frank@company.com', 'Sales', 78000, False, '2017-04-18'),
        (7, 'Grace Wilson', 'grace@company.com', 'Engineering', 98000, True, '2019-07-22'),
        (8, 'Henry Moore', 'henry@company.com', 'HR', 62000, True, '2021-02-14'),
        (9, 'Ivy Taylor', 'ivy@company.com', 'Finance', 85000, True, '2020-05-30'),
        (10, 'Jack Anderson', 'jack@company.com', 'Marketing', 71000, True, '2021-08-25'),
        (11, 'Kate Thomas', 'kate@company.com', 'Sales', 76000, True, '2022-01-10'),
        (12, 'Leo Jackson', 'leo@company.com', 'Engineering', 92000, False, '2018-06-15'),
        (13, 'Mia Harris', 'mia@company.com', 'HR', 64000, True, '2021-11-20'),
        (14, 'Noah Martin', 'noah@company.com', 'Finance', 88000, True, '2019-12-08'),
        (15, 'Olivia Garcia', 'olivia@company.com', 'Marketing', 69000, True, '2022-03-17')
    ]
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?, ?)", employees_data)
    
    print("Inserting customers (10 rows)...")
    cities = ['Seattle', 'Portland', 'San Francisco', 'Los Angeles', 'Denver']
    customers_data = [
        (1, 'Customer A', 'customera@email.com', 'Seattle'),
        (2, 'Customer B', 'customerb@email.com', 'Portland'),
        (3, 'Customer C', 'customerc@email.com', 'San Francisco'),
        (4, 'Customer D', 'customerd@email.com', 'Los Angeles'),
        (5, 'Customer E', 'customere@email.com', 'Denver'),
        (6, 'Customer F', 'customerf@email.com', 'Seattle'),
        (7, 'Customer G', 'customerg@email.com', 'Portland'),
        (8, 'Customer H', 'customerh@email.com', 'San Francisco'),
        (9, 'Customer I', 'customeri@email.com', 'Los Angeles'),
        (10, 'Customer J', 'customerj@email.com', 'Denver')
    ]
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?)", customers_data)
    
    print("Inserting products (20 rows)...")
    categories = ['Electronics', 'Clothing', 'Books', 'Home', 'Sports']
    products_data = []
    for i in range(1, 21):
        products_data.append((
            i,
            f'Product {i}',
            random.choice(categories),
            round(random.uniform(10, 500), 2)
        ))
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?)", products_data)
    
    print("Inserting orders (30 rows)...")
    statuses = ['pending', 'processing', 'shipped', 'delivered']
    orders_data = []
    for i in range(1, 31):
        order_date = datetime(2024, 1, 1) + timedelta(days=random.randint(0, 180))
        orders_data.append((
            i,
            random.randint(1, 10),
            order_date.strftime('%Y-%m-%d'),
            round(random.uniform(50, 1000), 2),
            random.choice(statuses)
        ))
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    print("Inserting order items (60 rows)...")
    order_items_data = []
    for i in range(1, 61):
        order_id = random.randint(1, 30)
        product_id = random.randint(1, 20)
        quantity = random.randint(1, 5)
        price = round(random.uniform(10, 500), 2)
        order_items_data.append((i, order_id, product_id, quantity, price))
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    # Get table sizes
    departments_count = conn.execute("SELECT COUNT(*) FROM departments").fetchone()[0]
    employees_count = conn.execute("SELECT COUNT(*) FROM employees").fetchone()[0]
    customers_count = conn.execute("SELECT COUNT(*) FROM customers").fetchone()[0]
    orders_count = conn.execute("SELECT COUNT(*) FROM orders").fetchone()[0]
    products_count = conn.execute("SELECT COUNT(*) FROM products").fetchone()[0]
    order_items_count = conn.execute("SELECT COUNT(*) FROM order_items").fetchone()[0]
    
    conn.close()
    
    print("\n✅ Database setup complete for Day 27")
    print(f"\n📁 Database location: {db_path}")
    print(f"\n📊 Table sizes:")
    print(f"   - departments: {departments_count} rows")
    print(f"   - employees: {employees_count} rows")
    print(f"   - customers: {customers_count} rows")
    print(f"   - orders: {orders_count} rows")
    print(f"   - products: {products_count} rows")
    print(f"   - order_items: {order_items_count} rows")
    print(f"\n💡 This database is designed for views practice")
    print(f"   Create views to simplify complex queries and improve reusability")

if __name__ == "__main__":
    setup()
