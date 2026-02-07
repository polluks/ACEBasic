REM Test: WRITE # formatted output

REM WRITE # produces delimited output
OPEN "O",#1,"T:testwr.dat"
WRITE #1,10,20,30
CLOSE #1

REM Read back and verify
OPEN "I",#1,"T:testwr.dat"
INPUT #1,a%,b%,c%
ASSERT a% = 10, "First WRITE value should be 10"
ASSERT b% = 20, "Second WRITE value should be 20"
ASSERT c% = 30, "Third WRITE value should be 30"
CLOSE #1

REM Clean up
KILL "T:testwr.dat"
