#!/usr/bin/env python3
"""Setup script for Day 28: Data Modeling - Star Schema"""

import duckdb
from pathlib import Path
from datetime import date, timedelta
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day28.db"
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    print("📊 Creating star schema for e-commerce analytics...")
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS fact_sales")
    conn.execute("DROP TABLE IF EXISTS dim_date")
    conn.execute("DROP TABLE IF EXISTS dim_customer")
    conn.execute("DROP TABLE IF EXISTS dim_product")
    conn.execute("DROP TABLE IF EXISTS dim_store")
    
    # ============================================
    # Create Dimension Tables
    # ============================================
    
    print("📅 Creating dim_date...")
    conn.execute("""
        CREATE TABLE dim_date (
            date_id INTEGER PRIMARY KEY,
            date DATE,
            year INTEGER,
            quarter INTEGER,
            month INTEGER,
            month_name VARCHAR,
            day INTEGER,
            day_of_week INTEGER,
            day_name VARCHAR,
            week_of_year INTEGER,
            is_weekend BOOLEAN,
            is_holiday BOOLEAN,
            fiscal_year INTEGER,
            fiscal_quarter INTEGER
        )
    """)
    
    # Generate date dimension for 2023-2024
    base_date = date(2023, 1, 1)
    date_data = []
    day_names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    month_names = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December']
    holidays = [date(2023, 1, 1), date(2023, 7, 4), date(2023, 12, 25),
                date(2024, 1, 1), date(2024, 7, 4), date(2024, 12, 25)]
    
    for i in range(730):  # 2 years
        current_date = base_date + timedelta(days=i)
        date_id = int(current_date.strftime('%Y%m%d'))
        year = current_date.year
        quarter = (current_date.month - 1) // 3 + 1
        month = current_date.month
        day = current_date.day
        day_of_week = current_date.weekday()
        week_of_year = current_date.isocalendar()[1]
        is_weekend = day_of_week >= 5
        is_holiday = current_date in holidays
        fiscal_year = year if month >= 7 else year - 1
        fiscal_quarter = ((month - 7) % 12) // 3 + 1
        
        date_data.append((
            date_id, current_date, year, quarter, month, month_names[month-1],
            day, day_of_week, day_names[day_of_week], week_of_year,
            is_weekend, is_holiday, fiscal_year, fiscal_quarter
        ))
    
    conn.executemany("""
        INSERT INTO dim_date VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, date_data)
    
    print("👥 Creating dim_customer...")
    conn.execute("""
        CREATE TABLE dim_customer (
            customer_id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            email VARCHAR,
            phone VARCHAR,
            address VARCHAR,
            city VARCHAR,
            state VARCHAR,
            country VARCHAR,
            postal_code VARCHAR,
            segment VARCHAR,
            registration_date DATE,
            lifetime_value DECIMAL(10, 2),
            is_active BOOLEAN
        )
    """)
    
    # Generate customers
    segments = ['Premium', 'Standard', 'Basic']
    cities = [
        ('New York', 'NY'), ('Los Angeles', 'CA'), ('Chicago', 'IL'),
        ('Houston', 'TX'), ('Phoenix', 'AZ'), ('Philadelphia', 'PA'),
        ('San Antonio', 'TX'), ('San Diego', 'CA'), ('Dallas', 'TX'),
        ('San Jose', 'CA'), ('Austin', 'TX'), ('Jacksonville', 'FL'),
        ('Seattle', 'WA'), ('Denver', 'CO'), ('Boston', 'MA')
    ]
    
    customer_data = []
    for i in range(200):
        city, state = random.choice(cities)
        reg_date = base_date + timedelta(days=random.randint(0, 500))
        customer_data.append((
            i + 1,
            f"Customer {i+1}",
            f"customer{i+1}@example.com",
            f"555-{random.randint(1000, 9999)}",
            f"{random.randint(100, 9999)} Main St",
            city,
            state,
            "USA",
            f"{random.randint(10000, 99999)}",
            random.choice(segments),
            reg_date,
            round(random.uniform(100, 10000), 2),
            random.choice([True, True, True, False])  # 75% active
        ))
    
    conn.executemany("""
        INSERT INTO dim_customer VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, customer_data)
    
    print("📦 Creating dim_product...")
    conn.execute("""
        CREATE TABLE dim_product (
            product_id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            sku VARCHAR,
            category VARCHAR,
            subcategory VARCHAR,
            brand VARCHAR,
            unit_cost DECIMAL(10, 2),
            list_price DECIMAL(10, 2),
            supplier VARCHAR,
            is_active BOOLEAN
        )
    """)
    
    # Generate products
    categories = {
        'Electronics': ['Laptops', 'Phones', 'Tablets', 'Accessories'],
        'Clothing': ['Mens', 'Womens', 'Kids', 'Shoes'],
        'Home': ['Furniture', 'Decor', 'Kitchen', 'Bedding'],
        'Sports': ['Equipment', 'Apparel', 'Footwear', 'Accessories']
    }
    brands = ['BrandA', 'BrandB', 'BrandC', 'BrandD', 'BrandE']
    suppliers = ['Supplier1', 'Supplier2', 'Supplier3', 'Supplier4']
    
    product_data = []
    product_id = 1
    for category, subcats in categories.items():
        for subcat in subcats:
            for i in range(8):  # 8 products per subcategory
                cost = round(random.uniform(10, 500), 2)
                price = round(cost * random.uniform(1.5, 3.0), 2)
                product_data.append((
                    product_id,
                    f"{category} {subcat} {i+1}",
                    f"SKU-{product_id:05d}",
                    category,
                    subcat,
                    random.choice(brands),
                    cost,
                    price,
                    random.choice(suppliers),
                    random.choice([True, True, True, False])  # 75% active
                ))
                product_id += 1
    
    conn.executemany("""
        INSERT INTO dim_product VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, product_data)
    
    print("🏪 Creating dim_store...")
    conn.execute("""
        CREATE TABLE dim_store (
            store_id INTEGER PRIMARY KEY,
            store_name VARCHAR,
            store_type VARCHAR,
            address VARCHAR,
            city VARCHAR,
            state VARCHAR,
            country VARCHAR,
            region VARCHAR,
            manager_name VARCHAR,
            open_date DATE,
            square_feet INTEGER,
            is_active BOOLEAN
        )
    """)
    
    # Generate stores
    store_types = ['Flagship', 'Standard', 'Outlet']
    regions = ['Northeast', 'Southeast', 'Midwest', 'Southwest', 'West']
    
    store_data = []
    for i in range(25):
        city, state = random.choice(cities)
        region = random.choice(regions)
        open_date = base_date + timedelta(days=random.randint(-1000, 0))
        store_data.append((
            i + 1,
            f"Store {i+1}",
            random.choice(store_types),
            f"{random.randint(100, 9999)} Commerce Blvd",
            city,
            state,
            "USA",
            region,
            f"Manager {i+1}",
            open_date,
            random.randint(5000, 50000),
            True
        ))
    
    conn.executemany("""
        INSERT INTO dim_store VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, store_data)
    
    # ============================================
    # Create Fact Table
    # ============================================
    
    print("💰 Creating fact_sales...")
    conn.execute("""
        CREATE TABLE fact_sales (
            sale_id INTEGER PRIMARY KEY,
            date_id INTEGER,
            customer_id INTEGER,
            product_id INTEGER,
            store_id INTEGER,
            quantity INTEGER,
            unit_price DECIMAL(10, 2),
            discount_amount DECIMAL(10, 2),
            tax_amount DECIMAL(10, 2),
            total_amount DECIMAL(10, 2),
            cost_amount DECIMAL(10, 2),
            profit_amount DECIMAL(10, 2),
            FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
            FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
            FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
            FOREIGN KEY (store_id) REFERENCES dim_store(store_id)
        )
    """)
    
    # Generate sales transactions
    print("💳 Generating 5,000 sales transactions...")
    
    # Get active products and customers
    products = conn.execute("SELECT product_id, list_price, unit_cost FROM dim_product WHERE is_active = true").fetchall()
    customers = conn.execute("SELECT customer_id FROM dim_customer WHERE is_active = true").fetchall()
    stores = conn.execute("SELECT store_id FROM dim_store WHERE is_active = true").fetchall()
    dates = conn.execute("SELECT date_id FROM dim_date WHERE date >= '2023-06-01'").fetchall()
    
    sales_data = []
    for i in range(5000):
        product_id, list_price, unit_cost = random.choice(products)
        customer_id = random.choice(customers)[0]
        store_id = random.choice(stores)[0]
        date_id = random.choice(dates)[0]
        
        quantity = random.randint(1, 5)
        unit_price = float(list_price)
        discount_pct = random.choice([0, 0, 0, 0.05, 0.10, 0.15, 0.20])  # Most no discount
        discount_amount = round(unit_price * quantity * discount_pct, 2)
        subtotal = round(unit_price * quantity - discount_amount, 2)
        tax_amount = round(subtotal * 0.08, 2)  # 8% tax
        total_amount = round(subtotal + tax_amount, 2)
        cost_amount = round(float(unit_cost) * quantity, 2)
        profit_amount = round(subtotal - cost_amount, 2)
        
        sales_data.append((
            i + 1, date_id, customer_id, product_id, store_id,
            quantity, unit_price, discount_amount, tax_amount,
            total_amount, cost_amount, profit_amount
        ))
    
    conn.executemany("""
        INSERT INTO fact_sales VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, sales_data)
    
    conn.close()
    
    print("\n✅ Star schema setup complete for Day 28!")
    print(f"📁 Database location: {db_path}")
    print("\n📊 Schema created:")
    print("   Fact Table:")
    print("   - fact_sales (5,000 transactions)")
    print("\n   Dimension Tables:")
    print("   - dim_date (730 days: 2023-2024)")
    print("   - dim_customer (200 customers)")
    print("   - dim_product (128 products across 4 categories)")
    print("   - dim_store (25 stores across 5 regions)")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")
    print("\n🎯 You'll learn to:")
    print("   - Design star schemas")
    print("   - Query fact and dimension tables")
    print("   - Perform dimensional analysis")
    print("   - Calculate business metrics")
    print("   - Optimize for analytics")

if __name__ == "__main__":
    setup()
