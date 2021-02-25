;; Test that we can roundtrip struct and array types
(module
  ;; Arrays
  (type $vector-i32 (array i32))

  (type $vector-i31 (array (ref i31)))
  (type $vector-any (array (ref any)))

  ;; Structs
  (type $struct-i31 (struct
    (field (ref i31))
  ))
  (type $struct-any (struct
    (field (ref any))
  ))
  (type $struct-i31_any (struct
    (field (ref i31))
    (field (ref any))
  ))

  (func $foo (param $no-null (ref $vector-i32))
             (param $yes-null (ref null $vector-i32))
    ;; ok to set a non-nullable reference to a nullable target
    (local.set $no-null (local.get $yes-null))
  )

  (func $bar (param $v-i31 (ref $vector-i31))
             (param $v-any (ref $vector-any))
    ;; ok to set a vector of (immutable) i31s to a vector of anyies
    (local.set $v-any (local.get $v-i31))
  )

  (func $baz (param $s-i31 (ref $struct-i31))
             (param $s-any (ref $struct-any))
    ;; ok to set a struct of an (immutable) i31 to a one of an any
    (local.set $s-any (local.get $s-i31))
  )

  (func $boo (param $s-i31 (ref $struct-i31))
             (param $s-i31_any (ref $struct-i31_any))
    ;; also ok to have extra fields
    (local.set $s-i31 (local.get $s-i31_any))
  )
)
