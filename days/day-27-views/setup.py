#!/usr/bin/env python3
"""Setup script for Day 27: Constraints"""

import duckdb

def setup():
    conn = duckdb.connect('day27.db')
    
    conn.execute("""
        CREATE TABLE IF NOT EXISTS sample_data (
            id INTEGER,
            name VARCHAR,
            value INTEGER,
            created_date DATE
        )
    """)
    
    conn.execute("""
        INSERT INTO sample_data VALUES
        (1, 'Alice', 100, '2024-01-01'),
        (2, 'Bob', 200, '2024-01-02'),
        (3, 'Charlie', 150, '2024-01-03')
    """)
    
    conn.close()
    print("Database setup complete for Day 27")

if __name__ == "__main__":
    setup()
