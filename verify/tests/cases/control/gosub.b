REM Test: GOSUB/RETURN
result% = 0
GOSUB mysub
result% = result% + 10
ASSERT result% = 11, "After GOSUB and RETURN, result should be 11"
END

mysub:
result% = 1
RETURN
