REM Test include guard pattern
#ifndef MYHEADER_H
#define MYHEADER_H
PRINT "first include"
#endif
#ifndef MYHEADER_H
PRINT "should not appear - already defined"
#endif
PRINT "done"
