REM Test: INVOKE with parameters and return value
REM Calls a SUB with two LONGINT params, gets return value

DECLARE SUB LONGINT Add(LONGINT a, LONGINT b)
funcPtr& = @Add
result& = INVOKE funcPtr&(3, 4)
ASSERT result& = 7, "3 + 4 via INVOKE should be 7"

SUB LONGINT Add(LONGINT a, LONGINT b)
  Add = a + b
END SUB
