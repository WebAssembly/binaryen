(module
  (func $basics (param $x i32)
    (local $y i32)
    (local $z f32)
    (local $w i64)
    (local $t f64)
    (drop (get_local $x)) ;; keep as param get
    (drop (get_local $y)) ;; turn into get of 0-init
    (drop (get_local $z))
    (drop (get_local $w))
    (drop (get_local $t))
  )
)

