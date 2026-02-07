REM Test: DEF FN inline function

DEF FNsquare%(x%) = x% * x%
ASSERT FNsquare%(4) = 16, "FNsquare(4) should be 16"
ASSERT FNsquare%(0) = 0, "FNsquare(0) should be 0"
ASSERT FNsquare%(-3) = 9, "FNsquare(-3) should be 9"

REM DEF FN with single precision
DEF FNhalf(x) = x / 2.0
ASSERT FNhalf(10.0) = 5.0, "FNhalf(10.0) should be 5.0"

REM DEF FN with multiple params
DEF FNsum%(a%, b%) = a% + b%
ASSERT FNsum%(3, 7) = 10, "FNsum(3,7) should be 10"
