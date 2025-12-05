#!/usr/bin/env python3
"""Setup script for Day 8: INNER JOIN"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day08.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS order_items")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS categories")
    conn.execute("DROP TABLE IF EXISTS customers")
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS departments")
    conn.execute("DROP TABLE IF EXISTS locations")
    
    # Create locations table
    conn.execute("""
        CREATE TABLE locations (
            id INTEGER PRIMARY KEY,
            city VARCHAR,
            country VARCHAR
        )
    """)
    
    # Create departments table
    conn.execute("""
        CREATE TABLE departments (
            id INTEGER PRIMARY KEY,
            department_name VARCHAR,
            location_id INTEGER
        )
    """)
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department_id INTEGER,
            salary DECIMAL(10, 2),
            hire_date DATE,
            is_active BOOLEAN
        )
    """)
    
    # Create categories table
    conn.execute("""
        CREATE TABLE categories (
            id INTEGER PRIMARY KEY,
            category_name VARCHAR,
            description VARCHAR
        )
    """)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category_id INTEGER,
            price DECIMAL(10, 2),
            in_stock BOOLEAN
        )
    """)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            email VARCHAR,
            city VARCHAR
        )
    """)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            total DECIMAL(10, 2),
            status VARCHAR
        )
    """)
    
    # Create order_items table
    conn.execute("""
        CREATE TABLE order_items (
            id INTEGER PRIMARY KEY,
            order_id INTEGER,
            product_id INTEGER,
            quantity INTEGER,
            price DECIMAL(10, 2)
        )
    """)
    
    # Insert locations
    locations_data = [
        (1, 'New York', 'USA'),
        (2, 'London', 'UK'),
        (3, 'Tokyo', 'Japan'),
        (4, 'Paris', 'France'),
        (5, 'Berlin', 'Germany')
    ]
    conn.executemany("INSERT INTO locations VALUES (?, ?, ?)", locations_data)
    
    # Insert departments
    departments_data = [
        (1, 'Engineering', 1),
        (2, 'Sales', 1),
        (3, 'Marketing', 2),
        (4, 'HR', 2),
        (5, 'Finance', 3),
        (6, 'Operations', 4)
    ]
    conn.executemany("INSERT INTO departments VALUES (?, ?, ?)", departments_data)
    
    # Insert employees (80 employees)
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis']
    employees_data = []
    for i in range(1, 81):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        dept_id = random.randint(1, 6)
        salary = round(random.uniform(45000, 150000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        is_active = random.random() > 0.1
        employees_data.append((i, name, dept_id, salary, hire_date.date(), is_active))
    
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?)", employees_data)
    
    # Insert categories
    categories_data = [
        (1, 'Electronics', 'Electronic devices and accessories'),
        (2, 'Books', 'Physical and digital books'),
        (3, 'Clothing', 'Apparel and fashion items'),
        (4, 'Home & Garden', 'Home improvement and garden supplies'),
        (5, 'Sports', 'Sports equipment and accessories'),
        (6, 'Toys', 'Toys and games for all ages')
    ]
    conn.executemany("INSERT INTO categories VALUES (?, ?, ?)", categories_data)
    
    # Insert products (60 products)
    products_data = []
    for i in range(1, 61):
        product_name = f"Product {i}"
        category_id = random.randint(1, 6)
        price = round(random.uniform(10, 500), 2)
        in_stock = random.random() > 0.2
        products_data.append((i, product_name, category_id, price, in_stock))
    
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?, ?)", products_data)
    
    # Insert customers (50 customers)
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney']
    customers_data = []
    for i in range(1, 51):
        customer_name = f"Customer {i}"
        email = f"customer{i}@email.com"
        city = random.choice(cities)
        customers_data.append((i, customer_name, email, city))
    
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?)", customers_data)
    
    # Insert orders (150 orders)
    statuses = ['completed', 'pending', 'shipped', 'cancelled']
    orders_data = []
    for i in range(1, 151):
        customer_id = random.randint(1, 50)
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        total = round(random.uniform(20, 1500), 2)
        status = random.choice(statuses)
        orders_data.append((i, customer_id, order_date.date(), total, status))
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    # Insert order_items (400 items)
    order_items_data = []
    for i in range(1, 401):
        order_id = random.randint(1, 150)
        product_id = random.randint(1, 60)
        quantity = random.randint(1, 5)
        price = round(random.uniform(10, 500), 2)
        order_items_data.append((i, order_id, product_id, quantity, price))
    
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 08: INNER JOIN")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - locations: 5 rows")
    print(f"   - departments: 6 rows")
    print(f"   - employees: 80 rows")
    print(f"   - categories: 6 rows")
    print(f"   - products: 60 rows")
    print(f"   - customers: 50 rows")
    print(f"   - orders: 150 rows")
    print(f"   - order_items: 400 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
