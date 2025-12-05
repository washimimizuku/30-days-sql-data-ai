#!/usr/bin/env python3
"""Setup script for Day 6: DISTINCT"""

import duckdb
from pathlib import Path

def setup():
    # Create database in data/databases folder

    db_path = Path(__file__).parent.parent.parent / "data" / "databases" / "day06.db"

    db_path.parent.mkdir(parents=True, exist_ok=True)

    

    conn = duckdb.connect(str(db_path))
    
    # Create sample tables
    conn.execute("""
        CREATE TABLE IF NOT EXISTS sample_data (
            id INTEGER,
            name VARCHAR,
            value INTEGER,
            created_date DATE
        )
    """)
    
    # Insert sample data
    conn.execute("""
        INSERT INTO sample_data VALUES
        (1, 'Alice', 100, '2024-01-01'),
        (2, 'Bob', 200, '2024-01-02'),
        (3, 'Charlie', 150, '2024-01-03')
    """)
    
    conn.close()
    print("✅ Database setup complete for Day 06")
    print(f"\n📁 Database location: {db_path}")

if __name__ == "__main__":
    setup()
