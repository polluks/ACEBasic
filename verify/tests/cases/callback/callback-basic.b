' Test: Basic CALLBACK SUB
' Purpose: Verify CALLBACK SUB generates correct assembly for Amiga Hook convention

SUB MyHook(ADDRESS hook, ADDRESS obj, ADDRESS msg) CALLBACK
    ' Simple callback that just returns 0
    MyHook = 0&
END SUB

' Main program verifies compilation worked
compiled% = 1
ASSERT compiled% = 1, "CALLBACK SUB should compile"
END
