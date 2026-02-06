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

/* Generate a typed push: move.w/l src, -(sp) */
void gen_push(type, src)
int type;
char *src;
{
 if (type == shorttype)
    gen("move.w", src, "-(sp)");
 else
    gen("move.l", src, "-(sp)");
}

/* Generate a typed pop: move.w/l (sp)+, dest */
void gen_pop(type, dest)
int type;
char *dest;
{
 if (type == shorttype)
    gen("move.w", "(sp)+", dest);
 else
    gen("move.l", "(sp)+", dest);
}

/* Generate a typed move: move.w/l src, dest */
void gen_move_typed(type, src, dest)
int type;
char *src;
char *dest;
{
 if (type == shorttype)
    gen("move.w", src, dest);
 else
    gen("move.l", src, dest);
}
