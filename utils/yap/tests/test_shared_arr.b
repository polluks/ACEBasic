DEFINT a-z
DIM names$(3) SIZE 20
SHORTINT cnt, k

cnt = 0
FOR k = 0 TO 3
  names$(k) = ""
NEXT

SUB AddName(STRING n$)
  SHARED names$, cnt
  names$(cnt) = n$
  ++cnt
END SUB

SUB SHORTINT FindName(STRING n$)
  SHARED names$, cnt
  SHORTINT i
  FindName = -1
  FOR i = 0 TO cnt - 1
    PRINT "  cmp i="; i; " ["; LEFT$(names$(i), LEN(n$)); "] vs ["; n$; "]"
    IF LEFT$(names$(i), LEN(n$)) = n$ THEN
      FindName = i
      EXIT FOR
    END IF
  NEXT
END SUB

AddName("hello")
AddName("world")
PRINT "cnt="; cnt
PRINT "0=["; names$(0); "]"
PRINT "1=["; names$(1); "]"
PRINT "find hello="; FindName("hello")
PRINT "find world="; FindName("world")
PRINT "find nope="; FindName("nope")
