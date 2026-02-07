REM Test: ALLOC and CLEAR ALLOC

REM Allocate memory (type 7 = ANY cleared)
ADDRESS ptr
ptr = ALLOC(100, 7)
ASSERT ptr <> 0, "ALLOC should return non-zero address"

REM Allocate more memory
ADDRESS ptr2
ptr2 = ALLOC(200, 7)
ASSERT ptr2 <> 0, "Second ALLOC should return non-zero address"
ASSERT ptr2 <> ptr, "Different allocations should have different addresses"

REM Free all allocated memory
CLEAR ALLOC

REM Can allocate again after CLEAR ALLOC
ADDRESS ptr3
ptr3 = ALLOC(50, 7)
ASSERT ptr3 <> 0, "ALLOC after CLEAR ALLOC should work"
