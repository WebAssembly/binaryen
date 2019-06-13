(module
  (memory 1 2)
  (import "env" "sleep" (func $sleep))
  (export "memory" (memory 0))
  (func "minimal" (result i32)
    (call $sleep)
    (i32.const 21)
  )
  (func "repeat" (result i32)
    ;; sleep twice, then return 42
    (call $sleep)
    (call $sleep)
    (i32.const 42)
  )
  (func "local" (result i32)
    (local $x i32)
    (local.set $x (i32.load (i32.const 0))) ;; a zero that the optimizer won't see
    (local.set $x
      (i32.add (local.get $x) (i32.const 10)) ;; add 10
    )
    (call $sleep)
    (local.get $x)
  )
  (func "local2" (result i32)
    (local $x i32)
    (local.set $x (i32.load (i32.const 0))) ;; a zero that the optimizer won't see
    (local.set $x
      (i32.add (local.get $x) (i32.const 10)) ;; add 10
    )
    (call $sleep)
    (local.set $x
      (i32.add (local.get $x) (i32.const 12)) ;; add 12 more
    )
    (local.get $x)
  )
)

