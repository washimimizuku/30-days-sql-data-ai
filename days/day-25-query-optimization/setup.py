#!/usr/bin/env python3
"""Setup script for Day 25: Query Optimization"""

import duckdb
from pathlib import Path
import random
from datetime import datetime, timedelta

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day25.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Remove existing database
    if db_path.exists():
        db_path.unlink()
    
    conn = duckdb.connect(str(db_path))
    
    print("Creating tables...")
    
    # Customers table (10,000 rows)
    conn.execute("""
        CREATE TABLE customers (
            id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            email VARCHAR,
            city VARCHAR,
            state VARCHAR
        )
    """)
    
    # Orders table (100,000 rows)
    conn.execute("""
        CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            status VARCHAR,
            total DECIMAL(10,2)
        )
    """)
    
    # Products table (1,000 rows)
    conn.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            price DECIMAL(10,2),
            cost DECIMAL(10,2)
        )
    """)
    
    # Order items table (300,000 rows)
    conn.execute("""
        CREATE TABLE order_items (
            id INTEGER PRIMARY KEY,
            order_id INTEGER,
            product_id INTEGER,
            quantity INTEGER,
            price DECIMAL(10,2)
        )
    """)
    
    print("Inserting customers (10,000 rows)...")
    cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 
              'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose',
              'Austin', 'Jacksonville', 'Fort Worth', 'Columbus', 'Charlotte',
              'Seattle', 'Denver', 'Boston', 'Portland', 'Miami']
    states = ['NY', 'CA', 'IL', 'TX', 'AZ', 'PA', 'TX', 'CA', 'TX', 'CA',
              'TX', 'FL', 'TX', 'OH', 'NC', 'WA', 'CO', 'MA', 'OR', 'FL']
    
    customers_data = []
    for i in range(1, 10001):
        city_idx = random.randint(0, len(cities) - 1)
        customers_data.append((
            i,
            f'Customer_{i}',
            f'customer{i}@example.com',
            cities[city_idx],
            states[city_idx]
        ))
    
    conn.executemany(
        "INSERT INTO customers VALUES (?, ?, ?, ?, ?)",
        customers_data
    )
    
    print("Inserting products (1,000 rows)...")
    categories = ['Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports',
                  'Toys', 'Food', 'Beauty', 'Automotive', 'Office']
    
    products_data = []
    for i in range(1, 1001):
        price = round(random.uniform(10, 1000), 2)
        cost = round(price * random.uniform(0.4, 0.7), 2)
        products_data.append((
            i,
            f'Product_{i}',
            random.choice(categories),
            price,
            cost
        ))
    
    conn.executemany(
        "INSERT INTO products VALUES (?, ?, ?, ?, ?)",
        products_data
    )
    
    print("Inserting orders (100,000 rows)...")
    statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled']
    
    # Insert in batches
    batch_size = 10000
    for batch in range(10):
        orders_data = []
        for i in range(batch * batch_size + 1, (batch + 1) * batch_size + 1):
            order_date = datetime(2023, 1, 1) + timedelta(days=random.randint(0, 730))
            orders_data.append((
                i,
                random.randint(1, 10000),
                order_date.strftime('%Y-%m-%d'),
                random.choice(statuses),
                round(random.uniform(20, 2000), 2)
            ))
        
        conn.executemany(
            "INSERT INTO orders VALUES (?, ?, ?, ?, ?)",
            orders_data
        )
        print(f"  Inserted {(batch + 1) * batch_size} orders...")
    
    print("Inserting order items (300,000 rows)...")
    # Insert in batches
    batch_size = 30000
    for batch in range(10):
        order_items_data = []
        for i in range(batch * batch_size + 1, (batch + 1) * batch_size + 1):
            order_id = random.randint(1, 100000)
            product_id = random.randint(1, 1000)
            quantity = random.randint(1, 5)
            price = round(random.uniform(10, 1000), 2)
            
            order_items_data.append((
                i,
                order_id,
                product_id,
                quantity,
                price
            ))
        
        conn.executemany(
            "INSERT INTO order_items VALUES (?, ?, ?, ?, ?)",
            order_items_data
        )
        print(f"  Inserted {(batch + 1) * batch_size} order items...")
    
    # Get table sizes
    customers_count = conn.execute("SELECT COUNT(*) FROM customers").fetchone()[0]
    orders_count = conn.execute("SELECT COUNT(*) FROM orders").fetchone()[0]
    products_count = conn.execute("SELECT COUNT(*) FROM products").fetchone()[0]
    order_items_count = conn.execute("SELECT COUNT(*) FROM order_items").fetchone()[0]
    
    conn.close()
    
    print("\n✅ Database setup complete for Day 25")
    print(f"\n📁 Database location: {db_path}")
    print(f"\n📊 Table sizes:")
    print(f"   - customers: {customers_count:,} rows")
    print(f"   - orders: {orders_count:,} rows")
    print(f"   - products: {products_count:,} rows")
    print(f"   - order_items: {order_items_count:,} rows")
    print(f"\n💡 This database is designed for query optimization practice")
    print(f"   Use EXPLAIN and EXPLAIN ANALYZE to compare query performance")

if __name__ == "__main__":
    setup()
