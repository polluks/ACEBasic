REM Test: SWAP command

REM Swap integers
a% = 10
b% = 20
SWAP a%, b%
ASSERT a% = 20, "After SWAP, a% should be 20"
ASSERT b% = 10, "After SWAP, b% should be 10"

REM Swap longs
LONGINT x, y
x = 100000&
y = 200000&
SWAP x, y
ASSERT x = 200000, "After SWAP, x should be 200000"
ASSERT y = 100000, "After SWAP, y should be 100000"

REM Swap singles
p = 1.5
q = 2.5
SWAP p, q
ASSERT p = 2.5, "After SWAP, p should be 2.5"
ASSERT q = 1.5, "After SWAP, q should be 1.5"
