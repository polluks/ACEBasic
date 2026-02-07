REM Test: ON n GOTO
REM Branch by index, out-of-range fallthrough

result% = 0
n% = 2
ON n% GOTO one,two,three

REM Fallthrough if out of range
result% = -1
GOTO done

one:
result% = 10
GOTO done

two:
result% = 20
GOTO done

three:
result% = 30
GOTO done

done:
ASSERT result% = 20, "ON 2 GOTO should jump to second label"

REM Test out-of-range: falls through
result2% = 0
m% = 5
ON m% GOTO aa,bb
result2% = 99
GOTO done2

aa:
result2% = 1
GOTO done2

bb:
result2% = 2
GOTO done2

done2:
ASSERT result2% = 99, "ON out-of-range should fall through"
