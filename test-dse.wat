(module
  (type $s (struct (field (mut i32))))
  (func $asdf (param $ref (ref $s))
    (struct.set $s 0 (local.get $ref) (i32.const 1))
    (struct.set $s 0 (local.get $ref) (i32.const 2))
  )
)
