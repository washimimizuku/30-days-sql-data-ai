#!/usr/bin/env python3
"""Setup script for Day 17: Window Functions - LAG, LEAD, Moving Averages"""

import duckdb
from datetime import date, timedelta
from pathlib import Path
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day17.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS daily_sales")
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS customers")
    conn.execute("DROP TABLE IF EXISTS stock_prices")
    
    # Create daily_sales table
    conn.execute("""
        CREATE TABLE daily_sales (
            date DATE PRIMARY KEY,
            total DECIMAL(10, 2),
            orders_count INTEGER
        )
    """)
    
    # Generate 90 days of sales data with trends
    base_date = date(2024, 1, 1)
    sales_data = []
    base_amount = 5000
    
    for i in range(90):
        current_date = base_date + timedelta(days=i)
        # Add trend and randomness
        trend = i * 20  # Upward trend
        noise = random.uniform(-500, 500)
        total = base_amount + trend + noise
        orders = random.randint(20, 50)
        sales_data.append((current_date, round(total, 2), orders))
    
    conn.executemany("INSERT INTO daily_sales VALUES (?, ?, ?)", sales_data)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            customer_id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            registration_date DATE
        )
    """)
    
    conn.execute("""
        INSERT INTO customers VALUES
        (1, 'Alice Johnson', '2023-06-15'),
        (2, 'Bob Smith', '2023-08-20'),
        (3, 'Charlie Brown', '2023-09-10'),
        (4, 'Diana Prince', '2023-10-05'),
        (5, 'Eve Davis', '2023-11-12')
    """)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            order_id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            total DECIMAL(10, 2),
            status VARCHAR
        )
    """)
    
    # Generate orders for customers with varying patterns
    orders_data = []
    order_id = 1
    
    # Customer 1: Regular orders, increasing values
    for i in range(8):
        order_date = date(2024, 1, 1) + timedelta(days=i*10)
        total = 100 + i * 20 + random.uniform(-10, 10)
        orders_data.append((order_id, 1, order_date, round(total, 2), 'completed'))
        order_id += 1
    
    # Customer 2: Irregular orders
    for days in [5, 18, 35, 60, 75]:
        order_date = date(2024, 1, 1) + timedelta(days=days)
        total = random.uniform(150, 300)
        orders_data.append((order_id, 2, order_date, round(total, 2), 'completed'))
        order_id += 1
    
    # Customer 3: Decreasing order values
    for i in range(6):
        order_date = date(2024, 1, 1) + timedelta(days=i*12)
        total = 200 - i * 15 + random.uniform(-5, 5)
        orders_data.append((order_id, 3, order_date, round(total, 2), 'completed'))
        order_id += 1
    
    # Customer 4: Stable orders
    for i in range(7):
        order_date = date(2024, 1, 1) + timedelta(days=i*11)
        total = 120 + random.uniform(-10, 10)
        orders_data.append((order_id, 4, order_date, round(total, 2), 'completed'))
        order_id += 1
    
    # Customer 5: Few orders, long gaps
    for days in [10, 45, 85]:
        order_date = date(2024, 1, 1) + timedelta(days=days)
        total = random.uniform(80, 150)
        orders_data.append((order_id, 5, order_date, round(total, 2), 'completed'))
        order_id += 1
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?)", orders_data)
    
    # Create stock_prices table
    conn.execute("""
        CREATE TABLE stock_prices (
            date DATE,
            symbol VARCHAR,
            open_price DECIMAL(10, 2),
            close_price DECIMAL(10, 2),
            volume INTEGER,
            PRIMARY KEY (date, symbol)
        )
    """)
    
    # Generate stock price data for 2 symbols
    stock_data = []
    symbols = ['TECH', 'RETAIL']
    base_prices = {'TECH': 150.0, 'RETAIL': 80.0}
    
    for symbol in symbols:
        price = base_prices[symbol]
        for i in range(90):
            current_date = base_date + timedelta(days=i)
            # Random walk with slight upward bias
            change = random.uniform(-3, 3.5)
            price = max(price + change, 10)  # Don't go below 10
            open_price = price + random.uniform(-1, 1)
            close_price = price
            volume = random.randint(100000, 500000)
            stock_data.append((current_date, symbol, round(open_price, 2), 
                             round(close_price, 2), volume))
    
    conn.executemany("INSERT INTO stock_prices VALUES (?, ?, ?, ?, ?)", stock_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 17!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print("  - daily_sales (90 rows) - 3 months of daily sales with trends")
    print("  - orders (29 rows) - customer orders with varying patterns")
    print("  - customers (5 rows) - customer information")
    print("  - stock_prices (180 rows) - 2 stocks, 90 days each")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
