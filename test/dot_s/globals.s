    .text
    .globl globals
    .type globals,@function
globals:
    i32.const   $push0=, 0
    i32.const   $push1=, 7
    i32.store   local_global($pop0), $pop1
    i32.const   $push2=, 0
    i32.load    $drop=, local_global($pop2)
    i32.const   $drop=, local_global
    .endfunc
.Lfunc_end0:
    .size   globals, .Lfunc_end0-globals

    .globl import_globals
    .type import_globals,@function
import_globals:
    i32.const   $push0=, 0
    i32.const   $push1=, 7
    i32.store   imported_global($pop0), $pop1
    i32.const   $push2=, 0
    i32.load    $drop=, imported_global($pop2)
    i32.const   $drop=, imported_global
    .endfunc
.Lfunc_end0:
    .size   import_globals, .Lfunc_end0-import_globals

    .globl globals_offset
    .type globals_offset,@function
globals_offset:
    i32.const   $push0=, 4
    i32.const   $push1=, 7
    i32.store   local_global+12($pop0), $pop1
    i32.const   $push2=, 8
    i32.load    $drop=, local_global-4($pop2)
    i32.const   $drop=, local_global+16
    .endfunc
.Lfunc_end0:
    .size   globals_offset, .Lfunc_end0-globals_offset

    .globl import_globals_offset
    .type import_globals_offset,@function
import_globals_offset:
    i32.const   $push0=, 4
    i32.const   $push1=, 7
    i32.store   imported_global+12($pop0), $pop1
    i32.const   $push2=, 8
    i32.load    $drop=, imported_global-4($pop2)
    i32.const   $drop=, imported_global+16
    .endfunc
.Lfunc_end0:
    .size   import_globals_offset, .Lfunc_end0-import_globals_offset

    .type   local_global,@object
    .p2align    2
local_global:
    .int32  17
    .size   local_global, 4

    .type   initialized_with_global,@object
    .p2align    2
initialized_with_global:
    .int32  local_global
    .size   initialized_with_global, 4

    .type   initialized_with_global_offset,@object
    .p2align    2
initialized_with_global_offset:
    .int32  local_global+2
    .size   initialized_with_global_offset, 4

    .import_global  imported_global
