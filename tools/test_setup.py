"""
Setup verification for 30 Days of SQL
"""
import sys

def check_python():
    version = sys.version_info
    if version.major == 3 and version.minor >= 11:
        print(f"✅ Python version: {version.major}.{version.minor}.{version.micro}")
        return True
    else:
        print(f"❌ Python {version.major}.{version.minor} - need 3.11+")
        return False

def check_duckdb():
    try:
        import duckdb
        print(f"✅ DuckDB installed: {duckdb.__version__}")
        return True
    except ImportError:
        print("❌ DuckDB not installed")
        print("   Run: pip install duckdb")
        return False

if __name__ == "__main__":
    checks = [check_python(), check_duckdb()]
    print("\n" + "="*50)
    if all(checks):
        print("✅ All set! Ready to start Day 1")
    else:
        print("❌ Please fix issues above")
    print("="*50)
