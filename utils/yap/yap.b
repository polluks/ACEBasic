REM YAP - Yet Another Preprocessor for ACE BASIC
REM Phase 3: #include support with include-once and path resolution
REM
REM Usage: yap [options] <inputfile> <outputfile>
REM
REM Removes all four comment types. Consolidates blank lines.
REM Processes #define, #undef, #ifdef, #ifndef, #else, #endif.
REM Replaces macros in output lines (not inside strings).

DEFINT a-z

REM ---- Constants ----
CONST TRUE = -1
CONST FALSE = 0
CONST MAX_MACROS = 512
CONST MAX_MACRO_NAME = 48
CONST MAX_MACRO_VALUE = 256
CONST MAX_COND_DEPTH = 16
CONST MAX_INCLUDE_DEPTH = 8
CONST MAX_INCLUDED_FILES = 128
CONST MAX_INCLUDE_PATHS = 8

REM ---- Global variables ----
STRING inFile$ SIZE 256
STRING outFile$ SIZE 256
SHORTINT inCComment
SHORTINT inAceComment
SHORTINT lastWasBlank
SHORTINT exitCode

REM ---- Include file stack ----
DIM inclFileName$(MAX_INCLUDE_DEPTH) SIZE 256
DIM inclLineNum(MAX_INCLUDE_DEPTH)
SHORTINT includeDepth

REM ---- Include-once tracking ----
DIM includedFiles$(MAX_INCLUDED_FILES) SIZE 256
SHORTINT includedCount

REM ---- Include search paths ----
DIM includePath$(MAX_INCLUDE_PATHS) SIZE 256
SHORTINT includePathCount

REM ---- Macro table ----
DIM macroName$(MAX_MACROS) SIZE MAX_MACRO_NAME
DIM macroValue$(MAX_MACROS) SIZE MAX_MACRO_VALUE
SHORTINT macroCount

REM ---- Conditional stack ----
DIM condActive(MAX_COND_DEPTH)
DIM condSeenTrue(MAX_COND_DEPTH)
DIM condHadElse(MAX_COND_DEPTH)
SHORTINT condDepth

REM ---- Forward declarations ----
DECLARE SUB ShowUsage
DECLARE SUB SHORTINT ParseArgs
DECLARE SUB ProcessFile
DECLARE SUB STRING RemoveComments$(STRING ln$)
DECLARE SUB SHORTINT IsIdentStart(SHORTINT ch)
DECLARE SUB SHORTINT IsIdentChar(SHORTINT ch)
DECLARE SUB SHORTINT MacroFind(STRING nm$)
DECLARE SUB MacroDefine(STRING nm$, STRING val$)
DECLARE SUB MacroUndef(STRING nm$)
DECLARE SUB SHORTINT OutputActive
DECLARE SUB HandleDefine(STRING rest$)
DECLARE SUB HandleUndef(STRING rest$)
DECLARE SUB HandleIfdef(STRING rest$)
DECLARE SUB HandleIfndef(STRING rest$)
DECLARE SUB HandleElse
DECLARE SUB HandleEndif
DECLARE SUB SHORTINT IsDirectiveLine(STRING ln$)
DECLARE SUB HandleDirective(STRING ln$)
DECLARE SUB STRING ReplaceMacros$(STRING ln$)
DECLARE SUB STRING FileDir$(STRING path$)
DECLARE SUB SHORTINT AlreadyIncluded(STRING path$)
DECLARE SUB AddIncluded(STRING path$)
DECLARE SUB STRING FindIncludeFile$(STRING nm$, SHORTINT isAngle)
DECLARE SUB HandleInclude(STRING rest$)

REM ---- Main program ----
exitCode = 0
inCComment = FALSE
inAceComment = FALSE
lastWasBlank = FALSE
macroCount = 0
condDepth = 0
includeDepth = 0
includedCount = 0
includePathCount = 0

IF ParseArgs = FALSE THEN
  SYSTEM 10
END IF

ProcessFile
SYSTEM exitCode

REM ---- SUB: ShowUsage ----
SUB ShowUsage
  PRINT "YAP - Yet Another Preprocessor for ACE BASIC"
  PRINT "Usage: yap [options] <inputfile> <outputfile>"
  PRINT ""
  PRINT "Options:"
  PRINT "  -H              Show this help"
  PRINT "  -D<name>[=val]  Define a macro"
  PRINT "  -U<name>        Undefine a macro"
  PRINT "  -I<path>        Add include search path"
END SUB

