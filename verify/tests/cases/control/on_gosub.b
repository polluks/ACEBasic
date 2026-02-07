REM Test: ON n GOSUB
REM Branch to subroutine and return

result% = 0
n% = 3
ON n% GOSUB sub1,sub2,sub3
ASSERT result% = 30, "ON 3 GOSUB should call third subroutine"

REM Test with index 1
result% = 0
n% = 1
ON n% GOSUB sub1,sub2,sub3
ASSERT result% = 10, "ON 1 GOSUB should call first subroutine"
END

sub1:
result% = 10
RETURN

sub2:
result% = 20
RETURN

sub3:
result% = 30
RETURN
