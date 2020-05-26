(module
 (global $global$0 (mut i32) (i32.const -44))
 (import "env" "memory" (memory $0 1 1))
 (func "foo" (result i32)
  (if
   (i32.div_u
    (global.get $global$0)
    (i32.load (i32.const 0))
   )
   (unreachable)
  )
  (i32.const 1)
 )
)