REM ---- SUB: ParseArgs ----
REM Returns TRUE if arguments are valid, FALSE otherwise
SUB SHORTINT ParseArgs
  SHARED inFile$, outFile$
  SHARED includePath$, includePathCount
  SHORTINT i, nFiles
  STRING a$ SIZE 256
  STRING opt$ SIZE 2
  STRING rest$ SIZE 256
  SHORTINT eqPos, j, pLen, lastCh

  nFiles = 0

  IF ARGCOUNT < 2 THEN
    ShowUsage
    ParseArgs = FALSE
    EXIT SUB
  END IF

  FOR i = 1 TO ARGCOUNT
    a$ = ARG$(i)
    IF LEFT$(a$, 1) = "-" THEN
      opt$ = UCASE$(MID$(a$, 2, 1))
      IF opt$ = "H" THEN
        ShowUsage
        ParseArgs = FALSE
        EXIT SUB
      ELSEIF opt$ = "D" THEN
        REM -D<name>[=value]
        rest$ = MID$(a$, 3)
        IF LEN(rest$) = 0 THEN
          PRINT "Error: -D requires a macro name"
          ParseArgs = FALSE
          EXIT SUB
        END IF
        eqPos = 0
        FOR j = 1 TO LEN(rest$)
          IF MID$(rest$, j, 1) = "=" THEN
            eqPos = j
            j = LEN(rest$)
          END IF
        NEXT
        IF eqPos > 0 THEN
          MacroDefine(LEFT$(rest$, eqPos - 1), MID$(rest$, eqPos + 1))
        ELSE
          MacroDefine(rest$, "1")
        END IF
      ELSEIF opt$ = "U" THEN
        REM -U<name>
        rest$ = MID$(a$, 3)
        IF LEN(rest$) = 0 THEN
          PRINT "Error: -U requires a macro name"
          ParseArgs = FALSE
          EXIT SUB
        END IF
        MacroUndef(rest$)
      ELSEIF opt$ = "I" THEN
        REM -I<path>
        rest$ = MID$(a$, 3)
        IF LEN(rest$) = 0 THEN
          PRINT "Error: -I requires a path"
          ParseArgs = FALSE
          EXIT SUB
        END IF
        IF includePathCount >= MAX_INCLUDE_PATHS THEN
          PRINT "Error: too many -I paths (max "; STR$(MAX_INCLUDE_PATHS); ")"
          ParseArgs = FALSE
          EXIT SUB
        END IF
        REM Ensure path ends with / or :
        pLen = LEN(rest$)
        lastCh = PEEK(@rest$ + pLen - 1)
        IF lastCh <> 47 AND lastCh <> 58 THEN
          rest$ = rest$ + "/"
        END IF
        includePath$(includePathCount) = rest$
        ++includePathCount
      END IF
    ELSE
      ++nFiles
      IF nFiles = 1 THEN
        inFile$ = a$
      ELSEIF nFiles = 2 THEN
        outFile$ = a$
      END IF
    END IF
  NEXT

  IF nFiles < 2 THEN
    PRINT "Error: need input and output file"
    ShowUsage
    ParseArgs = FALSE
    EXIT SUB
  END IF

  ParseArgs = TRUE
END SUB

REM ---- SUB: IsIdentStart ----
REM Returns TRUE if ch is a letter or underscore
SUB SHORTINT IsIdentStart(SHORTINT ch)
  IF ch = 95 THEN
    IsIdentStart = TRUE
  ELSEIF ch >= 65 AND ch <= 90 THEN
    IsIdentStart = TRUE
  ELSEIF ch >= 97 AND ch <= 122 THEN
    IsIdentStart = TRUE
  ELSE
    IsIdentStart = FALSE
  END IF
END SUB

REM ---- SUB: IsIdentChar ----
REM Returns TRUE if ch is a letter, digit, or underscore
SUB SHORTINT IsIdentChar(SHORTINT ch)
  IF ch = 95 THEN
    IsIdentChar = TRUE
  ELSEIF ch >= 65 AND ch <= 90 THEN
    IsIdentChar = TRUE
  ELSEIF ch >= 97 AND ch <= 122 THEN
    IsIdentChar = TRUE
  ELSEIF ch >= 48 AND ch <= 57 THEN
    IsIdentChar = TRUE
  ELSE
    IsIdentChar = FALSE
  END IF
END SUB

REM ---- SUB: MacroFind ----
REM Linear search for macro by name. Returns index (0-based) or -1.
SUB SHORTINT MacroFind(STRING nm$)
  SHARED macroName$, macroCount
  SHORTINT i
  MacroFind = -1
  FOR i = 0 TO macroCount - 1
    IF macroName$(i) = nm$ THEN
      MacroFind = i
      EXIT FOR
    END IF
  NEXT
END SUB

