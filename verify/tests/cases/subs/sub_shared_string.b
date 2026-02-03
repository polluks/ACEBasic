REM Test: SUB with SHARED string variable
REM A SUB can access a string variable via SHARED

msg$ = "Hello from SHARED"
result$ = ""

SUB GetMessage
  SHARED msg$, result$
  result$ = msg$
END SUB

CALL GetMessage()
ASSERT result$ = "Hello from SHARED", "SHARED string should match"
