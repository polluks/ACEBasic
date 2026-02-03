REM Test: DATA/READ with numeric values
REM This test catches regressions in FFP conversion for DATA statements

DIM SHORTINT arr(7)

DATA 1, 1, 1, 0, 1, 1, 1

FOR i = 1 TO 7
  READ arr(i)
NEXT

ASSERT arr(1) = 1, "DATA value 1 should be 1"
ASSERT arr(2) = 1, "DATA value 2 should be 1"
ASSERT arr(3) = 1, "DATA value 3 should be 1"
ASSERT arr(4) = 0, "DATA value 4 should be 0"
ASSERT arr(5) = 1, "DATA value 5 should be 1"
ASSERT arr(6) = 1, "DATA value 6 should be 1"
ASSERT arr(7) = 1, "DATA value 7 should be 1"