REM ---- SUB: MacroDefine ----
REM Add or update a macro in the table.
SUB MacroDefine(STRING nm$, STRING val$)
  SHARED macroName$, macroValue$, macroCount
  SHORTINT idx
  idx = MacroFind(nm$)
  IF idx >= 0 THEN
    macroValue$(idx) = val$
  ELSE
    IF macroCount >= MAX_MACROS THEN
      PRINT "Error: too many macros (max "; STR$(MAX_MACROS); ")"
      STOP
    END IF
    macroName$(macroCount) = nm$
    macroValue$(macroCount) = val$
    ++macroCount
  END IF
END SUB

REM ---- SUB: MacroUndef ----
REM Remove a macro by swapping with last entry.
SUB MacroUndef(STRING nm$)
  SHARED macroName$, macroValue$, macroCount
  SHORTINT idx
  idx = MacroFind(nm$)
  IF idx >= 0 THEN
    --macroCount
    IF idx < macroCount THEN
      macroName$(idx) = macroName$(macroCount)
      macroValue$(idx) = macroValue$(macroCount)
    END IF
  END IF
END SUB

REM ---- SUB: OutputActive ----
REM Returns TRUE if all conditional levels are active (output should happen).
SUB SHORTINT OutputActive
  SHARED condActive, condDepth
  SHORTINT i
  OutputActive = TRUE
  FOR i = 1 TO condDepth
    IF condActive(i) = FALSE THEN
      OutputActive = FALSE
      EXIT FOR
    END IF
  NEXT
END SUB

REM ---- SUB: HandleDefine ----
REM Parse: TOKEN [value]
SUB HandleDefine(STRING rest$)
  SHARED inclFileName$, inclLineNum, includeDepth, exitCode
  STRING nm$ SIZE 256
  STRING val$ SIZE 256
  SHORTINT i, sLen, ch, startPos

  sLen = LEN(rest$)
  i = 1

  REM Skip leading whitespace
  WHILE i <= sLen
    ch = PEEK(@rest$ + i - 1)
    IF ch <> 32 AND ch <> 9 THEN
      i = i
      GOTO hd_got_start
    END IF
    ++i
  WEND
  PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #define missing name"
  exitCode = 10
  EXIT SUB

hd_got_start:
  REM Extract identifier
  startPos = i
  IF IsIdentStart(PEEK(@rest$ + i - 1)) = FALSE THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #define invalid name"
    exitCode = 10
    EXIT SUB
  END IF
  WHILE i <= sLen
    IF IsIdentChar(PEEK(@rest$ + i - 1)) THEN
      ++i
    ELSE
      GOTO hd_got_name
    END IF
  WEND

hd_got_name:
  nm$ = MID$(rest$, startPos, i - startPos)

  REM Skip whitespace between name and value
  WHILE i <= sLen
    ch = PEEK(@rest$ + i - 1)
    IF ch = 32 OR ch = 9 THEN
      ++i
    ELSE
      GOTO hd_got_val_start
    END IF
  WEND
  REM No value provided - default to "1"
  MacroDefine(nm$, "1")
  EXIT SUB

hd_got_val_start:
  val$ = MID$(rest$, i)
  MacroDefine(nm$, val$)
END SUB

REM ---- SUB: HandleUndef ----
REM Parse: TOKEN
SUB HandleUndef(STRING rest$)
  SHARED inclFileName$, inclLineNum, includeDepth, exitCode
  STRING nm$ SIZE 256
  SHORTINT i, sLen, ch, startPos

  sLen = LEN(rest$)
  i = 1

  REM Skip leading whitespace
  WHILE i <= sLen
    ch = PEEK(@rest$ + i - 1)
    IF ch <> 32 AND ch <> 9 THEN
      GOTO hu_got_start
    END IF
    ++i
  WEND
  PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #undef missing name"
  exitCode = 10
  EXIT SUB

hu_got_start:
  REM Extract identifier
  startPos = i
  WHILE i <= sLen
    IF IsIdentChar(PEEK(@rest$ + i - 1)) THEN
      ++i
    ELSE
      GOTO hu_got_name
    END IF
  WEND

hu_got_name:
  nm$ = MID$(rest$, startPos, i - startPos)
  MacroUndef(nm$)
END SUB

REM ---- SUB: HandleIfdef ----
SUB HandleIfdef(STRING rest$)
  SHARED condActive, condSeenTrue, condHadElse
  SHARED condDepth, inclFileName$, inclLineNum, includeDepth, exitCode
  STRING nm$ SIZE 256
  SHORTINT i, sLen, ch, startPos, parentActive, defined

  IF condDepth >= MAX_COND_DEPTH THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": conditional nesting too deep"
    exitCode = 10
    EXIT SUB
  END IF

  REM Check if parent levels are all active
  parentActive = TRUE
  FOR i = 1 TO condDepth
    IF condActive(i) = FALSE THEN
      parentActive = FALSE
      i = condDepth
    END IF
  NEXT

  sLen = LEN(rest$)
  i = 1

  REM Skip leading whitespace
  WHILE i <= sLen
    ch = PEEK(@rest$ + i - 1)
    IF ch <> 32 AND ch <> 9 THEN
      GOTO hif_got_start
    END IF
    ++i
  WEND
  PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #ifdef missing name"
  exitCode = 10
  EXIT SUB

