REM Test: AND, OR, NOT boolean operators
REM TRUE = -1, FALSE = 0

REM AND truth table
ASSERT (-1 AND -1) = -1, "T AND T should be T"
ASSERT (-1 AND 0) = 0, "T AND F should be F"
ASSERT (0 AND -1) = 0, "F AND T should be F"
ASSERT (0 AND 0) = 0, "F AND F should be F"

REM OR truth table
ASSERT (-1 OR -1) = -1, "T OR T should be T"
ASSERT (-1 OR 0) = -1, "T OR F should be T"
ASSERT (0 OR -1) = -1, "F OR T should be T"
ASSERT (0 OR 0) = 0, "F OR F should be F"

REM NOT
ASSERT NOT -1 = 0, "NOT T should be F"
ASSERT NOT 0 = -1, "NOT F should be T"

REM Compound expressions
ASSERT (-1 AND -1) OR 0 = -1, "(T AND T) OR F should be T"
ASSERT NOT (0 OR 0) = -1, "NOT (F OR F) should be T"
