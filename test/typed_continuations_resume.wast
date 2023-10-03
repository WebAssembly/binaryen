(module
 (type $ft (func (param i32) (result i32)))
 (type $ct (cont $ft))
 (tag $t (result i32))

 (func $go (param $x (ref $ct)) (result i32)
   (drop
    (block $handler (result (ref $ct))
     (return
      (resume $ct
       (tag $t $handler)
       (i32.const 123)
       (local.get $x)
      )
     )
    )
   )
   (i32.const 123)
 )
)
