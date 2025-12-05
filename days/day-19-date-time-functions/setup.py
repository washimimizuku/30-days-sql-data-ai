#!/usr/bin/env python3
"""Setup script for Day 19: Date and Time Functions"""

import duckdb
from datetime import date, datetime, timedelta
from pathlib import Path
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day19.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS orders")
    conn.execute("DROP TABLE IF EXISTS customers")
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS events")
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            customer_id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            registration_date DATE,
            birth_date DATE,
            last_order_date DATE
        )
    """)
    
    # Generate customers with various registration dates
    customers_data = [
        (1, 'Alice Johnson', date(2021, 3, 15), date(1985, 6, 20), date(2024, 11, 28)),
        (2, 'Bob Smith', date(2022, 7, 22), date(1990, 2, 14), date(2024, 11, 25)),
        (3, 'Charlie Brown', date(2023, 1, 10), date(1988, 9, 5), date(2024, 10, 15)),
        (4, 'Diana Prince', date(2023, 6, 5), date(1992, 12, 1), date(2024, 11, 20)),
        (5, 'Eve Davis', date(2023, 9, 18), date(1987, 4, 30), date(2024, 8, 10)),
        (6, 'Frank Miller', date(2024, 1, 8), date(1995, 7, 15), date(2024, 11, 30)),
        (7, 'Grace Lee', date(2024, 3, 25), date(1991, 11, 22), date(2024, 11, 29)),
        (8, 'Henry Wilson', date(2024, 6, 12), date(1989, 3, 8), date(2024, 7, 5)),
        (9, 'Iris Chen', date(2024, 9, 1), date(1993, 8, 17), date(2024, 11, 27)),
        (10, 'Jack Taylor', date(2024, 11, 5), date(1986, 1, 25), None),  # Never ordered
    ]
    
    conn.executemany("INSERT INTO customers VALUES (?, ?, ?, ?, ?)", customers_data)
    
    # Create orders table
    conn.execute("""
        CREATE TABLE orders (
            order_id INTEGER PRIMARY KEY,
            customer_id INTEGER,
            order_date DATE,
            order_timestamp TIMESTAMP,
            total DECIMAL(10, 2),
            status VARCHAR
        )
    """)
    
    # Generate orders spanning 2 years with various patterns
    orders_data = []
    order_id = 1
    base_date = date(2023, 1, 1)
    
    # Generate orders for each customer
    for customer_id in range(1, 10):
        # Different order patterns per customer
        if customer_id <= 3:  # Heavy users
            num_orders = random.randint(15, 25)
        elif customer_id <= 6:  # Regular users
            num_orders = random.randint(8, 15)
        else:  # Light users
            num_orders = random.randint(3, 8)
        
        for _ in range(num_orders):
            days_offset = random.randint(0, 700)
            order_date = base_date + timedelta(days=days_offset)
            
            # Add timestamp with random hour
            hour = random.randint(6, 22)
            minute = random.randint(0, 59)
            order_timestamp = datetime.combine(order_date, datetime.min.time()) + timedelta(hours=hour, minutes=minute)
            
            total = random.uniform(50, 500)
            status = random.choice(['completed', 'completed', 'completed', 'pending', 'cancelled'])
            
            orders_data.append((order_id, customer_id, order_date, order_timestamp, round(total, 2), status))
            order_id += 1
    
    conn.executemany("INSERT INTO orders VALUES (?, ?, ?, ?, ?, ?)", orders_data)
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            employee_id INTEGER PRIMARY KEY,
            name VARCHAR,
            hire_date DATE,
            department VARCHAR
        )
    """)
    
    employees_data = [
        (1, 'Sarah Connor', date(2018, 3, 15), 'Engineering'),
        (2, 'John Doe', date(2019, 7, 22), 'Sales'),
        (3, 'Jane Smith', date(2020, 1, 10), 'Marketing'),
        (4, 'Mike Johnson', date(2020, 6, 5), 'Engineering'),
        (5, 'Lisa Brown', date(2021, 9, 18), 'Sales'),
        (6, 'Tom Wilson', date(2022, 2, 8), 'Marketing'),
        (7, 'Emma Davis', date(2022, 11, 25), 'Engineering'),
        (8, 'Chris Lee', date(2023, 4, 12), 'Sales'),
        (9, 'Anna White', date(2023, 8, 1), 'Marketing'),
        (10, 'David Chen', date(2024, 1, 15), 'Engineering'),
    ]
    
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?)", employees_data)
    
    # Create events table
    conn.execute("""
        CREATE TABLE events (
            event_id INTEGER PRIMARY KEY,
            event_name VARCHAR,
            start_date DATE,
            end_date DATE
        )
    """)
    
    events_data = [
        (1, 'Spring Sale', date(2024, 3, 1), date(2024, 3, 31)),
        (2, 'Summer Campaign', date(2024, 6, 1), date(2024, 8, 31)),
        (3, 'Back to School', date(2024, 8, 15), date(2024, 9, 15)),
        (4, 'Fall Promotion', date(2024, 9, 1), date(2024, 11, 30)),
        (5, 'Black Friday', date(2024, 11, 25), date(2024, 11, 29)),
        (6, 'Cyber Monday', date(2024, 11, 28), date(2024, 12, 2)),
        (7, 'Holiday Sale', date(2024, 12, 1), date(2024, 12, 31)),
        (8, 'New Year Event', date(2024, 12, 26), date(2025, 1, 5)),
    ]
    
    conn.executemany("INSERT INTO events VALUES (?, ?, ?, ?)", events_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 19!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print("  - customers (10 rows) - with registration dates, birth dates, last order dates")
    print(f"  - orders ({len(orders_data)} rows) - spanning 2 years with timestamps")
    print("  - employees (10 rows) - with hire dates")
    print("  - events (8 rows) - with start and end dates")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
