REM Test: STRUCT definition and member access

STRUCT MyPoint
  LONGINT xx
  LONGINT yy
END STRUCT

REM BSS-allocated struct (no pointer, no ALLOC needed)
DECLARE STRUCT MyPoint pt

pt->xx = 10&
pt->yy = 20&
ASSERT pt->xx = 10, "Struct member xx should be 10"
ASSERT pt->yy = 20, "Struct member yy should be 20"

REM Modify members
pt->xx = pt->xx + 5
ASSERT pt->xx = 15, "Modified struct member xx should be 15"
