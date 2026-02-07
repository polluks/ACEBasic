REM Test: STRING$ and SPACE$ functions

REM STRING$ creates repeated character
a$ = STRING$(5, 65)
ASSERT a$ = "AAAAA", "STRING$(5,65) should be AAAAA"
ASSERT LEN(a$) = 5, "Length should be 5"

REM STRING$ with character code for asterisk
b$ = STRING$(3, 42)
ASSERT b$ = "***", "STRING$(3,42) should be ***"
ASSERT LEN(b$) = 3, "Length should be 3"

REM SPACE$ creates spaces
c$ = SPACE$(4)
ASSERT LEN(c$) = 4, "SPACE$(4) should have length 4"

REM SPACE$(0) should be empty
d$ = SPACE$(0)
ASSERT LEN(d$) = 0, "SPACE$(0) should be empty"

REM STRING$ with 1 character
e$ = STRING$(1, 88)
ASSERT e$ = "X", "STRING$(1,88) should be X"
