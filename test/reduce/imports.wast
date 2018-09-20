(module
  (import "env" "func" (func $import))
  (export "x" (func $x))
  (func $x (result i32)
    (nop)
    (nop)
    (nop)
    (call $import)
    (drop (i32.const 1234))
    (i32.const 5678) ;; easily reducible
  )
  (func $not-exported
    (nop)
    (unreachable)
  )
)

