-- ============================================================================
-- TASK 2: SAFE DELETE OPERATIONS WITH VALIDATION
-- ============================================================================

-- Example 1: Eliminating duplicate redundant staging log row signatures
-- BEFORE SELECT: Verify row configurations and duplicate identification markers
SELECT session_id, count(*) FROM user_sessions GROUP BY session_id HAVING count(*) > 1;

-- SAFE DELETE: Purging matching logs while isolating one unique baseline entry
DELETE FROM user_sessions 
WHERE session_id = 7012 
  AND rowid NOT IN (SELECT MIN(rowid) FROM user_sessions WHERE session_id = 7012);

-- AFTER SELECT: Verify duplicate instance drops safely without loss of the origin core data
SELECT session_id FROM user_sessions WHERE session_id = 7012;
/* SAFETY EXPLANATION: By deploying subquery filters to anchor the internal minimum 
   row pointer (MIN rowid), we drop rogue identical loops while keeping one valid reference record alive. */


-- Example 2: Dropping system orphan entries after rigorous integrity checks
SELECT e.enrollment_id, e.student_id 
FROM enrollments e 
LEFT JOIN students s ON e.student_id = s.student_id 
WHERE s.student_id IS NULL;

DELETE FROM enrollments 
WHERE student_id NOT IN (SELECT student_id FROM students);

SELECT enrollment_id FROM enrollments WHERE student_id NOT IN (SELECT student_id FROM students);
/* SAFETY EXPLANATION: This destructive action targets strictly unmapped student vectors. 
   It cleans relational integrity anomalies without impacting legitimate active user profiles. */
