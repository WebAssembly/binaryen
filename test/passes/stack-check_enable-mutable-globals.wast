(module
 (import "env" "__stack_pointer" (global $sp (mut i32)))
 (func "use_stack" (result i32)
  (global.set $sp (i32.const 42))
  (global.get $sp)
 )
)
