#!/usr/bin/env python3
"""Setup script for Day 2: WHERE Clause and Filtering"""

import duckdb
from pathlib import Path
from datetime import date, timedelta
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day02.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    print("📊 Creating database for Day 2: WHERE Clause and Filtering...")
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS employees")
    conn.execute("DROP TABLE IF EXISTS products")
    conn.execute("DROP TABLE IF EXISTS customers")
    
    # Create employees table
    conn.execute("""
        CREATE TABLE employees (
            employee_id INTEGER PRIMARY KEY,
            name VARCHAR NOT NULL,
            email VARCHAR,
            phone VARCHAR,
            department VARCHAR NOT NULL,
            position VARCHAR,
            salary DECIMAL(10, 2) NOT NULL,
            hire_date DATE NOT NULL,
            city VARCHAR NOT NULL,
            is_active BOOLEAN DEFAULT TRUE
        )
    """)
    
    # Generate realistic employee data
    first_names = ['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'Robert', 'Lisa',
                   'James', 'Mary', 'William', 'Jennifer', 'Richard', 'Linda', 'Joseph',
                   'Patricia', 'Thomas', 'Barbara', 'Christopher', 'Susan', 'Daniel', 'Jessica',
                   'Matthew', 'Karen', 'Anthony', 'Nancy', 'Mark', 'Betty', 'Donald', 'Helen']
    
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
                  'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez',
                  'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin']
    
    departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance', 'Operations']
    positions = {
        'Engineering': ['Software Engineer', 'Senior Engineer', 'Tech Lead', 'Engineering Manager'],
        'Sales': ['Sales Rep', 'Account Executive', 'Sales Manager', 'VP Sales'],
        'Marketing': ['Marketing Specialist', 'Content Writer', 'Marketing Manager', 'CMO'],
        'HR': ['HR Specialist', 'Recruiter', 'HR Manager', 'VP HR'],
        'Finance': ['Accountant', 'Financial Analyst', 'Finance Manager', 'CFO'],
        'Operations': ['Operations Specialist', 'Project Manager', 'Operations Manager', 'COO']
    }
    
    cities = ['New York', 'London', 'Tokyo', 'Paris', 'Berlin', 'Sydney', 'Toronto', 'Singapore']
    
    base_date = date(2018, 1, 1)
    employees_data = []
    
    for i in range(100):
        first = random.choice(first_names)
        last = random.choice(last_names)
        dept = random.choice(departments)
        position = random.choice(positions[dept])
        
        # Salary based on position
        if 'Manager' in position or 'Lead' in position:
            salary = round(random.uniform(80000, 120000), 2)
        elif 'VP' in position or 'C' in position[:2]:
            salary = round(random.uniform(120000, 200000), 2)
        else:
            salary = round(random.uniform(45000, 85000), 2)
        
        hire_date = base_date + timedelta(days=random.randint(0, 2000))
        
        # Some employees don't have phone/email
        has_email = random.random() > 0.1  # 90% have email
        has_phone = random.random() > 0.15  # 85% have phone
        
        employees_data.append((
            i + 1,
            f"{first} {last}",
            f"{first.lower()}.{last.lower()}@company.com" if has_email else None,
            f"555-{random.randint(1000, 9999)}" if has_phone else None,
            dept,
            position,
            salary,
            hire_date,
            random.choice(cities),
            random.choice([True, True, True, False])  # 75% active
        ))
    
    conn.executemany("""
        INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, employees_data)
    
    # Create products table
    conn.execute("""
        CREATE TABLE products (
            product_id INTEGER PRIMARY KEY,
            product_name VARCHAR NOT NULL,
            category VARCHAR NOT NULL,
            price DECIMAL(10, 2) NOT NULL,
            stock_quantity INTEGER NOT NULL,
            product_code VARCHAR,
            description VARCHAR,
            is_available BOOLEAN DEFAULT TRUE
        )
    """)
    
    # Generate product data
    categories = {
        'Electronics': ['Laptop', 'Smartphone', 'Tablet', 'Headphones', 'Camera', 'Monitor'],
        'Books': ['Fiction Novel', 'Textbook', 'Biography', 'Cookbook', 'Travel Guide'],
        'Clothing': ['T-Shirt', 'Jeans', 'Jacket', 'Sneakers', 'Dress', 'Sweater'],
        'Home': ['Lamp', 'Chair', 'Table', 'Rug', 'Curtains', 'Pillow'],
        'Sports': ['Basketball', 'Tennis Racket', 'Yoga Mat', 'Dumbbell', 'Bicycle']
    }
    
    products_data = []
    product_id = 1
    
    for category, items in categories.items():
        for item in items:
            for variant in range(2):  # 2 variants per item
                price = round(random.uniform(10, 500), 2)
                stock = random.randint(0, 200)
                code = f"{category[:3].upper()}{product_id:04d}"
                
                # Some products don't have descriptions
                has_desc = random.random() > 0.2  # 80% have descriptions
                
                products_data.append((
                    product_id,
                    f"{item} {chr(65+variant)}",  # A, B variants
                    category,
                    price,
                    stock,
                    code,
                    f"High quality {item.lower()}" if has_desc else None,
                    random.choice([True, True, True, False])  # 75% available
                ))
                product_id += 1
    
    conn.executemany("""
        INSERT INTO products VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, products_data)
    
    # Create customers table
    conn.execute("""
        CREATE TABLE customers (
            customer_id INTEGER PRIMARY KEY,
            first_name VARCHAR NOT NULL,
            last_name VARCHAR NOT NULL,
            email VARCHAR,
            city VARCHAR NOT NULL,
            country VARCHAR NOT NULL,
            registration_date DATE NOT NULL,
            is_premium BOOLEAN DEFAULT FALSE
        )
    """)
    
    # Generate customer data
    countries = ['USA', 'UK', 'Japan', 'France', 'Germany', 'Australia', 'Canada', 'Singapore']
    customers_data = []
    
    for i in range(80):
        first = random.choice(first_names)
        last = random.choice(last_names)
        country = random.choice(countries)
        city = random.choice(cities)
        reg_date = base_date + timedelta(days=random.randint(0, 1800))
        
        # Some customers don't have email
        has_email = random.random() > 0.05  # 95% have email
        
        customers_data.append((
            i + 1,
            first,
            last,
            f"{first.lower()}.{last.lower()}{i}@email.com" if has_email else None,
            city,
            country,
            reg_date,
            random.choice([True, False, False, False])  # 25% premium
        ))
    
    conn.executemany("""
        INSERT INTO customers VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, customers_data)
    
    conn.close()
    
    print("✅ Database setup complete for Day 2!")
    print(f"📁 Database location: {db_path}")
    print("\n📊 Tables created:")
    print("   - employees (100 rows) - Various departments, salaries, cities")
    print("   - products (60 rows) - Multiple categories with prices")
    print("   - customers (80 rows) - Different countries and cities")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")
    print("\n🎯 Practice filtering with:")
    print("   - WHERE with comparison operators")
    print("   - AND, OR, NOT logical operators")
    print("   - IN and BETWEEN operators")
    print("   - LIKE pattern matching")
    print("   - IS NULL checks")

if __name__ == "__main__":
    setup()
