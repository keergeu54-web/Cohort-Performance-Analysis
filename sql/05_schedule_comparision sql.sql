-- 05 schedule_comparision. sql

-- question:

-- Does the number of training  day per week affect attendance?

-- cohort 2 to 5 used a three day week (MWF) , while cohort 6
-- used a five_day week (MTWTF)

SELECT
	c.schedule,
    ROUND(100 * SUM(a.status IN ('present', 'late'))/ COUNT(*)
    ) AS attendance_rate,
    COUNT(*) AS n
FROM attendance a
JOIN enrolments e ON a.enrolment_id = e.enrolment_id
JOIN cohorts c ON e.cohort_id = c.cohort_id

WHERE a.status <> 'Not Recorded'
GROUP BY C.schedule;

-- Result:
-- Attendance is almost the same under both schedule:
-- 58.0% for the five day week and 58.9% for the three day week
-- the different is less than one percentage point, suggesting
-- that the change in weekly schedule had little different in
-- attendance based on the available date