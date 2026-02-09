/*
    $VER = 0.0.4

    @author: Manfred Bergmann


    Wrapper for ACE compiler/build

    possible arguments:
    1. mode [compile | compile_run | compile_submod | run | clean]
    2. input [filepath]
    3. (opt) flags:
        [echo]: outputs the entered parameters
        [optimize]: optimize compile
*/

parse arg mode input flags

signal on halt
signal on break_c

options results

BAS = 'ace:bin/bas'

/* check arguments */
if mode = '' then do
    say "ERROR: Unknown mode!"
    exit
end
if input = '' then do
    say "ERROR: Unknown input!"
    exit
end

if flags = 'echo' then do
    say 'mode: 'mode
    say 'input: 'input
    exit
end

/* extract the folder and filename of the file to be compiled */
inputLen = length(input)
p = lastpos('/', input)
if p > 0 then do
    file_name = trim(substr(input, p+1, inputLen-1))
    folder_path = substr(input, 1, p-1)
end
else do
    file_name = input
    folder_path = ''
end
say 'filename: 'file_name
say 'folder: 'folder_path

/* generate the assembly name (stripping away the .b) */
p = lastpos('.', file_name)
if p = 0 then do
    say 'ERROR: Not a valid ACE Basic filename, should contain ".b"!'
    exit
end
assembly_name = trim(substr(file_name, 1, p-1))
say 'Assembly name: 'assembly_name

outputname = assembly_name
say 'Output name: 'outputname

err = 0
/* Now compile and or run */
if mode = 'compile' | mode = 'compile_run' | mode = 'compile_submod' then do
    say 'Compiling...'
    if mode = 'compile' then do
        ADDRESS COMMAND BAS '-S 'outputname
    end
    else if mode = 'compile_submod' then do
        ADDRESS COMMAND BAS '-mO 'outputname
    end
    else do
        ADDRESS COMMAND BAS '-i 'outputname
    end
    say 'Compiling...done'
    call assertNoError('compile')
end
else if mode = 'run' then do
    RC = 0
end
else if mode = 'clean' then do
    say 'Deleting generated files...'
    ADDRESS COMMAND Delete outputname'.s'
    ADDRESS COMMAND Delete outputname'.o'
    ADDRESS COMMAND Delete outputname
    say 'Deleting generated files...done'
end

/* run? */
say 'RC: 'RC
if RC <= 0 & (mode = 'compile_run' | mode = 'run') then do
    if length(folder_path) = 0 then
        exepath = outputname
    else
        exepath = folder_path'/'outputname

    say 'Run...'exepath
    ADDRESS COMMAND exepath
end

exit

extractParentFolder: procedure
    parse arg path
    parentPath = path
    pathLen = length(path)
    p = lastpos('/', path)
    if p > 0 then
        parentPath = substr(path, 1, p-1)
    else
        parentPath = ''
    return parentPath

assertNoError: procedure expose RC
    parse arg label
    say 'RC: 'RC
    if RC > 0 then do
        say 'Error on 'label'!'
        exit
    end
    return

