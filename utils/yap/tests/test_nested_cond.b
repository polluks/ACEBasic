REM Test nested conditionals and false-branch nesting
#define OUTER
#ifdef OUTER
PRINT "outer true"
#ifdef INNER
PRINT "should not appear - inner not defined"
#else
PRINT "inner else"
#endif
#endif
#ifndef OUTER
PRINT "should not appear"
#ifdef ANYTHING
PRINT "should not appear nested"
#endif
#endif
PRINT "after all"
