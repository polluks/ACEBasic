REM Test: LEN string function

REM Empty string
ASSERT LEN("") = 0, "LEN of empty string should be 0"

REM Single character
ASSERT LEN("A") = 1, "LEN of single char should be 1"

REM Normal string
ASSERT LEN("Hello") = 5, "LEN of Hello should be 5"

REM String with spaces
ASSERT LEN("A B C") = 5, "LEN of A B C should be 5"

REM Variable
a$ = "Testing"
ASSERT LEN(a$) = 7, "LEN of Testing should be 7"

REM Empty variable
b$ = ""
ASSERT LEN(b$) = 0, "LEN of empty variable should be 0"
