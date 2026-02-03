OPTION 2+
REM Test: 68020 native long multiply, divide, modulo

REM === Long Multiplication ===
a& = 100000
b& = 50
ASSERT a& * b& = 5000000, "100000 * 50 should equal 5000000"

a& = -3
b& = 7
ASSERT a& * b& = -21, "-3 * 7 should equal -21"

a& = -4
b& = -5
ASSERT a& * b& = 20, "-4 * -5 should equal 20"

a& = 0
b& = 99999
ASSERT a& * b& = 0, "0 * 99999 should equal 0"

a& = 1
b& = 77777
ASSERT a& * b& = 77777, "1 * 77777 should equal 77777"

REM === Long Integer Division ===
a& = 100000
b& = 3
ASSERT a& \ b& = 33333, "100000 \ 3 should equal 33333"

a& = -21
b& = 7
ASSERT a& \ b& = -3, "-21 \ 7 should equal -3"

a& = 0
b& = 5
ASSERT a& \ b& = 0, "0 \ 5 should equal 0"

a& = 77777
b& = 1
ASSERT a& \ b& = 77777, "77777 \ 1 should equal 77777"

REM === Long Modulo ===
a& = 17
b& = 5
ASSERT a& MOD b& = 2, "17 MOD 5 should equal 2"

a& = 100
b& = 7
ASSERT a& MOD b& = 2, "100 MOD 7 should equal 2"

a& = 100000
b& = 3
ASSERT a& MOD b& = 1, "100000 MOD 3 should equal 1"

a& = 21
b& = 7
ASSERT a& MOD b& = 0, "21 MOD 7 should equal 0"

REM === Short multiply still works (sanity) ===
x% = 6
y% = 7
ASSERT x% * y% = 42, "6 * 7 should equal 42"

REM === Combined expressions ===
a& = 10000
b& = 3
c& = 7
ASSERT (a& * b&) \ c& = 4285, "(10000 * 3) \ 7 should equal 4285"

a& = 100
b& = 7
c& = 3
ASSERT (a& MOD b&) * c& = 6, "(100 MOD 7) * 3 should equal 6"
