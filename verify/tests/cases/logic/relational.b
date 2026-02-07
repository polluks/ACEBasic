REM Test: Relational operators with integers and floats

REM Integer comparisons
ASSERT (5 = 5) = -1, "5=5 should be TRUE (-1)"
ASSERT (5 <> 3) = -1, "5<>3 should be TRUE"
ASSERT (3 < 5) = -1, "3<5 should be TRUE"
ASSERT (5 > 3) = -1, "5>3 should be TRUE"
ASSERT (3 <= 3) = -1, "3<=3 should be TRUE"
ASSERT (3 >= 3) = -1, "3>=3 should be TRUE"

REM Float comparisons
ASSERT 1.5 < 2.5, "1.5 < 2.5 should be true"
ASSERT 2.5 > 1.5, "2.5 > 1.5 should be true"
ASSERT 1.5 = 1.5, "1.5 = 1.5 should be true"
ASSERT 1.5 <> 2.5, "1.5 <> 2.5 should be true"

REM Edge cases
ASSERT 0 = 0, "0 = 0 should be true"
ASSERT NOT (0 <> 0), "0 <> 0 should be false"
ASSERT -1 < 0, "-1 < 0 should be true"
ASSERT -1 < 1, "-1 < 1 should be true"

REM Chained conditions with AND
ASSERT (3 > 1) AND (3 < 5), "3 between 1 and 5"
ASSERT (10 >= 10) AND (10 <= 10), "10 is 10"
