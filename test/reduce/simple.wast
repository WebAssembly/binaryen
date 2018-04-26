(module
  (export "x" (func $x))
  (func $x (result i32)
    (nop)
    (nop)
    (nop)
    (drop (i32.const 1234))
    (i32.const 5678) ;; easily reducible
  )
  (func $not-exported
    (nop)
    (unreachable)
  )
)

