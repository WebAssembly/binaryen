(module
 (type $ft1 (func (param i32 i64 i32) (result i32)))
 (type $ft2 (func (param         i32) (result i32)))
 (type $ct1 (cont $ft1))
 (type $ct2 (cont $ft2))

 (func $f (param $x (ref $ct1)) (result (ref $ct2))
  (cont.bind $ct1 $ct2
   (i32.const 123)
   (i64.const 456)
   (local.get $x)
  )
 )
)
