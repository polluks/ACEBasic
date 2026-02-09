REM Test: include-once via include guards
PRINT "Before first include"
#include "helper_guarded.h"
PRINT "Between includes"
#include "helper_guarded.h"
PRINT "After second include"
PRINT "Val is "; GUARDED_VAL
