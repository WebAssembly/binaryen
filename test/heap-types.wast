;; Test that we can roundtrip struct and array types
(module
  ;; Structs
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

  ;; Arrays
  (type $vector (array (mut f64)))
  (type $matrix (array (ref $vector)))

  ;; RTT
  (type $parent (struct))
  (type $child (struct i32))
  (type $grandchild (struct i32 i64))
  (global $rttparent (rtt 0 $parent) (rtt.canon $parent))
  (global $rttchild (rtt 1 $child) (rtt.sub $child (global.get $rttparent)))
  (global $rttgrandchild (rtt 2 $grandchild) (rtt.sub $grandchild (global.get $rttchild)))

  (func $structs (param $x (ref $struct.A)) (result (ref $struct.B))
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
    (drop
      (struct.new_default_with_rtt $struct.A
        (rtt.canon $struct.A)
      )
    )
    (drop
      (struct.new_with_rtt $struct.A
        (rtt.canon $struct.A)
        (i32.const 1)
        (f32.const 2.345)
        (f64.const 3.14159)
      )
    )
    (unreachable)
  )
  (func $arrays (param $x (ref $vector)) (result (ref $matrix))
    (local $tv (ref null $vector))
    (local $tm (ref null $matrix))
    (drop
      (array.new_with_rtt $vector
        (rtt.canon $vector)
        (i32.const 3)
        (f64.const 3.14159)
      )
    )
    (drop
      (array.new_default_with_rtt $matrix
        (rtt.canon $matrix)
      )
    )
    (drop
      (array.get $vector
        (local.get $x)
        (i32.const 2)
      )
    )
    (drop
      (array.set $vector
        (local.get $x)
        (i32.const 2)
        (f64.const 2.18281828)
      )
    )
    (drop
      (array.len $vector
        (local.get $x)
      )
    )
  )
  ;; RTT types as parameters
  (func $rtt-param-with-depth (param $rtt (rtt 1 $parent)))
  (func $rtt-param-without-depth (param $rtt (rtt $parent)))
)
