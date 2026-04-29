(module
 (import "env" "__stack_pointer" (global $sp (mut i32)))
 (import "GOT.func" "__stdio_write" (global $gimport$9 (mut i32)))
 (import "env" "table" (table $timport$9 1 funcref))
 (global $global i32 (i32.const 42))
 (export "__stdio_write" (func $__stdio_write))
 (export "__data_end" (global $global))
 (func $__stdio_write
 )
)
