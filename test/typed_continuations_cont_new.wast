(module
 (type $ft (func (param i32) (result i32)))
 (type $ct (cont $ft))

 (func $f (param $x (ref $ct)))
 (func $g (param i32) (result i32)
  (i32.const 123)
 )
 (elem declare func $g)

 (func $h
   (drop (cont.new $ct (ref.func $g)))
 )

)
