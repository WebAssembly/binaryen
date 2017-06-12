(module
  (func $tee
    (local $x i32)
    (local $y f64)
    (drop (tee_local $x (i32.const 1)))
    (drop (tee_local $y (f64.const 2)))
    (set_local $x (tee_local $x (i32.const 3)))
    (set_local $x (tee_local $x (tee_local $x (i32.const 3))))
    (drop (tee_local $x (unreachable)))
  )
)

