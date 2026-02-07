REM Test: CONST named constants

CONST MAX = 100
CONST MIN = -50
CONST PI_APPROX = 3

ASSERT MAX = 100, "CONST MAX should be 100"
ASSERT MIN = -50, "CONST MIN should be -50"
ASSERT PI_APPROX = 3, "CONST PI_APPROX should be 3"

REM Use in expressions
x% = MAX + MIN
ASSERT x% = 50, "MAX + MIN should be 50"

REM Multiple consts on one line
CONST A = 1, B = 2, C = 3
ASSERT A = 1, "CONST A should be 1"
ASSERT B = 2, "CONST B should be 2"
ASSERT C = 3, "CONST C should be 3"
