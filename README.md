# 🎓 Higher Education Course SQL Analysis

This project involves a comprehensive SQL-based exploration of a dataset related to higher education courses across various colleges, universities, and districts. The objective was to analyze structural, operational, and demographic patterns in course offerings using real-world data.

---

## 📌 Project Objective

To demonstrate SQL proficiency by writing 20 structured queries that extract meaningful insights from a dataset representing higher education courses in India. The goal was to explore and analyze course categories, college types, affiliations, durations, and geographic trends.

---

## 🗃️ Dataset Overview

- **Table Name:** `CollegeCourses`
- **Total Rows:** 58,000+
- **Columns (14):**
  - `SrNo`, `District`, `Taluka`, `CollegeName`, `University`, `CollegeType`
  - `CourseName`, `CourseType`, `IsProfessional`, `CourseAidedStatus`
  - `CourseDurationMonths`, `CourseCategory`, `CourseDurationYears`, `IsGovernmentCollege`

---

## 📊 SQL Tasks Performed

A total of **20 SQL queries** were written and tested, covering:

1. Top districts offering professional courses
2. Average course duration by type
3. Unique colleges per course category
4. Colleges offering both UG and PG
5. Unaided + non-professional course analysis
6. Courses above category average duration
7. Ranking courses by duration within colleges
8. Duration range analysis per college
9. Professional course count by university
10. Multi-category colleges
11. Taluka vs. district duration averages
12. Duration classification (short/medium/long)
13. Specialization extraction from course names
14. Courses with 'Engineering' in name
15. Unique course-name/type/category combos
16. Non-Government course listings
17. Second-highest aided course university
18. Courses above median duration
19. % of unaided courses that are professional
20. Top 3 categories by average course duration

---

## 📌 SQL Features Used

- `GROUP BY`, `ORDER BY`, `HAVING`
- `JOIN`, `CTE`, `RANK()`, `CASE`
- `SUBSTRING_INDEX`, `LIMIT`, `OFFSET`
- Conditional aggregation and filtering
- Simulated median using subqueries

---

## ✅ Conclusion

This project provided hands-on experience in working with large, structured datasets using SQL. I was able to explore the educational landscape across institutions and regions and apply advanced SQL techniques to generate analytical insights.

---

## 🧠 Key Takeaways

- SQL is a powerful tool for querying and analyzing relational datasets with precision.
- Writing 20+ queries helped solidify understanding of filtering, aggregation, joins, and analytical functions.
- The insights gained can support strategic decisions like regional policy planning, course optimization, and student targeting.

---

## 📂 Repository Contents

- `CollegeCourses.sql` — Table creation and data import
- `SQL_Task_Batch_10_Answered_With_Comments.sql` — All 20 SQL queries with comments
- `README.md` — Project overview and documentation

---

## 🙌 Author

**Pratham Nagar**  
[GitHub Profile](https://github.com/NagarPratham)

---

## 📬 Feedback

Feel free to open issues or submit pull requests if you'd like to suggest improvements or collaborate!
