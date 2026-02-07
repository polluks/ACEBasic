REM Test: STR$ and VAL functions

REM STR$ converts number to string
REM Note: STR$ includes leading space for positive numbers
s$ = STR$(42)
ASSERT LEN(s$) > 0, "STR$(42) should produce a non-empty string"
ASSERT VAL(s$) = 42, "VAL(STR$(42)) should be 42"

REM VAL converts string to number
ASSERT VAL("100") = 100, "VAL(100) should be 100"
ASSERT VAL("-5") = -5, "VAL(-5) should be -5"
ASSERT VAL("0") = 0, "VAL(0) should be 0"

REM Round-trip: VAL(STR$(n)) = n
x = 123
ASSERT VAL(STR$(x)) = 123, "Round-trip VAL(STR$(123))"

REM VAL with float
ASSERT VAL("3.14") > 3.1, "VAL(3.14) should be > 3.1"
ASSERT VAL("3.14") < 3.2, "VAL(3.14) should be < 3.2"

REM VAL of non-numeric returns 0
ASSERT VAL("abc") = 0, "VAL(abc) should be 0"
