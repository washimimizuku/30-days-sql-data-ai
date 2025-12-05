#!/usr/bin/env python3
"""
Day 1: Setup and SELECT Basics
Creates sample database with employees table
"""

import duckdb

def setup():
    """Create database and populate with sample data"""
    
    # Connect to database
    conn = duckdb.connect('day01.db')
    
    # Create employees table
    conn.execute("""
        CREATE TABLE IF NOT EXISTS employees (
            id INTEGER,
            name VARCHAR,
            department VARCHAR,
            salary DECIMAL(10, 2),
            city VARCHAR,
            hire_date DATE
        )
    """)
    
    # Insert sample data
    conn.execute("""
        INSERT INTO employees VALUES
        (1, 'Alice Johnson', 'Engineering', 75000, 'San Francisco', '2020-01-15'),
        (2, 'Bob Smith', 'Sales', 65000, 'New York', '2019-03-20'),
        (3, 'Charlie Brown', 'Engineering', 80000, 'San Francisco', '2021-06-10'),
        (4, 'Diana Prince', 'Marketing', 70000, 'Los Angeles', '2020-09-01'),
        (5, 'Eve Davis', 'Sales', 68000, 'New York', '2018-11-15'),
        (6, 'Frank Miller', 'Engineering', 85000, 'San Francisco', '2019-07-22'),
        (7, 'Grace Lee', 'Marketing', 72000, 'Los Angeles', '2021-02-14'),
        (8, 'Henry Wilson', 'Sales', 66000, 'Chicago', '2020-05-30'),
        (9, 'Iris Chen', 'Engineering', 78000, 'San Francisco', '2022-01-10'),
        (10, 'Jack Ryan', 'Marketing', 71000, 'Chicago', '2019-08-25')
    """)
    
    # Verify data
    result = conn.execute("SELECT COUNT(*) as count FROM employees").fetchone()
    print(f"✅ Database created: day01.db")
    print(f"✅ Employees table created with {result[0]} rows")
    
    # Show sample data
    print("\n📊 Sample data:")
    conn.execute("SELECT * FROM employees LIMIT 3").show()
    
    conn.close()
    print("\n🎉 Setup complete! Run your queries with:")
    print("   duckdb day01.db < exercise.sql")

if __name__ == "__main__":
    setup()
