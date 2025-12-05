#!/usr/bin/env python3
"""Setup script for Day 6: HAVING Clause"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day06.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS order_items")
    conn.execute("DROP TABLE IF EXISTS sales")
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            salary DECIMAL(10, 2),
            hire_date DATE,
            city VARCHAR,
            is_active BOOLEAN
        )
    """)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10, 2),
            cost DECIMAL(10, 2),
            rating DECIMAL(3, 2)
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
    
    # Create sales table
    conn.execute("""
        CREATE TABLE sales (
            id INTEGER PRIMARY KEY,
            product_id INTEGER,
            sale_date DATE,
            quantity INTEGER,
            amount DECIMAL(10, 2)
        )
    """)
    
    # Generate employee data (200 employees)
    departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations', 'Support', 'Product', 'Legal', 'Admin']
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney', 'Toronto', 'Singapore', 'Mumbai', 'Dublin']
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
                   'William', 'Barbara', 'David', 'Elizabeth', 'Richard', 'Susan', 'Joseph', 'Jessica']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis']
    
    employees_data = []
    for i in range(1, 201):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        dept = random.choice(departments)
        salary = round(random.uniform(35000, 200000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        city = random.choice(cities)
        is_active = random.random() > 0.15
        employees_data.append((i, name, dept, salary, hire_date.date(), city, is_active))
    
    conn.executemany(
        "INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?, ?)",
        employees_data
    )
    
    # Generate product data (150 products)
    categories = ['Electronics', 'Books', 'Clothing', 'Home & Garden', 'Sports', 'Toys', 'Food', 'Beauty', 'Automotive', 'Health']
    products_data = []
    for i in range(1, 151):
        product_name = f"Product {i}"
        category = random.choice(categories)
        cost = round(random.uniform(5, 500), 2)
        price = round(cost * random.uniform(1.5, 3.5), 2)
        rating = round(random.uniform(2.5, 5.0), 2)
        products_data.append((i, product_name, category, price, cost, rating))
    
    conn.executemany(
        "INSERT INTO products VALUES (?, ?, ?, ?, ?, ?)",
        products_data
    )
    
    # Generate orders data (500 orders)
    statuses = ['Pending', 'Shipped', 'Delivered', 'Cancelled']
    orders_data = []
    for i in range(1, 501):
        customer_id = random.randint(1, 100)
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        total = round(random.uniform(20.00, 5000.00), 2)
        status = random.choice(statuses)
        orders_data.append((i, customer_id, order_date.date(), total, status))
    
    conn.executemany(
        "INSERT INTO orders VALUES (?, ?, ?, ?, ?)",
        orders_data
    )
    
    # Generate order_items data (1200 items)
    order_items_data = []
    for i in range(1, 1201):
        order_id = random.randint(1, 500)
        product_id = random.randint(1, 150)
        quantity = random.randint(1, 20)
        price = round(random.uniform(10, 800), 2)
        order_items_data.append((i, order_id, product_id, quantity, price))
    
    conn.executemany(
        "INSERT INTO order_items VALUES (?, ?, ?, ?, ?)",
        order_items_data
    )
    
    # Generate sales data (1000 sales)
    sales_data = []
    for i in range(1, 1001):
        product_id = random.randint(1, 150)
        sale_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        quantity = random.randint(1, 50)
        amount = round(random.uniform(10, 1000) * quantity, 2)
        sales_data.append((i, product_id, sale_date.date(), quantity, amount))
    
    conn.executemany(
        "INSERT INTO sales VALUES (?, ?, ?, ?, ?)",
        sales_data
    )
    
    conn.close()
    
    print("✅ Database setup complete for Day 06: HAVING Clause")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - employees: 200 rows")
    print(f"   - products: 150 rows")
    print(f"   - orders: 500 rows")
    print(f"   - order_items: 1200 rows")
    print(f"   - sales: 1000 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
