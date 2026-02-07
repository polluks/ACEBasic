REM Test: INSTR function

a$ = "Hello World"

REM Basic search
ASSERT INSTR(a$, "World") = 7, "World starts at position 7"
ASSERT INSTR(a$, "Hello") = 1, "Hello starts at position 1"
ASSERT INSTR(a$, "o") = 5, "First o is at position 5"

REM Not found
ASSERT INSTR(a$, "xyz") = 0, "xyz not found should return 0"

REM Search with start position
ASSERT INSTR(6, a$, "o") = 8, "o from position 6 should be at 8"
ASSERT INSTR(1, a$, "Hello") = 1, "Hello from 1 should be at 1"

REM Single character search
ASSERT INSTR(a$, "H") = 1, "H should be at position 1"
ASSERT INSTR(a$, "d") = 11, "d should be at position 11"

REM Empty needle
ASSERT INSTR(a$, "") = 1, "Empty needle should return 1"
