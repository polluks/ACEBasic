REM Test: DEFINT, DEFLNG, DEFSNG, DEFSTR
REM Set default type by first letter

DEFINT a-c
a = 10
b = 20
c = 30
ASSERT a = 10, "DEFINT a should make 'a' integer"
ASSERT b = 20, "DEFINT b should make 'b' integer"
ASSERT a + b + c = 60, "Sum of DEFINT vars"

DEFLNG x-z
x = 50000&
ASSERT x = 50000, "DEFLNG x should make 'x' long"

DEFSNG m-n
m = 1.5
ASSERT m = 1.5, "DEFSNG m should make 'm' single"
