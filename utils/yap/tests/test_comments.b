REM Test input for YAP comment removal
REM This file tests all four comment types

REM --- ACE single-line comments (apostrophe) ---
PRINT "hello" 'this is a comment
x = 42 ' another comment
PRINT "keep this"

REM --- ACE block comments (curly braces) ---
{this is a block comment}
PRINT "before block" {inline block comment} : PRINT "after"
{* multi-line
   block comment
   spanning three lines *}
PRINT "after multiline block"

REM --- C block comments ---
/* C style single line comment */
PRINT "before C" /* inline C comment */ : PRINT "after C"
/* multi-line
   C comment
   spanning three lines */
PRINT "after multiline C"

REM --- C++ single-line comments ---
// full line C++ comment
PRINT "before C++" // trailing C++ comment

REM --- Comments inside strings should be preserved ---
PRINT "it's a test"
PRINT "hello /* not a comment */ world"
PRINT "braces { are } fine in strings"
PRINT "slashes // are fine too"

REM --- Blank line consolidation ---
PRINT "before blanks"



PRINT "after blanks"


PRINT "after more blanks"

REM --- Mixed comments on one line ---
x = 1 /* set x */ + 2 'then add

REM --- Edge cases ---
PRINT "end"
