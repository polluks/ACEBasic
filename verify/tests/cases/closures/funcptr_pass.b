REM Test: Function pointer address can be stored and compared
REM Tests that @SubName produces a consistent address

DECLARE SUB LONGINT Add(LONGINT a, LONGINT b)

ptr1& = @Add
ptr2& = @Add

ASSERT ptr1& = ptr2&, "Same function address should match"
ASSERT ptr1& <> 0, "Function pointer should be non-zero"

SUB LONGINT Add(LONGINT a, LONGINT b)
  Add = a + b
END SUB
