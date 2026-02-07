REM Test: POKE/PEEK, POKEW/PEEKW, POKEL/PEEKL

REM Allocate cleared memory for testing
ADDRESS buf
buf = ALLOC(32, 7)
ASSERT buf <> 0, "ALLOC should succeed"

REM 8-bit POKE/PEEK round-trip
POKE buf, 42
ASSERT PEEK(buf) = 42, "PEEK should return 42 after POKE"

POKE buf, 255
ASSERT PEEK(buf) = 255, "PEEK should return 255"

POKE buf, 0
ASSERT PEEK(buf) = 0, "PEEK should return 0"

REM 16-bit POKEW/PEEKW round-trip
POKEW buf + 4, 1000
ASSERT PEEKW(buf + 4) = 1000, "PEEKW should return 1000"

POKEW buf + 4, 32000
ASSERT PEEKW(buf + 4) = 32000, "PEEKW should return 32000"

REM 32-bit POKEL/PEEKL round-trip
POKEL buf + 8, 100000&
ASSERT PEEKL(buf + 8) = 100000, "PEEKL should return 100000"

POKEL buf + 8, 1000000&
ASSERT PEEKL(buf + 8) = 1000000, "PEEKL should return 1000000"
