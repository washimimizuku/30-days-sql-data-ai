#!/usr/bin/env python3
"""Setup script for Day 4: Aggregate Functions"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day04.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS transactions")
    conn.execute("DROP TABLE IF EXISTS sales")
    
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
            email VARCHAR,
            age INTEGER
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
            status VARCHAR,
            items_count INTEGER
        )
    """)
    
    # Create transactions table
    conn.execute("""
        CREATE TABLE transactions (
            id INTEGER PRIMARY KEY,
            transaction_date DATE,
            amount DECIMAL(10, 2),
            type VARCHAR,
            customer_id INTEGER
        )
    """)
    
    # Create sales table
    conn.execute("""
        CREATE TABLE sales (
            id INTEGER PRIMARY KEY,
            sale_date DATE,
            product_id INTEGER,
            quantity INTEGER,
            unit_price DECIMAL(10, 2),
            total_amount DECIMAL(10, 2),
            region VARCHAR
        )
    """)
    
    # Generate employee data (120 employees)
    departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations', 'Support', 'Product']
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney', 'Toronto', 'Singapore', 'Mumbai', 'Dublin']
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
                   'William', 'Barbara', 'David', 'Elizabeth', 'Richard', 'Susan', 'Joseph', 'Jessica',
                   'Thomas', 'Sarah', 'Charles', 'Karen', 'Daniel', 'Nancy', 'Matthew', 'Lisa',
                   'Anthony', 'Betty', 'Mark', 'Margaret', 'Donald', 'Sandra', 'Steven', 'Ashley',
                   'Paul', 'Kimberly', 'Andrew', 'Emily', 'Joshua', 'Donna', 'Kenneth', 'Michelle']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
                  'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
                  'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Thompson', 'White', 'Harris']
    
    employees_data = []
    for i in range(1, 121):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        dept = random.choice(departments)
        positions = {
            'Engineering': ['Software Engineer', 'Senior Engineer', 'Tech Lead', 'Engineering Manager'],
            'Sales': ['Sales Rep', 'Account Executive', 'Sales Manager', 'VP Sales'],
            'Marketing': ['Marketing Specialist', 'Content Manager', 'Marketing Director', 'CMO'],
            'HR': ['HR Specialist', 'Recruiter', 'HR Manager', 'HR Director'],
            'Finance': ['Financial Analyst', 'Accountant', 'Finance Manager', 'CFO'],
            'Operations': ['Operations Specialist', 'Operations Manager', 'VP Operations'],
            'Support': ['Support Specialist', 'Support Manager', 'Support Director'],
            'Product': ['Product Manager', 'Senior PM', 'VP Product']
        }
        position = random.choice(positions[dept])
        salary = round(random.uniform(40000, 180000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        city = random.choice(cities)
        email = f"{name.lower().replace(' ', '.')}@company.com" if random.random() > 0.1 else None
        age = random.randint(22, 65)
        employees_data.append((i, name, dept, position, salary, hire_date.date(), city, email, age))
    
    conn.executemany(
        "INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        employees_data
    )
    
    # Generate product data (100 products)
    categories = ['Electronics', 'Books', 'Clothing', 'Home & Garden', 'Sports', 'Toys', 'Food', 'Beauty']
    products_data = []
    for i in range(1, 101):
        product_name = f"Product {i}"
        category = random.choice(categories)
        cost = round(random.uniform(5, 500), 2)
        price = round(cost * random.uniform(1.3, 2.5), 2)
        stock = random.randint(0, 1000)
        products_data.append((i, product_name, category, price, stock, cost))
    
    conn.executemany(
        "INSERT INTO products VALUES (?, ?, ?, ?, ?, ?)",
        products_data
    )
    
    # Generate orders data (200 orders)
    statuses = ['Pending', 'Shipped', 'Delivered', 'Cancelled']
    orders_data = []
    for i in range(1, 201):
        customer_id = random.randint(1, 50)
        customer = f"Customer {customer_id}"
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        total = round(random.uniform(10.00, 5000.00), 2)
        status = random.choice(statuses)
        items = random.randint(1, 15)
        orders_data.append((i, customer_id, customer, order_date.date(), total, status, items))
    
    conn.executemany(
        "INSERT INTO orders VALUES (?, ?, ?, ?, ?, ?, ?)",
        orders_data
    )
    
    # Generate transactions data (300 transactions)
    transaction_types = ['purchase', 'refund', 'payment', 'adjustment']
    transactions_data = []
    for i in range(1, 301):
        trans_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        amount = round(random.uniform(5.00, 2000.00), 2)
        trans_type = random.choice(transaction_types)
        customer_id = random.randint(1, 50)
        transactions_data.append((i, trans_date.date(), amount, trans_type, customer_id))
    
    conn.executemany(
        "INSERT INTO transactions VALUES (?, ?, ?, ?, ?)",
        transactions_data
    )
    
    # Generate sales data (500 sales)
    regions = ['North', 'South', 'East', 'West', 'Central']
    sales_data = []
    for i in range(1, 501):
        sale_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        product_id = random.randint(1, 100)
        quantity = random.randint(1, 50)
        unit_price = round(random.uniform(10, 500), 2)
        total = round(quantity * unit_price, 2)
        region = random.choice(regions)
        sales_data.append((i, sale_date.date(), product_id, quantity, unit_price, total, region))
    
    conn.executemany(
        "INSERT INTO sales VALUES (?, ?, ?, ?, ?, ?, ?)",
        sales_data
    )
    
    conn.close()
    
    print("✅ Database setup complete for Day 04: Aggregate Functions")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - employees: 120 rows")
    print(f"   - products: 100 rows")
    print(f"   - orders: 200 rows")
    print(f"   - transactions: 300 rows")
    print(f"   - sales: 500 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
