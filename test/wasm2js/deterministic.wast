(module
 (import "env" "memory" (memory $0 1 1))
 (global $global$0 (mut i32) (i32.const -44))
 (func $foo (export "foo") (result i32)
  (if
   (i32.div_u
    (global.get $global$0)
    (i32.load (i32.const 0))
   )
   (then
    (unreachable)
   )
  )
  (i32.const 1)
 )
)
