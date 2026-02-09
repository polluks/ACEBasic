REM Test: Recursive Fibonacci
REM Two recursive calls per invocation

SUB LONGINT Fib(n%)
  IF n% <= 0 THEN
    Fib = 0
  ELSE
    IF n% = 1 THEN
      Fib = 1
    ELSE
      Fib = Fib(n% - 1) + Fib(n% - 2)
    END IF
  END IF
END SUB

ASSERT Fib(0) = 0, "Fib(0) = 0"
ASSERT Fib(1) = 1, "Fib(1) = 1"
ASSERT Fib(2) = 1, "Fib(2) = 1"
ASSERT Fib(3) = 2, "Fib(3) = 2"
ASSERT Fib(4) = 3, "Fib(4) = 3"
ASSERT Fib(5) = 5, "Fib(5) = 5"
ASSERT Fib(10) = 55, "Fib(10) = 55"
ASSERT Fib(15) = 610, "Fib(15) = 610"
