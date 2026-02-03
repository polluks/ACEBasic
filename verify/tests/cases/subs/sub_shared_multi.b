REM Test: SUB with multiple SHARED variables
REM A SUB can share multiple variables at once

a% = 10
b% = 20
c& = 30
sum& = 0

SUB ComputeSum
  SHARED a%, b%, c&, sum&
  sum& = a% + b% + c&
END SUB

CALL ComputeSum()
ASSERT sum& = 60, "Sum of 10+20+30 should be 60"
