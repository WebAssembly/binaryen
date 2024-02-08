(module
  ;; import a "yield" function that receives the current value,
  ;; then pauses execution until it is resumed later.
  (import "env" "yield" (func $yield (param i32)))
  (memory 1 2)
  (export "memory" (memory 0))
  ;; simple linear progression in a loop
  (func $linear (export "linear") (result i32)
    (local $x i32)
    (loop $l
      (call $yield (local.get $x))
      (local.set $x
        (i32.add (local.get $x) (i32.const 10))
      )
      (br $l)
    )
  )
  ;; exponential in a loop
  (func $exponential (export "exponential") (result i32)
    (local $x i32)
    (local.set $x
      (i32.const 1)
    )
    (loop $l
      (call $yield (local.get $x))
      (local.set $x
        (i32.mul (local.get $x) (i32.const 2))
      )
      (br $l)
    )
  )
  ;; just some weird numbers, no loop
  (func $weird (export "weird") (result i32)
    (call $yield (i32.const 42))
    (call $yield (i32.const 1337))
    (call $yield (i32.const 0))
    (call $yield (i32.const -1000))
    (call $yield (i32.const 42))
    (call $yield (i32.const 314159))
    (call $yield (i32.const 21828))
    (unreachable)
  )
)
