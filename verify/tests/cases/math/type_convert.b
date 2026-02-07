REM Test: CINT, CLNG, CSNG type conversion

REM CINT converts to short integer with rounding
ASSERT CINT(3.2) = 3, "CINT(3.2) should be 3"
ASSERT CINT(3.7) = 4, "CINT(3.7) should be 4"
ASSERT CINT(3.5) = 4, "CINT(3.5) should round up to 4"
ASSERT CINT(-2.3) = -2, "CINT(-2.3) should be -2"
ASSERT CINT(-2.7) = -3, "CINT(-2.7) should be -3"

REM CLNG converts to long integer with rounding
LONGINT r
r = CLNG(100.7)
ASSERT r = 101, "CLNG(100.7) should be 101"
r = CLNG(100.2)
ASSERT r = 100, "CLNG(100.2) should be 100"

REM CSNG converts to single precision
v = CSNG(42)
ASSERT v = 42, "CSNG(42) should be 42.0"
