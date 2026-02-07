REM Test: Bitwise operations on integers

REM AND on bit patterns
ASSERT (255 AND 15) = 15, "255 AND 15 should be 15"
ASSERT (170 AND 85) = 0, "170 AND 85 should be 0 (alternating bits)"
ASSERT (255 AND 255) = 255, "255 AND 255 should be 255"
ASSERT (255 AND 0) = 0, "255 AND 0 should be 0"

REM OR on bit patterns
ASSERT (170 OR 85) = 255, "170 OR 85 should be 255"
ASSERT (240 OR 15) = 255, "240 OR 15 should be 255"
ASSERT (0 OR 0) = 0, "0 OR 0 should be 0"

REM XOR on bit patterns
ASSERT (255 XOR 255) = 0, "255 XOR 255 should be 0"
ASSERT (255 XOR 0) = 255, "255 XOR 0 should be 255"
ASSERT (170 XOR 85) = 255, "170 XOR 85 should be 255"

REM NOT on bit patterns (bitwise complement)
REM NOT 0 = -1 (all bits set)
ASSERT NOT 0 = -1, "NOT 0 should be -1"
