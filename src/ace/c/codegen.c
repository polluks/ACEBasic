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

/* Generate a shared library function call:
   check_for_ace_lib + make_library_base + move.l base,a6
   + jsr offset(a6) + restore a4/a5 if needed. */
extern	ACELIBS	acelib[];
extern	char	librarybase[];
extern	BOOL	restore_a4;
extern	BOOL	restore_a5;

void gen_lib_call(func_item)
SYM *func_item;
{
 BYTE libnum;
 char func_address[MAXIDSIZE+9];

 if ((libnum=check_for_ace_lib(func_item->libname)) == NEGATIVE)
    make_library_base(func_item->libname);
 else
    strcpy(librarybase,acelib[libnum].base);
 gen("move.l",librarybase,"a6");
 itoa(func_item->address,func_address,10);
 strcat(func_address,"(a6)");
 gen("jsr",func_address,"  ");
 if (restore_a4) { gen("move.l","_a4_temp","a4"); restore_a4=FALSE; }
 if (restore_a5) { gen("move.l","_a5_temp","a5"); restore_a5=FALSE; }
}

/* Emit a library-open-and-check block directly to the output file:
   jsr open_func / cmpi #1,_starterr / bne ok_label / jmp _ABORT / label: */
extern	FILE	*dest;

void gen_lib_open_check(open_func, ok_label)
char *open_func;
char *ok_label;
{
 fprintf(dest,"\tjsr\t%s\n", open_func);
 fprintf(dest,"\tcmpi.b\t#1,_starterr\n");
 fprintf(dest,"\tbne.s\t%s\n", ok_label);
 fprintf(dest,"\tjmp\t_ABORT_PROG\n");
 fprintf(dest,"%s:\n", ok_label);
}

/* Generate NOP placeholders for potential type coercion.
   Fills cx[] with CODE pointers to the generated NOPs. */
extern	CODE	*curr_code;

void gen_coerce_slots(cx, count)
CODE *cx[];
int count;
{
 int i;
 for (i=0;i<count;i++)
 {
  gen("nop","  ","  ");
  cx[i]=curr_code;
 }
}
