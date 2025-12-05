# 30 Days of SQL for Data and AI

A focused 30-day program (1 hour/day) to master SQL for data engineering and analytics using DuckDB.

## Overview

**Duration**: 30 days, ~1 hour/day (30-35 hours total)  
**Prerequisites**: None - starts from basics  
**Database**: DuckDB (zero setup, works everywhere)  
**Outcome**: SQL skills for all data projects

> **Note**: Most days take 1 hour, but project days (10, 20, 30) may take 1.5-2 hours. Learn at your own pace!

**What's Included**:
- 📚 30 comprehensive lessons
- 💻 247 hands-on SQL exercises
- ✅ 405 quiz questions (27 quizzes × 15 questions)
- 🎯 3 major projects (Days 10, 20, 30)
- 📊 Real-world data engineering scenarios

---

## Why DuckDB?

✅ **Zero installation** - Just `pip install duckdb`  
✅ **No server setup** - Works immediately  
✅ **Full SQL support** - All standard SQL features  
✅ **Fast** - Optimized for analytics  
✅ **Reads data files** - CSV, JSON, Parquet directly  
✅ **Perfect for learning** - Focus on SQL, not database admin

### Quick Example
```python
import duckdb

# Create in-memory database
con = duckdb.connect(':memory:')

# Query CSV directly
result = con.execute("SELECT * FROM 'data.csv'").df()
```

---

## What You'll Learn

### SQL Fundamentals (Days 1-10)
- SELECT statements and basic queries
- WHERE clauses and filtering
- ORDER BY and LIMIT
- Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY and HAVING
- INNER JOIN basics
- LEFT, RIGHT, FULL OUTER JOINs
- Self joins and cross joins
- Multiple aggregations
- **Mini Project**: Sales analysis queries

### Intermediate SQL (Days 11-20)
- Subqueries (WHERE, FROM, SELECT)
- Common Table Expressions (CTEs)
- Window functions (ROW_NUMBER, RANK, LAG, LEAD)
- Advanced window functions (partitioning, framing)
- CASE statements and conditional logic
- Date and time functions
- String functions and text manipulation
- NULL handling (COALESCE, NULLIF)
- UNION and set operations
- **Mini Project**: Data warehouse queries

### Advanced & Data Engineering (Days 21-30)
- Indexes and performance tuning
- Query optimization techniques
- EXPLAIN plans and analysis
- Transactions and ACID properties
- Views and materialized views
- Data modeling (star schema, snowflake)
- Working with JSON in DuckDB
- Reading Parquet files
- Advanced analytics queries
- **Capstone**: Complete analytics database

---

## Daily Structure

**Regular Days** (1 hour):
- **📖 Concept** (15 min) - Theory and examples
- **💻 Exercise** (40 min) - Hands-on SQL queries
- **✅ Quiz** (5 min) - Test understanding

**Project Days** (1.5-2 hours):
- Days 10, 20, 30 are mini-projects requiring more time
- Take your time - quality over speed!

---

## Projects

- Day 10: **Mini Project** - Sales analysis with complex queries
- Day 20: **Mini Project** - Data warehouse dimensional modeling
- Day 30: **Capstone** - Complete analytics database design

---

## After Completion

You'll be ready for:
✅ 100 Days of Data and AI bootcamp  
✅ Complex data analysis with SQL  
✅ Data warehouse design  
✅ Query optimization  
✅ DuckDB for analytics  
✅ Transition to Spark SQL and dbt  
✅ All SQL-based portfolio projects

---

## 📁 Project Structure

```
30-days-sql-data-ai/
├── README.md              # Start here
├── QUICKSTART.md          # 5-minute setup guide
├── requirements.txt       # Python packages
│
├── docs/                  # 📚 Documentation
│   ├── CURRICULUM.md      # Day-by-day breakdown
│   ├── SETUP.md           # Detailed setup guide
│   ├── TROUBLESHOOTING.md # Common issues & fixes
│   ├── PROJECT_STRUCTURE.md
│   ├── CONTRIBUTING.md
│   └── GIT_SETUP.md
│
├── tools/                 # 🛠️ Utilities
│   ├── cheatsheet.md      # SQL quick reference
│   ├── run_sql.py         # Helper script to run SQL files
│   └── test_setup.py      # Verify installation
│
├── data/                  # 📊 Data files
│   ├── raw/               # Original data
│   ├── processed/         # Processed data
│   └── databases/         # DuckDB files
│
└── days/                  # 📖 30 Daily Lessons
    ├── day-01-setup-select-basics/
    │   ├── README.md      # Lesson
    │   ├── exercise.sql   # Practice
    │   ├── solution.sql   # Solutions
    │   ├── setup.py       # Data setup
    │   └── quiz.md        # Quiz
    ├── day-02-where-filtering/
    └── ... (day-30-capstone-analytics-database)
```

---

## 🚀 Getting Started

### Recommended: Fork & Track Your Progress

**Why fork?** Track your learning journey, build your portfolio, and practice Git!

1. **Fork this repository** on GitHub (click "Fork" button)
2. **Clone your fork**: `git clone https://github.com/YOUR-USERNAME/30-days-sql-data-ai.git`
3. **Follow setup below**
4. **Commit daily** as you complete exercises

👉 **See [docs/GIT_SETUP.md](./docs/GIT_SETUP.md) for complete Git workflow**

### Quick Start (5 minutes)

