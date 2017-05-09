(module
  (func $trivial
    (nop)
  )
  (func $trivial2
    (drop (i32.const 1))
    (drop (i32.const 2))
    (drop (i32.const 3))
  )
  (func $return-void
    (return)
  )
  (func $return-val (result i32)
    (return (i32.const 1))
  )
)

