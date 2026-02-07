REM Test: DIM arrays

REM One-dimensional array
DIM SHORTINT arr(5)
arr(0) = 10
arr(1) = 20
arr(2) = 30
arr(3) = 40
arr(4) = 50
arr(5) = 60
ASSERT arr(0) = 10, "arr(0) should be 10"
ASSERT arr(3) = 40, "arr(3) should be 40"
ASSERT arr(5) = 60, "arr(5) should be 60"

REM Two-dimensional array
DIM SHORTINT grid(2, 2)
grid(0, 0) = 1
grid(1, 0) = 2
grid(0, 1) = 3
grid(1, 1) = 4
grid(2, 2) = 9
ASSERT grid(0, 0) = 1, "grid(0,0) should be 1"
ASSERT grid(1, 1) = 4, "grid(1,1) should be 4"
ASSERT grid(2, 2) = 9, "grid(2,2) should be 9"

REM Sum array elements
sum% = 0
FOR i% = 0 TO 5
  sum% = sum% + arr(i%)
NEXT
ASSERT sum% = 210, "Sum of arr elements should be 210"
