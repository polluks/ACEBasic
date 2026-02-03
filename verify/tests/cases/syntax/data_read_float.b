REM Test: DATA/READ with floating point values
REM Tests FFP conversion in DATA statements

DIM SINGLE fvals(3)

DATA 1.5, 2.0, -0.5

FOR i = 1 TO 3
  READ fvals(i)
NEXT

ASSERT fvals(1) > 1.4, "DATA float 1 should be > 1.4"
ASSERT fvals(1) < 1.6, "DATA float 1 should be < 1.6"
ASSERT fvals(2) = 2.0, "DATA float 2 should be 2.0"
ASSERT fvals(3) > -0.6, "DATA float 3 should be > -0.6"
ASSERT fvals(3) < -0.4, "DATA float 3 should be < -0.4"
