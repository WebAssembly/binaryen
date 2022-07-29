(module
 (import "env" "__stack_pointer" (global $sp (mut i32)))
 (global $__stack_base (mut i32) (i32.const 0))
 (global $__stack_end (mut i32) (i32.const 0))
 (func "use_stack" (result i32)
  (global.set $sp (i32.const 42))
  (global.get $sp)
 )
)
;; if __stack_base and __stack_end are missing, no stack checking should occur
(module
 (import "env" "__stack_pointer" (global $sp (mut i32)))
 (export "use_stack" (func $0))
 (func $0 (result i32)
  (global.set $sp (i32.const 42))
  (global.get $sp)
 )
)
