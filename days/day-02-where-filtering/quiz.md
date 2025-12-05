# Day 2 Quiz: WHERE Clause and Filtering

Test your understanding of filtering data with WHERE clauses!

---

## Questions

### 1. What is the purpose of the WHERE clause?

- A) To sort the results
- B) To filter rows based on conditions
- C) To join tables together
- D) To group rows

### 2. Which operator checks if a value is within a range (inclusive)?

- A) IN
- B) LIKE
- C) BETWEEN
- D) OR

### 3. How do you check if a column value is NULL?

- A) WHERE column = NULL
- B) WHERE column == NULL
- C) WHERE column IS NULL
- D) WHERE column EQUALS NULL

### 4. What does the % wildcard represent in LIKE patterns?

- A) Exactly one character
- B) Zero or more characters
- C) One or more characters
- D) Any digit

### 5. Which query finds employees in 'Sales' OR 'Marketing' with salary > 70000?

- A) WHERE department = 'Sales' OR 'Marketing' AND salary > 70000
- B) WHERE (department = 'Sales' OR department = 'Marketing') AND salary > 70000
- C) WHERE department IN 'Sales', 'Marketing' AND salary > 70000
- D) WHERE department = 'Sales' AND 'Marketing' OR salary > 70000

### 6. What does the IN operator do?

- A) Checks if a value is within a numeric range
- B) Checks if a value matches any value in a list
- C) Checks if a value contains a substring
- D) Checks if a value is NULL

### 7. Which wildcard matches exactly one character in LIKE patterns?

- A) %
- B) *
- C) _
- D) ?

### 8. What is the result of: WHERE salary BETWEEN 50000 AND 80000?

- A) salary > 50000 AND salary < 80000
- B) salary >= 50000 AND salary <= 80000
- C) salary > 50000 OR salary < 80000
- D) salary >= 50000 OR salary <= 80000

### 9. Which operator has the highest precedence?

- A) OR
- B) AND
- C) NOT
- D) They all have equal precedence

### 10. How do you find names that start with 'J'?

- A) WHERE name LIKE 'J%'
- B) WHERE name LIKE '%J'
- C) WHERE name = 'J%'
- D) WHERE name STARTS WITH 'J'

### 11. What's wrong with: WHERE email = NULL?

- A) Should use == instead of =
- B) Should use IS NULL instead of = NULL
- C) Should use EQUALS NULL
- D) Nothing, it's correct

### 12. Which finds employees NOT in 'HR' or 'Finance'?

- A) WHERE department NOT IN ('HR', 'Finance')
- B) WHERE NOT department = 'HR' OR 'Finance'
- C) WHERE department != 'HR' AND 'Finance'
- D) WHERE department <> ('HR', 'Finance')

### 13. What does this query return: WHERE name LIKE '_a%'?

- A) Names with 'a' as the first character
- B) Names with 'a' as the second character
- C) Names containing 'a'
- D) Names ending with 'a'

### 14. How do you combine AND and OR correctly?

- A) Always use parentheses to group OR conditions
- B) AND always comes before OR
- C) OR always comes before AND
- D) They cannot be combined

### 15. Which is the correct way to find values NOT between 40 and 60?

- A) WHERE value NOT BETWEEN 40 AND 60
- B) WHERE value < 40 OR value > 60
- C) WHERE NOT (value >= 40 AND value <= 60)
- D) All of the above

---

## Answers

1. **B** - To filter rows based on conditions
   - WHERE clause filters which rows are returned based on specified conditions

2. **C** - BETWEEN
   - BETWEEN checks if a value is within a range, inclusive of both endpoints

3. **C** - WHERE column IS NULL
   - Must use IS NULL, not = NULL, to check for NULL values

4. **B** - Zero or more characters
   - % matches any number of characters (including zero)

5. **B** - WHERE (department = 'Sales' OR department = 'Marketing') AND salary > 70000
   - Parentheses group the OR conditions correctly

6. **B** - Checks if a value matches any value in a list
   - IN is shorthand for multiple OR conditions

7. **C** - _
   - Underscore (_) matches exactly one character

8. **B** - salary >= 50000 AND salary <= 80000
   - BETWEEN is inclusive of both boundary values

9. **C** - NOT
   - Precedence: NOT > AND > OR (use parentheses for clarity)

10. **A** - WHERE name LIKE 'J%'
    - % after 'J' matches any characters following J

11. **B** - Should use IS NULL instead of = NULL
    - NULL requires IS NULL or IS NOT NULL, not comparison operators

12. **A** - WHERE department NOT IN ('HR', 'Finance')
    - NOT IN checks if value is not in the list

13. **B** - Names with 'a' as the second character
    - _ matches first character, 'a' is second, % matches rest

14. **A** - Always use parentheses to group OR conditions
    - Parentheses make intent clear and avoid precedence issues

15. **D** - All of the above
    - All three expressions are equivalent and correct

---

## Scoring

- **13-15 correct**: Excellent! You've mastered WHERE clauses
- **10-12 correct**: Good job! Review the concepts you missed
- **7-9 correct**: You're getting there. Practice more with the exercises
- **Below 7**: Review the theory section and try the exercises again

---

## Key Takeaways

✅ **WHERE filters rows** - Only rows matching conditions are returned

✅ **Comparison operators** - =, !=, <, >, <=, >=

✅ **Logical operators** - AND (all true), OR (any true), NOT (negate)

✅ **IN operator** - Match any value in a list

✅ **BETWEEN** - Range check (inclusive)

✅ **LIKE patterns** - % (zero or more), _ (exactly one)

✅ **IS NULL** - Check for NULL values (never use = NULL)

✅ **Parentheses** - Group conditions for clarity

✅ **Precedence** - NOT > AND > OR (use parentheses!)

✅ **NOT IN / NOT BETWEEN** - Negate IN and BETWEEN operators
