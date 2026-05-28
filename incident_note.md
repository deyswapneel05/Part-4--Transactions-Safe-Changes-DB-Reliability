# Engineering Reliability Incident Note: Dangerous Non-Isolated Mutations

## 1. What Went Wrong (Root Cause Analysis)
A developer intends to clear out a dummy evaluation logging record from the live production context (`test_results`). However, due to haste or lack of a peer-review filter, they execute a destructive DML operation completely missing a defining filter criterion:
```sql
-- HIGH RISK RISK OPERATION EXECUTED:
DELETE FROM test_results;
