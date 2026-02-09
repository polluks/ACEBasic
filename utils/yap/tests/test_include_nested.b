REM Test: nested #include (outer includes inner)
PRINT "Before nested"
#include "helper_outer.h"
PRINT "After nested"
PRINT "Inner="; INNER_VAL; " Outer="; OUTER_VAL
