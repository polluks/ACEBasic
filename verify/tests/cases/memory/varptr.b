REM Test: VARPTR and SADD

REM VARPTR of integer variable
x% = 42
ADDRESS addr
addr = VARPTR(x%)
ASSERT addr <> 0, "VARPTR should return non-zero address"

REM VARPTR of long variable
LONGINT lng
lng = 12345&
addr = VARPTR(lng)
ASSERT addr <> 0, "VARPTR of LONGINT should be non-zero"

REM SADD of string variable
a$ = "Hello"
addr = SADD(a$)
ASSERT addr <> 0, "SADD should return non-zero address"

REM @ as alias for VARPTR
y% = 100
addr = @y%
ASSERT addr <> 0, "@ should return non-zero like VARPTR"
ASSERT @y% = VARPTR(y%), "@ and VARPTR should return same address"
