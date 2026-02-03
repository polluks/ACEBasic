' Test: CALLBACK SUB address-of operator (@)
' Purpose: Verify @SubName works for CALLBACK SUBs to get function address

SUB MyHook(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    ' Simple callback that just returns 0
    MyHook = 0&
END SUB

' Get the address of the CALLBACK SUB
hookAddr& = @MyHook

' Verify address is non-zero
ASSERT hookAddr& <> 0, "CALLBACK address should be non-zero"

END
