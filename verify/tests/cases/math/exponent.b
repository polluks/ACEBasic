REM Test: Exponentiation operator (^)

REM Integer base and exponent
ASSERT 2^0 = 1, "2^0 should be 1"
ASSERT 2^1 = 2, "2^1 should be 2"
ASSERT 2^3 = 8, "2^3 should be 8"
ASSERT 2^10 = 1024, "2^10 should be 1024"
ASSERT 3^3 = 27, "3^3 should be 27"
ASSERT 5^2 = 25, "5^2 should be 25"

REM Float exponentiation
r = 2.0^0.5
ASSERT r > 1.41, "2^0.5 should be close to sqrt(2)"
ASSERT r < 1.42, "2^0.5 should be close to sqrt(2)"

REM Any number to the 0 power is 1
ASSERT 10^0 = 1, "10^0 should be 1"
ASSERT 1^100 = 1, "1^100 should be 1"
