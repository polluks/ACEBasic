REM Test: Shared string array assignment
REM Regression test for bug where assigning to a string array
REM inside a SUB (via SHARED) caused garbage bytes due to
REM missing braces in assign.c array handler.

DEFINT a-z
DIM names$(3) SIZE 20

REM Initialize array
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
    IF names$(i) = n$ THEN
      FindName = i
      EXIT FOR
    END IF
  NEXT
END SUB

REM Add entries via SUB
AddName("hello")
AddName("world")
AddName("test")

REM Verify contents are intact (no garbage bytes)
ASSERT names$(0) = "hello", "names$(0) should be hello"
ASSERT names$(1) = "world", "names$(1) should be world"
ASSERT names$(2) = "test", "names$(2) should be test"
ASSERT names$(3) = "", "names$(3) should be empty"

REM Verify lengths (garbage bytes would make these wrong)
ASSERT LEN(names$(0)) = 5, "LEN of hello should be 5"
ASSERT LEN(names$(1)) = 5, "LEN of world should be 5"
ASSERT LEN(names$(2)) = 4, "LEN of test should be 4"

REM Verify lookup works (depends on clean string data)
ASSERT FindName("hello") = 0, "FindName hello should be 0"
ASSERT FindName("world") = 1, "FindName world should be 1"
ASSERT FindName("test") = 2, "FindName test should be 2"
ASSERT FindName("nope") = -1, "FindName nope should be -1"
