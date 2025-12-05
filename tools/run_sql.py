#!/usr/bin/env python3
"""
Helper script to run SQL files with DuckDB
Usage: python tools/run_sql.py <database.db> <query.sql>
"""

import sys
import duckdb

def main():
    if len(sys.argv) != 3:
        print("Usage: python tools/run_sql.py <database.db> <query.sql>")
        print("\nExample:")
        print("  python tools/run_sql.py data/databases/day01.db days/day-01-setup-select-basics/exercise.sql")
        sys.exit(1)
    
    db_file = sys.argv[1]
    sql_file = sys.argv[2]
    
    try:
        # Connect to database
        conn = duckdb.connect(db_file)
        
        # Read and execute SQL file
        with open(sql_file, 'r') as f:
            sql_content = f.read()
        
        # Execute the SQL
        result = conn.execute(sql_content)
        
        # Try to fetch results if there are any
        try:
            rows = result.fetchall()
            if rows:
                print(f"\n✅ Query executed successfully! ({len(rows)} rows)")
                print("\nResults:")
                print("-" * 80)
                for row in rows:
                    print(row)
        except:
            print("\n✅ SQL executed successfully!")
        
        conn.close()
        
    except FileNotFoundError as e:
        print(f"❌ Error: File not found - {e}")
        sys.exit(1)
    except duckdb.Error as e:
        print(f"❌ DuckDB Error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
