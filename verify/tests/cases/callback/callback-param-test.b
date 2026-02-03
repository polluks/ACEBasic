' Test: CALLBACK SUB Parameter Passing via CallHookPkt
' Purpose: Verify hook pointer (A0) and h_Data are received correctly

' Hook structure layout (from utility/hooks.h):
CONST HOOK_H_DATA_OFFSET = 16

' Hook structure
STRUCT Hook
    ADDRESS h_MinNode_mln_Succ
    ADDRESS h_MinNode_mln_Pred
    ADDRESS h_Entry
    ADDRESS h_SubEntry
    ADDRESS h_Data
END STRUCT

' Library declaration for CallHookPkt
DECLARE FUNCTION LONGINT CallHookPkt(ADDRESS hook, ADDRESS obj, ADDRESS msg) LIBRARY utility

' Our CALLBACK SUB - receives hook in A0, obj in A2, msg in A1
SUB TestCallback(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    ADDRESS hData

    ' Read h_Data from hook structure using PEEKL
    hData = PEEKL(hook + HOOK_H_DATA_OFFSET)

    ' Store h_Data at address passed in obj
    POKEL obj, hData

    TestCallback = 42&
END SUB

' Main program
LIBRARY "utility.library"

' Variable to store result from callback
LONGINT resultValue

' Create hook structure (BSS object)
DECLARE STRUCT Hook myHook
myHook->h_Entry = @TestCallback
myHook->h_SubEntry = 0&
myHook->h_Data = 12345&

' Call the callback via CallHookPkt
' We pass VARPTR(resultValue) as obj so callback can store h_Data there
retVal& = CallHookPkt(myHook, VARPTR(resultValue), 0&)

ASSERT retVal& = 42&, "Callback should return 42"
ASSERT resultValue = 12345&, "h_Data should be 12345"

LIBRARY CLOSE "utility.library"
END
