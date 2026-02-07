REM Test: REPEAT with immediately true UNTIL condition
REM Body should execute exactly once

count% = 0
REPEAT
  count% = count% + 1
UNTIL -1
ASSERT count% = 1, "REPEAT with immediately true UNTIL should run once"

REM Another case: condition true on first check
x% = 10
runs% = 0
REPEAT
  runs% = runs% + 1
UNTIL x% > 5
ASSERT runs% = 1, "REPEAT body should execute exactly once"