hif_got_start:
  startPos = i
  WHILE i <= sLen
    IF IsIdentChar(PEEK(@rest$ + i - 1)) THEN
      ++i
    ELSE
      GOTO hif_got_name
    END IF
  WEND

hif_got_name:
  nm$ = MID$(rest$, startPos, i - startPos)
  defined = (MacroFind(nm$) >= 0)

  ++condDepth
  IF parentActive AND defined THEN
    condActive(condDepth) = TRUE
    condSeenTrue(condDepth) = TRUE
  ELSE
    condActive(condDepth) = FALSE
    IF parentActive THEN
      condSeenTrue(condDepth) = defined
    ELSE
      condSeenTrue(condDepth) = TRUE
    END IF
  END IF
  condHadElse(condDepth) = FALSE
END SUB

REM ---- SUB: HandleIfndef ----
SUB HandleIfndef(STRING rest$)
  SHARED condActive, condSeenTrue, condHadElse
  SHARED condDepth, inclFileName$, inclLineNum, includeDepth, exitCode
  STRING nm$ SIZE 256
  SHORTINT i, sLen, ch, startPos, parentActive, defined

  IF condDepth >= MAX_COND_DEPTH THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": conditional nesting too deep"
    exitCode = 10
    EXIT SUB
  END IF

  parentActive = TRUE
  FOR i = 1 TO condDepth
    IF condActive(i) = FALSE THEN
      parentActive = FALSE
      i = condDepth
    END IF
  NEXT

  sLen = LEN(rest$)
  i = 1

  WHILE i <= sLen
    ch = PEEK(@rest$ + i - 1)
    IF ch <> 32 AND ch <> 9 THEN
      GOTO hnif_got_start
    END IF
    ++i
  WEND
  PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #ifndef missing name"
  exitCode = 10
  EXIT SUB

hnif_got_start:
  startPos = i
  WHILE i <= sLen
    IF IsIdentChar(PEEK(@rest$ + i - 1)) THEN
      ++i
    ELSE
      GOTO hnif_got_name
    END IF
  WEND

hnif_got_name:
  nm$ = MID$(rest$, startPos, i - startPos)
  defined = (MacroFind(nm$) >= 0)

  ++condDepth
  IF parentActive AND (defined = FALSE) THEN
    condActive(condDepth) = TRUE
    condSeenTrue(condDepth) = TRUE
  ELSE
    condActive(condDepth) = FALSE
    IF parentActive THEN
      condSeenTrue(condDepth) = (defined = FALSE)
    ELSE
      condSeenTrue(condDepth) = TRUE
    END IF
  END IF
  condHadElse(condDepth) = FALSE
END SUB

REM ---- SUB: HandleElse ----
SUB HandleElse
  SHARED condActive, condSeenTrue, condHadElse
  SHARED condDepth, inclFileName$, inclLineNum, includeDepth, exitCode
  SHORTINT parentActive, i

  IF condDepth = 0 THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #else without #ifdef/#ifndef"
    exitCode = 10
    EXIT SUB
  END IF

  IF condHadElse(condDepth) THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": duplicate #else"
    exitCode = 10
    EXIT SUB
  END IF

  parentActive = TRUE
  FOR i = 1 TO condDepth - 1
    IF condActive(i) = FALSE THEN
      parentActive = FALSE
      i = condDepth
    END IF
  NEXT

  condHadElse(condDepth) = TRUE
  IF parentActive AND condSeenTrue(condDepth) = FALSE THEN
    condActive(condDepth) = TRUE
    condSeenTrue(condDepth) = TRUE
  ELSE
    condActive(condDepth) = FALSE
  END IF
END SUB

REM ---- SUB: HandleEndif ----
SUB HandleEndif
  SHARED condDepth, inclFileName$, inclLineNum, includeDepth, exitCode

  IF condDepth = 0 THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #endif without #ifdef/#ifndef"
    exitCode = 10
    EXIT SUB
  END IF

  --condDepth
END SUB

REM ---- SUB: IsDirectiveLine ----
REM Returns TRUE if the line starts with # (after optional whitespace)
SUB SHORTINT IsDirectiveLine(STRING ln$)
  SHORTINT i, sLen, ch
  sLen = LEN(ln$)
  i = 1
  WHILE i <= sLen
    ch = PEEK(@ln$ + i - 1)
    IF ch = 32 OR ch = 9 THEN
      ++i
    ELSEIF ch = 35 THEN
      IsDirectiveLine = TRUE
      EXIT SUB
    ELSE
      IsDirectiveLine = FALSE
      EXIT SUB
    END IF
  WEND
  IsDirectiveLine = FALSE
