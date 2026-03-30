(module
 (type $s (struct (field (mut i32))))
 (type $1 (func))
 (type $2 (func (param (ref $s) i32)))
 (tag $t (type $1))
 (func $asdf (type $2) (param $ref (ref $s)) (param $b i32)
  (struct.set $s 0
   (local.get $ref)
   (i32.const 1)
  )
  (if
   (local.get $b)
   (then
    (throw $t)
   )
  )
  (struct.set $s 0
   (local.get $ref)
   (i32.const 2)
  )
 )
)
