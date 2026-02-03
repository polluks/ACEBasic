' bind_multi_arg.b - BIND multiple arguments, INVOKE with remaining
' Tests closure with multiple bound parameters

DECLARE SUB LONGINT AddThree(LONGINT a, LONGINT b, LONGINT c)

SUB LONGINT AddThree(LONGINT a, LONGINT b, LONGINT c)
  AddThree = a + b + c
END SUB

' Bind two args, leave one free
adder& = BIND(@AddThree, 10, 20)
result& = INVOKE adder&(3)
ASSERT result& = 33, "10 + 20 + 3 via BIND should be 33"
