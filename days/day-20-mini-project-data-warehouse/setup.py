#!/usr/bin/env python3
"""Setup script for Day 20: Mini Project - Data Warehouse Analytics"""

import duckdb
from datetime import date, timedelta
from pathlib import Path
import random

def setup():
    # Create database in data/databases folder
    db_path = Path(__file__).parent.parent.parent / 'data' / 'databases' / 'day20.db'
    db_path.parent.mkdir(parents=True, exist_ok=True)
    
    conn = duckdb.connect(str(db_path))
    
    # Drop existing tables
    conn.execute("DROP TABLE IF EXISTS fact_sales")
    conn.execute("DROP TABLE IF EXISTS dim_date")
    conn.execute("DROP TABLE IF EXISTS dim_customer")
    conn.execute("DROP TABLE IF EXISTS dim_product")
    conn.execute("DROP TABLE IF EXISTS dim_store")
    
    print("Creating data warehouse tables...")
    
    # Create dim_date table
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
            is_weekend BOOLEAN,
            is_holiday BOOLEAN
        )
    """)
    
    # Generate 2 years of dates
    start_date = date(2023, 1, 1)
    date_data = []
    holidays = [date(2023, 1, 1), date(2023, 7, 4), date(2023, 11, 23), date(2023, 12, 25),
                date(2024, 1, 1), date(2024, 7, 4), date(2024, 11, 28), date(2024, 12, 25)]
    day_names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    month_names = ['', 'January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December']
    
    for i in range(730):  # 2 years
        current_date = start_date + timedelta(days=i)
        date_id = int(current_date.strftime('%Y%m%d'))
        dow = current_date.weekday()  # 0=Monday, 6=Sunday
        quarter = (current_date.month - 1) // 3 + 1
        
        date_data.append((
            date_id, current_date, current_date.year, quarter, current_date.month,
            month_names[current_date.month], current_date.day, dow,
            day_names[dow], dow >= 5, current_date in holidays
        ))
    
    conn.executemany("INSERT INTO dim_date VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", date_data)
    
    # Create dim_customer table
    conn.execute("""
        CREATE TABLE dim_customer (
            customer_id INTEGER PRIMARY KEY,
            customer_name VARCHAR,
            email VARCHAR,
            city VARCHAR,
            state VARCHAR,
            country VARCHAR,
            segment VARCHAR,
            registration_date DATE
        )
    """)
    
    # Generate 1000 customers
    first_names = ['James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
                   'William', 'Barbara', 'David', 'Elizabeth', 'Richard', 'Susan', 'Joseph', 'Jessica']
    last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
                  'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas']
    cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio',
              'San Diego', 'Dallas', 'San Jose', 'Austin', 'Jacksonville', 'Fort Worth', 'Columbus',
              'Charlotte', 'San Francisco', 'Indianapolis', 'Seattle', 'Denver', 'Boston']
    states = ['NY', 'CA', 'IL', 'TX', 'AZ', 'PA', 'TX', 'CA', 'TX', 'CA', 'TX', 'FL', 'TX', 'OH',
              'NC', 'CA', 'IN', 'WA', 'CO', 'MA']
    segments = ['Standard', 'Premium', 'VIP']
    
    customer_data = []
    for i in range(1, 1001):
        name = f"{random.choice(first_names)} {random.choice(last_names)}"
        email = f"{name.lower().replace(' ', '.')}@email.com"
        city_idx = random.randint(0, len(cities)-1)
        city = cities[city_idx]
        state = states[city_idx]
        segment = random.choices(segments, weights=[70, 25, 5])[0]
        reg_date = start_date + timedelta(days=random.randint(0, 600))
        
        customer_data.append((i, name, email, city, state, 'USA', segment, reg_date))
    
    conn.executemany("INSERT INTO dim_customer VALUES (?, ?, ?, ?, ?, ?, ?, ?)", customer_data)
    
    # Create dim_product table
    conn.execute("""
        CREATE TABLE dim_product (
            product_id INTEGER PRIMARY KEY,
            product_name VARCHAR,
            category VARCHAR,
            subcategory VARCHAR,
            brand VARCHAR,
            unit_cost DECIMAL(10, 2),
            list_price DECIMAL(10, 2)
        )
    """)
    
    # Generate 200 products
    categories = {
        'Electronics': ['Laptops', 'Phones', 'Tablets', 'Accessories'],
        'Clothing': ['Mens', 'Womens', 'Kids', 'Shoes'],
        'Home': ['Furniture', 'Decor', 'Kitchen', 'Bedding'],
        'Sports': ['Equipment', 'Apparel', 'Footwear', 'Accessories'],
        'Books': ['Fiction', 'Non-Fiction', 'Educational', 'Children']
    }
    brands = ['BrandA', 'BrandB', 'BrandC', 'BrandD', 'BrandE']
    
    product_data = []
    product_id = 1
    for category, subcats in categories.items():
        for subcat in subcats:
            for i in range(10):  # 10 products per subcategory
                name = f"{category} {subcat} Product {i+1}"
                brand = random.choice(brands)
                cost = round(random.uniform(10, 200), 2)
                price = round(cost * random.uniform(1.3, 2.5), 2)
                
                product_data.append((product_id, name, category, subcat, brand, cost, price))
                product_id += 1
    
    conn.executemany("INSERT INTO dim_product VALUES (?, ?, ?, ?, ?, ?, ?)", product_data)
    
    # Create dim_store table
    conn.execute("""
        CREATE TABLE dim_store (
            store_id INTEGER PRIMARY KEY,
            store_name VARCHAR,
            city VARCHAR,
            state VARCHAR,
            country VARCHAR,
            region VARCHAR,
            store_type VARCHAR,
            open_date DATE
        )
    """)
    
    # Generate 20 stores
    regions = {'Northeast': ['NY', 'MA', 'PA'], 'Southeast': ['FL', 'NC', 'TX'],
               'Midwest': ['IL', 'OH', 'IN'], 'Southwest': ['AZ', 'TX', 'CO'],
               'West': ['CA', 'WA', 'CA']}
    store_types = ['Flagship', 'Standard', 'Outlet']
    
    store_data = []
    store_id = 1
    for region, region_states in regions.items():
        for i in range(4):  # 4 stores per region
            state = random.choice(region_states)
            city = random.choice([c for c, s in zip(cities, states) if s == state])
            name = f"{city} {random.choice(store_types)} Store"
            store_type = random.choice(store_types)
            open_date = start_date + timedelta(days=random.randint(-730, 0))
            
            store_data.append((store_id, name, city, state, 'USA', region, store_type, open_date))
            store_id += 1
    
    conn.executemany("INSERT INTO dim_store VALUES (?, ?, ?, ?, ?, ?, ?, ?)", store_data)
    
    # Create fact_sales table
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
            total_amount DECIMAL(10, 2)
        )
    """)
    
    # Generate 10,000+ sales transactions
    print("Generating sales transactions...")
    sales_data = []
    sale_id = 1
    
    # Generate sales with realistic patterns
    for i in range(730):  # Each day
        current_date = start_date + timedelta(days=i)
        date_id = int(current_date.strftime('%Y%m%d'))
        
        # More sales on weekends and holidays
        dow = current_date.weekday()
        is_weekend = dow >= 5
        is_holiday = current_date in holidays
        
        if is_holiday:
            num_sales = random.randint(20, 40)
        elif is_weekend:
            num_sales = random.randint(15, 30)
        else:
            num_sales = random.randint(10, 20)
        
        for _ in range(num_sales):
            customer_id = random.randint(1, 1000)
            product_id = random.randint(1, 200)
            store_id = random.randint(1, 20)
            quantity = random.randint(1, 5)
            
            # Get product price
            unit_price = round(random.uniform(20, 300), 2)
            discount = round(unit_price * random.uniform(0, 0.2), 2)
            total = round((unit_price - discount) * quantity, 2)
            
            sales_data.append((sale_id, date_id, customer_id, product_id, store_id,
                             quantity, unit_price, discount, total))
            sale_id += 1
    
    conn.executemany("INSERT INTO fact_sales VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", sales_data)
    
    conn.close()
    
    print("\n✅ Data warehouse setup complete for Day 20!")
    print(f"\n📁 Database location: {db_path}")
    print("\nTables created:")
    print(f"  - dim_date (730 rows) - 2 years of dates")
    print(f"  - dim_customer (1000 rows) - customers across 20 cities")
    print(f"  - dim_product (200 rows) - 5 categories, 20 subcategories")
    print(f"  - dim_store (20 rows) - 5 regions")
    print(f"  - fact_sales ({len(sales_data)} rows) - sales transactions")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")

if __name__ == "__main__":
    setup()
