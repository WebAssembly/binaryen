(module
  (type $struct (struct
    (field (mut i32))
    (field f32)
    (field $named f64)
  ))
  (type $array (array (mut f64)))

  (func $structs (param $x (ref $struct))
    (drop
      (struct.get $struct 0 (local.get $x))
    )
    (drop
      (struct.get $struct 1 (local.get $x))
    )
    (drop
      (struct.get $struct 2 (local.get $x))
    )
    (struct.set $struct 0 (local.get $x) (i32.const 42))
  )

  (func $arrays (param $x (ref $array))
    (drop
      (array.get $array (local.get $x) (i32.const 10))
    )
    (array.set $array (local.get $x) (i32.const 42) (f64.const 3.14159))
  )
)

