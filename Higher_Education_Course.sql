DROP DATABASE IF EXISTS EducationDB;
CREATE DATABASE EducationDB;
USE EducationDB;

CREATE TABLE CollegeCourses (
    SrNo INT PRIMARY KEY,
    District VARCHAR(100),
    Taluka VARCHAR(100),
    CollegeName VARCHAR(255),
    University VARCHAR(255),
    CollegeType VARCHAR(100),
    CourseName VARCHAR(255),
    CourseType VARCHAR(50),
    IsProfessional VARCHAR(50),
    CourseAidedStatus VARCHAR(50),
    CourseDurationMonths INT,
    CourseCategory VARCHAR(100),
    CourseDurationYears DECIMAL(5,2),
    IsGovernmentCollege VARCHAR(10)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/DA_Batch_10_Dataset.csv'
INTO TABLE CollegeCourses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE CollegeCourses
MODIFY CollegeName VARCHAR(500);

select * from CollegeCourses;

-- Q1. Find the top 5 districts with the highest number of colleges offering professional courses.
-- Count distinct colleges offering professional courses
-- Group by district and return the top 5 by count
SELECT District, COUNT(DISTINCT CollegeName) AS CollegeCount
FROM CollegeCourses
WHERE TRIM(IsProfessional) = 'Professional Course'
GROUP BY District
ORDER BY CollegeCount DESC
LIMIT 5;

/*Q2. Calculate the average course duration (in months) for each Course Type and sort them in descending order
 Calculates average duration grouped by UG, PG, etc., sorted in descending order  */
SELECT CourseType, 
ROUND(AVG(CourseDurationMonths), 2) AS AvgDuration
FROM CollegeCourses
GROUP BY CourseType
ORDER BY AvgDuration DESC;

/*Q3. Count how many unique College Names offer each Course Category
Uses COUNT DISTINCT on CollegeName grouped by CourseCategory  */
SELECT CourseCategory, 
COUNT(DISTINCT CollegeName) AS UniqueColleges
FROM CollegeCourses
GROUP BY CourseCategory;

/*Q4. Find the names of colleges offering both Post Graduate and Under Graduate courses.
Filters CourseType in UG/PG, groups by CollegeName, selects those with both  */
SELECT CollegeName
FROM CollegeCourses
WHERE CourseType IN ('Post Graduate Course', 'Under Graduate Course')
GROUP BY CollegeName
HAVING COUNT(DISTINCT CourseType) = 2;

/*Q5. List all universities that have more than 10 unaided courses that are not professional.
Applies filters on CourseAidedStatus and IsProfessional before grouping  */
SELECT University
FROM CollegeCourses
WHERE TRIM(CourseAidedStatus) = 'Unaided'
AND TRIM(IsProfessional) = 'Non-Professional Course'
GROUP BY University
HAVING COUNT(*) > 10;

/*Q6. Display colleges from the "Engineering" category that have
 at least one course with a duration greater than the category’s average.
Joins a subquery with Engineering category average to filter those exceeding it */
SELECT DISTINCT c.CollegeName
FROM CollegeCourses c
JOIN (
    SELECT AVG(CourseDurationMonths) AS avg_duration
    FROM CollegeCourses
    WHERE CourseCategory = 'Engineering'
) a
ON c.CourseDurationMonths > a.avg_duration
WHERE c.CourseCategory = 'Engineering';

/*Q7. Assign a rank to each course within a College Name based on course duration, longest first.
Uses RANK() window function partitioned by CollegeName*/
SELECT CollegeName, CourseName, CourseDurationMonths,
RANK() OVER (PARTITION BY CollegeName ORDER BY CourseDurationMonths DESC) AS DurationRank
FROM CollegeCourses;

/*Q8. Find colleges where the longest and shortest course durations are more than 24 months apart.
 Uses HAVING clause on MAX - MIN grouped by CollegeName*/
SELECT CollegeName
FROM CollegeCourses
GROUP BY CollegeName
HAVING (MAX(CourseDurationMonths) - MIN(CourseDurationMonths)) > 24;

/*Q9. Show the cumulative number of professional courses offered by each university sorted alphabetically.
 Filters for IsProfessional = 'Professional' and groups by University*/
SELECT University,
COUNT(*) AS TotalProfessionalCourses
FROM CollegeCourses
WHERE TRIM(IsProfessional) = 'Professional Course'
GROUP BY University
ORDER BY University;

/*Q10. Using a self-join or CTE, find colleges offering more than one course category.
 Group by CollegeName and count distinct CourseCategory*/
SELECT CollegeName
FROM CollegeCourses
GROUP BY CollegeName
HAVING COUNT(DISTINCT CourseCategory) > 1;

/*Q11. Create a temporary table (CTE) that includes average duration of courses by district 
and use it to list talukas where the average course duration is above the district average.
Compares district average and taluka average using CTEs and JOIN*/
WITH DistrictAvg AS (
    SELECT District, AVG(CourseDurationMonths) AS DistAvg
    FROM CollegeCourses
    GROUP BY District
),
TalukaAvg AS (
    SELECT District, Taluka, AVG(CourseDurationMonths) AS TalukaAvg
    FROM CollegeCourses
    GROUP BY District, Taluka
)
SELECT t.Taluka, t.District, t.TalukaAvg
FROM TalukaAvg t
JOIN DistrictAvg d ON t.District = d.District
WHERE t.TalukaAvg > d.DistAvg;

/*Q12. Create a new column classifying course duration as: Short (< 12 months) Medium (12-36 months) Long (> 36 months)
Then count the number of each duration type per course category.
Classifies as Short, Medium, Long using CASE and groups by CourseCategory*/
SELECT CourseCategory,
       CASE 
           WHEN CourseDurationMonths < 12 THEN 'Short'
           WHEN CourseDurationMonths BETWEEN 12 AND 36 THEN 'Medium'
           ELSE 'Long'
       END AS DurationType,
       COUNT(*) AS CountPerType
FROM CollegeCourses
GROUP BY CourseCategory, DurationType;

/*Q13. Extract only the course specialization from Course Name. 
(e.g., from "Bachelor of Engineering (B. E.) - Electrical", extract "Electrical")
Uses SUBSTRING_INDEX to extract text after last dash*/
SELECT CourseName,
       TRIM(SUBSTRING_INDEX(CourseName, '-', -1)) AS Specialization
FROM CollegeCourses
WHERE CourseName LIKE '%-%';

/*Q14. Count how many courses include the word Engineering in the name.
Uses LIKE to search for the keyword in CourseName*/
SELECT COUNT(*) AS EngineeringCourses
FROM CollegeCourses
WHERE CourseName LIKE '%Engineering%';

/*Q15. List all unique combinations of Course Name, Course Type, and Course Category.
Uses DISTINCT to fetch all unique combinations of the three fields*/
SELECT DISTINCT CourseName, CourseType, CourseCategory
FROM CollegeCourses;

/*Q16. Write a query to get all courses that are not offered by any Government college.
Uses IsGovernmentCollege column to filter out government colleges*/
SELECT *
FROM CollegeCourses
WHERE TRIM(IsGovernmentCollege) <> 'Yes';

/*Q17. Find the university that has the second-highest number of aided courses.
 Uses RANK() to rank universities by count of aided courses and selects rank 2*/
SELECT University, AidedCount
FROM (
    SELECT University, COUNT(*) AS AidedCount,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM CollegeCourses
    WHERE TRIM(CourseAidedStatus) = 'Aided'
    GROUP BY University
) ranked
WHERE rnk = 2;

/*Q19. For each University, find the percentage of unaided courses that are professional.
Calculates percentage using SUM and COUNT inside a GROUP BY*/
SELECT University,
       ROUND(
           100.0 * SUM(CASE WHEN IsProfessional = 'Professional Course' THEN 1 ELSE 0 END) /
           COUNT(*), 2
       ) AS ProfessionalPercentage
FROM CollegeCourses
WHERE CourseAidedStatus = 'Unaided'
GROUP BY University;

/*Q20. Determine which Course Category has the highest average course duration and display the top 3.
Calculates average by CourseCategory and limits to top 3 by descending average*/
SELECT CourseCategory,
       ROUND(AVG(CourseDurationMonths), 2) AS AvgDuration
FROM CollegeCourses
GROUP BY CourseCategory
ORDER BY AvgDuration DESC
LIMIT 3;
