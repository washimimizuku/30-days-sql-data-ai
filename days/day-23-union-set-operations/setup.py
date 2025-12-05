#!/usr/bin/env python3
"""Setup script for Day 23: UNION and Set Operations"""

import duckdb
from pathlib import Path

def setup():
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day23.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    for table in ['employees_2023', 'employees_2024', 'customers_east', 'customers_west', 
                  'products_online', 'products_store', 'orders_q1', 'orders_q2']:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # Create employees tables (some overlap)
    conn.execute("""
        CREATE TABLE employees_2023 (
            employee_id INTEGER, name VARCHAR, email VARCHAR, department VARCHAR, salary DECIMAL(10,2)
        )
    """)
    
    conn.execute("""
        INSERT INTO employees_2023 VALUES
        (1, 'Alice Johnson', 'alice@company.com', 'Engineering', 95000),
        (2, 'Bob Smith', 'bob@company.com', 'Sales', 85000),
        (3, 'Charlie Brown', 'charlie@company.com', 'Marketing', 75000),
        (4, 'Diana Prince', 'diana@company.com', 'Engineering', 90000),
        (5, 'Eve Davis', 'eve@company.com', 'Sales', 80000)
    """)
    
    conn.execute("""
        CREATE TABLE employees_2024 (
            employee_id INTEGER, name VARCHAR, email VARCHAR, department VARCHAR, salary DECIMAL(10,2)
        )
    """)
    
    conn.execute("""
        INSERT INTO employees_2024 VALUES
        (3, 'Charlie Brown', 'charlie@company.com', 'Marketing', 78000),
        (4, 'Diana Prince', 'diana@company.com', 'Engineering', 95000),
        (5, 'Eve Davis', 'eve@company.com', 'Sales', 85000),
        (6, 'Frank Miller', 'frank@company.com', 'Engineering', 92000),
        (7, 'Grace Lee', 'grace@company.com', 'Marketing', 77000),
        (8, 'Henry Wilson', 'henry@company.com', 'Sales', 88000)
    """)
    
    # Create customer tables (regional)
    conn.execute("""
        CREATE TABLE customers_east (
            customer_id INTEGER, name VARCHAR, email VARCHAR, city VARCHAR, state VARCHAR
        )
    """)
    
    conn.execute("""
        INSERT INTO customers_east VALUES
        (1, 'Customer A', 'a@email.com', 'New York', 'NY'),
        (2, 'Customer B', 'b@email.com', 'Boston', 'MA'),
        (3, 'Customer C', 'c@email.com', 'Philadelphia', 'PA'),
        (4, 'Customer D', 'd@email.com', 'Miami', 'FL'),
        (5, 'Customer E', 'e@email.com', 'Atlanta', 'GA')
    """)
    
    conn.execute("""
        CREATE TABLE customers_west (
            customer_id INTEGER, name VARCHAR, email VARCHAR, city VARCHAR, state VARCHAR
        )
    """)
    
    conn.execute("""
        INSERT INTO customers_west VALUES
        (6, 'Customer F', 'f@email.com', 'Los Angeles', 'CA'),
        (7, 'Customer G', 'g@email.com', 'San Francisco', 'CA'),
        (8, 'Customer H', 'h@email.com', 'Seattle', 'WA'),
        (3, 'Customer C', 'c@email.com', 'Denver', 'CO'),
        (9, 'Customer I', 'i@email.com', 'Phoenix', 'AZ')
    """)
    
    # Create product tables (some overlap)
    conn.execute("""
        CREATE TABLE products_online (
            product_id INTEGER, product_name VARCHAR, category VARCHAR, price DECIMAL(10,2)
        )
    """)
    
    conn.execute("""
        INSERT INTO products_online VALUES
        (1, 'Laptop', 'Electronics', 1299.99),
        (2, 'Mouse', 'Electronics', 29.99),
        (3, 'Keyboard', 'Electronics', 89.99),
        (4, 'Monitor', 'Electronics', 399.99),
        (5, 'Webcam', 'Electronics', 79.99)
    """)
    
    conn.execute("""
        CREATE TABLE products_store (
            product_id INTEGER, product_name VARCHAR, category VARCHAR, price DECIMAL(10,2)
        )
    """)
    
    conn.execute("""
        INSERT INTO products_store VALUES
        (3, 'Keyboard', 'Electronics', 89.99),
        (4, 'Monitor', 'Electronics', 399.99),
        (6, 'Office Chair', 'Furniture', 249.99),
        (7, 'Desk', 'Furniture', 599.99),
        (8, 'Lamp', 'Furniture', 45.99)
    """)
    
    # Create quarterly order tables
    conn.execute("""
        CREATE TABLE orders_q1 (
            order_id INTEGER, customer_id INTEGER, order_date DATE, total DECIMAL(10,2)
        )
    """)
    
    conn.execute("""
        INSERT INTO orders_q1 VALUES
        (1, 1, '2024-01-15', 150.00),
        (2, 2, '2024-02-20', 275.50),
        (3, 3, '2024-03-10', 89.99)
    """)
    
    conn.execute("""
        CREATE TABLE orders_q2 (
            order_id INTEGER, customer_id INTEGER, order_date DATE, total DECIMAL(10,2)
        )
    """)
    
    conn.execute("""
        INSERT INTO orders_q2 VALUES
        (4, 1, '2024-04-05', 420.00),
        (5, 4, '2024-05-12', 310.25),
        (6, 2, '2024-06-18', 195.00)
    """)
    
    conn.close()
    
    print("✅ Database setup complete for Day 23!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print("  - employees_2023 (5 rows), employees_2024 (6 rows) - with 3 overlapping")
    print("  - customers_east (5 rows), customers_west (5 rows) - with 1 overlapping")
    print("  - products_online (5 rows), products_store (5 rows) - with 2 overlapping")
    print("  - orders_q1 (3 rows), orders_q2 (3 rows)")
    print("\n💡 Perfect for practicing UNION, INTERSECT, EXCEPT!")
    print(f"\n💡 Run queries with: python ../../tools/run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
