REM Test: REPEAT/UNTIL loop
x% = 1
sum% = 0
REPEAT
  sum% = sum% + x%
  x% = x% + 1
UNTIL x% > 5
ASSERT sum% = 15, "Sum of 1 to 5 should equal 15"
ASSERT x% = 6, "x% should be 6 after loop"
