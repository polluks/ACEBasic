REM Test: basic #include "file" directive
PRINT "Before include"
#include "helper_simple.h"
PRINT "After include"
PRINT "Value is "; HELPER_VALUE