END SUB

REM ---- SUB: HandleDirective ----
REM Dispatcher: extract keyword after #, route to handler.
REM Conditionals are always processed (even in false branches) for nesting.
REM #define/#undef are skipped in false branches.
SUB HandleDirective(STRING ln$)
  SHARED exitCode
  STRING kw$ SIZE 16
  STRING rest$ SIZE 1025
  SHORTINT i, sLen, ch, startPos

  sLen = LEN(ln$)
  i = 1

  REM Skip whitespace before #
  WHILE i <= sLen
    ch = PEEK(@ln$ + i - 1)
    IF ch = 32 OR ch = 9 THEN
      ++i
    ELSE
      GOTO hdir_hash
    END IF
  WEND
  EXIT SUB

hdir_hash:
  REM Skip the # character
  ++i

  REM Skip whitespace after #
  WHILE i <= sLen
    ch = PEEK(@ln$ + i - 1)
    IF ch = 32 OR ch = 9 THEN
      ++i
    ELSE
      GOTO hdir_kw_start
    END IF
  WEND
  EXIT SUB

hdir_kw_start:
  REM Extract keyword
  startPos = i
  WHILE i <= sLen
    ch = PEEK(@ln$ + i - 1)
    IF ch >= 97 AND ch <= 122 THEN
      ++i
    ELSEIF ch >= 65 AND ch <= 90 THEN
      ++i
    ELSE
      GOTO hdir_got_kw
    END IF
  WEND

hdir_got_kw:
  kw$ = LCASE$(MID$(ln$, startPos, i - startPos))

  REM Remainder after keyword
  IF i <= sLen THEN
    rest$ = MID$(ln$, i)
  ELSE
    rest$ = ""
  END IF

  REM Conditionals are always processed for correct nesting
  IF kw$ = "ifdef" THEN
    HandleIfdef(rest$)
  ELSEIF kw$ = "ifndef" THEN
    HandleIfndef(rest$)
  ELSEIF kw$ = "else" THEN
    HandleElse
  ELSEIF kw$ = "endif" THEN
    HandleEndif
  ELSEIF OutputActive THEN
    REM #define, #undef, #include only in active branches
    IF kw$ = "define" THEN
      HandleDefine(rest$)
    ELSEIF kw$ = "undef" THEN
      HandleUndef(rest$)
    ELSEIF kw$ = "include" THEN
      HandleInclude(rest$)
    END IF
  END IF
END SUB

REM ---- SUB: ReplaceMacros$ ----
REM Token-scanning replacement engine.
REM Scans for identifiers, looks them up, replaces with value.
REM Does NOT replace inside string literals.
REM No recursive expansion.
REM Optimized: POKE-based O(n) string building, inlined ident checks.
SUB STRING ReplaceMacros$(STRING ln$)
  SHARED macroCount, macroName$, macroValue$
  STRING out$ SIZE 1025
  STRING tok$ SIZE 256
  SHORTINT i, sLen, ch, startPos, idx, inQuote, oLen
  SHORTINT vLen, j

  IF macroCount = 0 THEN
    ReplaceMacros$ = ln$
    EXIT SUB
  END IF

  oLen = 0
  inQuote = FALSE
  sLen = LEN(ln$)
  i = 1

  WHILE i <= sLen
    ch = PEEK(@ln$ + i - 1)

    REM Track string literals
    IF ch = 34 THEN
      inQuote = NOT inQuote
      POKE @out$ + oLen, ch
      ++oLen
      ++i
    ELSEIF inQuote THEN
      POKE @out$ + oLen, ch
      ++oLen
      ++i
    ELSEIF ch = 95 OR (ch >= 65 AND ch <= 90) OR (ch >= 97 AND ch <= 122) THEN
      REM Identifier start (inlined IsIdentStart)
      startPos = i
      ++i
      WHILE i <= sLen
        ch = PEEK(@ln$ + i - 1)
        REM Inlined IsIdentChar
        IF ch = 95 OR (ch >= 65 AND ch <= 90) OR (ch >= 97 AND ch <= 122) OR (ch >= 48 AND ch <= 57) THEN
          ++i
        ELSE
          GOTO rm_got_tok
        END IF
      WEND
