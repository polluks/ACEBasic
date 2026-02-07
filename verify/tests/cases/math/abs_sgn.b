REM Test: ABS and SGN functions

REM ABS returns absolute value
ASSERT ABS(5) = 5, "ABS(5) should be 5"
ASSERT ABS(-5) = 5, "ABS(-5) should be 5"
ASSERT ABS(0) = 0, "ABS(0) should be 0"

REM ABS with floats
ASSERT ABS(-3.5) = 3.5, "ABS(-3.5) should be 3.5"
ASSERT ABS(3.5) = 3.5, "ABS(3.5) should be 3.5"

REM SGN returns sign indicator
ASSERT SGN(10) = 1, "SGN(10) should be 1"
ASSERT SGN(-10) = -1, "SGN(-10) should be -1"
ASSERT SGN(0) = 0, "SGN(0) should be 0"

REM SGN with floats
ASSERT SGN(0.5) = 1, "SGN(0.5) should be 1"
ASSERT SGN(-0.5) = -1, "SGN(-0.5) should be -1"
