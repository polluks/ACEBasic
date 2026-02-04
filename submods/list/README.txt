Lisp-style List Library for ACE BASIC
======================================

A singly-linked list implementation inspired by Common Lisp, providing
type-safe cons cells with support for multiple data types.


Overview
--------

Lists are built from cons cells, each containing:
- A value (car) - can be SHORTINT, LONGINT, SINGLE, STRING, or nested list
- A pointer to the next cell (cdr)
- A type tag for runtime type checking

The empty list is represented by LNil (0).

Example:

    LInit                              ' Initialize library

    ' Build list (1 2 3) using cons
    lst = LCons%(3, LNil)
    lst = LCons%(2, lst)
    lst = LCons%(1, lst)

    ' Or use the builder pattern
    LNew
    LAdd%(1)
    LAdd%(2)
    LAdd%(3)
    lst = LEnd

    ' Access elements
    PRINT LCar%(lst)                   ' Prints 1
    PRINT LSecond%(lst)                ' Prints 2
    PRINT LLen(lst)                    ' Prints 3

    ' Iterate
    cur = lst
    WHILE NOT LNull(cur)
      PRINT LCar%(cur)
      cur = LCdr(cur)
    WEND

    LFree(lst)                         ' Free memory
    LCleanup                           ' Close library


Type Suffixes
-------------

Functions use type suffixes to indicate the data type:
  %  - SHORTINT (16-bit integer)
  &  - LONGINT (32-bit integer)
  !  - SINGLE (32-bit float)
  $  - STRING (null-terminated)
  (none) - ADDRESS (for nested lists)

Use LType() to check the type of a cell at runtime.


Memory Management
-----------------

Ownership Model: Strict ownership with no reference counting.

Rules:

1. When you create a list with LCons or the builder, you OWN that list.

2. LCdr/LRest returns a pointer INTO the existing list, not a copy.
   You do NOT own what LCdr returns - it's part of the original list.

3. Call LFree only on lists you fully own.
   LFree recursively frees all cells from that point.

4. NEVER call LFree on a sublist obtained via LCdr:

   WRONG:
       list& = LCons%(1, LCons%(2, LNil))
       rest& = LCdr(list&)
       LFree(rest&)        ' BAD: rest& is part of list&
       LFree(list&)        ' CRASH: double free!

   RIGHT:
       list& = LCons%(1, LCons%(2, LNil))
       rest& = LCdr(list&)
       ' use rest& ...
       LFree(list&)        ' Frees everything including rest&

5. If you need an independent sublist, use LCopy:

       list& = LCons%(1, LCons%(2, LNil))
       rest& = LCopy(LCdr(list&))   ' rest& is a separate copy
       LFree(rest&)                  ' OK: independent list
       LFree(list&)                  ' OK: original list

6. LAppend(a, b) copies cells from a but SHARES b.
   After LAppend, freeing b would corrupt the result.

       result& = LAppend(listA&, listB&)
       LFree(listA&)       ' OK: was copied
       ' Do NOT free listB& while result& is in use
       LFree(result&)      ' Frees the copy of a AND all of b

7. LNconc(a, b) modifies a's tail to point to b.
   Both a and b now share structure. Free only once.

Value Copying:

- All values are copied at insertion time
- Strings are copied (new allocation) - caller's string can change
- LFree frees copied string storage
- No garbage collection - user responsible for calling LFree


Building the Module
-------------------

On Amiga (or emulator):

    cd ACE:submods/list
    bas -m list

This compiles list.b as a module, producing list.o


Building the Test Program
-------------------------

On Amiga (or emulator):

    cd ACE:submods/list
    bas test_list list.o

This compiles and links test_list.b with the list module.

To run:

    test_list

Expected output: "All tests passed!" with 92 assertions.


Using in Your Programs
----------------------

1. Include the header:

    #include <submods/list.h>

2. Link with the external module (no EXTERNAL statement needed if
   using #include, the header handles declarations)

3. Compile your program:

    bas myprogram ace:submods/list/list.o


Files
-----

list.b        - Library source code
list.o        - Compiled module (after building)
test_list.b   - Comprehensive test suite
README.txt    - This file

include/submods/list.h - Header file with declarations and documentation


Function Reference
------------------

See include/submods/list.h for detailed documentation of all functions.

Core functions:
  LInit, LCleanup     - Library initialization
  LCons*, LSnoc*      - Cell creation (prepend/append)
  LCar*, LCdr         - Access head/tail
  LFirst*, LSecond*   - Convenience accessors
  LNull, LType, LLen  - Predicates and info
  LNew, LAdd*, LEnd   - Builder pattern
  LAppend, LRev       - Non-destructive operations
  LCopy, LNth         - Copy and indexed access
  LNconc, LNrev       - Destructive operations
  LFree               - Memory deallocation
  LDump, LDumpLn      - Debug output
