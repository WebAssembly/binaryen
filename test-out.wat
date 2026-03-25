(module
 (type $s (struct (field (mut i32))))
 (type $1 (func (param (ref $s))))
 (func $a (type $1) (param $ref (ref $s))
  (struct.set $s 0
   (local.get $ref)
   (i32.const 5)
  )
  (struct.set $s 0
   (local.get $ref)
   (i32.const 4)
  )
  (struct.set $s 0
   (local.get $ref)
   (i32.const 4)
  )
 )
)
