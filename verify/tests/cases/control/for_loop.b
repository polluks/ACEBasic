REM Test: FOR/NEXT loop
sum% = 0
FOR i% = 1 TO 5
  sum% = sum% + i%
NEXT
ASSERT sum% = 15, "Sum of 1 to 5 should equal 15"
ASSERT i% = 6, "Loop var should be 6 after loop"
