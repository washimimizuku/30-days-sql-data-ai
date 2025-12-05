#!/usr/bin/env python3
"""Setup script for Day 29: Working with JSON in DuckDB"""

import duckdb
import json
from pathlib import Path
from datetime import datetime, timedelta
import random

def setup():
    # Setup paths
    project_root = Path(__file__).parent.parent.parent
    db_path = project_root / "data" / "databases" / "day29.db"
    raw_data_path = project_root / "data" / "raw"
    
    # Create directories
    db_path.parent.mkdir(parents=True, exist_ok=True)
    raw_data_path.mkdir(parents=True, exist_ok=True)
    
    print("📝 Creating JSON data files in data/raw/...")
    
    # 1. Create API logs JSON file (array of objects)
    api_logs = []
    base_date = datetime(2024, 1, 1)
    
    endpoints = ['/api/users', '/api/products', '/api/orders', '/api/analytics']
    methods = ['GET', 'POST', 'PUT', 'DELETE']
    status_codes = [200, 201, 400, 404, 500]
    
    for i in range(100):
        log = {
            "timestamp": (base_date + timedelta(hours=i)).isoformat(),
            "request_id": f"req_{i+1:04d}",
            "method": random.choice(methods),
            "endpoint": random.choice(endpoints),
            "status_code": random.choice(status_codes),
            "response_time_ms": random.randint(10, 500),
            "user": {
                "id": random.randint(1, 50),
                "ip": f"192.168.{random.randint(1,255)}.{random.randint(1,255)}"
            },
            "metadata": {
                "user_agent": "Mozilla/5.0",
                "region": random.choice(["us-east", "us-west", "eu-west", "ap-south"])
            }
        }
        api_logs.append(log)
    
    with open(raw_data_path / 'api_logs.json', 'w') as f:
        json.dump(api_logs, f, indent=2)
    
    # 2. Create e-commerce events JSON file (newline-delimited JSON)
    events = []
    event_types = ['page_view', 'add_to_cart', 'purchase', 'search', 'click']
    pages = ['/home', '/products', '/cart', '/checkout', '/account']
    
    for i in range(150):
        event = {
            "event_id": f"evt_{i+1:05d}",
            "event_type": random.choice(event_types),
            "timestamp": (base_date + timedelta(minutes=i*10)).isoformat(),
            "user_id": random.randint(1, 30),
            "session_id": f"sess_{random.randint(1, 50):03d}",
            "properties": {}
        }
        
        if event['event_type'] == 'page_view':
            event['properties'] = {
                "page": random.choice(pages),
                "duration_seconds": random.randint(5, 300),
                "referrer": random.choice(["google", "direct", "facebook", None])
            }
        elif event['event_type'] == 'add_to_cart':
            event['properties'] = {
                "product_id": random.randint(1, 100),
                "product_name": f"Product {random.randint(1, 100)}",
                "price": round(random.uniform(10, 500), 2),
                "quantity": random.randint(1, 5)
            }
        elif event['event_type'] == 'purchase':
            event['properties'] = {
                "order_id": f"ORD{random.randint(1000, 9999)}",
                "total_amount": round(random.uniform(50, 1000), 2),
                "items": [
                    {
                        "product_id": random.randint(1, 100),
                        "quantity": random.randint(1, 3),
                        "price": round(random.uniform(10, 200), 2)
                    }
                    for _ in range(random.randint(1, 4))
                ],
                "payment_method": random.choice(["credit_card", "paypal", "apple_pay"])
            }
        elif event['event_type'] == 'search':
            event['properties'] = {
                "query": random.choice(["laptop", "phone", "headphones", "camera"]),
                "results_count": random.randint(0, 50),
                "filters": {
                    "price_min": random.choice([None, 50, 100]),
                    "price_max": random.choice([None, 500, 1000]),
                    "category": random.choice([None, "Electronics", "Accessories"])
                }
            }
        
        events.append(event)
    
    # Write as newline-delimited JSON
    with open(raw_data_path / 'events.ndjson', 'w') as f:
        for event in events:
            f.write(json.dumps(event) + '\n')
    
    # 3. Create product catalog with nested JSON
    products = []
    categories = ['Electronics', 'Clothing', 'Home', 'Sports']
    
    for i in range(50):
        product = {
            "product_id": i + 1,
            "name": f"Product {i+1}",
            "category": random.choice(categories),
            "price": round(random.uniform(10, 500), 2),
            "attributes": {
                "brand": random.choice(["BrandA", "BrandB", "BrandC"]),
                "color": random.choice(["Red", "Blue", "Black", "White"]),
                "size": random.choice(["S", "M", "L", "XL", None]),
                "weight_kg": round(random.uniform(0.1, 5.0), 2)
            },
            "tags": random.sample(["new", "sale", "popular", "featured", "limited"], k=random.randint(1, 3)),
            "reviews": {
                "average_rating": round(random.uniform(3.0, 5.0), 1),
                "count": random.randint(0, 500),
                "recent": [
                    {
                        "rating": random.randint(1, 5),
                        "comment": "Great product!",
                        "date": (base_date + timedelta(days=random.randint(1, 30))).isoformat()
                    }
                    for _ in range(random.randint(0, 3))
                ]
            },
            "inventory": {
                "in_stock": random.choice([True, False]),
                "quantity": random.randint(0, 100),
                "warehouses": [
                    {
                        "location": loc,
                        "quantity": random.randint(0, 50)
                    }
                    for loc in random.sample(["US-East", "US-West", "EU", "Asia"], k=random.randint(1, 3))
                ]
            }
        }
        products.append(product)
    
    with open(raw_data_path / 'products.json', 'w') as f:
        json.dump(products, f, indent=2)
    
    # 4. Create user profiles JSON
    users = []
    for i in range(30):
        user = {
            "user_id": i + 1,
            "username": f"user{i+1}",
            "email": f"user{i+1}@example.com",
            "profile": {
                "first_name": f"First{i+1}",
                "last_name": f"Last{i+1}",
                "age": random.randint(18, 70),
                "location": {
                    "city": random.choice(["New York", "Los Angeles", "Chicago", "Houston"]),
                    "state": random.choice(["NY", "CA", "IL", "TX"]),
                    "country": "USA"
                }
            },
            "preferences": {
                "newsletter": random.choice([True, False]),
                "notifications": {
                    "email": random.choice([True, False]),
                    "sms": random.choice([True, False]),
                    "push": random.choice([True, False])
                },
                "favorite_categories": random.sample(categories, k=random.randint(1, 3))
            },
            "purchase_history": {
                "total_orders": random.randint(0, 50),
                "total_spent": round(random.uniform(0, 5000), 2),
                "last_purchase_date": (base_date + timedelta(days=random.randint(1, 100))).isoformat() if random.random() > 0.2 else None
            }
        }
        users.append(user)
    
    with open(raw_data_path / 'users.json', 'w') as f:
        json.dump(users, f, indent=2)
    
    print("✅ Created 4 JSON files:")
    print("   - api_logs.json (100 API request logs)")
    print("   - events.ndjson (150 e-commerce events)")
    print("   - products.json (50 products with nested data)")
    print("   - users.json (30 user profiles)")
    
    # Create database and load JSON data
    print("\n📊 Creating database and loading JSON data...")
    conn = duckdb.connect(str(db_path))
    
    # Create a reference table for file locations
    conn.execute("""
        CREATE TABLE json_files (
            file_name VARCHAR,
            file_path VARCHAR,
            description VARCHAR,
            record_count INTEGER
        )
    """)
    
    conn.execute("""
        INSERT INTO json_files VALUES
        ('api_logs.json', '../../data/raw/api_logs.json', 'API request logs with nested user data', 100),
        ('events.ndjson', '../../data/raw/events.ndjson', 'E-commerce events (newline-delimited)', 150),
        ('products.json', '../../data/raw/products.json', 'Product catalog with reviews and inventory', 50),
        ('users.json', '../../data/raw/users.json', 'User profiles with preferences', 30)
    """)
    
    conn.close()
    
    print(f"\n✅ Database setup complete for Day 29!")
    print(f"📁 Database location: {db_path}")
    print(f"📁 JSON files location: {raw_data_path}")
    print(f"\n💡 Run queries with: python ../../run_sql.py {db_path} exercise.sql")
    print("\n🎯 You'll learn to:")
    print("   - Read JSON files with read_json_auto()")
    print("   - Extract nested JSON values")
    print("   - Work with JSON arrays")
    print("   - Convert JSON to relational tables")
    print("   - Query semi-structured data")

if __name__ == "__main__":
    setup()
