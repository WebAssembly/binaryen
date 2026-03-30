(module
  (type $s (struct (field (mut i32))))
  (tag $t)
  (func $asdf (param $ref (ref $s)) (param $b i32)
    (struct.set $s 0 (local.get $ref) (i32.const 1))

    (if (local.get $b) (then (throw $t)))

    (struct.set $s 0 (local.get $ref) (i32.const 2))
  )
)
