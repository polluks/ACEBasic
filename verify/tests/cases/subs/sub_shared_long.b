REM Test: SUB with SHARED long integer variable
REM A SUB can access a long integer variable via SHARED

value& = 100000
result& = 0

SUB GetLong
  SHARED value&, result&
  result& = value&
END SUB

CALL GetLong()
ASSERT result& = 100000, "SHARED long should be 100000"
