(module
  (import "env" "bar" (func $bar (param i32) (result i32)))
  (func "foo1" (result i32)
    (local $x i32)
    (local.set $x (call $bar (i32.const 0)))
    (drop
     (call $bar (i32.const 1))
    )
    (local.get $x) ;; local2stack can help here
  )
)

