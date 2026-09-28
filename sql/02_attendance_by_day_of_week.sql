-- 02_attendance_by_day_of_week
-- purpose_find which day of he week has the weakest 
-- attendance, across every course and cohort in the program
SELECT
	DAYNAME(session_date) day_of_week,
	100*SUM(status IN('Present', 'Late'))/ COUNT(*) attendance_rate
FROM attendance
WHERE status != 'Not Recorded'
GROUP BY DAYNAME(session_date)
ORDER BY attendance_rate;

-- Result : friday is weakest at 53.5%, monday strongest at 63.5

SELECT COUNT(*) FROM attendance;

-- Attendance by week in each cohort
WITH cohort_attendance AS(
SELECT 
	DAYNAME(a.session_date) day_of_week,
	c.cohort_label,
	100*SUM(a.status IN('present','Late'))/ COUNT(*) attendance_rate

FROM attendance a
JOIN enrolments e ON a.enrolment_id = e.enrolment_id
JOIN cohorts c ON e.cohort_id = c.cohort_id
WHERE a.status != 'Not Recorded'
GROUP BY C.Cohort_label, DAYNAME(a.session_date)
)
SELECT cohort_label, day_of_week, attendance_rate,
	RANK() OVER(PARTITION BY cohort_label ORDER BY attendance_rate) AS rank_
FROM cohort_attendance;