REM Test: String comparison operators

a$ = "ABC"
b$ = "DEF"
c$ = "ABC"

REM Equality
ASSERT a$ = c$, "ABC = ABC should be true"
ASSERT NOT (a$ = b$), "ABC = DEF should be false"

REM Not equal
ASSERT a$ <> b$, "ABC <> DEF should be true"
ASSERT NOT (a$ <> c$), "ABC <> ABC should be false"

REM Less than (lexicographic)
ASSERT a$ < b$, "ABC < DEF should be true"
ASSERT NOT (b$ < a$), "DEF < ABC should be false"

REM Greater than
ASSERT b$ > a$, "DEF > ABC should be true"
ASSERT NOT (a$ > b$), "ABC > DEF should be false"

REM Empty strings
x$ = ""
y$ = ""
ASSERT x$ = y$, "Empty strings should be equal"
