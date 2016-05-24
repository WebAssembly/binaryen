(module
  (memory 10)
  (func
    (local $x i32)
    (i32.add (set_local $x (i32.const 10)) (i32.const 20))
    (i32.add (i32.store (i32.const 30) (i32.const 40)) (i32.const 50))
  )
)

