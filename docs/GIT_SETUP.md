# Git Workflow for Students

Track your learning progress, build your portfolio, and practice Git while learning SQL!

## Why Use Git?

✅ **Portfolio** - Show employers your learning journey  
✅ **Backup** - Never lose your work  
✅ **Progress Tracking** - Visual record of daily commits  
✅ **Git Practice** - Learn version control alongside SQL  
✅ **Motivation** - Green squares on your GitHub profile!  

---

## Initial Setup (One Time)

### Step 1: Fork the Repository

1. **Go to the original repository** on GitHub
2. **Click "Fork"** button (top right)
3. **Wait** for GitHub to create your copy

### Step 2: Clone Your Fork

```bash
# Clone your fork (replace YOUR-USERNAME)
git clone https://github.com/YOUR-USERNAME/30-days-sql-data-ai.git

# Navigate into the directory
cd 30-days-sql-data-ai
```

### Step 3: Set Up Python Environment

```bash
# Create virtual environment
python -m venv venv

# Activate it
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows

# Install packages
pip install -r requirements.txt

# Verify setup
python tools/test_setup.py
```

### Step 4: Configure Git (If First Time)

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Optional: Set up commit message template
git config commit.template .gitmessage

# Verify
git config --list
```

> 💡 The commit template provides helpful examples when you run `git commit` without `-m`

---

## Daily Workflow

### Every Day You Code:

#### 1. Start Your Session

```bash
# Navigate to project
cd 30-days-sql-data-ai

# Activate virtual environment
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows

# Pull any updates (if working from multiple computers)
git pull origin main
```

#### 2. Work on Today's Lesson

```bash
# Open today's lesson
cd days/day-01-setup-select-basics

# Read README.md
# Complete exercise.sql
# Check solution.sql if stuck
# Take quiz.md
```

#### 3. Commit Your Work

```bash
# Go back to project root
cd ../..

# Check what changed
git status

# Add your changes
git add days/day-01-setup-select-basics/exercise.sql

# Or add all changes
git add .

# Commit with a descriptive message
git commit -m "Complete Day 1: Setup and SELECT Basics"

# Push to GitHub
git push origin main
```

---

## Commit Message Templates

Use clear, consistent commit messages:

### Daily Lessons:
```bash
git commit -m "Complete Day 1: Setup and SELECT Basics"
git commit -m "Complete Day 5: GROUP BY"
git commit -m "Complete Day 15: CTEs"
```

### Projects:
```bash
git commit -m "Complete Day 10: Mini Project - Sales Analysis"
git commit -m "Complete Day 20: Mini Project - Data Warehouse"
git commit -m "Complete Day 30: Capstone Analytics Database"
```

### Work in Progress:
```bash
git commit -m "WIP: Day 8 exercises (partial)"
git commit -m "Add notes to Day 12 README"
```

### Fixes:
```bash
git commit -m "Fix Day 3 query syntax error"
git commit -m "Update Day 7 solution with better approach"
```

---

## Recommended Commit Strategy

### Option 1: Commit After Each Day (Recommended)
```bash
# Complete the day's work
# Then commit once
git add days/day-XX-topic/
git commit -m "Complete Day XX: Topic Name"
git push origin main
```

**Pros**: Clean history, one commit per day  
**Cons**: Lose intermediate progress if something goes wrong

### Option 2: Commit After Each Exercise
```bash
# After each exercise
git add days/day-XX-topic/exercise.sql
git commit -m "Day XX: Complete exercise 1"
# ... continue for each exercise
git push origin main
```

**Pros**: Detailed history, can revert to any exercise  
**Cons**: Many commits, cluttered history

### Option 3: Commit at End of Session
```bash
# At end of your study session
git add .
git commit -m "Progress: Days 5-7"
git push origin main
```

**Pros**: Flexible, matches your schedule  
**Cons**: Less granular tracking

**Recommendation**: Use **Option 1** for clean, professional-looking commit history.

---

## Viewing Your Progress

### On GitHub:
- Visit your repository: `https://github.com/YOUR-USERNAME/30-days-sql-data-ai`
- See your commit history
- View green contribution squares on your profile

