REM Test: Comments should be ignored
REM This is a comment
x% = 42
ASSERT x% = 42, "Code after REM comment should execute"
' This is also a comment
y% = 10
ASSERT y% = 10, "Code after apostrophe comment should execute"
