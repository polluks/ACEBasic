REM Test: IF/THEN/ELSE
x% = 3
result% = 0
IF x% > 5 THEN
  result% = 1
ELSE
  result% = 2
END IF
ASSERT result% = 2, "x%=3 is not > 5, should take ELSE branch"
