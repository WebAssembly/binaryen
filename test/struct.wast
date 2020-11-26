(module
  (type $struct.A (struct
    i32
    (field f32)
    (field $named f64)
  ))
  (type $struct.B (struct
    (field (mut i64))
    (field (ref $struct.A))
    (field (mut (ref $struct.A)))
  ))

  (func "foo" (param $x (ref $struct.A)) (result (ref $struct.B))
    (local (ref null $struct.A))
    (local (ref null $struct.B))
    (unreachable)
  )
)
