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

  (type $parent (struct))
  (type $child (struct_subtype i32 $parent))
  (type $grandchild (struct_subtype i32 i64 $child))

  (type $nested-child-struct (struct (field (mut (ref $child)))))
  (type $nested-child-array (array (mut (ref $child))))

  (global $struct.new-in-global (ref $struct.A)
    (struct.new_default $struct.A)
  )

  (func $structs (param $x (ref $struct.A)) (param $struct.A.prime (ref null $struct.A.prime)) (param $grandchild (ref null $grandchild)) (param $struct.C (ref null $struct.C)) (param $nested-child-struct (ref null $nested-child-struct)) (result (ref $struct.B))
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
      (struct.get $struct.A.prime $othername (local.get $struct.A.prime))
    )
    (drop
      (struct.get_u $struct.B 0 (local.get $tB))
    )
    (drop
      (struct.get_s $struct.B 0 (local.get $tB))
    )
    ;; immutable fields allow subtyping.
    (drop
      (struct.get $child 0 (local.get $grandchild))
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
      (local.get $struct.C)
      (f32.const 100)
    )
    ;; values may be subtypes
    (struct.set $nested-child-struct 0
      (local.get $nested-child-struct)
      (ref.as_non_null
       (local.get $grandchild)
      )
    )
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
    (unreachable)
  )
  (func $arrays (param $x (ref $vector)) (param $nested-child-array (ref null $nested-child-array)) (param $grandchild (ref null $grandchild)) (result (ref $matrix))
    (local $tv (ref null $vector))
    (local $tm (ref null $matrix))
    (local $tb (ref null $bytes))
    (local $tw (ref null $words))
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
      (local.get $nested-child-array)
      (i32.const 3)
      (ref.as_non_null
       (local.get $grandchild)
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
  (func $ref.is_X (param $x anyref)
    (if (ref.is_null (local.get $x)) (unreachable))
    (if (ref.is_i31 (local.get $x)) (unreachable))
  )
  (func $ref.as_X (param $x anyref) (param $f funcref)
    (drop (ref.as_non_null (local.get $x)))
    (drop (ref.as_func (local.get $f)))
    (drop (ref.as_i31 (local.get $x)))
  )
  (func $br_on_X (param $x anyref)
    (local $y anyref)
    (local $z (ref null any))
    (local $temp-func (ref null func))
    (local $temp-i31 (ref null i31))
    (block $null
      (local.set $z
        (br_on_null $null (local.get $x))
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
  (func $unreachables-2 (param $struct.C (ref null $struct.C))
    (struct.set $struct.C 0 (local.get $struct.C) (unreachable))
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
  (func $unreachables-array-2 (param $vector (ref null $vector))
    (array.get $vector
      (local.get $vector)
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
  (func $unreachables-array-4 (param $vector (ref null $vector))
    (array.set $vector
      (local.get $vector)
      (unreachable)
      (f64.const 2.18281828)
    )
  )
  (func $unreachables-array-5 (param $vector (ref null $vector))
    (array.set $vector
      (local.get $vector)
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
    (array.init_static $vector
      (f64.const 1)
      (f64.const 2)
      (f64.const 4)
      (f64.const 8)
    )
  )
  (func $array-init-packed (result (ref $bytes))
    (array.init_static $bytes
      (i32.const 4)
      (i32.const 2)
      (i32.const 1)
    )
  )
  (func $static-operations
    (local $temp.A (ref null $struct.A))
    (local $temp.B (ref null $struct.B))
    (drop
      (ref.test $struct.B (ref.null $struct.A))
    )
    (drop
      (ref.cast null $struct.B (ref.null $struct.A))
    )
    (drop
      (block $out-B (result (ref $struct.B))
        (local.set $temp.A
          (br_on_cast $out-B $struct.B (ref.null $struct.A))
        )
        (unreachable)
      )
    )
    (drop
      (block $out-A (result (ref null $struct.A))
        (local.set $temp.B
          (br_on_cast_fail $out-A $struct.B (ref.null $struct.A))
        )
        (unreachable)
      )
    )
  )
)
