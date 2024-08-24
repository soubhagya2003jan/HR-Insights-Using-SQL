 -- What is the average age of employees in each department?

 SELECT Department, AVG(MonthlyIncome) AS salary
 FROM hr_analytics
 GROUP BY Department;

/* Average Salary for r&d is $6280,
   Sales $6967,
   Human Resource $6655
*/

-- How many employees are in each AgeGroup?

SELECT AgeGroup, COUNT(EmployeeNumber) AS num_of_employee
FROM hr_analytics
GROUP BY AgeGroup;

/* Maximum number of employees are in 26-35 age group */

-- What is the attrition rate by department?

WITH Attriton_rate AS (
                   SELECT Department,
                   COUNT( CASE
           WHEN Attrition = 'Yes' THEN EmployeeNumber END)
AS number_employee_yes,
                       COUNT(CASE WHEN Attrition = 'No' THEN EmployeeNumber END )
                   AS number_of_employee_no
FROM hr_analytics
GROUP BY Department
    )
SELECT Department,
       ROUND(AVG(number_employee_yes/number_of_employee_no) * 100,0) AS Attrition_rate_employee
FROM Attriton_rate
GROUP BY Department;

/* R&D attrition rate is 16
   Sales = 26
   Human Resource = 25
*/

-- Which JobRole has the highest number of employees who travel frequently for business?


SELECT hr_analytics.JobRole,
       count(hr_analytics.EmployeeNumber) AS employees
FROM hr_analytics
WHERE BusinessTravel = 'Travel_Frequently'
GROUP BY hr_analytics.JobRole
ORDER BY employees DESC
LIMIT 1;

/* Maximum Number of employees are in Sales Department Who Travel Frequently
*/

-- What is the average DailyRate by JobLevel?

SELECT hr_analytics.JobRole, AVG(hr_analytics.DailyRate)
FROM  hr_analytics
GROUP BY JobRole;

/* Highest Daily Rate is of Laboratory Technician */

-- How does the average Distance From Home vary across different departments?

SELECT hr_analytics.Department, AVG(hr_analytics.DistanceFromHome) AS avg_distance
FROM hr_analytics
GROUP BY hr_analytics.Department;

/* Average Distance is around 8 - 10 Km */


-- What is the highest level of Education achieved by employees in the Sales department?

SELECT hr_analytics.EmployeeNumber,hr_analytics.Department
FROM  hr_analytics
WHERE Department = 'Sales' AND Education > 4;

-- Calculate the cumulative MonthlyIncome for each department.


    SELECT EmployeeNumber,
       SUM(MonthlyIncome) OVER (PARTITION BY EmployeeNumber ORDER BY MonthlyIncome) AS CumulativeMonthlyIncome
FROM hr_analytics
ORDER BY MonthlyIncome DESC;


-- Which JobRole has the highest Monthly Income?

SELECT JobRole,
       MAX(MonthlyIncome) AS HighestMonthlyIncome
FROM hr_analytics
GROUP BY JobRole
ORDER BY HighestMonthlyIncome DESC
LIMIT 1;

/* Manager have the highest monthly income */


-- How many employees work overtime (OverTime) in each department?

SELECT hr_analytics.Department,
       COUNT(CASE WHEN hr_analytics.OverTime = 'Yes' THEN hr_analytics.EmployeeNumber END) as overtime_emp
FROM hr_analytics
GROUP BY Department;

/* R&D have 272 employees who do overtime
   sales have 129 while Hr have 17
*/

-- What is the top 3 highest DailyRate across all employees?

SELECT hr_analytics.EmployeeNumber, AVG(hr_analytics.DailyRate) AS dr
FROM hr_analytics
GROUP BY hr_analytics.EmployeeNumber
ORDER BY dr DESC
LIMIT 3;

-- Find the average JobSatisfaction for each department

SELECT hr_analytics.Department,
       ROUND(AVG(hr_analytics.JobSatisfaction),2)
           AS job_sat
FROM hr_analytics
GROUP BY hr_analytics.Department;

-- What is the average YearsAtCompany of employees who received a promotion (YearsSinceLastPromotion) within the last 2 years?

SELECT AVG(YearsAtCompany) AS AverageYearsAtCompany
FROM hr_analytics
WHERE YearsSinceLastPromotion <= 2;

-- What is the total number of employees in each department?

SELECT hr_analytics.Department,
       SUM(hr_analytics.EmployeeCount)
           AS Total_employee
FROM hr_analytics
GROUP BY Department;

-- Calculate the percentage of total employees working in each department.

SELECT Department,
       COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hr_analytics) AS PercentageOfTotalEmployees
FROM hr_analytics
GROUP BY Department
ORDER BY PercentageOfTotalEmployees DESC;

/* R&D 65%
   SALES 30%
   HR 5%
*/


-- Rank employees by their TotalWorkingYears within their department.

SELECT Department,
       EmployeeNumber,
       RANK() OVER(PARTITION BY Department ORDER BY TotalWorkingYears) AS rnk
FROM hr_analytics
ORDER BY Department, rnk;

-- What is the median MonthlyIncome in each department?

WITH RankedIncome AS (
    SELECT Department,
           MonthlyIncome,
           ROW_NUMBER() OVER (PARTITION BY Department ORDER BY MonthlyIncome) AS rn,
           COUNT(*) OVER (PARTITION BY Department) AS total_count
    FROM hr_analytics
),
MedianIncome AS (
    SELECT Department,
           MonthlyIncome
    FROM RankedIncome
    WHERE rn = (total_count + 1) / 2
       OR rn = (total_count + 2) / 2
)
SELECT Department,
       AVG(MonthlyIncome) AS MedianMonthlyIncome
FROM MedianIncome
GROUP BY Department;

/* Median Salary of hr is $3886
   R&D is $4377
   Sales is $5765
*/
