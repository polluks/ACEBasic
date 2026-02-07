REM Test: SUB with typed parameters
REM Parameters are call-by-value

result% = 0

SUB AddInts(a%, b%)
  SHARED result%
  result% = a% + b%
END SUB

CALL AddInts(10, 20)
ASSERT result% = 30, "SUB with integer params: 10+20=30"

REM Test that parameters are by value (original not modified)
x% = 100
SUB TryModify(n%)
  n% = 999
END SUB

CALL TryModify(x%)
ASSERT x% = 100, "Call-by-value should not modify original"

REM SUB with long parameter
LONGINT lresult
lresult = 0

SUB AddLongs(LONGINT a, LONGINT b)
  SHARED lresult
  lresult = a + b
END SUB

CALL AddLongs(100000&, 200000&)
ASSERT lresult = 300000, "SUB with LONGINT params"
