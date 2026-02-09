REM Test #ifdef, #ifndef, #else, #endif
#define HAVEFOO
#ifdef HAVEFOO
PRINT "foo is defined"
#endif
#ifndef HAVEFOO
PRINT "this should not appear"
#endif
#ifdef MISSING
PRINT "this should not appear either"
#else
PRINT "else branch"
#endif
#ifndef MISSING
PRINT "not defined branch"
#else
PRINT "this should not appear"
#endif
