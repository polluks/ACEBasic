REM Test: SUB with SHARED array
REM A SUB can access array elements via SHARED

DIM nums%(4)
nums%(0) = 1
nums%(1) = 2
nums%(2) = 3
nums%(3) = 4
nums%(4) = 5
sum% = 0

SUB SumArray
  SHARED nums%, sum%
  FOR i% = 0 TO 4
    sum% = sum% + nums%(i%)
  NEXT i%
END SUB

CALL SumArray()
ASSERT sum% = 15, "Sum of array 1-5 should be 15"
ASSERT nums%(2) = 3, "Array element 2 should be 3"
