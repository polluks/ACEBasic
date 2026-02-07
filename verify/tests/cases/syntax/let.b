REM Test: LET keyword (explicit assignment)

LET x% = 42
ASSERT x% = 42, "LET x% = 42 should work"

LET y = 3.14
ASSERT y > 3.1, "LET with float should work"

REM LET is optional - both forms equivalent
z% = 10
LET z% = 20
ASSERT z% = 20, "LET should overwrite previous value"
