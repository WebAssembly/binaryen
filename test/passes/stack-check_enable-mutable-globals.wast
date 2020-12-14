(module
 (import "env" "__stack_pointer" (global $sp (mut i32)))
 (func "use_stack" (result i32)
  (global.set $sp (i32.const 42))
  (global.get $sp)
 )
)
;; running on the output should not crash, but pick valid names
(module
 (import "env" "__stack_pointer" (global $sp (mut i32)))
 (global $__stack_base (mut i32) (i32.const 0))
 (global $__stack_limit (mut i32) (i32.const 0))
 (export "use_stack" (func $0))
 (export "__set_stack_limits" (func $__set_stack_limits))
 (func $0 (result i32)
  (unreachable)
 )
)
