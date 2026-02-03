REM Test: DATA/READ with signed numeric values
REM Tests negative number handling in DATA statements

DIM SHORTINT vals(4)

DATA 5, -3, 0, -1

FOR i = 1 TO 4
  READ vals(i)
NEXT

ASSERT vals(1) = 5, "DATA value 1 should be 5"
ASSERT vals(2) = -3, "DATA value 2 should be -3"
ASSERT vals(3) = 0, "DATA value 3 should be 0"
ASSERT vals(4) = -1, "DATA value 4 should be -1"
