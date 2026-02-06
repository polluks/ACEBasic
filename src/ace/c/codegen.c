/* << ACE >>

   -- Amiga BASIC Compiler --

   ** codegen.c: Semantic code generation helpers **

   Reduces assembly-level noise in parser code by wrapping common
   code generation patterns into single calls.
*/

#include "acedef.h"

/* Generate a JSR to a runtime function and register its XREF. */
extern	int	lev;

void gen_rt_call(funcname)
char *funcname;
{
 gen("jsr", funcname, "  ");
 enter_XREF(funcname);
}

/* Build a frame-relative address string: e.g. "-12(a4)" */
void gen_frame_addr(address, buf)
int address;
char *buf;
{
 itoa(-1*address, buf, 10);
 strcat(buf, frame_ptr[lev]);
}
