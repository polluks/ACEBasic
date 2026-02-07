REM Test: INT and FIX functions

REM INT returns largest integer <= n (floor)
ASSERT INT(3.7) = 3, "INT(3.7) should be 3"
ASSERT INT(3.2) = 3, "INT(3.2) should be 3"
ASSERT INT(3.0) = 3, "INT(3.0) should be 3"
ASSERT INT(0.5) = 0, "INT(0.5) should be 0"

REM INT with negative numbers floors down
ASSERT INT(-3.2) = -4, "INT(-3.2) should be -4"
ASSERT INT(-3.7) = -4, "INT(-3.7) should be -4"

REM FIX truncates toward zero
ASSERT FIX(3.7) = 3, "FIX(3.7) should be 3"
ASSERT FIX(3.2) = 3, "FIX(3.2) should be 3"

REM FIX with negative truncates toward zero (differs from INT)
ASSERT FIX(-3.2) = -3, "FIX(-3.2) should be -3"
ASSERT FIX(-3.7) = -3, "FIX(-3.7) should be -3"

REM Both same for positive
ASSERT INT(5.9) = FIX(5.9), "INT and FIX same for positive"
