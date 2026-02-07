REM Test: LEFT$ and RIGHT$ string functions

a$ = "Hello World"

REM LEFT$ basic usage
ASSERT LEFT$(a$, 5) = "Hello", "LEFT$(Hello World, 5) should be Hello"
ASSERT LEFT$(a$, 1) = "H", "LEFT$(Hello World, 1) should be H"

REM LEFT$ with n=0 returns empty string
ASSERT LEFT$(a$, 0) = "", "LEFT$ with 0 should return empty"

REM LEFT$ with n > length returns whole string
ASSERT LEFT$(a$, 100) = "Hello World", "LEFT$ with n>len returns all"

REM RIGHT$ basic usage
ASSERT RIGHT$(a$, 5) = "World", "RIGHT$(Hello World, 5) should be World"
ASSERT RIGHT$(a$, 1) = "d", "RIGHT$(Hello World, 1) should be d"

REM RIGHT$ with n > length returns whole string
ASSERT RIGHT$(a$, 100) = "Hello World", "RIGHT$ with n>len returns all"
