REM Test: SLEEP FOR statement
step% = 0
step% = step% + 1
ASSERT step% = 1, "Before SLEEP"
SLEEP FOR 0.1
step% = step% + 1
ASSERT step% = 2, "After SLEEP - execution continued"
