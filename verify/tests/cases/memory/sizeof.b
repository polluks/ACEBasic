REM Test: SIZEOF function

REM Known type sizes
ASSERT SIZEOF(byte) = 1, "SIZEOF(byte) should be 1"
ASSERT SIZEOF(shortint) = 2, "SIZEOF(shortint) should be 2"
ASSERT SIZEOF(longint) = 4, "SIZEOF(longint) should be 4"
ASSERT SIZEOF(address) = 4, "SIZEOF(address) should be 4"
ASSERT SIZEOF(single) = 4, "SIZEOF(single) should be 4"

REM SIZEOF of a variable
SHORTINT si
ASSERT SIZEOF(si) = 2, "SIZEOF shortint var should be 2"

LONGINT li
ASSERT SIZEOF(li) = 4, "SIZEOF longint var should be 4"
