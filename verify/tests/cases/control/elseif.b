REM Test: ELSEIF syntax construct

REM Test 1: Basic ELSEIF (should match second condition)
x% = 2
result% = 0
IF x% = 1 THEN
  result% = 1
ELSEIF x% = 2 THEN
  result% = 2
ELSEIF x% = 3 THEN
  result% = 3
ELSE
  result% = 99
END IF
ASSERT result% = 2, "Test 1: x%=2 should match ELSEIF x%=2"

REM Test 2: ELSEIF without ELSE (no match, should skip all)
y% = 5
result% = 0
IF y% = 1 THEN
  result% = 1
ELSEIF y% = 2 THEN
  result% = 2
END IF
ASSERT result% = 0, "Test 2: y%=5 should not match any branch"

REM Test 3: First IF condition matches (skip all ELSEIF)
z% = 1
result% = 0
IF z% = 1 THEN
  result% = 1
ELSEIF z% = 2 THEN
  result% = 2
ELSE
  result% = 99
END IF
ASSERT result% = 1, "Test 3: z%=1 should match first IF"

REM Test 4: Fall through to ELSE (no conditions match)
w% = 99
result% = 0
IF w% = 1 THEN
  result% = 1
ELSEIF w% = 2 THEN
  result% = 2
ELSE
  result% = 99
END IF
ASSERT result% = 99, "Test 4: w%=99 should fall through to ELSE"

REM Test 5: Many ELSEIF clauses
n% = 5
result% = 0
IF n% = 1 THEN
  result% = 1
ELSEIF n% = 2 THEN
  result% = 2
ELSEIF n% = 3 THEN
  result% = 3
ELSEIF n% = 4 THEN
  result% = 4
ELSEIF n% = 5 THEN
  result% = 5
ELSEIF n% = 6 THEN
  result% = 6
ELSE
  result% = 99
END IF
ASSERT result% = 5, "Test 5: n%=5 should match ELSEIF n%=5"

REM Test 6: Nested IF inside ELSEIF block
a% = 2
b% = 1
result% = 0
IF a% = 1 THEN
  result% = 1
ELSEIF a% = 2 THEN
  IF b% = 1 THEN
    result% = 21
  ELSE
    result% = 20
  END IF
ELSE
  result% = 99
END IF
ASSERT result% = 21, "Test 6: a%=2 b%=1 should give nested result 21"

REM Test 7: Complex expressions in conditions
v% = 10
result% = 0
IF v% > 20 THEN
  result% = 1
ELSEIF v% > 5 AND v% <= 15 THEN
  result% = 2
ELSEIF v% > 0 THEN
  result% = 3
ELSE
  result% = 99
END IF
ASSERT result% = 2, "Test 7: v%=10 should match medium range"

REM Test 8: Nested ELSEIF inside ELSEIF block
p% = 2
q% = 3
result% = 0
IF p% = 1 THEN
  result% = 1
ELSEIF p% = 2 THEN
  IF q% = 1 THEN
    result% = 21
  ELSEIF q% = 2 THEN
    result% = 22
  ELSEIF q% = 3 THEN
    result% = 23
  ELSE
    result% = 20
  END IF
ELSEIF p% = 3 THEN
  result% = 3
ELSE
  result% = 99
END IF
ASSERT result% = 23, "Test 8: p%=2 q%=3 should give nested elseif result 23"

REM Test 9: Deeply nested ELSEIF
r% = 2
s% = 2
t% = 2
result% = 0
IF r% = 1 THEN
  result% = 1
ELSEIF r% = 2 THEN
  IF s% = 1 THEN
    result% = 21
  ELSEIF s% = 2 THEN
    IF t% = 1 THEN
      result% = 221
    ELSEIF t% = 2 THEN
      result% = 222
    ELSE
      result% = 220
    END IF
  ELSE
    result% = 20
  END IF
ELSE
  result% = 99
END IF
ASSERT result% = 222, "Test 9: r%=2 s%=2 t%=2 should give deeply nested 222"

REM Test 10: Single-line IF THEN (true)
c% = 5
result% = 0
IF c% = 5 THEN result% = 5
ASSERT result% = 5, "Test 10: c%=5 single-line should set result%=5"

REM Test 11: Single-line IF THEN (false, no action)
d% = 3
result% = 0
IF d% = 5 THEN result% = 5
ASSERT result% = 0, "Test 11: d%=3 single-line should not change result%"

REM Test 12: Single-line IF THEN ELSE (true branch)
e% = 1
result% = 0
IF e% = 1 THEN result% = 1 ELSE result% = 99
ASSERT result% = 1, "Test 12: e%=1 should take THEN branch"

REM Test 13: Single-line IF THEN ELSE (false branch)
f% = 2
result% = 0
IF f% = 1 THEN result% = 1 ELSE result% = 99
ASSERT result% = 99, "Test 13: f%=2 should take ELSE branch"

REM Test 14: Block IF/ELSE (no ELSEIF) - true branch
i% = 1
result% = 0
IF i% = 1 THEN
  result% = 1
ELSE
  result% = 99
END IF
ASSERT result% = 1, "Test 14: i%=1 block IF should take THEN branch"

REM Test 15: Block IF/ELSE (no ELSEIF) - false branch
j% = 5
result% = 0
IF j% = 1 THEN
  result% = 1
ELSE
  result% = 99
END IF
ASSERT result% = 99, "Test 15: j%=5 block IF should take ELSE branch"

REM Test 16: Simple IF/ELSEIF/ELSE - first matches
k% = 1
result% = 0
IF k% = 1 THEN
  result% = 1
ELSEIF k% = 2 THEN
  result% = 2
ELSE
  result% = 99
END IF
ASSERT result% = 1, "Test 16: k%=1 should match first IF"

REM Test 17: Simple IF/ELSEIF/ELSE - elseif matches
l% = 2
result% = 0
IF l% = 1 THEN
  result% = 1
ELSEIF l% = 2 THEN
  result% = 2
ELSE
  result% = 99
END IF
ASSERT result% = 2, "Test 17: l%=2 should match ELSEIF"

REM Test 18: Simple IF/ELSEIF/ELSE - else matches
m% = 9
result% = 0
IF m% = 1 THEN
  result% = 1
ELSEIF m% = 2 THEN
  result% = 2
ELSE
  result% = 99
END IF
ASSERT result% = 99, "Test 18: m%=9 should fall through to ELSE"
