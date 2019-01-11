(module
  (func $tee
    (local $x i32)
    (local $y f64)
    (drop (local.tee $x (i32.const 1)))
    (drop (local.tee $y (f64.const 2)))
    (local.set $x (local.tee $x (i32.const 3)))
    (local.set $x (local.tee $x (local.tee $x (i32.const 3))))
    (drop (local.tee $x (unreachable)))
  )
)

