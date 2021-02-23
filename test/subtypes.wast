;; Test that we can roundtrip struct and array types
(module
  ;; Arrays
  (type $vector-i32 (array i32))

  (type $vector-i31 (array (ref i31)))
  (type $vector-any (array (ref any)))

  ;; Structs
  (type $struct.A (struct
    i32
    (field f32)
    (field $named f64)
  ))

  (func $foo (param $no-null (ref $vector-i32))
    (local $yes-null (ref null $vector-i32))
    ;; ok to set a non-nullable reference to a nullable target
    (local.set $no-null (local.get $yes-null))
  )

  (func $bar (param $i31v (ref $vector-i31))
    (local $anyv (ref $vector-any))
    ;; ok to set a vector of i31s to a vector of anyies
    (local.set $anyv (local.get $i31v))
  )
)
