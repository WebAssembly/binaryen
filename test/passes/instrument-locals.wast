(module
  (func $A
    (local $x i32)
    (local $y i64)
    (local $z f32)
    (local $w f64)

    (drop (local.get $x))
    (drop (local.get $y))
    (drop (local.get $z))
    (drop (local.get $w))

    (drop (local.get $x))
    (drop (local.get $y))
    (drop (local.get $z))
    (drop (local.get $w))

    (local.set $x (i32.const 1))
    (local.set $y (i64.const 2))
    (local.set $z (f32.const 3.21))
    (local.set $w (f64.const 4.321))

    (local.set $x (i32.const 11))
    (local.set $y (i64.const 22))
    (local.set $z (f32.const 33.21))
    (local.set $w (f64.const 44.321))
  )
)

