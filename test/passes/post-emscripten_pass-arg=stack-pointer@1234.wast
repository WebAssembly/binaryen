(module
  (import "env" "not_stack" (global i32))
  (global $should_be_stack_pointer (mut i32) (i32.const 2))
)
