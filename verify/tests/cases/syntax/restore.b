REM Test: DATA / READ / RESTORE

DATA 10, 20, 30

READ a%
READ b%
READ c%
ASSERT a% = 10, "First READ should be 10"
ASSERT b% = 20, "Second READ should be 20"
ASSERT c% = 30, "Third READ should be 30"

REM RESTORE resets pointer to first DATA item
RESTORE
READ d%
ASSERT d% = 10, "After RESTORE, READ should give 10 again"

REM Read all again after RESTORE
RESTORE
READ x%
READ y%
READ z%
ASSERT x% = 10, "Re-read first value"
ASSERT y% = 20, "Re-read second value"
ASSERT z% = 30, "Re-read third value"
