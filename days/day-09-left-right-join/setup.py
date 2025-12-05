#!/usr/bin/env python3
"""Setup script for Day 9: LEFT and RIGHT JOIN"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day09.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop tables
    for table in ['order_items', 'orders', 'products', 'customers', 'employees', 'departments']:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # Create tables
    conn.execute("""
        CREATE TABLE departments (
            id INTEGER PRIMARY KEY,
            department_name VARCHAR,
            location VARCHAR,
            budget DECIMAL(12, 2)
        )
    """)
    
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department_id INTEGER,
            salary DECIMAL(10, 2),
            hire_date DATE
        )
    """)
    
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            email VARCHAR,
            city VARCHAR,
            registration_date DATE
        )
    """)
    
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10, 2),
            stock INTEGER
        )
    """)
    
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            total DECIMAL(10, 2),
            status VARCHAR
        )
    """)
    
    conn.execute("""
        CREATE TABLE order_items (
            id INTEGER PRIMARY KEY,
            order_id INTEGER,
            product_id INTEGER,
            quantity INTEGER,
            price DECIMAL(10, 2)
        )
    """)
    
    # Insert departments
    departments_data = [
        (1, 'Engineering', 'New York', 500000),
        (2, 'Sales', 'London', 300000),
        (3, 'Marketing', 'Tokyo', 200000),
        (4, 'HR', 'Paris', 150000),
        (5, 'Finance', 'Berlin', 250000),
        (6, 'Operations', 'Sydney', 180000)
    ]
    conn.executemany("INSERT INTO departments VALUES (?, ?, ?, ?)", departments_data)
    
    # Insert employees (some without departments)
    names = ['James Smith', 'Mary Johnson', 'John Williams', 'Patricia Brown', 'Robert Jones']
    employees_data = []
    for i in range(1, 61):
        name = f"{random.choice(names)} {i}"
        dept_id = random.randint(1, 5) if random.random() > 0.15 else None
        salary = round(random.uniform(45000, 120000), 2)
        hire_date = datetime(2019, 1, 1) + timedelta(days=random.randint(0, 1825))
        employees_data.append((i, name, dept_id, salary, hire_date.date()))
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?)", employees_data)
    
    # Insert customers
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin']
    customers_data = []
    for i in range(1, 51):
        customer_name = f"Customer {i}"
        email = f"customer{i}@email.com"
        city = random.choice(cities)
        reg_date = datetime(2021, 1, 1) + timedelta(days=random.randint(0, 1095))
        customers_data.append((i, customer_name, email, city, reg_date.date()))
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?, ?)", customers_data)
    
    # Insert products
    categories = ['Electronics', 'Books', 'Clothing', 'Home', 'Sports']
    products_data = []
    for i in range(1, 41):
        product_name = f"Product {i}"
        category = random.choice(categories)
        price = round(random.uniform(10, 500), 2)
        stock = random.randint(0, 100)
        products_data.append((i, product_name, category, price, stock))
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?, ?)", products_data)
    
    # Insert orders (only for some customers)
    orders_data = []
    order_id = 1
    for customer_id in range(1, 51):
        if random.random() > 0.3:  # 70% of customers have orders
            num_orders = random.randint(1, 5)
            for _ in range(num_orders):
                order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
                total = round(random.uniform(20, 1000), 2)
                status = random.choice(['completed', 'pending', 'shipped'])
                orders_data.append((order_id, customer_id, order_date.date(), total, status))
                order_id += 1
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    # Insert order_items (only for some products)
    order_items_data = []
    item_id = 1
    for order_id in range(1, len(orders_data) + 1):
        num_items = random.randint(1, 3)
        for _ in range(num_items):
            product_id = random.randint(1, 35)  # Only products 1-35 get ordered
            quantity = random.randint(1, 5)
            price = round(random.uniform(10, 500), 2)
            order_items_data.append((item_id, order_id, product_id, quantity, price))
            item_id += 1
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 09: LEFT and RIGHT JOIN")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - departments: 6 rows")
    print(f"   - employees: 60 rows (some without departments)")
    print(f"   - customers: 50 rows (some without orders)")
    print(f"   - products: 40 rows (some never ordered)")
    print(f"   - orders: ~100 rows")
    print(f"   - order_items: ~200 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