rm_got_tok:
      tok$ = MID$(ln$, startPos, i - startPos)
      idx = MacroFind(tok$)
      IF idx >= 0 THEN
        REM Copy macro value via POKE
        vLen = LEN(macroValue$(idx))
        FOR j = 0 TO vLen - 1
          POKE @out$ + oLen + j, PEEK(@macroValue$(idx) + j)
        NEXT
        oLen = oLen + vLen
      ELSE
        REM Copy original token via POKE
        vLen = i - startPos
        FOR j = 0 TO vLen - 1
          POKE @out$ + oLen + j, PEEK(@ln$ + startPos - 1 + j)
        NEXT
        oLen = oLen + vLen
      END IF
    ELSE
      POKE @out$ + oLen, ch
      ++oLen
      ++i
    END IF
  WEND

  POKE @out$ + oLen, 0
  ReplaceMacros$ = out$
END SUB

REM ---- SUB: FileDir$ ----
REM Extracts the directory portion of a path.
REM Returns everything up to and including the last / or :
REM Returns "" if no directory separator found.
SUB STRING FileDir$(STRING path$)
  SHORTINT i, sLen, ch, lastSep
  sLen = LEN(path$)
  lastSep = 0
  FOR i = 1 TO sLen
    ch = PEEK(@path$ + i - 1)
    IF ch = 47 OR ch = 58 THEN
      lastSep = i
    END IF
  NEXT
  IF lastSep > 0 THEN
    FileDir$ = LEFT$(path$, lastSep)
  ELSE
    FileDir$ = ""
  END IF
END SUB

REM ---- SUB: AlreadyIncluded ----
REM Returns TRUE if the given path is in the included-files list.
SUB SHORTINT AlreadyIncluded(STRING path$)
  SHARED includedFiles$, includedCount
  SHORTINT i
  AlreadyIncluded = FALSE
  FOR i = 0 TO includedCount - 1
    IF includedFiles$(i) = path$ THEN
      AlreadyIncluded = TRUE
      EXIT FOR
    END IF
  NEXT
END SUB

REM ---- SUB: AddIncluded ----
REM Adds a file path to the included-files list.
SUB AddIncluded(STRING path$)
  SHARED includedFiles$, includedCount
  IF includedCount >= MAX_INCLUDED_FILES THEN
    PRINT "Error: too many included files (max "; STR$(MAX_INCLUDED_FILES); ")"
    STOP
  END IF
  includedFiles$(includedCount) = path$
  ++includedCount
END SUB

REM ---- SUB: FindIncludeFile$ ----
REM Resolves an include filename to a full path.
REM isAngle: TRUE for <...>, FALSE for "..."
REM Quoted form: try relative to current file dir, then -I paths
REM Angle form: try ACEinclude: + name, then -I paths
REM Returns resolved path or "" if not found.
SUB STRING FindIncludeFile$(STRING nm$, SHORTINT isAngle)
  SHARED inclFileName$, includeDepth
  SHARED includePath$, includePathCount
  STRING tryPath$ SIZE 256
  STRING curDir$ SIZE 256
  SHORTINT i

  IF isAngle = FALSE THEN
    REM Quoted form: try relative to current file's directory
    curDir$ = FileDir$(inclFileName$(includeDepth))
    IF LEN(curDir$) > 0 THEN
      tryPath$ = curDir$ + nm$
      OPEN "I", #10, tryPath$
      IF HANDLE(10) <> 0& THEN
        CLOSE #10
        FindIncludeFile$ = tryPath$
        EXIT SUB
      END IF
    END IF
    REM Try current working directory
    OPEN "I", #10, nm$
    IF HANDLE(10) <> 0& THEN
      CLOSE #10
      FindIncludeFile$ = nm$
      EXIT SUB
    END IF
  ELSE
    REM Angle form: try ACEinclude: + name
    tryPath$ = "ACEinclude:" + nm$
    OPEN "I", #10, tryPath$
    IF HANDLE(10) <> 0& THEN
      CLOSE #10
      FindIncludeFile$ = tryPath$
      EXIT SUB
    END IF
  END IF

  REM Try -I paths
  FOR i = 0 TO includePathCount - 1
    tryPath$ = includePath$(i) + nm$
    OPEN "I", #10, tryPath$
    IF HANDLE(10) <> 0& THEN
      CLOSE #10
      FindIncludeFile$ = tryPath$
      EXIT SUB
    END IF
  NEXT

  FindIncludeFile$ = ""
END SUB

REM ---- SUB: HandleInclude ----
REM Parse #include directive: extract filename, resolve, push state, open.
SUB HandleInclude(STRING rest$)
  SHARED inclFileName$, inclLineNum, includeDepth
  SHARED exitCode
  STRING nm$ SIZE 256
  STRING resolved$ SIZE 256
  SHORTINT i, sLen, ch, startPos, endChar, isAngle, chan

  sLen = LEN(rest$)
  i = 1

  REM Skip leading whitespace
  WHILE i <= sLen
    ch = PEEK(@rest$ + i - 1)
    IF ch = 32 OR ch = 9 THEN
      ++i
    ELSE
      GOTO hinc_got_start
    END IF
  WEND
  PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #include missing filename"
  exitCode = 10
  EXIT SUB

