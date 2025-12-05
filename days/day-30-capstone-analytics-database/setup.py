#!/usr/bin/env python3
"""Setup script for Day 30: Capstone - Complete Analytics Database"""

import duckdb
from pathlib import Path
from datetime import date, timedelta, datetime
import random
import json

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day30.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    print("🎓 Creating Capstone Analytics Database...")
    print("   This combines ALL concepts from Days 1-29!\n")
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    tables = ['order_items', 'orders', 'customers', 'products', 'categories', 
              'stores', 'employees', 'reviews', 'inventory', 'shipments']
    for table in tables:
        conn.execute(f"DROP TABLE IF EXISTS {table}")
    
    # ============================================
    # Create Tables (Days 1-3: Basic SQL)
    # ============================================
    
    print("📊 Creating tables...")
    
    # Categories table
    conn.execute("""
        CREATE TABLE categories (
            category_id INTEGER PRIMARY KEY,
            category_name VARCHAR NOT NULL,
            description VARCHAR,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    categories_data = [
        (1, 'Electronics', 'Electronic devices and accessories'),
        (2, 'Clothing', 'Apparel and fashion items'),
        (3, 'Home & Garden', 'Home improvement and garden supplies'),
        (4, 'Sports & Outdoors', 'Sports equipment and outdoor gear'),
        (5, 'Books', 'Books and educational materials'),
        (6, 'Toys & Games', 'Toys, games, and entertainment')
    ]
    conn.executemany("INSERT INTO categories VALUES (?, ?, ?, CURRENT_TIMESTAMP)", categories_data)
    
    # Products table
    conn.execute("""
        CREATE TABLE products (
            product_id INTEGER PRIMARY KEY,
            product_name VARCHAR NOT NULL,
            category_id INTEGER,
            price DECIMAL(10, 2) NOT NULL,
            cost DECIMAL(10, 2) NOT NULL,
            stock_quantity INTEGER DEFAULT 0,
            reorder_level INTEGER DEFAULT 10,
            supplier VARCHAR,
            is_active BOOLEAN DEFAULT TRUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (category_id) REFERENCES categories(category_id)
        )
    """)
    
    # Generate 100 products
    products_data = []
    product_names = {
        1: ['Laptop', 'Smartphone', 'Tablet', 'Headphones', 'Camera', 'Monitor', 'Keyboard', 'Mouse'],
        2: ['T-Shirt', 'Jeans', 'Jacket', 'Sneakers', 'Dress', 'Sweater', 'Shorts', 'Hat'],
        3: ['Sofa', 'Table', 'Chair', 'Lamp', 'Rug', 'Curtains', 'Plant', 'Mirror'],
        4: ['Basketball', 'Tennis Racket', 'Yoga Mat', 'Dumbbell', 'Bicycle', 'Tent', 'Backpack'],
        5: ['Novel', 'Textbook', 'Magazine', 'Comic Book', 'Dictionary', 'Atlas'],
        6: ['Board Game', 'Puzzle', 'Action Figure', 'Doll', 'LEGO Set', 'Video Game']
    }
    
    product_id = 1
    for cat_id, names in product_names.items():
        for i, name in enumerate(names):
            for variant in range(2):  # 2 variants per product
                cost = round(random.uniform(10, 500), 2)
                price = round(cost * random.uniform(1.5, 3.0), 2)
                stock = random.randint(0, 200)
                products_data.append((
                    product_id,
                    f"{name} {chr(65+variant)}",  # A, B variants
                    cat_id,
                    price,
                    cost,
                    stock,
                    random.randint(5, 20),
                    f"Supplier{random.randint(1, 5)}",
                    random.choice([True, True, True, False]),  # 75% active
                    datetime.now()
                ))
                product_id += 1
    
    conn.executemany("""
        INSERT INTO products VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, products_data)
    
    # Customers table
    conn.execute("""
        CREATE TABLE customers (
            customer_id INTEGER PRIMARY KEY,
            first_name VARCHAR NOT NULL,
            last_name VARCHAR NOT NULL,
            email VARCHAR UNIQUE NOT NULL,
            phone VARCHAR,
            address VARCHAR,
            city VARCHAR,
            state VARCHAR,
            zip_code VARCHAR,
            country VARCHAR DEFAULT 'USA',
            customer_segment VARCHAR,
            registration_date DATE,
            last_purchase_date DATE,
            total_lifetime_value DECIMAL(10, 2) DEFAULT 0,
            is_active BOOLEAN DEFAULT TRUE
        )
    """)
    
    # Generate 300 customers
    first_names = ['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'Robert', 'Lisa', 
                   'William', 'Jennifer', 'James', 'Mary', 'Christopher', 'Patricia', 'Daniel']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 
                  'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez']
    cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia',
              'San Antonio', 'San Diego', 'Dallas', 'San Jose', 'Austin', 'Seattle']
    states = ['NY', 'CA', 'IL', 'TX', 'AZ', 'PA', 'TX', 'CA', 'TX', 'CA', 'TX', 'WA']
    segments = ['Premium', 'Standard', 'Basic']
    
    customers_data = []
    base_date = date(2022, 1, 1)
    for i in range(300):
        first = random.choice(first_names)
        last = random.choice(last_names)
        city_idx = random.randint(0, len(cities)-1)
        reg_date = base_date + timedelta(days=random.randint(0, 700))
        last_purchase = reg_date + timedelta(days=random.randint(0, 365)) if random.random() > 0.1 else None
        
        customers_data.append((
            i + 1,
            first,
            last,
            f"{first.lower()}.{last.lower()}{i}@example.com",
            f"555-{random.randint(1000, 9999)}",
            f"{random.randint(100, 9999)} Main St",
            cities[city_idx],
            states[city_idx],
            f"{random.randint(10000, 99999)}",
            'USA',
            random.choice(segments),
            reg_date,
            last_purchase,
            round(random.uniform(0, 5000), 2),
            random.choice([True, True, True, False])
        ))
    
    conn.executemany("""
        INSERT INTO customers VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, customers_data)
    
    # Stores table
    conn.execute("""
        CREATE TABLE stores (
            store_id INTEGER PRIMARY KEY,
            store_name VARCHAR NOT NULL,
            city VARCHAR,
            state VARCHAR,
            region VARCHAR,
            manager_name VARCHAR,
            opened_date DATE,
            is_active BOOLEAN DEFAULT TRUE
        )
    """)
    
    stores_data = []
    regions = ['Northeast', 'Southeast', 'Midwest', 'Southwest', 'West']
    for i in range(20):
        city_idx = random.randint(0, len(cities)-1)
        stores_data.append((
            i + 1,
            f"Store {i+1}",
            cities[city_idx],
            states[city_idx],
            random.choice(regions),
            f"Manager {i+1}",
            base_date + timedelta(days=random.randint(-500, 0)),
            True
        ))
    
    conn.executemany("INSERT INTO stores VALUES (?, ?, ?, ?, ?, ?, ?, ?)", stores_data)
    
    # Employees table
    conn.execute("""
        CREATE TABLE employees (
            employee_id INTEGER PRIMARY KEY,
            first_name VARCHAR NOT NULL,
            last_name VARCHAR NOT NULL,
            email VARCHAR UNIQUE,
            store_id INTEGER,
            position VARCHAR,
            salary DECIMAL(10, 2),
            hire_date DATE,
            is_active BOOLEAN DEFAULT TRUE,
            FOREIGN KEY (store_id) REFERENCES stores(store_id)
        )
    """)
    
    positions = ['Sales Associate', 'Cashier', 'Stock Clerk', 'Assistant Manager', 'Manager']
    salary_ranges = {
        'Sales Associate': (30000, 45000),
        'Cashier': (28000, 40000),
        'Stock Clerk': (32000, 42000),
        'Assistant Manager': (45000, 65000),
        'Manager': (60000, 90000)
    }
    
    employees_data = []
    for i in range(100):
        first = random.choice(first_names)
        last = random.choice(last_names)
        position = random.choice(positions)
        salary_min, salary_max = salary_ranges[position]
        
        employees_data.append((
            i + 1,
            first,
            last,
            f"{first.lower()}.{last.lower()}.emp{i}@company.com",
            random.randint(1, 20),
            position,
            round(random.uniform(salary_min, salary_max), 2),
            base_date + timedelta(days=random.randint(0, 600)),
            random.choice([True, True, True, False])
        ))
    
    conn.executemany("INSERT INTO employees VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", employees_data)
    
    # Orders table
    conn.execute("""
        CREATE TABLE orders (
            order_id INTEGER PRIMARY KEY,
            customer_id INTEGER NOT NULL,
            store_id INTEGER,
            employee_id INTEGER,
            order_date DATE NOT NULL,
            ship_date DATE,
            delivery_date DATE,
            status VARCHAR,
            payment_method VARCHAR,
            subtotal DECIMAL(10, 2),
            tax_amount DECIMAL(10, 2),
            shipping_cost DECIMAL(10, 2),
            total_amount DECIMAL(10, 2),
            FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
            FOREIGN KEY (store_id) REFERENCES stores(store_id),
            FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
        )
    """)
    
    # Generate 2000 orders
    print("💳 Generating 2,000 orders...")
    statuses = ['Completed', 'Completed', 'Completed', 'Shipped', 'Processing', 'Cancelled']
    payment_methods = ['Credit Card', 'Debit Card', 'PayPal', 'Cash']
    
    orders_data = []
    order_date = date(2023, 1, 1)
    for i in range(2000):
        order_date = order_date + timedelta(days=random.randint(0, 1))
        status = random.choice(statuses)
        ship_date = order_date + timedelta(days=random.randint(1, 3)) if status != 'Cancelled' else None
        delivery_date = ship_date + timedelta(days=random.randint(2, 7)) if status == 'Completed' else None
        
        subtotal = round(random.uniform(50, 1000), 2)
        tax = round(subtotal * 0.08, 2)
        shipping = round(random.uniform(5, 25), 2) if status != 'Cancelled' else 0
        total = round(subtotal + tax + shipping, 2)
        
        orders_data.append((
            i + 1,
            random.randint(1, 300),
            random.randint(1, 20),
            random.randint(1, 100),
            order_date,
            ship_date,
            delivery_date,
            status,
            random.choice(payment_methods),
            subtotal,
            tax,
            shipping,
            total
        ))
    
    conn.executemany("""
        INSERT INTO orders VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, orders_data)
    
    # Order Items table
    conn.execute("""
        CREATE TABLE order_items (
            order_item_id INTEGER PRIMARY KEY,
            order_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            unit_price DECIMAL(10, 2) NOT NULL,
            discount_percent DECIMAL(5, 2) DEFAULT 0,
            line_total DECIMAL(10, 2),
            FOREIGN KEY (order_id) REFERENCES orders(order_id),
            FOREIGN KEY (product_id) REFERENCES products(product_id)
        )
    """)
    
    # Generate order items (2-5 items per order)
    print("📦 Generating order items...")
    order_items_data = []
    item_id = 1
    active_products = conn.execute("SELECT product_id, price FROM products WHERE is_active = true").fetchall()
    
    for order_id in range(1, 2001):
        num_items = random.randint(2, 5)
        for _ in range(num_items):
            product_id, price = random.choice(active_products)
            quantity = random.randint(1, 3)
            discount = random.choice([0, 0, 0, 5, 10, 15, 20])
            unit_price = float(price)
            line_total = round(unit_price * quantity * (1 - discount/100), 2)
            
            order_items_data.append((
                item_id,
                order_id,
                product_id,
                quantity,
                unit_price,
                discount,
                line_total
            ))
            item_id += 1
    
    conn.executemany("""
        INSERT INTO order_items VALUES (?, ?, ?, ?, ?, ?, ?)
    """, order_items_data)
    
    # Reviews table
    conn.execute("""
        CREATE TABLE reviews (
            review_id INTEGER PRIMARY KEY,
            product_id INTEGER NOT NULL,
            customer_id INTEGER NOT NULL,
            rating INTEGER CHECK (rating BETWEEN 1 AND 5),
            review_text VARCHAR,
            review_date DATE,
            helpful_count INTEGER DEFAULT 0,
            FOREIGN KEY (product_id) REFERENCES products(product_id),
            FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        )
    """)
    
    # Generate reviews
    review_texts = [
        "Great product! Highly recommend.",
        "Good value for money.",
        "Not what I expected.",
        "Excellent quality!",
        "Average product.",
        "Would buy again!",
        "Disappointed with the quality.",
        "Perfect for my needs.",
        "Could be better.",
        "Amazing! Love it!"
    ]
    
    reviews_data = []
    for i in range(500):
        reviews_data.append((
            i + 1,
            random.randint(1, len(products_data)),
            random.randint(1, 300),
            random.randint(1, 5),
            random.choice(review_texts),
            date(2023, 1, 1) + timedelta(days=random.randint(0, 365)),
            random.randint(0, 50)
        ))
    
    conn.executemany("INSERT INTO reviews VALUES (?, ?, ?, ?, ?, ?, ?)", reviews_data)
    
    conn.close()
    
    print("\n✅ Capstone database setup complete!")
    print(f"📁 Database location: {db_path}")
    print("\n📊 Database contains:")
    print("   - categories (6 categories)")
    print("   - products (100+ products)")
    print("   - customers (300 customers)")
    print("   - stores (20 stores)")
    print("   - employees (100 employees)")
    print("   - orders (2,000 orders)")
    print("   - order_items (6,000+ line items)")
    print("   - reviews (500 product reviews)")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")
    print("\n🎓 This capstone project tests ALL skills from Days 1-29:")
    print("   ✓ SELECT, WHERE, ORDER BY (Days 1-3)")
    print("   ✓ Aggregations & GROUP BY (Days 4-7)")
    print("   ✓ JOINs (Days 8-12)")
    print("   ✓ Subqueries & CTEs (Days 13-15)")
    print("   ✓ Window Functions (Days 16-17)")
    print("   ✓ CASE Statements (Day 18)")
    print("   ✓ Date/String Functions (Days 19, 21)")
    print("   ✓ NULL Handling (Day 22)")
    print("   ✓ Set Operations (Day 23)")
    print("   ✓ Performance & Optimization (Days 24-25)")
    print("   ✓ Data Modeling (Day 28)")

if __name__ == "__main__":
    setup()
