(module
  (func $A
    (local $x i32)
    (local $y i64)
    (local $z f32)
    (local $w f64)

    (drop (get_local $x))
    (drop (get_local $y))
    (drop (get_local $z))
    (drop (get_local $w))

    (drop (get_local $x))
    (drop (get_local $y))
    (drop (get_local $z))
    (drop (get_local $w))

    (set_local $x (i32.const 1))
    (set_local $y (i64.const 2))
    (set_local $z (f32.const 3.21))
    (set_local $w (f64.const 4.321))

    (set_local $x (i32.const 11))
    (set_local $y (i64.const 22))
    (set_local $z (f32.const 33.21))
    (set_local $w (f64.const 44.321))
  )
)

