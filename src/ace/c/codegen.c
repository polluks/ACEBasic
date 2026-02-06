/* << ACE >>

   -- Amiga BASIC Compiler --

   ** codegen.c: Semantic code generation helpers **

   Reduces assembly-level noise in parser code by wrapping common
   code generation patterns into single calls.
*/

#include "acedef.h"

/* Generate a JSR to a runtime function and register its XREF. */
void gen_rt_call(funcname)
char *funcname;
{
 gen("jsr", funcname, "  ");
 enter_XREF(funcname);
}
