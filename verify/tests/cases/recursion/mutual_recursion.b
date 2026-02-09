REM Test: Mutual recursion
REM IsEven and IsOdd call each other

DECLARE SUB SHORTINT IsOdd(n%)

SUB SHORTINT IsEven(n%)
  IF n% = 0 THEN
    IsEven = -1
  ELSE
    IsEven = IsOdd(n% - 1)
  END IF
END SUB

SUB SHORTINT IsOdd(n%)
  IF n% = 0 THEN
    IsOdd = 0
  ELSE
    IsOdd = IsEven(n% - 1)
  END IF
END SUB

ASSERT IsEven(0) = -1, "0 is even"
ASSERT IsOdd(0) = 0, "0 is not odd"
ASSERT IsEven(1) = 0, "1 is not even"
ASSERT IsOdd(1) = -1, "1 is odd"
ASSERT IsEven(4) = -1, "4 is even"
ASSERT IsOdd(5) = -1, "5 is odd"
ASSERT IsEven(7) = 0, "7 is not even"
ASSERT IsOdd(8) = 0, "8 is not odd"
