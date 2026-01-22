ACE BASIC Compiler Test Suite
=============================

This test suite validates the ACE BASIC compiler functionality.

Directory Structure
-------------------

verify/tests/
  runner.rexx       - ARexx test runner script
  run-screens.rexx  - Visual verification for screen tests
  cases/            - Test source files
    syntax/         - Basic syntax tests
    arithmetic/     - Integer arithmetic tests
    floats/         - Floating point tests
    control/        - Control flow tests
    errors/         - Expected compilation failures
    screens/        - ECS screen mode tests (visual verification)
  expected/         - Expected output for runtime verification
  results/          - Test run output (created at runtime)

Running Tests
-------------

On Amiga (or emulator):

  rx verify/tests/runner.rexx           ; Run all tests
  rx verify/tests/runner.rexx syntax    ; Run only syntax tests
  rx verify/tests/runner.rexx floats    ; Run only float tests
  rx verify/tests/runner.rexx errors    ; Run only error tests
  rx verify/tests/runner.rexx screens   ; Run only screen tests (compile-only)

Test Levels
-----------

Level 1: Compile-only
  - Verifies ACE produces .s assembly file
  - Exit code 0 indicates success

Level 2-4: Full pipeline (when expected output exists)
  - Compiles, assembles, links, and runs
  - Compares output against expected/testname.expected

Error Tests
-----------

Tests in cases/errors/ are expected to FAIL compilation.
A passing error test means the compiler correctly rejected invalid code.

Screen Tests
------------

Tests in cases/screens/ verify ECS screen modes compile correctly.
These are compile-only tests since output goes to the screen, not stdout.

Supported modes (OCS/ECS compatible):
  - Mode 1: Lores (320x200)
  - Mode 2: Hires (640x200)
  - Mode 3: Lores interlaced (320x400)
  - Mode 4: Hires interlaced (640x400)
  - Mode 5: HAM (Hold-And-Modify)
  - Mode 6: Extra-halfbrite (EHB)

For visual verification, use the dedicated script:

  cd ACE:verify/tests
  rx run-screens.rexx

This builds and runs each screen test sequentially with a 5-second delay
so you can visually verify each screen opens correctly.

Adding New Tests
----------------

1. Create a .b file in the appropriate cases/ subdirectory
2. Optionally create expected/testname.expected for output verification
3. For error tests, place in cases/errors/ (compilation should fail)

Test Naming
-----------

Use descriptive names without spaces:
  - float_add.b, not "float add.b"
  - for_loop.b, not "for-loop.b"
