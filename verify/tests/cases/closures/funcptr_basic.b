REM Test: Basic INVOKE with no parameters
REM Calls a SUB through a function pointer

called% = 0
DECLARE SUB Hello
funcPtr& = @Hello
INVOKE funcPtr&
ASSERT called% = 1, "SUB should have been called via INVOKE"

SUB Hello
  SHARED called%
  called% = 1
END SUB
