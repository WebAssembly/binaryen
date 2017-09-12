(module
  (func $basic (param $p i32)
    (local $x i32)
    (set_local $x (i32.const 10))
    (call $basic (i32.add (get_local $x) (get_local $x)))
  )
)

