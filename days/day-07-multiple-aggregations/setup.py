#!/usr/bin/env python3
"""Setup script for Day 7: Multiple Aggregations"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day07.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS customers")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS order_items")
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            salary DECIMAL(10, 2),
            hire_date DATE,
            commission DECIMAL(10, 2)
        )
    """)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10, 2),
            stock INTEGER,
            cost DECIMAL(10, 2)
        )
    """)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            email VARCHAR,
            city VARCHAR,
            registration_date DATE
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
    
    # Generate employee data (100 employees)
    departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations']
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis']
    
    employees_data = []
    for i in range(1, 101):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        dept = random.choice(departments)
        salary = round(random.uniform(40000, 150000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        commission = round(random.uniform(0, 20000), 2) if dept == 'Sales' else 0
        employees_data.append((i, name, dept, salary, hire_date.date(), commission))
    
    conn.executemany(
        "INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?)",
        employees_data
    )
    
    # Generate product data (80 products)
    categories = ['Electronics', 'Books', 'Clothing', 'Home & Garden', 'Sports', 'Toys']
    products_data = []
    for i in range(1, 81):
        product_name = f"Product {i}"
        category = random.choice(categories)
        cost = round(random.uniform(10, 300), 2)
        price = round(cost * random.uniform(1.5, 3.0), 2)
        stock = random.randint(0, 200)
        products_data.append((i, product_name, category, price, stock, cost))
    
    conn.executemany(
        "INSERT INTO products VALUES (?, ?, ?, ?, ?, ?)",
        products_data
    )
    
    # Generate customer data (60 customers)
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney']
    customers_data = []
    for i in range(1, 61):
        customer_name = f"Customer {i}"
        email = f"customer{i}@email.com"
        city = random.choice(cities)
        reg_date = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 1460))
        customers_data.append((i, customer_name, email, city, reg_date.date()))
    
    conn.executemany(
        "INSERT INTO customers VALUES (?, ?, ?, ?, ?)",
        customers_data
    )
    
    # Generate orders data (300 orders)
    statuses = ['completed', 'pending', 'cancelled', 'shipped']
    orders_data = []
    for i in range(1, 301):
        customer_id = random.randint(1, 60)
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        total = round(random.uniform(20.00, 2000.00), 2)
        status = random.choice(statuses)
        orders_data.append((i, customer_id, order_date.date(), total, status))
    
    conn.executemany(
        "INSERT INTO orders VALUES (?, ?, ?, ?, ?)",
        orders_data
    )
    
    # Generate order_items data (800 items)
    order_items_data = []
    for i in range(1, 801):
        order_id = random.randint(1, 300)
        product_id = random.randint(1, 80)
        quantity = random.randint(1, 10)
        price = round(random.uniform(15, 500), 2)
        order_items_data.append((i, order_id, product_id, quantity, price))
    
    conn.executemany(
        "INSERT INTO order_items VALUES (?, ?, ?, ?, ?)",
        order_items_data
    )
    
    conn.close()
    
    print("✅ Database setup complete for Day 07: Multiple Aggregations")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - employees: 100 rows")
    print(f"   - products: 80 rows")
    print(f"   - customers: 60 rows")
    print(f"   - orders: 300 rows")
    print(f"   - order_items: 800 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
