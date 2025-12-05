#!/usr/bin/env python3
"""Setup script for Day 13: Subqueries in WHERE"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day13.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop tables
    tables = ['order_items', 'orders', 'customers', 'products', 'employees', 'departments']
    for table in tables:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # Create departments table
    conn.execute("""
        CREATE TABLE departments (
            id INTEGER PRIMARY KEY,
            department_name VARCHAR,
            city VARCHAR,
            budget DECIMAL(12, 2)
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
            age INTEGER
        )
    """)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            city VARCHAR,
            state VARCHAR,
            registration_date DATE
        )
    """)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10, 2),
            cost DECIMAL(10, 2)
        )
    """)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            employee_id INTEGER,
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
    
    # Insert departments
    departments_data = [
        (1, 'Sales', 'New York', 500000),
        (2, 'Engineering', 'San Francisco', 800000),
        (3, 'Marketing', 'New York', 300000),
        (4, 'HR', 'Chicago', 200000),
        (5, 'Finance', 'New York', 400000),
        (6, 'Operations', 'Los Angeles', 350000)
    ]
    conn.executemany("INSERT INTO departments VALUES (?, ?, ?, ?)", departments_data)
    
    # Insert employees (some departments have no employees)
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis']
    employees_data = []
    for i in range(1, 51):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        department_id = random.randint(1, 5)  # Dept 6 has no employees
        salary = round(random.uniform(45000, 150000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        age = random.randint(25, 65)
        employees_data.append((i, name, department_id, salary, hire_date.date(), age))
    
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?)", employees_data)
    
    # Insert customers (some will have no orders)
    cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix']
    states = ['NY', 'CA', 'IL', 'TX', 'AZ']
    city_state_map = dict(zip(cities, states))
    
    customers_data = []
    for i in range(1, 41):
        customer_name = f"Customer {i}"
        city = random.choice(cities)
        state = city_state_map[city]
        reg_date = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 1460))
        customers_data.append((i, customer_name, city, state, reg_date.date()))
    
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?, ?)", customers_data)
    
    # Insert products (some will never be ordered)
    categories = ['Electronics', 'Books', 'Clothing', 'Home', 'Sports', 'Premium']
    products_data = []
    for i in range(1, 51):
        product_name = f"Product {i}"
        category = random.choice(categories)
        cost = round(random.uniform(10, 300), 2)
        price = round(cost * random.uniform(1.3, 2.5), 2)
        products_data.append((i, product_name, category, price, cost))
    
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?, ?)", products_data)
    
    # Insert orders (only for some customers and employees)
    orders_data = []
    order_id = 1
    for customer_id in range(1, 31):  # Only customers 1-30 have orders
        num_orders = random.randint(1, 5)
        for _ in range(num_orders):
            employee_id = random.randint(1, 40)  # Employees 41-50 have no orders
            order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
            total = round(random.uniform(50, 2000), 2)
            status = random.choice(['completed', 'pending', 'shipped'])
            orders_data.append((order_id, customer_id, employee_id, order_date.date(), total, status))
            order_id += 1
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?, ?)", orders_data)
    
    # Insert order_items (only for some products)
    order_items_data = []
    item_id = 1
    for order_id in range(1, len(orders_data) + 1):
        num_items = random.randint(1, 4)
        products_in_order = random.sample(range(1, 41), num_items)  # Products 41-50 never ordered
        
        for product_id in products_in_order:
            quantity = random.randint(1, 5)
            price = round(random.uniform(20, 500), 2)
            order_items_data.append((item_id, order_id, product_id, quantity, price))
            item_id += 1
    
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 13: Subqueries in WHERE")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables with data for subquery practice:")
    print(f"   - departments: 6 rows (dept 6 has no employees)")
    print(f"   - employees: 50 rows (employees 41-50 have no orders)")
    print(f"   - customers: 40 rows (customers 31-40 have no orders)")
    print(f"   - products: 50 rows (products 41-50 never ordered)")
    print(f"   - orders: ~100 rows")
    print(f"   - order_items: ~250 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
