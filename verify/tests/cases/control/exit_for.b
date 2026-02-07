REM Test: EXIT FOR
REM Premature exit from FOR loop

last% = 0
FOR i% = 1 TO 10
  IF i% = 5 THEN EXIT FOR
  last% = i%
NEXT
ASSERT last% = 4, "EXIT FOR at 5 means last completed iteration was 4"
ASSERT i% = 5, "Loop var should be 5 when EXIT FOR fired"

REM EXIT FOR in nested loop only exits inner loop
outer% = 0
inner_sum% = 0
FOR j% = 1 TO 3
  FOR k% = 1 TO 100
    IF k% > 2 THEN EXIT FOR
    inner_sum% = inner_sum% + 1
  NEXT
  outer% = outer% + 1
NEXT
ASSERT outer% = 3, "Outer loop should complete all 3 iterations"
ASSERT inner_sum% = 6, "Inner loop should run 2 times per outer (2*3=6)"
