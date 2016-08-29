/* Oracle. SCORM duration in course context - displays time spent per SCORM launch in contextual class. */

SELECT 
      cc.title AS item_title
      , u.user_id
      , ROUND((sl.exit_time - sl.launch_time) * 24 *60,2) AS Minutes_In_Session
      , ROUND(STATS_MODE(experienced_duration_tracked/60000),2) AS Mode_Minutes
      , sl.completion
      , CASE sl.completion
          WHEN 'complete' then trunc(sl.exit_time)
          ELSE NULL
        END AS SUBMIT_DATE
from bblearn.scormregistration sr
left outer join bblearn.scormlaunchhistory sl on sl.scorm_registration_id = sr.scorm_registration_id
left outer join bblearn.course_contents cc on cc.pk1 = to_number(trim(REGEXP_SUBSTR(sr.content_id, '[^_]+')))
left outer join bblearn.course_main cm on cm.pk1 = cc.crsmain_pk1
INNER JOIN bblearn.users u 
  ON u.user_id = sr.global_objective_scope
INNER JOIN bblearn.course_contents cc_parent 
  ON cc.parent_pk1 = cc_parent.pk1
 WHERE cm.pk1 = :ctx_course_pk1
GROUP BY cc.title, u.user_id, ROUND((sl.exit_time - sl.launch_time) * 24 *60,2), sl.exit_time, sl.completion
;