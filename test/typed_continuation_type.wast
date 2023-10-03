(module
 (type $ft (func (param i32) (result i32)))
 (type $ct (cont $ft))

 (func $id (param $x (ref $ct)) (result (ref $ct))
  (local.get $x)
 )
)
