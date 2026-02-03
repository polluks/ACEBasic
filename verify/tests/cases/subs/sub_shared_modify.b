REM Test: SUB modifying a SHARED variable
REM A SUB can modify a shared variable and the main program sees the change

counter% = 5

SUB IncrementCounter
  SHARED counter%
  counter% = counter% + 1
END SUB

ASSERT counter% = 5, "Initial counter should be 5"
CALL IncrementCounter()
ASSERT counter% = 6, "After first increment should be 6"
CALL IncrementCounter()
ASSERT counter% = 7, "After second increment should be 7"
