REM Test: Trigonometric functions (radians)

REM SIN at known values
ASSERT SIN(0) = 0, "SIN(0) should be 0"

REM COS at known values
ASSERT COS(0) = 1, "COS(0) should be 1"

REM TAN(0) = 0
ASSERT TAN(0) = 0, "TAN(0) should be 0"

REM SIN(pi/2) should be close to 1
REM pi/2 ~ 1.5708
s = SIN(1.5708)
ASSERT s > 0.99, "SIN(pi/2) should be close to 1"

REM COS(pi/2) should be close to 0
c = COS(1.5708)
ASSERT c < 0.01, "COS(pi/2) should be close to 0"
ASSERT c > -0.01, "COS(pi/2) should be close to 0 (neg)"

REM ATN (arctangent)
a = ATN(1)
REM ATN(1) = pi/4 ~ 0.7854
ASSERT a > 0.78, "ATN(1) should be close to pi/4"
ASSERT a < 0.80, "ATN(1) should be close to pi/4"

REM Identity: SIN^2 + COS^2 = 1
x = 1.0
sinx = SIN(x)
cosx = COS(x)
sum = sinx * sinx + cosx * cosx
ASSERT sum > 0.99, "sin^2 + cos^2 should be close to 1"
ASSERT sum < 1.01, "sin^2 + cos^2 should be close to 1"
