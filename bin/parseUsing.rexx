/* parseUsing.rexx - Scan source file for REM #using directives
 *
 * Usage: rx parseUsing.rexx <sourcefile>
 *
 * Scans the first 20 lines of a BASIC source file for REM #using
 * directives and outputs the paths space-separated.
 *
 * Example directive in source:
 *   REM #using ace:submods/list/list.o
 *
 * Output: ace:submods/list/list.o
 */

PARSE ARG filename

IF filename = '' THEN DO
    SAY 'Usage: rx parseUsing.rexx <sourcefile>'
    EXIT 10
END

filename = STRIP(filename)

IF ~OPEN('f', filename, 'R') THEN DO
    /* File doesn't exist or can't be opened - silent exit */
    EXIT 0
END

out = ''
DO i = 1 TO 20 WHILE ~EOF('f')
    line = READLN('f')
    uline = UPPER(line)

    /* Look for #using directive (case-insensitive) */
    p = POS('#USING', uline)
    IF p > 0 THEN DO
        /* Extract path after #using */
        path = STRIP(SUBSTR(line, p + 7))
        IF path ~= '' THEN
            out = out || ' ' || path
    END
END

CALL CLOSE('f')

/* Only output if we found something */
out = STRIP(out)
IF out ~= '' THEN
    SAY out
EXIT 0
