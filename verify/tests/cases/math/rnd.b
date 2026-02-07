REM Test: RND and RANDOMIZE

REM Seed the random number generator
RANDOMIZE 12345

REM RND should return value between 0 and 1
r1 = RND
ASSERT r1 >= 0, "RND should be >= 0"
ASSERT r1 <= 1, "RND should be <= 1"

r2 = RND
ASSERT r2 >= 0, "Second RND should be >= 0"
ASSERT r2 <= 1, "Second RND should be <= 1"

REM Same seed should produce same sequence
RANDOMIZE 12345
s1 = RND
s2 = RND
ASSERT s1 = r1, "Same seed should produce same first value"
ASSERT s2 = r2, "Same seed should produce same second value"

REM Generate multiple values, all should be in range
ok% = -1
FOR i% = 1 TO 20
  v = RND
  IF v < 0 OR v > 1 THEN ok% = 0
NEXT
ASSERT ok%, "All 20 RND values should be in [0,1]"
