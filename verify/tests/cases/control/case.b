REM Test: CASE / END CASE
REM Multiple branches, first-match semantics

x% = 2
result% = 0

CASE
  x% = 1 : result% = 10
  x% = 2 : result% = 20
  x% = 3 : result% = 30
END CASE
ASSERT result% = 20, "CASE should match x%=2 and set result to 20"

REM Test with no matching case
y% = 99
flag% = 0
CASE
  y% = 1 : flag% = 1
  y% = 2 : flag% = 1
END CASE
ASSERT flag% = 0, "No matching CASE should leave flag unchanged"

REM Test first match wins
z% = 5
val% = 0
CASE
  z% > 3 : val% = 1
  z% > 4 : val% = 2
  z% = 5 : val% = 3
END CASE
ASSERT val% = 1, "CASE should match first true condition"
