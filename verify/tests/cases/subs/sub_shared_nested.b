REM Test: Nested SUB calls with SHARED variable
REM Multiple SUBs can share the same variable

total& = 0

SUB AddTen
  SHARED total&
  total& = total& + 10
END SUB

SUB AddTwenty
  SHARED total&
  total& = total& + 20
END SUB

CALL AddTen()
ASSERT total& = 10, "After AddTen, total should be 10"
CALL AddTwenty()
ASSERT total& = 30, "After AddTwenty, total should be 30"