### Locally:
```bash
# View commit history
git log --oneline

# View commits with dates
git log --pretty=format:"%h - %an, %ar : %s"

# View your progress graph
git log --graph --oneline --all
```

---

## Common Git Commands

### Checking Status:
```bash
git status              # See what changed
git diff                # See exact changes
git log --oneline       # View commit history
```

### Making Changes:
```bash
git add file.sql        # Stage specific file
git add .               # Stage all changes
git commit -m "message" # Commit with message
git push origin main    # Push to GitHub
```

### Undoing Changes:
```bash
# Undo changes to a file (before staging)
git checkout -- file.sql

# Unstage a file (after git add)
git reset HEAD file.sql

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes) - CAREFUL!
git reset --hard HEAD~1
```

### Syncing:
```bash
git pull origin main    # Get latest changes
git fetch origin        # Check for updates
```

---

## Tips for Success

### 1. Commit Daily
Make it a habit to commit after completing each day. It's motivating to see your progress!

### 2. Write Good Commit Messages
- Start with a verb: "Complete", "Add", "Fix", "Update"
- Be specific: "Complete Day 5" not "Day 5"
- Keep it short: 50 characters or less

### 3. Push Regularly
Push to GitHub at least once per day. This backs up your work and shows your activity.

### 4. Don't Commit Sensitive Data
Never commit:
- Database credentials
- API keys or passwords
- Personal data
- Large database files (use .gitignore)

### 5. Use .gitignore
The repository already has a `.gitignore` file that excludes:
- `venv/` - Virtual environment
- `__pycache__/` - Python cache
- `*.duckdb` - Database files
- `.DS_Store` - Mac system files

---

## Troubleshooting

### "Nothing to commit"
You haven't made any changes, or changes aren't staged:
```bash
git status  # Check what changed
git add .   # Stage changes
```

### "Permission denied"
You don't have access to push:
```bash
# Make sure you cloned YOUR fork, not the original
git remote -v  # Check remote URL

# Should show: https://github.com/YOUR-USERNAME/...
# Not: https://github.com/ORIGINAL-OWNER/...
```

### "Merge conflict"
You edited the same file on different computers:
```bash
# Pull changes first
git pull origin main

# Resolve conflicts in your editor
# Then commit the merge
git add .
git commit -m "Resolve merge conflict"
git push origin main
```

### "Forgot to commit yesterday"
No problem! Commit today with yesterday's date:
```bash
git commit -m "Complete Day 5: GROUP BY" --date="yesterday"
```

### "Want to change last commit message"
```bash
git commit --amend -m "New commit message"
git push origin main --force  # Only if not pushed yet!
```

---

## Advanced: Keeping Your Fork Updated

If the original repository gets updates (bug fixes, improvements):

### One-Time Setup:
```bash
# Add original repo as "upstream"
git remote add upstream https://github.com/ORIGINAL-OWNER/30-days-sql-data-ai.git

# Verify
git remote -v
```

### When Updates Are Available:
```bash
# Fetch updates from original
git fetch upstream

# Merge updates into your main branch
git checkout main
git merge upstream/main

# Push updates to your fork
git push origin main
```

---

## Showcase Your Work

### On Your Resume:
```
30 Days of SQL for Data and AI
- Completed 30-day intensive SQL bootcamp
- Built 3 analytics projects (sales analysis, data warehouse, analytics database)
- Practiced daily with 90+ SQL queries
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

## Quick Reference

```bash
# Daily workflow
cd 30-days-sql-data-ai
source venv/bin/activate
# ... do your work ...
git add .
git commit -m "Complete Day X: Topic"
git push origin main

# Check progress
git log --oneline
git status

# Undo last change
git checkout -- file.sql

# Get help
git --help
git commit --help
```

---

## Need Help?

- 📖 **Git Basics**: https://git-scm.com/book/en/v2
- 🎓 **GitHub Guides**: https://guides.github.com
- 💬 **Ask in Issues**: Create an issue in your repository
- 🔍 **Google**: "git [your question]"

---

**Happy coding and committing!** 🚀

Remember: Every commit is progress. Every push is a backup. Every green square is motivation!
