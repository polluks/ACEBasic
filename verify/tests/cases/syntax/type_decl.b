REM Test: Variable type declarations

REM SHORTINT declaration
SHORTINT si
si = 100
ASSERT si = 100, "SHORTINT should hold 100"

REM LONGINT declaration
LONGINT li
li = 100000&
ASSERT li = 100000, "LONGINT should hold 100000"

REM ADDRESS declaration (same as LONGINT)
ADDRESS addr
addr = 12345&
ASSERT addr = 12345, "ADDRESS should hold value"

REM SINGLE declaration
SINGLE f
f = 2.5
ASSERT f = 2.5, "SINGLE should hold 2.5"

REM Multiple declarations on one line
SHORTINT p, q, r
p = 1
q = 2
r = 3
ASSERT p + q + r = 6, "Multiple SHORTINT decl should work"
