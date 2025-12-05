#!/usr/bin/env python3
"""Setup script for Day 21: String Functions"""

import duckdb
from pathlib import Path

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day21.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS customers")
    conn.execute("DROP TABLE IF EXISTS products")
    
    # Create employees table with messy data for cleaning
    conn.execute("""
        CREATE TABLE employees (
            employee_id INTEGER PRIMARY KEY,
            first_name VARCHAR,
            last_name VARCHAR,
            email VARCHAR,
            phone VARCHAR,
            department VARCHAR,
            job_title VARCHAR,
            salary_string VARCHAR
        )
    """)
    
    # Insert employees with various formatting issues
    conn.execute("""
        INSERT INTO employees VALUES
        (1, 'john', 'SMITH', 'John.Smith@Company.com', '555-123-4567', 'Engineering', 'Senior Developer', '95000'),
        (2, 'MARY', 'johnson', 'mary.j@company.COM', '(555) 234-5678', 'Marketing', 'Marketing Manager', '85000'),
        (3, 'Robert', 'WILLIAMS', '  robert.w@company.com  ', '555 345 6789', 'Sales', 'Sales Representative', '75000'),
        (4, 'jennifer', 'Brown', 'JBrown@company.com', '555-456-7890', 'Engineering', 'Junior Developer', '65000'),
        (5, 'MICHAEL', 'DAVIS', 'michael.davis@company.com', '5554567890', 'HR', 'HR Specialist', '70000'),
        (6, 'Linda', 'Miller', 'linda.miller@company.com', '555-567-8901', 'Finance', 'Financial Analyst', '80000'),
        (7, 'david', 'WILSON', 'DAVID.W@COMPANY.COM', '(555)678-9012', 'Engineering', 'Tech Lead', '105000'),
        (8, 'Sarah', 'moore', 'sarah.moore@company.com', '555 789 0123', 'Marketing', 'Content Writer', '60000'),
        (9, 'JAMES', 'taylor', 'j.taylor@company.com', '555-890-1234', 'Sales', 'Sales Manager', '90000'),
        (10, 'Patricia', 'ANDERSON', '  patricia.a@company.com', '555.901.2345', 'HR', 'HR Manager', '95000')
    """)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            customer_id INTEGER PRIMARY KEY,
            full_name VARCHAR,
            email VARCHAR,
            phone VARCHAR,
            address VARCHAR,
            city VARCHAR,
            state VARCHAR,
            zip_code VARCHAR,
            customer_since VARCHAR
        )
    """)
    
    # Insert customers with formatting variations
    conn.execute("""
        INSERT INTO customers VALUES
        (1, 'Alice Johnson', 'alice.j@email.com', '555-111-2222', '123 Main St', 'Seattle', 'WA', '98101', '2023-01-15'),
        (2, 'BOB SMITH', 'BOB.SMITH@EMAIL.COM', '(555) 222-3333', '456 Oak Ave', 'Portland', 'OR', '97201', '2023-03-20'),
        (3, 'Charlie Brown', '  charlie@email.com  ', '555 333 4444', '789 Pine Rd', 'San Francisco', 'CA', '94102', '2023-05-10'),
        (4, 'diana prince', 'diana.p@email.com', '5554445555', '321 Elm St', 'Los Angeles', 'CA', '90001', '2023-07-05'),
        (5, 'EVE DAVIS', 'eve.davis@email.com', '555-555-6666', '654 Maple Dr', 'Austin', 'TX', '78701', '2023-09-12'),
        (6, 'Frank Miller', 'frank.m@email.com', '555.666.7777', '987 Cedar Ln', 'Denver', 'CO', '80201', '2023-11-01'),
        (7, 'Grace Lee', 'grace.lee@email.com', '555-777-8888', '147 Birch Way', 'Boston', 'MA', '02101', '2024-01-15'),
        (8, 'HENRY WILSON', 'h.wilson@email.com', '(555)888-9999', '258 Spruce Ct', 'Chicago', 'IL', '60601', '2024-02-20'),
        (9, 'iris chen', 'iris.chen@email.com', '555 999 0000', '369 Willow Pl', 'Miami', 'FL', '33101', '2024-03-10'),
        (10, 'Jack Taylor', '  jack.t@email.com', '555-000-1111', '741 Ash Blvd', 'Phoenix', 'AZ', '85001', '2024-04-05')
    """)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            product_id INTEGER PRIMARY KEY,
            product_code VARCHAR,
            product_name VARCHAR,
            category VARCHAR,
            description VARCHAR,
            price_string VARCHAR,
            sku VARCHAR
        )
    """)
    
    # Insert products with various string patterns
    conn.execute("""
        INSERT INTO products VALUES
        (1, 'ELEC-001', 'Laptop Pro 15"', 'Electronics', 'High-performance laptop with 15-inch display', '1299.99', 'LP15-BLK-001'),
        (2, 'ELEC-002', 'Wireless Mouse', 'Electronics', 'Ergonomic wireless mouse with USB receiver', '29.99', 'WM-BLU-002'),
        (3, 'FURN-001', 'Office Chair', 'Furniture', 'Comfortable ergonomic office chair', '249.99', 'OC-BLK-001'),
        (4, 'BOOK-001', 'SQL Mastery', 'Books', 'Complete guide to SQL programming', '45.00', 'BK-SQL-001'),
        (5, 'ELEC-003', 'USB-C Cable 6ft', 'Electronics', 'Durable USB-C charging cable', '12.99', 'UC6-WHT-003'),
        (6, 'FURN-002', 'Standing Desk', 'Furniture', 'Adjustable height standing desk', '599.99', 'SD-OAK-002'),
        (7, 'CLTH-001', 'T-Shirt Logo', 'Clothing', 'Cotton t-shirt with company logo', '24.99', 'TS-BLU-M-001'),
        (8, 'ELEC-004', 'Monitor 27"', 'Electronics', '4K UHD monitor with HDR support', '399.99', 'MN27-BLK-004'),
        (9, 'BOOK-002', 'Python Guide', 'Books', 'Comprehensive Python programming guide', '39.99', 'BK-PY-002'),
        (10, 'FURN-003', 'Desk Lamp LED', 'Furniture', 'Adjustable LED desk lamp', '45.99', 'DL-WHT-003'),
        (11, 'CLTH-002', 'Hoodie Premium', 'Clothing', 'Premium quality hoodie', '59.99', 'HD-GRY-L-002'),
        (12, 'ELEC-005', 'Keyboard Mechanical', 'Electronics', 'RGB mechanical gaming keyboard', '89.99', 'KB-RGB-005'),
        (13, 'BOOK-003', 'Data Science 101', 'Books', 'Introduction to data science', '55.00', 'BK-DS-003'),
        (14, 'FURN-004', 'Bookshelf 5-Tier', 'Furniture', 'Wooden 5-tier bookshelf', '129.99', 'BS-OAK-004'),
        (15, 'CLTH-003', 'Cap Branded', 'Clothing', 'Adjustable branded cap', '19.99', 'CP-BLK-003')
    """)
    
    conn.close()
    
    print("✅ Database setup complete for Day 21!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print("  - employees (10 rows) - with mixed case names, various email/phone formats")
    print("  - customers (10 rows) - with formatting variations in names and contacts")
    print("  - products (15 rows) - with product codes, SKUs, and descriptions")
    print("\n💡 Perfect for practicing string functions and data cleaning!")
    print(f"\n💡 Run queries with: python ../../tools/run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
