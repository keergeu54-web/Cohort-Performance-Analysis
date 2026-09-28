-- 08 _Course_cohort_ranking sql
-- Purpose rank every course /cohort combination that has run in the program
-- by attenance rate alongside its completion rate to spot which specific
-- offering are understanding and wether any course repeat near the
-- bottom across mutiple


WITH att AS(
	SELECT
e.course_id,
e.cohort_id,
ROUND(100.0 * SUM(a.status IN('present', 'late'))/
	COUNT(*), 1) AS attendance_rate
FROM enrolments e
JOIN attendance a ON a.enrolment_id = e.enrolment_id
WHERE a.status!= 'Not Recorded'
GROUP BY e.course_id, e.cohort_id
),
Comp AS(
SELECT
course_id,
cohort_id,
ROUND(100.0 * SUM(status = 'Completed')
/ COUNT(*),1) AS completion_rate,
COUNT(*) AS enrolled
FROM enrolments
GROUP BY course_id, cohort_id
)
SELECT 
C.course_name,
att.cohort_id,
att.attendance_rate,
comp.completion_rate,
comp.enrolled
FROM att
JOIN comp
ON att.course_id = comp.course_id
AND att_cohort =comp.cohort_id
ORDER BY att.attendance_rate ASC;

-- Result Data analyze appear twice in the weakest five (cohort 4 and
-- cohort 5) suggesting  acourse level patern rather than one bad cohort.
-- completion rates for cohort 4,5 and 6 read low across almost every row
-- here because of the unknown _status data quality issue documented in 
-- 01 Data quality check sql not because those cohorts qenuinely performed
-- worse read completion figures for those cohort with that caveat attached
