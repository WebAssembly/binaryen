;; Test that we can roundtrip struct and array types
(module
  ;; Structs
  (type $struct.A (struct
    i32
    (field f32)
    (field $named f64)
  ))
  ;; identical to $struct.A, so will be canonicalized with it, but field names
  ;; are different
  (type $struct.A.prime (struct
    i32
    (field f32)
    (field $othername f64)
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
  (type $matrix (array (mut (ref null $vector))))
  (type $bytes (array (mut i8)))
  (type $words (array (mut i32)))

  ;; RTT
  (type $parent (struct))
  (type $child (struct i32))
  (type $grandchild (struct i32 i64))
  (global $rttparent (rtt 0 $parent) (rtt.canon $parent))
  (global $rttchild (rtt 1 $child) (rtt.sub $child (global.get $rttparent)))
  (global $rttgrandchild (rtt 2 $grandchild) (rtt.sub $grandchild (global.get $rttchild)))
  (global $rttfreshgrandchild (rtt 2 $grandchild) (rtt.fresh_sub $grandchild (global.get $rttchild)))

  (type $nested-child-struct (struct (field (mut (ref $child)))))
  (type $nested-child-array (array (mut (ref $child))))

  (global $struct.new-in-global (ref $struct.A)
    (struct.new_default_with_rtt $struct.A
      (rtt.canon $struct.A)
    )
  )

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
      (struct.get $struct.A.prime $othername (ref.null $struct.A.prime))
    )
    (drop
      (struct.get_u $struct.B 0 (local.get $tB))
    )
    (drop
      (struct.get_s $struct.B 0 (local.get $tB))
    )
    ;; immutable fields allow subtyping.
    (drop
      (struct.get $child 0 (ref.null $grandchild))
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
    (struct.set $struct.C 0
      (ref.null $struct.C)
      (f32.const 100)
    )
    ;; values may be subtypes
    (struct.set $nested-child-struct 0
      (ref.null $nested-child-struct)
      (ref.as_non_null
       (ref.null $grandchild)
      )
    )
    (drop
      (struct.new_default_with_rtt $struct.A
        (rtt.canon $struct.A)
      )
    )
    (drop
      (struct.new_with_rtt $struct.A
        (i32.const 1)
        (f32.const 2.345)
        (f64.const 3.14159)
        (rtt.canon $struct.A)
      )
    )
    (unreachable)
  )
  (func $arrays (param $x (ref $vector)) (result (ref $matrix))
    (local $tv (ref null $vector))
    (local $tm (ref null $matrix))
    (local $tb (ref null $bytes))
    (local $tw (ref null $words))
    (drop
      (array.new_with_rtt $vector
        (f64.const 3.14159)
        (i32.const 3)
        (rtt.canon $vector)
      )
    )
    (drop
      (array.new_default_with_rtt $matrix
        (i32.const 10)
        (rtt.canon $matrix)
      )
    )
    (drop
      (array.get $vector
        (local.get $x)
        (i32.const 2)
      )
    )
    (array.set $vector
      (local.get $x)
      (i32.const 2)
      (f64.const 2.18281828)
    )
    ;; values may be subtypes
    (array.set $nested-child-array
      (ref.null $nested-child-array)
      (i32.const 3)
      (ref.as_non_null
       (ref.null $grandchild)
      )
    )
    (drop
      (array.len $vector
        (local.get $x)
      )
    )
    (drop
      (array.get $words
        (local.get $tw)
        (i32.const 1)
      )
    )
    (drop
      (array.get_u $bytes
        (local.get $tb)
        (i32.const 2)
      )
    )
    (drop
      (array.get_s $bytes
        (local.get $tb)
        (i32.const 3)
      )
    )
    (unreachable)
  )
  ;; RTT types as parameters
  (func $rtt-param-with-depth (param $rtt (rtt 1 $parent)))
  (func $rtt-param-without-depth (param $rtt (rtt $parent)))
  (func $rtt-operations
    (local $temp.A (ref null $struct.A))
    (local $temp.B (ref null $struct.B))
    (drop
      (ref.test (ref.null $struct.A) (rtt.canon $struct.B))
    )
    (drop
      (ref.cast (ref.null $struct.A) (rtt.canon $struct.B))
    )
    (drop
      (block $out (result (ref $struct.B))
        ;; set the value to a local with type $struct.A, showing that the value
        ;; flowing out has the right type
        (local.set $temp.A
          (br_on_cast $out (ref.null $struct.A) (rtt.canon $struct.B))
        )
        ;; an untaken br_on_cast, with unreachable rtt - so we cannot use the
        ;; RTT in binaryen IR to find the cast type.
        (br_on_cast $out (ref.null $struct.A) (unreachable))
        (unreachable)
      )
    )
    (drop
      (block $out2 (result (ref null $struct.A))
        ;; set the value to a local with type $struct.A, showing that the value
        ;; flowing out has the right type
        (local.set $temp.B
          (br_on_cast_fail $out2 (ref.null $struct.A) (rtt.canon $struct.B))
        )
        (ref.null $struct.A)
      )
    )
  )
  (func $ref.is_X (param $x anyref)
    (if (ref.is_func (local.get $x)) (unreachable))
    (if (ref.is_data (local.get $x)) (unreachable))
    (if (ref.is_i31 (local.get $x)) (unreachable))
  )
  (func $ref.as_X (param $x anyref)
    (drop (ref.as_non_null (local.get $x)))
    (drop (ref.as_func (local.get $x)))
    (drop (ref.as_data (local.get $x)))
    (drop (ref.as_i31 (local.get $x)))
  )
  (func $br_on_X (param $x anyref)
    (local $y anyref)
    (local $z (ref null any))
    (local $temp-func (ref null func))
    (local $temp-data (ref null data))
    (local $temp-i31 (ref null i31))
    (block $null
      (local.set $z
        (br_on_null $null (local.get $x))
      )
    )
    (drop
      (block $func (result funcref)
        (local.set $y
          (br_on_func $func (local.get $x))
        )
        (ref.null func)
      )
    )
    (drop
      (block $data (result (ref null data))
        (local.set $y
          (br_on_data $data (local.get $x))
        )
        (ref.null data)
      )
    )
    (drop
      (block $i31 (result (ref null i31))
        (local.set $y
          (br_on_i31 $i31 (local.get $x))
        )
        (ref.null i31)
      )
    )
    (drop
      (block $non-null (result (ref any))
        (br_on_non_null $non-null (local.get $x))
        (unreachable)
      )
    )
    (drop
      (block $non-func (result anyref)
        (local.set $temp-func
          (br_on_non_func $non-func (local.get $x))
        )
        (ref.null any)
      )
    )
    (drop
      (block $non-data (result anyref)
        (local.set $temp-data
          (br_on_non_data $non-data (local.get $x))
        )
        (ref.null any)
      )
    )
    (drop
      (block $non-i31 (result anyref)
        (local.set $temp-i31
          (br_on_non_i31 $non-i31 (local.get $x))
        )
        (ref.null any)
      )
    )
  )
  (func $unreachables-1
    (drop
      (struct.get $struct.C 0 (unreachable))
    )
  )
  (func $unreachables-2
    (struct.set $struct.C 0 (ref.null $struct.C) (unreachable))
  )
  (func $unreachables-3
    (struct.set $struct.C 0 (unreachable) (unreachable))
  )
  (func $unreachables-4
    (struct.set $struct.C 0 (unreachable) (f32.const 1))
  )
  (func $unreachables-array-1
    (array.get $vector
      (unreachable)
      (i32.const 2)
    )
  )
  (func $unreachables-array-2
    (array.get $vector
      (ref.null $vector)
      (unreachable)
    )
  )
  (func $unreachables-array-3
    (array.set $vector
      (unreachable)
      (i32.const 2)
      (f64.const 2.18281828)
    )
  )
  (func $unreachables-array-4
    (array.set $vector
      (ref.null $vector)
      (unreachable)
      (f64.const 2.18281828)
    )
  )
  (func $unreachables-array-5
    (array.set $vector
      (ref.null $vector)
      (i32.const 2)
      (unreachable)
    )
  )
  (func $unreachables-array-6
    (drop
      (array.len $vector
        (unreachable)
      )
    )
  )
  (func $unreachables-7
    (drop
      (struct.new_default_with_rtt $struct.A
        (unreachable)
      )
    )
  )
  (func $array-copy (param $x (ref $vector)) (param $y (ref null $vector))
    (array.copy $vector $vector
      (local.get $x)
      (i32.const 11)
      (local.get $y)
      (i32.const 42)
      (i32.const 1337)
    )
  )
  (func $array-init (result (ref $vector))
    (array.init $vector
      (f64.const 1)
      (f64.const 2)
      (f64.const 4)
      (f64.const 8)
      (rtt.canon $vector)
    )
  )
  (func $array-init-packed (result (ref $bytes))
    (array.init $bytes
      (i32.const 4)
      (i32.const 2)
      (i32.const 1)
      (rtt.canon $bytes)
    )
  )
  (func $static-operations
    (local $temp.A (ref null $struct.A))
    (local $temp.B (ref null $struct.B))
    (drop
      (ref.test_static $struct.B (ref.null $struct.A))
    )
    (drop
      (ref.cast_static $struct.B (ref.null $struct.A))
    )
    (drop
      (block $out-B (result (ref $struct.B))
        (local.set $temp.A
          (br_on_cast_static $out-B $struct.B (ref.null $struct.A))
        )
        (unreachable)
      )
    )
    (drop
      (block $out-A (result (ref null $struct.A))
        (local.set $temp.B
          (br_on_cast_static_fail $out-A $struct.B (ref.null $struct.A))
        )
        (unreachable)
      )
    )
  )
  (func $static-constructions
    (drop
      (struct.new_default $struct.A)
    )
    (drop
      (struct.new $struct.A
        (i32.const 1)
        (f32.const 2.345)
        (f64.const 3.14159)
      )
    )
    (drop
      (array.new $vector
        (f64.const 3.14159)
        (i32.const 3)
      )
    )
    (drop
      (array.new_default $matrix
        (i32.const 10)
      )
    )
    (drop
      (array.init_static $vector
        (f64.const 1)
        (f64.const 2)
        (f64.const 4)
        (f64.const 8)
      )
    )
  )
)
