REM Test: SUB function returning a value
REM Return value assigned to function name

SUB SHORTINT Double(n%)
  Double = n% * 2
END SUB

r% = Double(5)
ASSERT r% = 10, "Double(5) should return 10"

r% = Double(0)
ASSERT r% = 0, "Double(0) should return 0"

r% = Double(-3)
ASSERT r% = -6, "Double(-3) should return -6"

REM Function returning single
SUB SINGLE Half(x)
  Half = x / 2.0
END SUB

h = Half(10.0)
ASSERT h = 5.0, "Half(10.0) should return 5.0"
