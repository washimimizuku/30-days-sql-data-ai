#!/usr/bin/env python3
"""Setup script for Day 10: Mini Project - Sales Analysis"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day10.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop tables
    for table in ['order_items', 'orders', 'products', 'categories', 'customers']:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # Create tables
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            email VARCHAR,
            city VARCHAR,
            state VARCHAR,
            registration_date DATE
        )
    """)
    
    conn.execute("""
        CREATE TABLE categories (
            id INTEGER PRIMARY KEY,
            category_name VARCHAR,
            description VARCHAR
        )
    """)
    
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category_id INTEGER,
            price DECIMAL(10, 2),
            cost DECIMAL(10, 2),
            stock INTEGER
        )
    """)
    
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            status VARCHAR,
            total DECIMAL(10, 2)
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
    
    # Insert categories
    categories_data = [
        (1, 'Laptops', 'Portable computers'),
        (2, 'Smartphones', 'Mobile phones'),
        (3, 'Tablets', 'Tablet computers'),
        (4, 'Accessories', 'Computer accessories'),
        (5, 'Audio', 'Headphones and speakers')
    ]
    conn.executemany("INSERT INTO categories VALUES (?, ?, ?)", categories_data)
    
    # Insert products
    products_data = []
    product_names = {
        1: ['MacBook Pro', 'Dell XPS', 'HP Spectre', 'Lenovo ThinkPad', 'ASUS ZenBook', 'Surface Laptop', 'Acer Swift', 'MSI Prestige', 'Razer Blade', 'LG Gram'],
        2: ['iPhone 14', 'Samsung Galaxy S23', 'Google Pixel 7', 'OnePlus 11', 'Xiaomi 13', 'Sony Xperia', 'Motorola Edge', 'Nokia G50', 'Oppo Find', 'Realme GT'],
        3: ['iPad Pro', 'Samsung Tab S8', 'Surface Pro', 'Lenovo Tab', 'Amazon Fire', 'Huawei MatePad', 'Xiaomi Pad', 'OnePlus Pad', 'Nokia T20', 'Realme Pad'],
        4: ['Wireless Mouse', 'Keyboard', 'USB-C Hub', 'Laptop Stand', 'Webcam', 'Monitor', 'Docking Station', 'Cable Set', 'Laptop Bag', 'Screen Protector'],
        5: ['AirPods Pro', 'Sony WH-1000XM5', 'Bose QC45', 'JBL Flip', 'Beats Studio', 'Sennheiser', 'Audio-Technica', 'Jabra Elite', 'Anker Soundcore', 'Marshall']
    }
    
    pid = 1
    for cat_id, names in product_names.items():
        for name in names:
            if cat_id == 1:  # Laptops
                cost = round(random.uniform(600, 1200), 2)
                price = round(cost * random.uniform(1.3, 1.6), 2)
            elif cat_id in [2, 3]:  # Phones, Tablets
                cost = round(random.uniform(300, 800), 2)
                price = round(cost * random.uniform(1.4, 1.7), 2)
            elif cat_id == 4:  # Accessories
                cost = round(random.uniform(10, 100), 2)
                price = round(cost * random.uniform(1.5, 2.5), 2)
            else:  # Audio
                cost = round(random.uniform(50, 300), 2)
                price = round(cost * random.uniform(1.4, 2.0), 2)
            
            stock = random.randint(0, 50)
            products_data.append((pid, name, cat_id, price, cost, stock))
            pid += 1
    
    conn.executemany("INSERT INTO products VALUES (?, ?, ?, ?, ?, ?)", products_data)
    
    # Insert customers
    cities_states = [
        ('New York', 'NY'), ('Los Angeles', 'CA'), ('Chicago', 'IL'), ('Houston', 'TX'),
        ('Phoenix', 'AZ'), ('Philadelphia', 'PA'), ('San Antonio', 'TX'), ('San Diego', 'CA'),
        ('Dallas', 'TX'), ('San Jose', 'CA')
    ]
    
    customers_data = []
    for i in range(1, 101):
        customer_name = f"Customer {i}"
        email = f"customer{i}@email.com"
        city, state = random.choice(cities_states)
        reg_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 365))
        customers_data.append((i, customer_name, email, city, state, reg_date.date()))
    
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?, ?, ?)", customers_data)
    
    # Insert orders (500 orders over 12 months)
    statuses = ['completed', 'pending', 'cancelled']
    status_weights = [0.85, 0.10, 0.05]  # 85% completed, 10% pending, 5% cancelled
    
    orders_data = []
    for i in range(1, 501):
        customer_id = random.randint(1, 100)
        order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 365))
        status = random.choices(statuses, weights=status_weights)[0]
        total = 0  # Will calculate from items
        orders_data.append((i, customer_id, order_date.date(), status, total))
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    # Insert order_items (1500 items, 3 per order average)
    order_items_data = []
    item_id = 1
    
    for order_id in range(1, 501):
        num_items = random.randint(1, 6)
        order_total = 0
        
        for _ in range(num_items):
            product_id = random.randint(1, 50)
            quantity = random.randint(1, 3)
            
            # Get product price
            result = conn.execute("SELECT price FROM products WHERE id = ?", [product_id]).fetchone()
            price = float(result[0]) if result else 100.0
            
            order_total += price * quantity
            order_items_data.append((item_id, order_id, product_id, quantity, price))
            item_id += 1
        
        # Update order total
        conn.execute("UPDATE orders SET total = ? WHERE id = ?", [round(order_total, 2), order_id])
    
    conn.executemany("INSERT INTO order_items VALUES (?, ?, ?, ?, ?)", order_items_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 10: Mini Project - Sales Analysis")
    print(f"📁 Database location: {db_path}")
    print(f"\n📊 Created realistic sales database:")
    print(f"   - customers: 100 rows (across 10 cities)")
    print(f"   - categories: 5 rows")
    print(f"   - products: 50 rows (10 per category)")
    print(f"   - orders: 500 rows (12 months of data)")
    print(f"   - order_items: ~1500 rows")
    print(f"\n💡 Start with: duckdb {db_path}")
    print(f"\n🎯 Complete 20 business questions in exercise.sql")

if __name__ == "__main__":
    setup()
