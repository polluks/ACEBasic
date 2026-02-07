REM Test: SHL and SHR shift functions

REM SHL shifts left (multiply by 2^n)
ASSERT SHL(1, 0) = 1, "SHL(1,0) should be 1"
ASSERT SHL(1, 1) = 2, "SHL(1,1) should be 2"
ASSERT SHL(1, 2) = 4, "SHL(1,2) should be 4"
ASSERT SHL(1, 3) = 8, "SHL(1,3) should be 8"
ASSERT SHL(1, 8) = 256, "SHL(1,8) should be 256"
ASSERT SHL(3, 4) = 48, "SHL(3,4) should be 48"

REM SHR shifts right (divide by 2^n)
ASSERT SHR(256, 1) = 128, "SHR(256,1) should be 128"
ASSERT SHR(256, 8) = 1, "SHR(256,8) should be 1"
ASSERT SHR(16, 2) = 4, "SHR(16,2) should be 4"
ASSERT SHR(1, 1) = 0, "SHR(1,1) should be 0"
ASSERT SHR(255, 4) = 15, "SHR(255,4) should be 15"
