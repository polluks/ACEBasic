REM Test: FOR/NEXT with STEP
sum% = 0
FOR i% = 10 TO 2 STEP -2
  sum% = sum% + i%
NEXT
ASSERT sum% = 30, "Sum of 10,8,6,4,2 should equal 30"
ASSERT i% = 0, "Loop var should be 0 after loop"
