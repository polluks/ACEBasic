REM Test: LOG and EXP functions

REM LOG(1) = 0
ASSERT LOG(1) = 0, "LOG(1) should be 0"

REM EXP(0) = 1
ASSERT EXP(0) = 1, "EXP(0) should be 1"

REM EXP(1) ~ 2.718
e = EXP(1)
ASSERT e > 2.71, "EXP(1) should be > 2.71"
ASSERT e < 2.72, "EXP(1) should be < 2.72"

REM LOG(EXP(x)) ~ x (round-trip)
x = 2.0
r = LOG(EXP(x))
ASSERT r > 1.99, "LOG(EXP(2)) should be close to 2"
ASSERT r < 2.01, "LOG(EXP(2)) should be close to 2"

REM EXP(LOG(x)) ~ x
y = 5.0
s = EXP(LOG(y))
ASSERT s > 4.99, "EXP(LOG(5)) should be close to 5"
ASSERT s < 5.01, "EXP(LOG(5)) should be close to 5"
