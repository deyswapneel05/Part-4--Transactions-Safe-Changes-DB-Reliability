-- ============================================================================
-- TASK 1: SAFE UPDATE OPERATIONS WITH VALIDATION
-- ============================================================================

-- Example 1: Correcting invalid email values
-- BEFORE SELECT: Verify targeted record rows to ensure only the specific entity alters
SELECT student_id, name, email FROM students WHERE student_id = 101;

-- SAFE UPDATE: Targeted change restricted by unique primary key index bounds
UPDATE students 
SET email = 'swapneel.dey@mckv.edu.in' 
WHERE student_id = 101;

-- AFTER SELECT: Post-execution check to verify update integrity
SELECT student_id, name, email FROM students WHERE student_id = 101;
/* SAFETY EXPLANATION: The WHERE clause utilizes the Primary Key 'student_id'. 
   Since this attribute has a UNIQUE constraint, it guarantees exactly one row 
   is affected, preventing accidental full-table email overwrites. */


-- Example 2: Correcting missing or null batch assignments
SELECT student_id, batch_id FROM enrollments WHERE student_id = 204;

UPDATE enrollments 
SET batch_id = 'ECE-LAT-2025' 
WHERE student_id = 204 AND batch_id IS NULL;

SELECT student_id, batch_id FROM enrollments WHERE student_id = 204;
/* SAFETY EXPLANATION: Combining the relational foreign key 'student_id' with 
   an explicit 'IS NULL' check limits mutations only to unassigned records, 
   safeguarding pre-existing valid batch configurations. */


-- Example 3: Fixing incorrect score values inside test entries
SELECT result_id, score FROM test_results WHERE result_id = 4502;

UPDATE test_results 
SET score = 95 
WHERE result_id = 4502;

SELECT result_id, score FROM test_results WHERE result_id = 4502;
/* SAFETY EXPLANATION: Query mutates data through the distinct unique identity marker 
   'result_id'. This atomic approach restricts structural shifts across overlapping profiles. */


-- Example 4: Updating a processing workflow status block post-validation
SELECT submission_id, status FROM submissions WHERE submission_id = 8891;

UPDATE submissions 
SET status = 'COMPLETED' 
WHERE submission_id = 8891 AND status = 'PENDING';

SELECT submission_id, status FROM submissions WHERE submission_id = 8891;
/* SAFETY EXPLANATION: The condition requires the current operational flag to be 
   state-checked ('PENDING') concurrently with the Primary Key. If another backend process 
   updates this record first, our runtime instruction safely steps back with 0 rows affected. */
