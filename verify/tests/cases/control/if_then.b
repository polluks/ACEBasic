REM Test: IF/THEN
x% = 10
result% = 0
IF x% > 5 THEN result% = 1
ASSERT result% = 1, "x%=10 is > 5, should set result%=1"
