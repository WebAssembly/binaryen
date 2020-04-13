(module
 (global $global$0 (mut i32) (i32.const -44))
<<<<<<< HEAD
 (import "mod" "base" (func $bar (result i32)))
=======
 (import "env" "memory" (memory $0 1 1))
>>>>>>> origin/master
 (func "foo" (result i32)
  (if
   (i32.div_u
    (global.get $global$0)
<<<<<<< HEAD
    (call $bar)
=======
    (i32.load (i32.const 0))
>>>>>>> origin/master
   )
   (unreachable)
  )
  (i32.const 1)
 )
)
