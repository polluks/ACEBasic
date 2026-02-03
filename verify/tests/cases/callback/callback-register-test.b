' Test: CALLBACK SUB Register Preservation
' Purpose: Verify callback saves and restores all registers correctly

' Hook structure
STRUCT Hook
    ADDRESS h_MinNode_mln_Succ
    ADDRESS h_MinNode_mln_Pred
    ADDRESS h_Entry
    ADDRESS h_SubEntry
    ADDRESS h_Data
END STRUCT

' Library declaration
DECLARE FUNCTION LONGINT CallHookPkt(ADDRESS hook, ADDRESS obj, ADDRESS msg) LIBRARY utility

' CALLBACK that does lots of work to stress registers
SUB BusyCallback(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    LONGINT a
    LONGINT b
    LONGINT c
    LONGINT d
    LONGINT sum

    ' Do lots of calculations to use many registers
    a = 100&
    b = 200&
    c = 300&
    d = 400&

    sum = a + b + c + d

    ' Return the sum (should be 1000)
    BusyCallback = sum
END SUB

' Main program
LIBRARY "utility.library"

' Set up variables BEFORE calling callback
LONGINT testVal1
LONGINT testVal2
LONGINT testVal3
testVal1 = 11111&
testVal2 = 22222&
testVal3 = 33333&

' Create hook structure (BSS object)
DECLARE STRUCT Hook myHook
myHook->h_Entry = @BusyCallback
myHook->h_SubEntry = 0&
myHook->h_Data = 0&

' Call the callback
retVal& = CallHookPkt(myHook, 0&, 0&)

' Verify return value and that our variables were not corrupted
ASSERT retVal& = 1000&, "Callback should return 1000"
ASSERT testVal1 = 11111&, "testVal1 should be preserved"
ASSERT testVal2 = 22222&, "testVal2 should be preserved"
ASSERT testVal3 = 33333&, "testVal3 should be preserved"

LIBRARY CLOSE "utility.library"
END
