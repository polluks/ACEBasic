REM Test: Relational operators on integers

REM Equality
ASSERT 5 = 5, "5 = 5 should be true"
ASSERT NOT (5 = 6), "5 = 6 should be false"

REM Not equal
ASSERT 5 <> 6, "5 <> 6 should be true"
ASSERT NOT (5 <> 5), "5 <> 5 should be false"

REM Less than
ASSERT 3 < 5, "3 < 5 should be true"
ASSERT NOT (5 < 3), "5 < 3 should be false"
ASSERT NOT (5 < 5), "5 < 5 should be false"

REM Greater than
ASSERT 5 > 3, "5 > 3 should be true"
ASSERT NOT (3 > 5), "3 > 5 should be false"
ASSERT NOT (5 > 5), "5 > 5 should be false"

REM Less than or equal
ASSERT 3 <= 5, "3 <= 5 should be true"
ASSERT 5 <= 5, "5 <= 5 should be true"
ASSERT NOT (6 <= 5), "6 <= 5 should be false"

REM Greater than or equal
ASSERT 5 >= 3, "5 >= 3 should be true"
ASSERT 5 >= 5, "5 >= 5 should be true"
ASSERT NOT (3 >= 5), "3 >= 5 should be false"

REM Negative number comparisons
ASSERT -5 < 0, "-5 < 0 should be true"
ASSERT -10 < -5, "-10 < -5 should be true"