hinc_got_start:
  REM Determine delimiter type
  IF ch = 34 THEN
    REM Double quote: "filename"
    endChar = 34
    isAngle = FALSE
    ++i
  ELSEIF ch = 60 THEN
    REM Angle bracket: <filename>
    endChar = 62
    isAngle = TRUE
    ++i
  ELSE
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #include expected "" or <"
    exitCode = 10
    EXIT SUB
  END IF

  REM Extract filename
  startPos = i
  WHILE i <= sLen
    ch = PEEK(@rest$ + i - 1)
    IF ch = endChar THEN
      GOTO hinc_got_name
    END IF
    ++i
  WEND
  PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #include unterminated filename"
  exitCode = 10
  EXIT SUB

hinc_got_name:
  nm$ = MID$(rest$, startPos, i - startPos)
  IF LEN(nm$) = 0 THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #include empty filename"
    exitCode = 10
    EXIT SUB
  END IF

  REM Resolve path
  resolved$ = FindIncludeFile$(nm$, isAngle)
  IF LEN(resolved$) = 0 THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": cannot find include file: "; nm$
    exitCode = 10
    EXIT SUB
  END IF

  REM Check include-once
  IF AlreadyIncluded(resolved$) THEN
    EXIT SUB
  END IF

  REM Check depth limit
  IF includeDepth >= MAX_INCLUDE_DEPTH - 1 THEN
    PRINT "Error: "; inclFileName$(includeDepth); " line "; inclLineNum(includeDepth); ": #include nesting too deep"
    exitCode = 10
    EXIT SUB
  END IF

  REM Add to included list
  AddIncluded(resolved$)

  REM Push state and open new file
  ++includeDepth
  inclFileName$(includeDepth) = resolved$
  inclLineNum(includeDepth) = 0

  chan = includeDepth + 2
  OPEN "I", #chan, resolved$
  IF HANDLE(chan) = 0& THEN
    PRINT "Error: cannot open include file: "; resolved$
    --includeDepth
    exitCode = 10
    EXIT SUB
  END IF
END SUB

REM ---- SUB: ProcessFile ----
REM Opens input/output files, reads line by line, removes comments,
REM processes directives, replaces macros, writes output.
SUB ProcessFile
  SHARED inFile$, outFile$, exitCode
  SHARED inCComment, inAceComment, lastWasBlank
  SHARED condDepth
  SHARED inclFileName$, inclLineNum, includeDepth
  STRING ln$ SIZE 1025
  STRING result$ SIZE 1025
  SHORTINT isBlank, bk, ch, chan, running

  REM Initialize include stack for main file
  includeDepth = 0
  inclFileName$(0) = inFile$
  inclLineNum(0) = 0

  OPEN "I", #2, inFile$
  IF HANDLE(2) = 0& THEN
    PRINT "Error: cannot open input file: "; inFile$
    exitCode = 10
    EXIT SUB
  END IF

  OPEN "O", #1, outFile$
  IF HANDLE(1) = 0& THEN
    PRINT "Error: cannot open output file: "; outFile$
    CLOSE #2
    exitCode = 10
    EXIT SUB
  END IF

  running = TRUE
  WHILE running
    chan = includeDepth + 2

    REM Check for EOF on current channel
    IF EOF(chan) THEN
      IF includeDepth = 0 THEN
        running = FALSE
        GOTO pf_loop_end
      ELSE
        REM Pop include stack
        CLOSE #chan
        --includeDepth
        GOTO pf_loop_end
      END IF
    END IF

    LINE INPUT #chan, ln$
    inclLineNum(includeDepth) = inclLineNum(includeDepth) + 1

    result$ = RemoveComments$(ln$)

    REM Is this a directive line?
    IF IsDirectiveLine(result$) THEN
      HandleDirective(result$)
    ELSEIF OutputActive THEN
      REM Apply macro replacement
      result$ = ReplaceMacros$(result$)

      REM Check if line is blank (empty or only whitespace)
      isBlank = TRUE
      IF LEN(result$) > 0 THEN
        FOR bk = 1 TO LEN(result$)
          ch = PEEK(@result$ + bk - 1)
          IF ch <> 32 AND ch <> 9 THEN
            isBlank = FALSE
            EXIT FOR
          END IF
        NEXT
      END IF

      REM Consolidate blank lines: skip consecutive blanks, keep one
      IF isBlank THEN
        IF lastWasBlank = FALSE THEN
          PRINT #1,
          lastWasBlank = TRUE
        END IF
      ELSE
        PRINT #1, result$
        lastWasBlank = FALSE
      END IF
    END IF

