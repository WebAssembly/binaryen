(module
  (memory 1 2)
  (import "env" "sleep" (func $sleep))
  (export "memory" (memory 0))
  (func "many_locals" (param $x i32) (result i32)
    (local $y i32)
    (local $z i32)
    (local.set $y
      (i32.add (local.get $x) (i32.const 10))
    )
    (local.set $z
      (i32.add (local.get $y) (i32.const 20))
    )
    (call $sleep)
    (select
      (local.get $y)
      (local.get $z)
      (local.get $x)
    )
  )
)

