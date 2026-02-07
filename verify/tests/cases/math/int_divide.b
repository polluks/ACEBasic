REM Test: Integer division operator (\)

REM Basic integer division
ASSERT 10 \ 3 = 3, "10 \ 3 should be 3"
ASSERT 7 \ 2 = 3, "7 \ 2 should be 3"
ASSERT 15 \ 5 = 3, "15 \ 5 should be 3"
ASSERT 100 \ 10 = 10, "100 \ 10 should be 10"

REM Exact division
ASSERT 10 \ 2 = 5, "10 \ 2 should be 5"
ASSERT 9 \ 3 = 3, "9 \ 3 should be 3"

REM Small quotients
ASSERT 1 \ 3 = 0, "1 \ 3 should be 0"
ASSERT 2 \ 3 = 0, "2 \ 3 should be 0"

REM Larger numbers
ASSERT 1000 \ 7 = 142, "1000 \ 7 should be 142"
