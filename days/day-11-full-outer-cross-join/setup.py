#!/usr/bin/env python3
"""Setup script for Day 11: FULL OUTER JOIN and CROSS JOIN"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day11.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop tables
    tables = ['order_items', 'orders', 'customers', 'products', 'categories', 
              'employees', 'departments', 'sizes', 'colors', 'system1_users', 'system2_users']
    for table in tables:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # Create departments table
    conn.execute("""
        CREATE TABLE departments (
            id INTEGER PRIMARY KEY,
            department_name VARCHAR,
            location VARCHAR,
            budget DECIMAL(12, 2)
        )
    """)
    
    # Create employees table (some without departments)
    conn.execute("""
        CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name VARCHAR,
            department_id INTEGER,
            salary DECIMAL(10, 2),
            hire_date DATE
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
    
    # Create products table (some without valid categories)
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category_id INTEGER,
            price DECIMAL(10, 2),
            product_code VARCHAR
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
    
    # Create orders table (some with invalid customer_ids)
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
    
    # Create sizes table for CROSS JOIN
    conn.execute("""
        CREATE TABLE sizes (
            id INTEGER PRIMARY KEY,
            size_name VARCHAR,
            size_code VARCHAR
        )
    """)
    
    # Create colors table for CROSS JOIN
    conn.execute("""
        CREATE TABLE colors (
            id INTEGER PRIMARY KEY,
            color_name VARCHAR,
            color_code VARCHAR
        )
    """)
    
    # Create system1_users for reconciliation
    conn.execute("""
        CREATE TABLE system1_users (
            user_id INTEGER PRIMARY KEY,
            username VARCHAR,
            email VARCHAR,
            last_login DATE
        )
    """)
    
    # Create system2_users for reconciliation
    conn.execute("""
        CREATE TABLE system2_users (
            user_id INTEGER PRIMARY KEY,
            username VARCHAR,
            email VARCHAR,
            status VARCHAR
        )
    """)
    
    # Insert departments (6 departments)
    departments_data = [
        (1, 'Engineering', 'New York', 500000),
        (2, 'Sales', 'London', 300000),
        (3, 'Marketing', 'Tokyo', 200000),
        (4, 'HR', 'Paris', 150000),
        (5, 'Finance', 'Berlin', 250000),
        (6, 'Operations', 'Sydney', 180000)
    ]
    conn.executemany("INSERT INTO departments VALUES (?, ?, ?, ?)", departments_data)
    
    # Insert employees (50 employees, some without departments)
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 
                   'William', 'Barbara', 'David', 'Elizabeth', 'Richard', 'Susan']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis']
    employees_data = []
    for i in range(1, 51):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        # 10% of employees have no department, 5% have invalid department_id
        if random.random() < 0.10:
            dept_id = None
        elif random.random() < 0.05:
            dept_id = 99  # Invalid department
        else:
            dept_id = random.randint(1, 5)  # Note: dept 6 will have no employees
        salary = round(random.uniform(45000, 120000), 2)
        hire_date = datetime(2019, 1, 1) + timedelta(days=random.randint(0, 1825))
        employees_data.append((i, name, dept_id, salary, hire_date.date()))
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?)", employees_data)
    
    # Insert categories (5 categories)
    categories_data = [
        (1, 'Electronics', 'Electronic devices and accessories'),
        (2, 'Books', 'Physical and digital books'),
        (3, 'Clothing', 'Apparel and fashion items'),
        (4, 'Home & Garden', 'Home improvement and garden supplies'),
        (5, 'Sports', 'Sports equipment and accessories')
    ]
    conn.executemany("INSERT INTO categories VALUES (?, ?, ?)", categories_data)
    
    # Insert products (40 products, some without valid categories)
    products_data = []
    for i in range(1, 41):
        product_name = f"Product {i}"
        # 10% of products have no category, 5% have invalid category_id
        if random.random() < 0.10:
            category_id = None
        elif random.random() < 0.05:
            category_id = 99  # Invalid category
        else:
            category_id = random.randint(1, 4)  # Note: category 5 will have no products
        price = round(random.uniform(10, 500), 2)
        product_code = f"PROD{i:03d}"
        products_data.append((i, product_name, category_id, price, product_code))
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?, ?)", products_data)
    
    # Insert customers (30 customers)
    customers_data = []
    for i in range(1, 31):
        customer_name = f"Customer {i}"
        email = f"customer{i}@email.com"
        city = random.choice(['New York', 'London', 'Tokyo', 'Paris', 'Berlin'])
        customers_data.append((i, customer_name, email, city))
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?)", customers_data)
    
    # Insert orders (60 orders, some with invalid customer_ids)
    orders_data = []
    for i in range(1, 61):
        # 10% of orders have invalid customer_id
        if random.random() < 0.10:
            customer_id = 999  # Invalid customer
        else:
            customer_id = random.randint(1, 25)  # Note: customers 26-30 have no orders
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 700))
        total = round(random.uniform(20, 1000), 2)
        status = random.choice(['completed', 'pending', 'shipped'])
        orders_data.append((i, customer_id, order_date.date(), total, status))
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    # Insert order_items (120 items)
    order_items_data = []
    for i in range(1, 121):
        order_id = random.randint(1, 60)
        product_id = random.randint(1, 35)  # Products 36-40 never ordered
        quantity = random.randint(1, 5)
        price = round(random.uniform(10, 500), 2)
        order_items_data.append((i, order_id, product_id, quantity, price))
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    # Insert sizes for CROSS JOIN
    sizes_data = [
        (1, 'Small', 'S'),
        (2, 'Medium', 'M'),
        (3, 'Large', 'L'),
        (4, 'X-Large', 'XL')
    ]
    conn.executemany("INSERT INTO sizes VALUES (?, ?, ?)", sizes_data)
    
    # Insert colors for CROSS JOIN
    colors_data = [
        (1, 'Red', 'RED'),
        (2, 'Blue', 'BLU'),
        (3, 'Green', 'GRN'),
        (4, 'Black', 'BLK'),
        (5, 'White', 'WHT')
    ]
    conn.executemany("INSERT INTO colors VALUES (?, ?, ?)", colors_data)
    
    # Insert system1_users (25 users)
    system1_data = []
    for i in range(1, 26):
        username = f"user{i}"
        email = f"user{i}@system1.com"
        last_login = datetime(2024, 1, 1) + timedelta(days=random.randint(0, 300))
        system1_data.append((i, username, email, last_login.date()))
    conn.executemany("INSERT INTO system1_users VALUES (?, ?, ?, ?)", system1_data)
    
    # Insert system2_users (25 users, with some overlap and some unique)
    system2_data = []
    # Users 1-20 exist in both systems
    for i in range(1, 21):
        username = f"user{i}"
        email = f"user{i}@system2.com"
        status = random.choice(['active', 'inactive'])
        system2_data.append((i, username, email, status))
    # Users 21-30 only in system2
    for i in range(21, 31):
        username = f"user{i}"
        email = f"user{i}@system2.com"
        status = random.choice(['active', 'inactive'])
        system2_data.append((i, username, email, status))
    conn.executemany("INSERT INTO system2_users VALUES (?, ?, ?, ?)", system2_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 11: FULL OUTER JOIN and CROSS JOIN")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created tables with intentional gaps for practice:")
    print(f"   - departments: 6 rows (dept 6 has no employees)")
    print(f"   - employees: 50 rows (some without departments)")
    print(f"   - categories: 5 rows (category 5 has no products)")
    print(f"   - products: 40 rows (some without valid categories)")
    print(f"   - customers: 30 rows (customers 26-30 have no orders)")
    print(f"   - orders: 60 rows (some with invalid customer_ids)")
    print(f"   - order_items: 120 rows")
    print(f"   - sizes: 4 rows (for CROSS JOIN)")
    print(f"   - colors: 5 rows (for CROSS JOIN)")
    print(f"   - system1_users: 25 rows (users 1-25)")
    print(f"   - system2_users: 25 rows (users 1-20 overlap, 21-30 unique)")
    print(f"\n💡 Start with: duckdb {db_path}")

if __name__ == "__main__":
    setup()
