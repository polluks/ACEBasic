REM Test: WHILE/WEND loop
x% = 1
sum% = 0
WHILE x% <= 5
  sum% = sum% + x%
  x% = x% + 1
WEND
ASSERT sum% = 15, "Sum of 1 to 5 should equal 15"
ASSERT x% = 6, "x% should be 6 after loop"
