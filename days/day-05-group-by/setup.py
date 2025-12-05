#!/usr/bin/env python3
"""Setup script for Day 5: GROUP BY Basics"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day05.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS sales")
    conn.execute("DROP TABLE IF EXISTS order_items")
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            job_title VARCHAR,
            salary DECIMAL(10, 2),
            hire_date DATE,
            city VARCHAR,
            age INTEGER,
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
            quantity INTEGER,
            cost DECIMAL(10, 2)
        )
    """)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            customer_name VARCHAR,
            order_date DATE,
            total DECIMAL(10, 2),
            status VARCHAR
        )
    """)
    
    # Create sales table
    conn.execute("""
        CREATE TABLE sales (
            id INTEGER PRIMARY KEY,
            product_id INTEGER,
            product_name VARCHAR,
            sale_date DATE,
            quantity INTEGER,
            amount DECIMAL(10, 2),
            region VARCHAR
        )
    """)
    
    # Create order_items table
    conn.execute("""
        CREATE TABLE order_items (
            id INTEGER PRIMARY KEY,
            order_id INTEGER,
            product_id INTEGER,
            quantity INTEGER,
            price DECIMAL(10, 2),
            order_date DATE
        )
    """)
    
    # Generate employee data (150 employees)
    departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations', 'Support', 'Product']
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney', 'Toronto', 'Singapore']
    job_titles = {
        'Engineering': ['Junior Engineer', 'Software Engineer', 'Senior Engineer', 'Tech Lead', 'Engineering Manager'],
        'Sales': ['Sales Rep', 'Account Executive', 'Sales Manager', 'VP Sales'],
        'Marketing': ['Marketing Specialist', 'Content Manager', 'Marketing Manager', 'Marketing Director'],
        'HR': ['HR Specialist', 'Recruiter', 'HR Manager', 'HR Director'],
        'Finance': ['Financial Analyst', 'Accountant', 'Finance Manager', 'CFO'],
        'Operations': ['Operations Specialist', 'Operations Manager', 'VP Operations'],
        'Support': ['Support Specialist', 'Support Manager', 'Support Director'],
        'Product': ['Product Manager', 'Senior PM', 'VP Product']
    }
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
                   'William', 'Barbara', 'David', 'Elizabeth', 'Richard', 'Susan', 'Joseph', 'Jessica',
                   'Thomas', 'Sarah', 'Charles', 'Karen', 'Daniel', 'Nancy', 'Matthew', 'Lisa']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
                  'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Wilson', 'Anderson', 'Thomas']
    
    employees_data = []
    for i in range(1, 151):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        dept = random.choice(departments)
        job_title = random.choice(job_titles[dept])
        salary = round(random.uniform(40000, 180000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        city = random.choice(cities)
        age = random.randint(22, 65)
        is_active = random.random() > 0.1
        employees_data.append((i, name, dept, job_title, salary, hire_date.date(), city, age, is_active))
    
    conn.executemany(
        "INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        employees_data
    )
    
    # Generate product data (120 products)
    categories = ['Electronics', 'Books', 'Clothing', 'Home & Garden', 'Sports', 'Toys', 'Food', 'Beauty']
    products_data = []
    for i in range(1, 121):
        product_name = f"Product {i}"
        category = random.choice(categories)
        cost = round(random.uniform(5, 300), 2)
        price = round(cost * random.uniform(1.5, 3.0), 2)
        quantity = random.randint(0, 500)
        products_data.append((i, product_name, category, price, quantity, cost))
    
    conn.executemany(
        "INSERT INTO products VALUES (?, ?, ?, ?, ?, ?)",
        products_data
    )
    
    # Generate orders data (300 orders)
    statuses = ['Pending', 'Shipped', 'Delivered', 'Cancelled']
    orders_data = []
    for i in range(1, 301):
        customer_id = random.randint(1, 80)
        customer = f"Customer {customer_id}"
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        total = round(random.uniform(20.00, 3000.00), 2)
        status = random.choice(statuses)
        orders_data.append((i, customer_id, customer, order_date.date(), total, status))
    
    conn.executemany(
        "INSERT INTO orders VALUES (?, ?, ?, ?, ?, ?)",
        orders_data
    )
    
    # Generate sales data (600 sales)
    regions = ['North', 'South', 'East', 'West', 'Central']
    product_names_list = [f"Product {i}" for i in range(1, 121)]
    sales_data = []
    for i in range(1, 601):
        product_id = random.randint(1, 120)
        product_name = product_names_list[product_id - 1]
        sale_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        quantity = random.randint(1, 20)
        amount = round(random.uniform(10, 500) * quantity, 2)
        region = random.choice(regions)
        sales_data.append((i, product_id, product_name, sale_date.date(), quantity, amount, region))
    
    conn.executemany(
        "INSERT INTO sales VALUES (?, ?, ?, ?, ?, ?, ?)",
        sales_data
    )
    
    # Generate order_items data (800 items)
    order_items_data = []
    for i in range(1, 801):
        order_id = random.randint(1, 300)
        product_id = random.randint(1, 120)
        quantity = random.randint(1, 10)
        price = round(random.uniform(10, 500), 2)
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        order_items_data.append((i, order_id, product_id, quantity, price, order_date.date()))
    
    conn.executemany(
        "INSERT INTO order_items VALUES (?, ?, ?, ?, ?, ?)",
        order_items_data
    )
    
    conn.close()
    
    print("✅ Database setup complete for Day 05: GROUP BY Basics")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - employees: 150 rows")
    print(f"   - products: 120 rows")
    print(f"   - orders: 300 rows")
    print(f"   - sales: 600 rows")
    print(f"   - order_items: 800 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
