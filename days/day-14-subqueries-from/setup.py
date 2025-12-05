#!/usr/bin/env python3
"""Setup script for Day 14: Subqueries in FROM"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day14.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop tables
    tables = ['order_items', 'orders', 'customers', 'products', 'employees']
    for table in tables:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department VARCHAR,
            salary DECIMAL(10, 2),
            hire_date DATE
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
            stock INTEGER
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
    
    # Insert employees
    departments = ['Sales', 'Engineering', 'Marketing', 'HR', 'Finance']
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis']
    
    employees_data = []
    for i in range(1, 51):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        department = random.choice(departments)
        salary = round(random.uniform(45000, 150000), 2)
        hire_date = datetime(2018, 1, 1) + timedelta(days=random.randint(0, 2190))
        employees_data.append((i, name, department, salary, hire_date.date()))
    
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?)", employees_data)
    
    # Insert products
    categories = ['Electronics', 'Books', 'Clothing', 'Home', 'Sports']
    products_data = []
    for i in range(1, 51):
        product_name = f"Product {i}"
        category = random.choice(categories)
        cost = round(random.uniform(10, 300), 2)
        price = round(cost * random.uniform(1.3, 2.5), 2)
        stock = random.randint(0, 200)
        products_data.append((i, product_name, category, price, cost, stock))
    
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?, ?, ?)", products_data)
    
    # Insert customers
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
    
    # Insert orders (spanning multiple months for time series analysis)
    orders_data = []
    order_id = 1
    for customer_id in range(1, 41):
        num_orders = random.randint(2, 8)
        for _ in range(num_orders):
            order_date = datetime(2024, 1, 1) + timedelta(days=random.randint(0, 365))
            total = round(random.uniform(50, 2000), 2)
            status = random.choice(['completed', 'pending', 'shipped', 'cancelled'])
            orders_data.append((order_id, customer_id, order_date.date(), total, status))
            order_id += 1
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    # Insert order_items
    order_items_data = []
    item_id = 1
    for order_id in range(1, len(orders_data) + 1):
        num_items = random.randint(1, 5)
        products_in_order = random.sample(range(1, 51), num_items)
        
        for product_id in products_in_order:
            quantity = random.randint(1, 5)
            price = round(random.uniform(20, 500), 2)
            order_items_data.append((item_id, order_id, product_id, quantity, price))
            item_id += 1
    
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 14: Subqueries in FROM")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables for derived table practice:")
    print(f"   - employees: 50 rows (5 departments)")
    print(f"   - products: 50 rows (5 categories)")
    print(f"   - customers: 40 rows (5 cities)")
    print(f"   - orders: ~200 rows (spanning 2024)")
    print(f"   - order_items: ~600 rows")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
