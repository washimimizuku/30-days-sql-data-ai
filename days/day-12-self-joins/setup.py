#!/usr/bin/env python3
"""Setup script for Day 12: Self Joins"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day12.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop tables
    tables = ['order_items', 'orders', 'customers', 'products', 'employees']
    for table in tables:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # Create employees table with manager_id for self-join
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            manager_id INTEGER,
            department_id INTEGER,
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
            cost DECIMAL(10, 2)
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
            total DECIMAL(10, 2)
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
    
    # Insert employees with hierarchical structure
    # CEO (id=1, no manager)
    # VPs (id=2-4, report to CEO)
    # Managers (id=5-10, report to VPs)
    # Staff (id=11-50, report to Managers)
    employees_data = [
        # CEO
        (1, 'Alice Johnson', None, 1, 250000, '2015-01-01'),
        
        # VPs reporting to CEO
        (2, 'Bob Smith', 1, 1, 180000, '2016-03-15'),
        (3, 'Carol White', 1, 2, 175000, '2016-06-01'),
        (4, 'David Brown', 1, 3, 170000, '2017-01-10'),
        
        # Managers reporting to VPs
        (5, 'Eve Davis', 2, 1, 120000, '2018-02-01'),
        (6, 'Frank Miller', 2, 1, 115000, '2018-05-15'),
        (7, 'Grace Wilson', 3, 2, 118000, '2018-08-01'),
        (8, 'Henry Moore', 3, 2, 112000, '2019-01-15'),
        (9, 'Ivy Taylor', 4, 3, 125000, '2019-03-01'),
        (10, 'Jack Anderson', 4, 3, 110000, '2019-06-01'),
    ]
    
    # Add staff members
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda']
    last_names = ['Garcia', 'Martinez', 'Rodriguez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson']
    
    for i in range(11, 51):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        manager_id = random.randint(5, 10)  # Report to managers
        department_id = random.randint(1, 3)
        salary = round(random.uniform(50000, 95000), 2)
        hire_date = datetime(2019, 1, 1) + timedelta(days=random.randint(0, 1825))
        employees_data.append((i, name, manager_id, department_id, salary, hire_date.date()))
    
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?)", employees_data)
    
    # Insert products
    categories = ['Electronics', 'Books', 'Clothing', 'Home', 'Sports']
    products_data = []
    for i in range(1, 41):
        product_name = f"Product {i}"
        category = random.choice(categories)
        cost = round(random.uniform(5, 200), 2)
        price = round(cost * random.uniform(1.3, 2.5), 2)  # 30-150% markup
        products_data.append((i, product_name, category, price, cost))
    
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?, ?)", products_data)
    
    # Insert customers
    cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia']
    states = ['NY', 'CA', 'IL', 'TX', 'AZ', 'PA']
    city_state_map = dict(zip(cities, states))
    
    customers_data = []
    for i in range(1, 31):
        customer_name = f"Customer {i}"
        city = random.choice(cities)
        state = city_state_map[city]
        reg_date = datetime(2021, 1, 1) + timedelta(days=random.randint(0, 1095))
        customers_data.append((i, customer_name, city, state, reg_date.date()))
    
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?, ?)", customers_data)
    
    # Insert orders (multiple per customer for sequence analysis)
    orders_data = []
    order_id = 1
    for customer_id in range(1, 31):
        num_orders = random.randint(2, 8)  # Each customer has 2-8 orders
        start_date = datetime(2023, 1, 1)
        
        for _ in range(num_orders):
            order_date = start_date + timedelta(days=random.randint(0, 700))
            total = round(random.uniform(20, 500), 2)
            orders_data.append((order_id, customer_id, order_date.date(), total))
            order_id += 1
            start_date = order_date  # Next order after this one
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?)", orders_data)
    
    # Insert order_items (for products bought together analysis)
    order_items_data = []
    item_id = 1
    for order_id in range(1, len(orders_data) + 1):
        num_items = random.randint(1, 4)  # 1-4 items per order
        products_in_order = random.sample(range(1, 41), num_items)
        
        for product_id in products_in_order:
            quantity = random.randint(1, 3)
            price = round(random.uniform(10, 300), 2)
            order_items_data.append((item_id, order_id, product_id, quantity, price))
            item_id += 1
    
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 12: Self Joins")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables:")
    print(f"   - employees: 50 rows (hierarchical: CEO → VPs → Managers → Staff)")
    print(f"   - products: 40 rows (5 categories)")
    print(f"   - customers: 30 rows (6 cities)")
    print(f"   - orders: ~150 rows (multiple per customer)")
    print(f"   - order_items: ~300 rows (products bought together)")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
