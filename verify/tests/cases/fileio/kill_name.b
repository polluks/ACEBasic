REM Test: KILL (delete) and NAME (rename)

REM Create a file
OPEN "O",#1,"T:testkill.dat"
PRINT #1,"test data"
CLOSE #1

REM NAME renames the file
NAME "T:testkill.dat" AS "T:testrenamed.dat"

REM Renamed file should be readable
OPEN "I",#1,"T:testrenamed.dat"
LINE INPUT #1,s$
ASSERT s$ = "test data", "Renamed file should have original content"
CLOSE #1

REM KILL deletes the file
KILL "T:testrenamed.dat"
