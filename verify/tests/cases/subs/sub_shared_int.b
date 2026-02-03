REM Test: SUB with SHARED integer variable
REM A SUB can access a main program variable via SHARED

x% = 42
result% = 0

SUB GetValue
  SHARED x%, result%
  result% = x%
END SUB

CALL GetValue()
ASSERT result% = 42, "SHARED integer should be 42"
