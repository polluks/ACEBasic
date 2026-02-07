REM Test: Invoke SUB without CALL keyword

result% = 0

SUB AddTen(n%)
  SHARED result%
  result% = n% + 10
END SUB

AddTen(5)
ASSERT result% = 15, "SUB without CALL: 5+10 should be 15"

AddTen(20)
ASSERT result% = 30, "SUB without CALL: 20+10 should be 30"
