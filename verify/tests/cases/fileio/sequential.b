REM Test: Sequential file I/O (OPEN, PRINT #, INPUT #, CLOSE, EOF)

REM Write data to a file
OPEN "O",#1,"T:testseq.dat"
PRINT #1,"Hello"
PRINT #1,42
PRINT #1,3.14
CLOSE #1

REM Read data back
OPEN "I",#1,"T:testseq.dat"
ASSERT NOT EOF(1), "Should not be at EOF after open"

LINE INPUT #1,s$
ASSERT s$ = "Hello", "First line should be Hello"

LINE INPUT #1,n$
ASSERT VAL(n$) = 42, "Second line should be 42"

CLOSE #1

REM Clean up
KILL "T:testseq.dat"
