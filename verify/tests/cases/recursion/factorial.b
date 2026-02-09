REM Test: Recursive factorial
REM SUB calls itself to compute n!

SUB LONGINT Factorial(n%)
  IF n% <= 1 THEN
    Factorial = 1
  ELSE
    Factorial = n% * Factorial(n% - 1)
  END IF
END SUB

ASSERT Factorial(0) = 1, "0! = 1"
ASSERT Factorial(1) = 1, "1! = 1"
ASSERT Factorial(2) = 2, "2! = 2"
ASSERT Factorial(3) = 6, "3! = 6"
ASSERT Factorial(5) = 120, "5! = 120"
ASSERT Factorial(10) = 3628800, "10! = 3628800"
