(module
  (memory 256 256)
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
  (func $zero
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (get_local $b) ;; a and c are untouched
  )
  (func $null
    (local $a i32)
    (local $c i32)
    (nop) ;; a and c are untouched
  )
)

