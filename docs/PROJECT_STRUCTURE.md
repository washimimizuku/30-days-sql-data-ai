# 30 Days of SQL for Data and AI - Project Structure

## 📁 Clean Project Structure

```
30-days-sql-data-ai/
├── README.md                    # Main project documentation
├── QUICKSTART.md                # 5-minute setup guide
├── requirements.txt             # Python dependencies (DuckDB, pandas)
├── LICENSE                      # MIT License
├── .gitignore                   # Git ignore rules
├── .gitmessage                  # Commit message template
│
├── docs/                        # Documentation
│   ├── SETUP.md                # Installation and setup guide
│   ├── CURRICULUM.md           # Day-by-day breakdown
│   ├── TROUBLESHOOTING.md      # Common issues
│   ├── PROJECT_STRUCTURE.md    # This file
│   ├── CONTRIBUTING.md         # Contribution guidelines
│   └── GIT_SETUP.md            # Git workflow guide
│
├── tools/                       # Utilities
│   ├── cheatsheet.md           # SQL quick reference
│   └── test_setup.py           # Setup verification script
│
├── data/                        # Data directories
│   ├── raw/                    # Original data files
│   ├── processed/              # Processed data outputs
│   └── databases/              # DuckDB database files
│
└── days/                        # 30 daily lessons
    ├── day-01-setup-select-basics/
    │   ├── README.md           # Lesson content
    │   ├── exercise.sql        # Practice queries
    │   ├── solution.sql        # Complete solutions
    │   ├── setup.py            # Data setup script
    │   └── quiz.md             # Knowledge check
    │
    ├── day-02-where-filtering/
    ├── day-03-order-by-limit/
    ├── ...
    └── day-30-capstone-analytics-database/
```

## 📚 Core Files

### README.md
Main project documentation including:
- Overview and learning objectives
- Why DuckDB (zero setup, fast, SQL-complete)
- What you'll learn (Fundamentals, Intermediate, Advanced)
- Daily structure (Concept, Exercise, Quiz)
- Getting started guide
- Tips for success

### QUICKSTART.md
5-minute setup guide:
- Install DuckDB
- Verify setup
- Start learning
- Quick reference

### requirements.txt
Python packages needed:
- duckdb (database engine)
- pandas (data manipulation)
- faker (generate sample data)
- jupyter (optional notebooks)
- matplotlib (optional visualization)

## 📖 Daily Lesson Structure

Each day contains 5 files:

1. **README.md** (100-250+ lines)
   - Learning objectives
   - Theory with SQL examples
   - Best practices
   - Exercise references
   - Tomorrow preview

2. **exercise.sql**
   - 5-10 hands-on queries
   - TODO comments for guidance
   - Progressive difficulty
   - Real-world scenarios

3. **solution.sql**
   - Complete working queries
   - Explanatory comments
   - Best practices demonstrated
   - Runnable SQL

4. **setup.py**
   - Creates sample data
   - Sets up tables
   - Generates realistic datasets
   - Uses DuckDB and Faker

5. **quiz.md**
   - 5-6 questions
   - Answer key included
   - Self-assessment guidance
   - Next steps recommendations

## 🎯 Key Features

### Three Major Projects
- **Day 10**: Sales Analysis (complex queries, aggregations, joins)
- **Day 20**: Data Warehouse (dimensional modeling, star schema)
- **Day 30**: Analytics Database (complete database design and queries)

### Progressive Learning
- Starts with basics (SELECT, WHERE, ORDER BY)
- Builds to intermediate (JOINs, subqueries, CTEs)
- Advances to analytics (window functions, optimization)
- Culminates in real projects (complete databases)

### Data Engineering Focus
- E-commerce and analytics examples
- Real-world scenarios
- Query optimization
- Data modeling
- Performance tuning

## 🚀 Getting Started

1. Read `README.md` for overview
2. Check `QUICKSTART.md` for 5-minute setup
3. Run `python tools/test_setup.py` to verify setup
4. Start with `days/day-01-setup-select-basics/README.md`
5. Run setup.py, complete exercises, check solutions, take quiz
6. Move to next day

## ✅ Quality Standards

All content verified for:
- Comprehensive lessons (100-250+ lines per README)
- Working SQL queries
- Hands-on exercises
- Complete solutions
- Data setup scripts
- Knowledge checks
- Consistent formatting
- Professional quality

## 📊 Statistics

- **30 days** of content
- **150 files** (5 per day)
- **~12,000+ lines** of SQL and documentation
- **3 major projects**
- **200+ SQL queries**
- **150+ quiz questions**

## 🎓 Learning Outcomes

After completing this curriculum, you'll be ready for:
- Complex data analysis with SQL
- Data warehouse design
- Query optimization
- DuckDB for analytics
- Transition to Spark SQL and dbt
- All SQL-based portfolio projects
- Junior data analyst/engineer roles
- 100 Days of Data and AI bootcamp

---

**Status**: ✅ Complete and Ready for Students
**Last Updated**: December 4, 2024
