#!/usr/bin/env python3
"""Setup script for Day 3: ORDER BY and LIMIT"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day03.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS customers")
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            position VARCHAR,
            salary DECIMAL(10, 2),
            hire_date DATE,
            city VARCHAR,
            email VARCHAR
        )
    """)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10, 2),
            stock_quantity INTEGER,
            rating DECIMAL(3, 2),
            release_date DATE
        )
    """)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            order_date DATE,
            total DECIMAL(10, 2),
            status VARCHAR,
            items_count INTEGER
        )
    """)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            first_name VARCHAR,
            last_name VARCHAR,
            email VARCHAR,
            city VARCHAR,
            total_purchases DECIMAL(10, 2),
            join_date DATE
        )
    """)
    
    # Generate employee data (100 employees)
    departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations', 'Support']
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney', 'Toronto', 'Singapore']
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
                   'William', 'Barbara', 'David', 'Elizabeth', 'Richard', 'Susan', 'Joseph', 'Jessica',
                   'Thomas', 'Sarah', 'Charles', 'Karen', 'Daniel', 'Nancy', 'Matthew', 'Lisa',
                   'Anthony', 'Betty', 'Mark', 'Margaret', 'Donald', 'Sandra', 'Steven', 'Ashley']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
                  'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
                  'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Thompson', 'White']
    
    employees_data = []
    for i in range(1, 101):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        dept = random.choice(departments)
        positions = {
            'Engineering': ['Software Engineer', 'Senior Engineer', 'Tech Lead', 'Engineering Manager'],
            'Sales': ['Sales Rep', 'Account Executive', 'Sales Manager', 'VP Sales'],
            'Marketing': ['Marketing Specialist', 'Content Manager', 'Marketing Director'],
            'HR': ['HR Specialist', 'Recruiter', 'HR Manager'],
            'Finance': ['Financial Analyst', 'Accountant', 'Finance Manager'],
            'Operations': ['Operations Specialist', 'Operations Manager'],
            'Support': ['Support Specialist', 'Support Manager']
        }
        position = random.choice(positions[dept])
        salary = round(random.uniform(45000, 150000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        city = random.choice(cities)
        email = f"{name.lower().replace(' ', '.')}@company.com"
        employees_data.append((i, name, dept, position, salary, hire_date.date(), city, email))
    
    conn.executemany(
        "INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        employees_data
    )
    
    # Generate product data (80 products)
    categories = ['Electronics', 'Books', 'Clothing', 'Home & Garden', 'Sports', 'Toys']
    product_names = {
        'Electronics': ['Laptop Pro', 'Wireless Mouse', 'USB-C Hub', 'Monitor 27"', 'Keyboard Mechanical',
                       'Webcam HD', 'Headphones Noise-Canceling', 'Tablet 10"', 'Smart Watch', 'Phone Charger'],
        'Books': ['Python Programming', 'Data Science Handbook', 'SQL Mastery', 'Machine Learning Guide',
                 'Web Development', 'Cloud Computing', 'DevOps Essentials', 'AI Fundamentals'],
        'Clothing': ['T-Shirt Cotton', 'Jeans Classic', 'Hoodie Warm', 'Sneakers Running', 'Jacket Winter',
                    'Dress Summer', 'Shorts Athletic', 'Socks Pack'],
        'Home & Garden': ['Coffee Maker', 'Blender Pro', 'Vacuum Cleaner', 'Plant Pot Set', 'LED Lamp',
                         'Storage Boxes', 'Kitchen Knife Set', 'Towel Set'],
        'Sports': ['Yoga Mat', 'Dumbbells Set', 'Resistance Bands', 'Jump Rope', 'Water Bottle',
                  'Gym Bag', 'Running Shoes', 'Fitness Tracker'],
        'Toys': ['Building Blocks', 'Puzzle 1000pc', 'Board Game', 'Action Figure', 'Doll House',
                'RC Car', 'Art Set', 'Science Kit']
    }
    
    products_data = []
    pid = 1
    for category in categories:
        for pname in product_names[category]:
            price = round(random.uniform(9.99, 999.99), 2)
            stock = random.randint(0, 500)
            rating = round(random.uniform(3.0, 5.0), 2)
            release_date = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 1460))
            products_data.append((pid, pname, category, price, stock, rating, release_date.date()))
            pid += 1
            if pid > 80:
                break
        if pid > 80:
            break
    
    conn.executemany(
        "INSERT INTO products VALUES (?, ?, ?, ?, ?, ?, ?)",
        products_data
    )
    
    # Generate orders data (150 orders)
    statuses = ['Pending', 'Shipped', 'Delivered', 'Cancelled']
    orders_data = []
    for i in range(1, 151):
        customer = f"{random.choice(first_names)} {random.choice(last_names)}"
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        total = round(random.uniform(15.00, 2500.00), 2)
        status = random.choice(statuses)
        items = random.randint(1, 10)
        orders_data.append((i, customer, order_date.date(), total, status, items))
    
    conn.executemany(
        "INSERT INTO orders VALUES (?, ?, ?, ?, ?, ?)",
        orders_data
    )
    
    # Generate customers data (60 customers)
    customers_data = []
    for i in range(1, 61):
        fname = random.choice(first_names)
        lname = random.choice(last_names)
        email = f"{fname.lower()}.{lname.lower()}@email.com"
        city = random.choice(cities)
        total_purchases = round(random.uniform(100.00, 50000.00), 2)
        join_date = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 1460))
        customers_data.append((i, fname, lname, email, city, total_purchases, join_date.date()))
    
    conn.executemany(
        "INSERT INTO customers VALUES (?, ?, ?, ?, ?, ?, ?)",
        customers_data
    )
    
    conn.close()
    
    print("✅ Database setup complete for Day 03: ORDER BY and LIMIT")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - employees: 100 rows")
    print(f"   - products: 80 rows")
    print(f"   - orders: 150 rows")
    print(f"   - customers: 60 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
