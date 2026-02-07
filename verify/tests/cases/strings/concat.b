REM Test: String concatenation

a$ = "Hello"
b$ = " "
c$ = "World"

REM Basic concatenation
d$ = a$ + b$ + c$
ASSERT d$ = "Hello World", "Concatenation should produce Hello World"

REM Concatenation with literals
e$ = "ABC" + "DEF"
ASSERT e$ = "ABCDEF", "Literal concat should produce ABCDEF"

REM Concatenation with empty string
f$ = a$ + ""
ASSERT f$ = "Hello", "Concat with empty should be unchanged"

g$ = "" + a$
ASSERT g$ = "Hello", "Empty + string should be the string"

REM Multiple concatenations
h$ = "A" + "B" + "C" + "D"
ASSERT h$ = "ABCD", "Multiple concats should produce ABCD"
ASSERT LEN(h$) = 4, "Length of ABCD should be 4"
