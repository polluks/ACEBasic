REM Test: Recursive summation
REM Sum integers from 1 to N recursively

SUB LONGINT SumTo(n%)
  IF n% <= 0 THEN
    SumTo = 0
  ELSE
    SumTo = n% + SumTo(n% - 1)
  END IF
END SUB

ASSERT SumTo(0) = 0, "SumTo(0) = 0"
ASSERT SumTo(1) = 1, "SumTo(1) = 1"
ASSERT SumTo(5) = 15, "SumTo(5) = 15"
ASSERT SumTo(10) = 55, "SumTo(10) = 55"
ASSERT SumTo(100) = 5050, "SumTo(100) = 5050"
