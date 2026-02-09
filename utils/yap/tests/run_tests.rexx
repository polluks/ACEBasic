/* YAP Preprocessor Test Runner
 *
 * Usage: rx run_tests.rexx [testname]
 *   No args: run all tests
 *   With arg: run only that test (e.g. "comments", "define")
 *
 * Must be run from the utils/yap/tests/ directory.
 */

PARSE ARG singleTest

yap = 'ACE:utils/yap/yap'
testsDir = ''

pass = 0
fail = 0

IF singleTest ~= '' THEN DO
    CALL runTest('test_' || singleTest)
END
ELSE DO
    /* Get list of .expected files */
    ADDRESS COMMAND 'list' testsDir 'PAT=test_#?.expected LFORMAT=%s >T:yaptests'

    IF ~OPEN('flist', 'T:yaptests', 'R') THEN DO
        SAY 'No test files found.'
        EXIT 10
    END

    DO WHILE ~EOF('flist')
        line = READLN('flist')
        IF line = '' THEN ITERATE
        /* Strip .expected suffix to get test name */
        testName = LEFT(line, LENGTH(line) - 9)
        CALL runTest(testName)
    END

    CALL CLOSE('flist')
    ADDRESS COMMAND 'delete >NIL: T:yaptests'
END

SAY ''
SAY 'Results:' pass 'passed,' fail 'failed'
IF fail > 0 THEN EXIT 10
EXIT 0

/*------------------------------------------------------------*/
runTest: PROCEDURE EXPOSE yap testsDir pass fail
    PARSE ARG testName

    input = testsDir || testName || '.b'
    expected = testsDir || testName || '.expected'
    actual = 'T:' || testName || '.actual'

    IF ~EXISTS(expected) THEN DO
        SAY '[SKIP]' testName '(no .expected file)'
        RETURN
    END

    IF ~EXISTS(input) THEN DO
        SAY '[SKIP]' testName '(no .b file)'
        RETURN
    END

    /* Build flags for special tests */
    flags = ''
    SELECT
        WHEN testName = 'test_cli_define' THEN
            flags = '-DPLATFORM=AMIGA -UDEBUG'
        WHEN testName = 'test_include_angle' THEN
            flags = '-Iincdir'
        OTHERWISE NOP
    END

    /* Run yap */
    cmd = yap flags input actual
    ADDRESS COMMAND cmd
    rc = RC

    IF rc ~= 0 THEN DO
        SAY '[FAIL]' testName '(yap returned' rc || ')'
        fail = fail + 1
        RETURN
    END

    /* Compare output with expected */
    match = compareFiles(expected, actual)

    IF match THEN DO
        SAY '[PASS]' testName
        pass = pass + 1
    END
    ELSE DO
        SAY '[FAIL]' testName '(output mismatch)'
        SAY '  Expected:'
        CALL showFile(expected)
        SAY '  Got:'
        CALL showFile(actual)
        fail = fail + 1
    END

    /* Clean up */
    IF EXISTS(actual) THEN ADDRESS COMMAND 'delete >NIL:' actual

    RETURN

/*------------------------------------------------------------*/
compareFiles: PROCEDURE
    PARSE ARG file1, file2

    IF ~OPEN('f1', file1, 'R') THEN RETURN 0
    IF ~OPEN('f2', file2, 'R') THEN DO
        CALL CLOSE('f1')
        RETURN 0
    END

    match = 1
    DO WHILE ~EOF('f1') & ~EOF('f2')
        line1 = READLN('f1')
        line2 = READLN('f2')
        IF line1 ~= line2 THEN DO
            match = 0
            LEAVE
        END
    END

    /* Check both files ended */
    IF match THEN DO
        IF ~EOF('f1') | ~EOF('f2') THEN match = 0
    END

    CALL CLOSE('f1')
    CALL CLOSE('f2')
    RETURN match

/*------------------------------------------------------------*/
showFile: PROCEDURE
    PARSE ARG filename
    IF ~OPEN('sf', filename, 'R') THEN DO
        SAY '    (cannot open)'
        RETURN
    END
    n = 1
    DO WHILE ~EOF('sf') & n <= 10
        line = READLN('sf')
        IF ~EOF('sf') | line ~= '' THEN
            SAY '    ' || n || ': [' || line || ']'
        n = n + 1
    END
    CALL CLOSE('sf')
    RETURN
