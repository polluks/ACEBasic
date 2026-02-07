REM Test: LOF, HANDLE file functions

REM Create a file with known content
OPEN "O",#1,"T:testfunc.dat"
PRINT #1,"ABCDE"
CLOSE #1

REM Open and check LOF (file length)
OPEN "I",#1,"T:testfunc.dat"
LONGINT flen
flen = LOF(1)
ASSERT flen > 0, "LOF should be > 0 for non-empty file"

REM HANDLE should return a valid DOS handle
LONGINT h
h = HANDLE(1)
ASSERT h <> 0, "HANDLE should return non-zero"
CLOSE #1

REM Clean up
KILL "T:testfunc.dat"
