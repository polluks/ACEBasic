REM Test: WHILE with initially false condition
REM Body should never execute

flag% = 0
WHILE 0
  flag% = 1
WEND
ASSERT flag% = 0, "WHILE with false condition should not execute body"

REM Condition false from the start
x% = 10
count% = 0
WHILE x% < 5
  count% = count% + 1
  x% = x% + 1
WEND
ASSERT count% = 0, "WHILE with initially false var should not execute"
ASSERT x% = 10, "Variable should be unchanged"
