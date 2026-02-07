REM Test: HEX$, OCT$, BIN$ conversion functions

REM HEX$ converts to hexadecimal string
ASSERT HEX$(255) = "FF", "HEX$(255) should be FF"
ASSERT HEX$(16) = "10", "HEX$(16) should be 10"
ASSERT HEX$(0) = "0", "HEX$(0) should be 0"

REM OCT$ converts to octal string
ASSERT OCT$(8) = "10", "OCT$(8) should be 10"
ASSERT OCT$(7) = "7", "OCT$(7) should be 7"
ASSERT OCT$(0) = "0", "OCT$(0) should be 0"

REM BIN$ converts to binary string
ASSERT BIN$(5) = "101", "BIN$(5) should be 101"
ASSERT BIN$(8) = "1000", "BIN$(8) should be 1000"
ASSERT BIN$(0) = "0", "BIN$(0) should be 0"
ASSERT BIN$(1) = "1", "BIN$(1) should be 1"

REM Larger values
ASSERT HEX$(256) = "100", "HEX$(256) should be 100"
