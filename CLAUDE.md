# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ACE (Amiga BASIC Compiler) is a complete BASIC compiler for the Amiga platform that generates native 68000 assembly code. Originally developed 1991-1996, released as GPL v2 in 1998.

## Build System

The build system uses AmigaDOS scripts in the `make/` directory:

### Building the ACE Compiler

```bash
# Build individual compiler modules (run from make/ directory)
cmake <module_name>    # Compiles one module (e.g., cmake lex)
makeace               # Builds entire ACE compiler
```

The `makeace` script compiles each module sequentially and links them into `bin/ace`.

### Building the Runtime Library (db.lib)

```bash
# Build library (run from make/ directory)
lcmake <module>       # Compile a C library module
lmake <module>        # Assemble an assembly library module
makedb               # Build entire db.lib from sources
```

The `makedb` script compiles C sources from `src/lib/c/` and assembles sources from `src/lib/asm/`, then joins all objects into `lib/db.lib`.

### Building the Startup Library

```bash
# From src/lib/startup/
make                  # Creates startup.lib from startup.s
```

### Compiling BASIC Programs

Three wrapper scripts in `bin/` orchestrate the full pipeline:

```bash
# Legacy toolchain (a68k + blink)
bas <sourcefile>                    # Compile, assemble, link
bas <options> <sourcefile> <libs>   # With compiler options and extra libraries

# Modern toolchain (vasm + vlink)
bas.vb <sourcefile>                 # Preferred: uses vasmm68k_mot + vlink
bas.vb <options> <sourcefile> <libs>

# Phoenix toolchain
bas.phx <sourcefile>                # Uses PhxAss + PhxLnk
```

Pipeline: `app` (preprocess) → `ace` (compile) → `vasm` (assemble) → `vlink` (link)

Source files use `.b` or `.bas` extensions.

## Testing

```bash
# Run all tests
rx tests/runner.rexx

# Run specific category
rx tests/runner.rexx syntax
rx tests/runner.rexx arithmetic
rx tests/runner.rexx floats
rx tests/runner.rexx control
rx tests/runner.rexx errors
```

Test structure:
- `tests/cases/<category>/` - Test source files (.b)
- `tests/expected/` - Expected output files (.expected)
- `tests/results/` - Runtime output (created during test runs)

Tests in `cases/errors/` are expected to fail compilation.

## Architecture

### ACE Compiler (`src/ace/c/`)

Multi-pass compiler that translates BASIC to 68000 assembly:

1. **Lexical Analysis** (`lex.c`) - Tokenizes BASIC source, handles keywords (defined in `acedef.h` as enum)
2. **Parsing** (`parse.c`, `parsevar.c`) - Recursive descent parser
3. **Expression Evaluation** (`expr.c`, `factor.c`) - Expression trees and type checking
4. **Statement Handling** (`statement.c`, `control.c`, `assign.c`) - Statement code generation
5. **Symbol Management** (`sym.c`, `symvar.c`) - Symbol table for variables, functions, labels
6. **Specialized Modules**:
   - `gfx.c` - Graphics primitives (LINE, CIRCLE, AREA)
   - `gadget.c`, `menu.c`, `window.c`, `screen.c` - Intuition GUI support
   - `file.c` - File I/O (sequential and random access)
   - `event.c` - Event traps and handlers
   - `libfunc.c` - External library calls
   - `serial.c` - Serial communication
   - `iff.c` - IFF picture loading
   - `basfun.c` - Built-in BASIC functions
   - `print.c` - PRINT statement handling
   - `sub.c` - SUB/FUNCTION procedures
   - `declare.c` - Variable and type declarations
6. **Code Generation** (`misc.c`) - Emits 68000 assembly
7. **Optimization** (`opt.c`) - Peephole optimizer (push/pop elimination, redundant move removal)
8. **Memory Management** (`alloc.c`, `memory.c`) - Dynamic allocation and code/data structures

Main header: `acedef.h` - Contains enums for all BASIC reserved words, structure definitions, function prototypes.

### Runtime Library (`src/lib/`)

Provides runtime support for compiled programs:

- **C modules** (`src/lib/c/`) - High-level library functions (file I/O, GUI, graphics, IFF, strings, text)
- **Assembly modules** (`src/lib/asm/`) - Low-level routines (string ops, math, sound, turtle graphics, file handling, screen/window functions)
- **Startup** (`src/lib/startup/startup.s`) - Program initialization and cleanup

All compiled into `lib/db.lib` and linked with every ACE program along with `startup.lib`.

### BMAP Files (`bmaps/`)

Binary maps for Amiga OS 39 shared libraries. Map library function offsets for external library calls via `LIBRARY` and `DECLARE FUNCTION` statements. Used by the compiler to resolve library function calls.

### Preprocessors

- **APP** - Original ACE preprocessor for include directives
- **ACPP** - C-style preprocessor for complex header files (see `include/` directory)

### Examples

The `examples/` directory contains 30+ categories of sample programs demonstrating all language features: games, graphics, GUI, fractals, turtle graphics, astronomy, benchmarks, file operations, networking.

## Code Style

- **K&R C style** - Original late-80s/early-90s C conventions
- Function definitions use K&R style (parameters on separate lines)
- Extensive use of Amiga-specific types: `BYTE`, `SHORT`, `LONG`, `BOOL`, `BPTR`
- Direct Amiga API calls via exec, dos, graphics, intuition libraries
- Manual memory management with Amiga AllocMem/FreeMem

## Key Files

- `acedef.h` - Central header with all type definitions, reserved word enums, function prototypes
- `parse.c` - Main parser entry point
- `lex.c` - Lexical analyzer
- `opt.c` - Peephole optimizer
- `bin/bas.vb` - Primary build script (modern vasm/vlink toolchain)
- `tests/runner.rexx` - Test harness

## Development Notes

- Build scripts in `make/` are AmigaDOS shell scripts (`.key` syntax)
- Test runner (`tests/runner.rexx`) is an ARexx script
- All scripts assume execution on Amiga (or emulator)
- The ACE assign (logical device) must be set to the repository root
- Stack of 40000-65000 bytes required for compiler operations
- Generated assembly goes to `.s` files, objects to `.o`, executables have no extension
- Temporary files typically go to `ram:t/` or `T:`
