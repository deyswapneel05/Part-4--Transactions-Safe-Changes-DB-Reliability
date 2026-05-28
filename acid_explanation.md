# Comprehensive Architectural Breakdown of ACID Properties

Using the multi-table code submission scenario implemented inside `transactions.sql` (Scenario 1), here is how the relational database engine guarantees maximum data consistency using ACID parameters:

## 1. Atomicity ("All or Nothing")
*   **Application:** When a user uploads a code file, the database engine processes two actions: appending a row to `submissions` and appending runtime telemetry logs to `test_results`. 
*   **Guaranteed Guardrail:** Atomicity ensures that if the system crashes midway (e.g., right after injecting the submission row but before recording runtime profiles), the database completely wipes the footprint. You will never encounter a broken dashboard showing a submission identity missing its accompanying performance evaluations.

## 2. Consistency (State Integrity)
*   **Application:** Relational structures maintain strict operational rules, including `Foreign Key` restraints requiring that a `student_id` must validly exist inside the parent profile index before generating transactions.
*   **Guaranteed Guardrail:** If an application routine attempts to commit a code score for a non-existent student account, the execution triggers a consistency error. The operational runtime prevents the transition from a valid state to a corrupt, broken state.

## 3. Isolation (Concurrency Control)
*   **Application:** Imagine thousands of students submit exam answers simultaneously at the end of a competitive round. 
*   **Guaranteed Guardrail:** Isolation parameters ensure that Transaction A (calculating your submission metrics) operates inside a virtual workspace independent of Transaction B (processing a classmate's code parameters on the exact same table). The engine blocks dirty reads or unexpected phantom mutations until a clean `COMMIT` is executed.

## 4. Durability (Permanent Persistence)
*   **Application:** The absolute final operational call is when the server engine responds with a clean `COMMIT` verification.
*   **Guaranteed Guardrail:** Once `COMMIT` executes, transaction records are flushed into non-volatile system disk arrays and recorded inside transaction redo logs. Even if a sudden power loss darkens the data center a millisecond later, the data remains safely recoverable upon system restart.
