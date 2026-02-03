REM Test: GOTO statement
skipped% = 0
GOTO skip
skipped% = 1
skip:
ASSERT skipped% = 0, "GOTO should skip assignment"
