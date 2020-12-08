;; Test that we can roundtrip struct and array types
(module
  (type $struct.A (struct
    i32
    (field f32)
    (field $named f64)
  ))
  (type $struct.B (struct
    (field i8)
    (field (mut i16))
    (field (ref $struct.A))
    (field (mut (ref $struct.A)))
  ))
  (type $struct.C (struct
    (field $named-mut (mut f32))
  ))

  (type $vector (array (mut f64)))
  (type $matrix (array (ref $vector)))

  (func "foo" (param $x (ref $struct.A)) (result (ref $struct.B))
    (local $tA (ref null $struct.A))
    (local $tB (ref null $struct.B))
    (local $tc (ref null $struct.C))
    (local $tv (ref null $vector))
    (local $tm (ref null $matrix))
    (drop
      (local.get $x)
    )
    (drop
      (struct.get $struct.A 0 (local.get $x))
    )
    (drop
      (struct.get $struct.A 1 (local.get $x))
    )
    (drop
      (struct.get $struct.A 2 (local.get $x))
    )
    (drop
      (struct.get $struct.A $named (local.get $x))
    )
    (drop
      (struct.get_u $struct.B 0 (local.get $tB))
    )
    (drop
      (struct.get_s $struct.B 0 (local.get $tB))
    )
    (drop
      (ref.null $struct.A)
    )
    (drop
      (block (result (ref null $struct.A))
        (local.get $x)
      )
    )
    (drop
      (if (result (ref null $struct.A))
        (i32.const 1)
        (local.get $x)
        (local.get $x)
      )
    )
    (drop
      (loop (result (ref null $struct.A))
        (local.get $x)
      )
    )
    (drop
      (select (result (ref null $struct.A))
        (local.get $x)
        (local.get $x)
        (i32.const 1)
      )
    )
    (struct.set $struct.A 0
      (local.get $x)
      (i32.const 100)
    )
    (unreachable)
  )
)
