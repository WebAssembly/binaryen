(module
 (global $global$0 (mut i32) (i32.const -44))
 (import "mod" "base" (func $bar (result i32)))
 (func "foo" (result i32)
  (if
   (i32.div_u
    (global.get $global$0)
    (call $bar)
   )
   (unreachable)
  )
  (i32.const 1)
 )
)
