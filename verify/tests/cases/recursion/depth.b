REM Test: Recursion depth
REM Verify recursion works at moderate depth

SUB LONGINT Countdown(n&)
  IF n& = 0 THEN
    Countdown = 0
  ELSE
    Countdown = 1 + Countdown(n& - 1)
  END IF
END SUB

REM Test increasing depths
ASSERT Countdown(10) = 10, "Depth 10"
ASSERT Countdown(50) = 50, "Depth 50"
ASSERT Countdown(100) = 100, "Depth 100"
ASSERT Countdown(200) = 200, "Depth 200"
