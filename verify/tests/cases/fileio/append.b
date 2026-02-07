REM Test: Append mode (OPEN "A")

REM Create file with initial content
OPEN "O",#1,"T:testapp.dat"
PRINT #1,"First"
CLOSE #1

REM Append to file
OPEN "A",#1,"T:testapp.dat"
PRINT #1,"Second"
CLOSE #1

REM Read back - should have both lines
OPEN "I",#1,"T:testapp.dat"
LINE INPUT #1,a$
ASSERT a$ = "First", "First line should be preserved"
LINE INPUT #1,b$
ASSERT b$ = "Second", "Appended line should be present"
CLOSE #1

REM Clean up
KILL "T:testapp.dat"
