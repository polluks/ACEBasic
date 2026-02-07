REM Test: EXIT SUB
REM Early return from subprogram

flag% = 0

SUB EarlyReturn(n%)
  SHARED flag%
  IF n% < 0 THEN EXIT SUB
  flag% = 1
END SUB

CALL EarlyReturn(-1)
ASSERT flag% = 0, "EXIT SUB should skip rest of SUB body"

flag% = 0
CALL EarlyReturn(1)
ASSERT flag% = 1, "Normal path should set flag"

REM EXIT SUB with return value
SUB SHORTINT SafeDiv(a%, b%)
  IF b% = 0 THEN
    SafeDiv = 0
    EXIT SUB
  END IF
  SafeDiv = a% / b%
END SUB

r% = SafeDiv(10, 2)
ASSERT r% = 5, "SafeDiv(10,2) should return 5"
r% = SafeDiv(10, 0)
ASSERT r% = 0, "SafeDiv(10,0) should return 0 via EXIT SUB"
