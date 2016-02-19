(module
  (memory 16777216 16777216)
  (func $b0-yes (param $a i32) (param $b i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)

    ;; Should reverse the order of the locals.
    (set_local $x (get_local $x))
    (set_local $y (get_local $y)) (set_local $y (get_local $y))
    (set_local $z (get_local $z)) (set_local $z (get_local $z)) (set_local $z (get_local $z))

    ;; Should not touch the args.
    (set_local $b (get_local $b)) (set_local $b (get_local $b)) (set_local $b (get_local $b))
    (set_local $b (get_local $b)) (set_local $b (get_local $b)) (set_local $b (get_local $b))
  )
)

