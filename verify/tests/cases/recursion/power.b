REM Test: Recursive exponentiation
REM Compute base^exp using recursion

SUB LONGINT Power(base%, exp%)
  IF exp% = 0 THEN
    Power = 1
  ELSE
    Power = base% * Power(base%, exp% - 1)
  END IF
END SUB

ASSERT Power(2, 0) = 1, "2^0 = 1"
ASSERT Power(2, 1) = 2, "2^1 = 2"
ASSERT Power(2, 8) = 256, "2^8 = 256"
ASSERT Power(2, 16) = 65536, "2^16 = 65536"
ASSERT Power(3, 4) = 81, "3^4 = 81"
ASSERT Power(5, 3) = 125, "5^3 = 125"
ASSERT Power(10, 4) = 10000, "10^4 = 10000"
