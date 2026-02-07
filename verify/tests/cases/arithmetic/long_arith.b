REM Test: Long integer arithmetic

LONGINT a, b, c

REM Addition
a = 100000&
b = 200000&
c = a + b
ASSERT c = 300000, "100000 + 200000 = 300000"

REM Subtraction
c = b - a
ASSERT c = 100000, "200000 - 100000 = 100000"

REM Multiplication
a = 1000&
b = 500&
c = a * b
ASSERT c = 500000, "1000 * 500 = 500000"

REM Division
a = 500000&
b = 1000&
c = a / b
ASSERT c = 500, "500000 / 1000 = 500"

REM Negative long values
a = -50000&
b = 30000&
c = a + b
ASSERT c = -20000, "-50000 + 30000 = -20000"
