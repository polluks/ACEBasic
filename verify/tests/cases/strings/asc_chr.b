REM Test: ASC and CHR$ functions

REM ASC returns ASCII code of first character
ASSERT ASC("A") = 65, "ASC(A) should be 65"
ASSERT ASC("Z") = 90, "ASC(Z) should be 90"
ASSERT ASC("a") = 97, "ASC(a) should be 97"
ASSERT ASC("0") = 48, "ASC(0) should be 48"
ASSERT ASC(" ") = 32, "ASC(space) should be 32"

REM CHR$ returns character from code
ASSERT CHR$(65) = "A", "CHR$(65) should be A"
ASSERT CHR$(97) = "a", "CHR$(97) should be a"
ASSERT CHR$(48) = "0", "CHR$(48) should be 0"

REM Round-trip: ASC(CHR$(n)) = n
ASSERT ASC(CHR$(66)) = 66, "Round trip ASC(CHR$(66)) should be 66"

REM ASC of multi-char string returns first char
ASSERT ASC("Hello") = 72, "ASC(Hello) should be 72 (H)"
