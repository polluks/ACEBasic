REM Test: Nested loop combinations
REM FOR inside FOR

sum% = 0
FOR i% = 1 TO 3
  FOR j% = 1 TO 3
    sum% = sum% + 1
  NEXT
NEXT
ASSERT sum% = 9, "3x3 nested FOR should iterate 9 times"

REM WHILE inside FOR
count% = 0
FOR i% = 1 TO 3
  w% = 1
  WHILE w% <= 2
    count% = count% + 1
    w% = w% + 1
  WEND
NEXT
ASSERT count% = 6, "WHILE(2) inside FOR(3) should iterate 6 times"

REM REPEAT inside WHILE
total% = 0
x% = 1
WHILE x% <= 2
  y% = 0
  REPEAT
    total% = total% + 1
    y% = y% + 1
  UNTIL y% >= 3
  x% = x% + 1
WEND
ASSERT total% = 6, "REPEAT(3) inside WHILE(2) should iterate 6 times"