1. **Install Python 3.11+**
2. **Fork & clone** this repository (or download if not using Git)
3. **Create virtual environment**: `python -m venv venv`
4. **Activate it**: `source venv/bin/activate` (Mac/Linux) or `venv\Scripts\activate` (Windows)
5. **Install packages**: `pip install duckdb pandas faker`
6. **Verify setup**: `python tools/test_setup.py`
7. **Start learning**: Open `days/day-01-setup-select-basics/README.md`

👉 **See [QUICKSTART.md](./QUICKSTART.md) for detailed step-by-step instructions**

### Documentation & Resources

- 📚 **[docs/CURRICULUM.md](./docs/CURRICULUM.md)** - Complete day-by-day breakdown
- 🔧 **[docs/SETUP.md](./docs/SETUP.md)** - Detailed setup instructions
- 🆘 **[docs/TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md)** - Common issues & solutions
- 📝 **[tools/cheatsheet.md](./tools/cheatsheet.md)** - SQL quick reference
- 🤝 **[docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md)** - How to contribute

---

## 📖 How to Use Each Day

1. **Read** the lesson (README.md) - 15 minutes
2. **Run** setup script (setup.py) - creates sample data
3. **Write** SQL queries (exercise.sql) - 40 minutes
4. **Check** solutions if stuck (solution.sql)
5. **Quiz** yourself (quiz.md) - 5 minutes

---

## 💡 Tips for Success

- **Code along** with examples - don't just read
- **Type out queries** - don't copy-paste
- **Commit daily** - track your progress with Git (see below)
- **Take your time** - especially on project days (10, 20, 30)
- **Take breaks** - it's okay to split a day across multiple sessions
- **Practice more** - try variations of queries to reinforce learning
- **Ask questions** - use community resources when stuck

---

## 📊 Track Your Progress with Git

**Recommended**: Fork this repository and commit your solutions daily!

### Benefits:
- 🎯 **Portfolio** - Show employers your learning journey
- 💾 **Backup** - Never lose your work
- 📈 **Motivation** - See your progress with GitHub's green squares
- 🛠️ **Git Practice** - Learn version control alongside SQL

### Quick Start:
1. **Fork** this repository on GitHub
2. **Clone** your fork: `git clone https://github.com/YOUR-USERNAME/30-days-sql-data-ai.git`
3. **Complete** each day's exercises
4. **Commit** daily: `git commit -m "Complete Day X: Topic"`
5. **Push** to GitHub: `git push origin main`

👉 **See [docs/GIT_SETUP.md](./docs/GIT_SETUP.md) for complete Git workflow and best practices**

---

## 🆘 Getting Help

- Check [tools/cheatsheet.md](./tools/cheatsheet.md) for quick reference
- See [docs/TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md) for common issues
- Review previous days
- Google error messages
- Check DuckDB documentation

---

## 📚 Additional Resources

### DuckDB Documentation
- [Official Docs](https://duckdb.org/docs/)
- [SQL Functions](https://duckdb.org/docs/sql/functions/overview)
- [Data Import](https://duckdb.org/docs/data/overview)

### SQL Learning
- [SQL Style Guide](https://www.sqlstyle.guide/)
- [SQL Cheat Sheet](./tools/cheatsheet.md)
- [Window Functions Guide](https://www.postgresql.org/docs/current/tutorial-window.html)

---

## 🎓 What's Next?

After completing this bootcamp:

1. **Build Projects** - Apply SQL skills to real projects
2. **Learn dbt** - Data transformation tool
3. **Explore Spark SQL** - Distributed SQL processing
4. **Try Snowflake/Databricks** - Cloud data platforms
5. **100 Days Bootcamp** - Continue your data journey

---

## 📊 Bootcamp Statistics

- **30 days** of structured content
- **150 files** (5 per day: README, setup.py, exercise.sql, solution.sql, quiz.md)
- **247 SQL exercises** to practice
- **405 quiz questions** for self-assessment (27 quizzes)
- **3 major projects** (sales analysis, data warehouse, analytics database)
- **35,000+ lines** of SQL, Python, and documentation

---

## ✅ Quality Guarantee

All content includes:
- ✅ Comprehensive lessons (100-250+ lines per README)
- ✅ Working SQL queries tested with DuckDB
- ✅ Hands-on exercises with real data
- ✅ Complete solutions with explanations
- ✅ Data setup scripts (Python + Faker)
- ✅ Knowledge checks (quizzes)
- ✅ Consistent formatting
- ✅ Professional quality

---

## 🤝 Contributing

Found a bug? Have a suggestion? Want to improve content?

See [docs/CONTRIBUTING.md](./docs/CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - See [LICENSE](./LICENSE) for details.

---

## 🌟 Showcase Your Work

### On Your Resume:
```
30 Days of SQL for Data and AI
- Completed 30-day intensive SQL bootcamp with DuckDB
- Built 3 analytics projects (sales analysis, data warehouse, analytics database)
- Practiced daily with 200+ SQL queries
- GitHub: github.com/YOUR-USERNAME/30-days-sql-data-ai
```

### On LinkedIn:
Share your progress:
- "Day 10/30 of SQL bootcamp complete! Built my first sales analysis queries 🎉"
- "Finished 30 Days of SQL! Ready for data analytics projects 🚀"

### On Your Portfolio:
Link to your GitHub repository showing:
- Consistent daily commits
- Complete query implementations
- Clean, documented SQL code

---

**Ready to start?** 👉 Open [QUICKSTART.md](./QUICKSTART.md) or jump to [Day 1](./days/day-01-setup-select-basics/README.md)!

**Happy querying!** 🚀