pf_loop_end:
  WEND

  REM Check for unterminated block comments
  IF inCComment THEN
    PRINT "Error: "; inclFileName$(0); ": unterminated C block comment at end of file"
    exitCode = 10
  END IF

  IF inAceComment THEN
    PRINT "Error: "; inclFileName$(0); ": unterminated ACE block comment at end of file"
    exitCode = 10
  END IF

  REM Check for unterminated conditionals
  IF condDepth > 0 THEN
    PRINT "Error: "; inclFileName$(0); ": unterminated #ifdef/#ifndef at end of file"
    exitCode = 10
  END IF

  CLOSE #1
  CLOSE #2
END SUB

REM ---- SUB: RemoveComments$ ----
REM Single-pass left-to-right scanner that removes all comment types.
REM Respects string literals (text between double quotes).
REM Optimized: POKE-based O(n) string building, fast path for simple lines.
SUB STRING RemoveComments$(STRING ln$)
  SHARED inCComment, inAceComment
  STRING out$ SIZE 1025
  SHORTINT i, sLen, ch, nx, oLen
  SHORTINT inString, done, handled, hasSpecial

  sLen = LEN(ln$)

  REM Fast path: no block comment active and no special chars in line
  IF inCComment = FALSE AND inAceComment = FALSE THEN
    hasSpecial = FALSE
    FOR i = 0 TO sLen - 1
      ch = PEEK(@ln$ + i)
      IF ch = 47 OR ch = 123 OR ch = 39 OR ch = 34 THEN
        hasSpecial = TRUE
        EXIT FOR
      END IF
    NEXT
    IF hasSpecial = FALSE THEN
      REM Trim trailing whitespace only
      oLen = sLen
      WHILE oLen > 0
        ch = PEEK(@ln$ + oLen - 1)
        IF ch <> 32 AND ch <> 9 THEN
          GOTO rc_fast_done
        END IF
        --oLen
      WEND
rc_fast_done:
      IF oLen = sLen THEN
        RemoveComments$ = ln$
      ELSEIF oLen = 0 THEN
        RemoveComments$ = ""
      ELSE
        RemoveComments$ = LEFT$(ln$, oLen)
      END IF
      EXIT SUB
    END IF
  END IF

  REM Slow path: character-by-character scan with POKE output
  oLen = 0
  inString = FALSE
  done = FALSE
  i = 1

  WHILE i <= sLen AND done = FALSE
    ch = PEEK(@ln$ + i - 1)
    handled = FALSE

    REM ---- Inside C block comment: scan for close ----
    IF inCComment THEN
      IF ch = 42 AND i < sLen THEN
        nx = PEEK(@ln$ + i)
        IF nx = 47 THEN
          inCComment = FALSE
          i = i + 2
        ELSE
          ++i
        END IF
      ELSE
        ++i
      END IF
      handled = TRUE
    END IF

    REM ---- Inside ACE block comment: scan for close ----
    IF handled = FALSE AND inAceComment THEN
      IF ch = 125 THEN
        inAceComment = FALSE
      END IF
      ++i
      handled = TRUE
    END IF

    IF handled = FALSE THEN
      REM ---- Toggle string literal state on " ----
      IF ch = 34 THEN
        inString = NOT inString
        POKE @out$ + oLen, ch
        ++oLen
        ++i
        handled = TRUE
      END IF
    END IF

    IF handled = FALSE AND inString = FALSE THEN
      REM ---- Check for slash (could start C comment) ----
      IF ch = 47 AND i < sLen THEN
        nx = PEEK(@ln$ + i)
        IF nx = 42 THEN
          REM Start of C block comment
          inCComment = TRUE
          i = i + 2
          handled = TRUE
        ELSEIF nx = 47 THEN
          REM Start of C++ line comment - rest of line is comment
          done = TRUE
          handled = TRUE
        END IF
      END IF

      REM ---- Check for ACE block comment open brace ----
      IF handled = FALSE AND ch = 123 THEN
        inAceComment = TRUE
        ++i
        handled = TRUE
      END IF

      REM ---- Check for ACE single-line comment apostrophe ----
      IF handled = FALSE AND ch = 39 THEN
        REM Rest of line is comment
        done = TRUE
        handled = TRUE
      END IF
    END IF

    REM ---- Normal character: POKE to output buffer ----
    IF handled = FALSE THEN
      POKE @out$ + oLen, ch
      ++oLen
      ++i
    END IF
  WEND

  REM Trim trailing whitespace
  WHILE oLen > 0
    ch = PEEK(@out$ + oLen - 1)
    IF ch = 32 OR ch = 9 THEN
      --oLen
    ELSE
      GOTO rc_slow_done
    END IF
  WEND
rc_slow_done:
  POKE @out$ + oLen, 0
  RemoveComments$ = out$
END SUB
