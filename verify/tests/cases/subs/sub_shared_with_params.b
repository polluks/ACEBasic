REM Test: SUB with both parameters and SHARED variables
REM A SUB can use both passed parameters and shared variables

multiplier% = 10
result% = 0

SUB Compute(n%)
  SHARED multiplier%, result%
  result% = n% * multiplier%
END SUB

CALL Compute(5)
ASSERT result% = 50, "5 * 10 should be 50"
CALL Compute(7)
ASSERT result% = 70, "7 * 10 should be 70"
