-- ============================================================================
-- TASK 3: ADVANCED TRANSACTION CONTROL SCENARIOS
-- ============================================================================

-- Scenario 1: Solution Upload Sequence with Automatic Sub-Result Row Tracking
BEGIN TRANSACTION;

INSERT INTO submissions (submission_id, student_id, problem_id, status)
VALUES (9901, 101, 50, 'PROCESSING');

INSERT INTO test_results (result_id, submission_id, runtime_ms, memory_kb)
VALUES (77001, 9901, 120, 4096);

-- Standard execution confirmation seals both relational steps instantly
COMMIT;
-- Expected Final State: Both records are permanently saved. If either step failed, the app aborts cleanly.


-- Scenario 2: Enrollment Routine Rollback triggered by broken/invalid inputs
BEGIN TRANSACTION;

INSERT INTO enrollments (enrollment_id, student_id, batch_id)
VALUES (550, 999, 'CSE-ADV-2026'); 

-- Application logic validates student_id '999' as non-existent (Foreign Key anomaly simulation)
-- Intercept triggered, state returns to clean origin conditions
ROLLBACK;
-- Expected Final State: The database instantly returns to its pre-transaction state; no orphan row is committed.


-- Scenario 3: Complex Multi-step Updates relying on Partial Checkpoints (SAVEPOINTS)
BEGIN TRANSACTION;

-- Step A: Standard Registration Parameter Setup
INSERT INTO registrations (reg_id, student_id, course_fee) 
VALUES (301, 101, 123000);

-- Establish Safe Restore Checkpoint
SAVEPOINT RegistrationBase;

-- Step B: Apply Optional Add-on Lab Module parameters
INSERT INTO registration_addons (addon_id, reg_id, addon_type) 
VALUES (9001, 301, 'Advanced-AI-Lab');

-- Validation reveals the user is over-allocated or changes their mind. Rollback addon ONLY.
ROLLBACK TO SAVEPOINT RegistrationBase;

-- Complete the core sequence cleanly
COMMIT;
-- Expected Final State: Core registration (reg_id 301) stays committed, while optional addon (addon_id 9001) is cleanly discarded.
