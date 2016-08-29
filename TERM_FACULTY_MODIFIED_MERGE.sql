/* Oracle. Start Prep: Term Faculty Added or Modified. Supporting visualization tool for system admins monitoring automated faculty assignment creation processes. Counts of enrollments added to a given DSK including Row and Availability status.
*/

SELECT 
  'The Faculty DSK <b>'||TERM_ENROLLMENT_DSK||'</b><ul><li> Was modified on '||TERM_ENROLLMENTS_MODIFIED||'.</li><li>'||ENABLED_COUNT||' faculty assignments are ENABLED/AVAILABLE in the DSK.</li><li>'||DISABLED_COUNT||' faculty assignments are DISABLED in the DSK.</li><li>'||UNAVAILABLE_COUNT||' faculty assignments are UNAVAILABLE in the DSK.</li></ul><br>' AS MESSAGE, TERM_COUNT AS THE_COUNT
FROM
(SELECT 
  MAX(CU.DTMODIFIED) AS TERM_ENROLLMENTS_MODIFIED
  ,COUNT(DS.BATCH_UID) AS TERM_COUNT
  ,DS.BATCH_UID AS TERM_ENROLLMENT_DSK
  ,COUNT(CASE WHEN (CU.ROW_STATUS=0 AND CU.AVAILABLE_IND='Y') THEN 1 END) AS ENABLED_COUNT
  ,COUNT(CASE WHEN CU.ROW_STATUS=2 THEN 1 END) AS DISABLED_COUNT
  ,COUNT(CASE WHEN CU.AVAILABLE_IND='N' THEN 1 END) AS UNAVAILABLE_COUNT
FROM bblearn.data_source DS
INNER JOIN bblearn.COURSE_USERS CU
  ON DS.PK1=CU.DATA_SRC_PK1
WHERE CU.DTMODIFIED > sysdate-7
AND DS.BATCH_UID LIKE 'FAC_%'
GROUP BY DS.BATCH_UID, CU.ROW_STATUS,CU.AVAILABLE_IND
ORDER BY DS.BATCH_UID DESC, CU.ROW_STATUS,CU.AVAILABLE_IND ASC)