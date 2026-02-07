REM Test: SQR (square root) function

REM Perfect squares
ASSERT SQR(4) = 2, "SQR(4) should be 2"
ASSERT SQR(9) = 3, "SQR(9) should be 3"
ASSERT SQR(16) = 4, "SQR(16) should be 4"
ASSERT SQR(25) = 5, "SQR(25) should be 5"
ASSERT SQR(100) = 10, "SQR(100) should be 10"

REM SQR(0) and SQR(1)
ASSERT SQR(0) = 0, "SQR(0) should be 0"
ASSERT SQR(1) = 1, "SQR(1) should be 1"

REM Non-perfect square - check approximate value
r = SQR(2)
ASSERT r > 1.4, "SQR(2) should be > 1.4"
ASSERT r < 1.5, "SQR(2) should be < 1.5"
