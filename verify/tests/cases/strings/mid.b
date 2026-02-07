REM Test: MID$ string function

a$ = "Hello World"

REM MID$ with start and length
ASSERT MID$(a$, 1, 5) = "Hello", "MID$(s,1,5) should be Hello"
ASSERT MID$(a$, 7, 5) = "World", "MID$(s,7,5) should be World"
ASSERT MID$(a$, 6, 1) = " ", "MID$(s,6,1) should be space"

REM MID$ without length returns rest of string
ASSERT MID$(a$, 7) = "World", "MID$(s,7) should be World"
ASSERT MID$(a$, 1) = "Hello World", "MID$(s,1) should be entire string"

REM MID$ with start beyond length returns empty
ASSERT MID$(a$, 50) = "", "MID$ beyond length should be empty"

REM Single character extraction
ASSERT MID$(a$, 1, 1) = "H", "MID$(s,1,1) should be H"
ASSERT MID$(a$, 5, 1) = "o", "MID$(s,5,1) should be o"
