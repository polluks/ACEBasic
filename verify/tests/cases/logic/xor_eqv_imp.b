REM Test: XOR, EQV, IMP boolean operators

REM XOR truth table
ASSERT (-1 XOR -1) = 0, "T XOR T should be F"
ASSERT (-1 XOR 0) = -1, "T XOR F should be T"
ASSERT (0 XOR -1) = -1, "F XOR T should be T"
ASSERT (0 XOR 0) = 0, "F XOR F should be F"

REM EQV truth table (equivalence: true when both same)
ASSERT (-1 EQV -1) = -1, "T EQV T should be T"
ASSERT (-1 EQV 0) = 0, "T EQV F should be F"
ASSERT (0 EQV -1) = 0, "F EQV T should be F"
ASSERT (0 EQV 0) = -1, "F EQV F should be T"

REM IMP truth table (implication: false only when T implies F)
ASSERT (-1 IMP -1) = -1, "T IMP T should be T"
ASSERT (-1 IMP 0) = 0, "T IMP F should be F"
ASSERT (0 IMP -1) = -1, "F IMP T should be T"
ASSERT (0 IMP 0) = -1, "F IMP F should be T"
