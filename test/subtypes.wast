;; Test that we can roundtrip struct and array types
(module
  ;; Arrays
  (type $vector-i32 (array i32))

  (type $vector-any (array (ref any)))
  (type $vector-i31 (array_subtype (ref i31) $vector-any))

  ;; Structs
  (type $struct-any (struct
    (field (ref any))
  ))
  (type $struct-i31 (struct_subtype
    (field (ref i31))
    $struct-any
  ))
  (type $struct-i31_any (struct_subtype
    (field (ref i31))
    (field (ref any))
    $struct-i31
  ))

  ;; Recursive structs
  (type $struct-rec-one (struct
    (field (ref $struct-rec-one))
  ))
  (type $struct-rec-two (struct_subtype
    (field (ref $struct-rec-two))
    (field (ref $struct-rec-two))
    $struct-rec-one
  ))

  (func $foo (param $no-null (ref $vector-i32))
             (param $yes-null (ref null $vector-i32))
    ;; ok to set a non-nullable reference to a nullable target
    (local.set $yes-null (local.get $no-null))
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

  (func $coinductive (param $rec-one (ref $struct-rec-one))
                     (param $rec-two (ref $struct-rec-two))
    ;; Do not infinitely recurse when determining this subtype relation!
    (local.set $rec-one (local.get $rec-two))
  )
)
