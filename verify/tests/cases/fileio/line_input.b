REM Test: LINE INPUT # reads full lines

REM Write multiple lines
OPEN "O",#1,"T:testlines.dat"
PRINT #1,"Line one"
PRINT #1,"Line two"
PRINT #1,"Line three"
CLOSE #1

REM Read with LINE INPUT
OPEN "I",#1,"T:testlines.dat"

LINE INPUT #1,a$
ASSERT a$ = "Line one", "First line should be Line one"

LINE INPUT #1,b$
ASSERT b$ = "Line two", "Second line should be Line two"

LINE INPUT #1,c$
ASSERT c$ = "Line three", "Third line should be Line three"

CLOSE #1

REM Clean up
KILL "T:testlines.dat"
