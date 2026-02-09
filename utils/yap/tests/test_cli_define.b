REM Test -D and -U command-line options
REM Run with: yap -DPLATFORM=AMIGA -UDEBUG test_cli_define.b out.b
#ifdef PLATFORM
PRINT "platform defined"
PRINT PLATFORM
#endif
#ifdef DEBUG
PRINT "debug should not appear"
#endif
PRINT "done"
