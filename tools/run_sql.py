#!/usr/bin/env python3
"""
Helper script to run SQL files with DuckDB
Usage: python3 tools/run_sql.py <database.db> <query.sql>
"""

import sys
import duckdb
import re

def split_sql_statements(sql_content):
    """Split SQL content into individual statements"""
    # Remove comments and empty lines
    lines = []
    for line in sql_content.split('\n'):
        line = line.strip()
        # Skip empty lines and comment-only lines
        if line and not line.startswith('--'):
            lines.append(line)
    
    if not lines:
        return []
    
    # Join lines and split by semicolon
    full_sql = ' '.join(lines)
    statements = [stmt.strip() for stmt in full_sql.split(';') if stmt.strip()]
    
    return statements

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 tools/run_sql.py <database.db> <query.sql>")
        print("\nExample:")
        print("  python3 tools/run_sql.py data/databases/day01.db days/day-01-setup-select-basics/exercise.sql")
        sys.exit(1)
    
    db_file = sys.argv[1]
    sql_file = sys.argv[2]
    
    try:
        # Connect to database
        conn = duckdb.connect(db_file)
        
        # Read SQL file
        with open(sql_file, 'r') as f:
            sql_content = f.read()
        
        # Split into individual statements
        statements = split_sql_statements(sql_content)
        
        if not statements:
            print("⚠️  No SQL statements found in file (only comments or empty lines)")
            return
        
        print(f"📄 Executing {len(statements)} SQL statement(s) from {sql_file}")
        print("=" * 80)
        
        # Execute each statement
        for i, statement in enumerate(statements, 1):
            print(f"\n🔍 Query {i}:")
            print(f"   {statement[:60]}{'...' if len(statement) > 60 else ''}")
            print("-" * 40)
            
            try:
                result = conn.execute(statement)
                
                # Try to fetch results
                try:
                    rows = result.fetchall()
                    if rows:
                        print(f"✅ {len(rows)} row(s) returned:")
                        for row in rows:
                            print(f"   {row}")
                    else:
                        print("✅ Query executed (no rows returned)")
                except:
                    print("✅ Query executed successfully")
                    
            except duckdb.Error as e:
                print(f"❌ Error in query {i}: {e}")
        
        conn.close()
        print(f"\n🎉 Completed executing {len(statements)} statement(s)")
        
    except FileNotFoundError as e:
        print(f"❌ Error: File not found - {e}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
