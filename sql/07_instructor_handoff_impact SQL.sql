-- 07 _ instructor_handoff_impact.sql

WITH multiple_instructors AS(

SELECT 
	course_id,
	cohort_id,
    COUNT(*) AS assigments
FROM instructor_assignments
GROUP BY course_id, cohort_id
HAVING COUNT(*) > 1
)
SELECT
i.course_id,
i.cohort_id,
i.instructor_id,
i.start_date,
i.end_date,
ROUND(
	SUM(a.status IN('Present', 'late')) / COUNT(*) *100, 1
    ) AS attendance_rate,
    COUNT(*) sessions
FROM instructor_assignments i
JOIN enrolments e ON i.course_id = e.course_id AND i.cohort_id = e.cohort_id
JOIN attendance a ON e.enrolment_id = a.enrolment_id
	AND	a.session_date BETWEEN i.start_date AND i.end_date
WHERE (i.course_id, i.cohort_id) IN (SELECT course_id, cohort_id FROM multiple_instructors)
GROUP BY i.course_id, i.cohort_id, i.instructor_id, i.start_date, i.end_date;