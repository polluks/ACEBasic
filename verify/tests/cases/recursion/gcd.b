REM Test: Recursive GCD (Euclidean algorithm)
REM Classic algorithm using modulo and recursion

SUB LONGINT Gcd(a&, b&)
  IF b& = 0 THEN
    Gcd = a&
  ELSE
    Gcd = Gcd(b&, a& MOD b&)
  END IF
END SUB

ASSERT Gcd(12, 8) = 4, "GCD(12,8) = 4"
ASSERT Gcd(100, 75) = 25, "GCD(100,75) = 25"
ASSERT Gcd(17, 13) = 1, "GCD(17,13) = 1 (coprime)"
ASSERT Gcd(48, 18) = 6, "GCD(48,18) = 6"
ASSERT Gcd(7, 0) = 7, "GCD(7,0) = 7"
ASSERT Gcd(0, 5) = 5, "GCD(0,5) = 5"
ASSERT Gcd(1000, 250) = 250, "GCD(1000,250) = 250"
