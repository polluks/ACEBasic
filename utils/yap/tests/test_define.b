REM Test #define, #undef, and value types
#define FOO
#define BAR 42
#define MSG "hello world"
PRINT FOO
PRINT BAR
PRINT MSG
#undef BAR
PRINT BAR
#define BAR 99
PRINT BAR
