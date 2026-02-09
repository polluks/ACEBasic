REM Test that macros are NOT replaced inside string literals
#define FOO 42
PRINT "FOO is a macro"
PRINT FOO
x = FOO + 1
PRINT "The value of FOO is"; FOO
