(module
 (type $ft (func (param i32) (result i32)))
 (type $ct (cont $ft))

 (func $id (param $x (ref $ct)) (result (ref $ct))
  (local.get $x)
 )
)

(assert_invalid
 (module
  (type $ft (func (param i32) (result i32)))
  (type $ct1 (cont $ft))
  (type $ct2 (cont $ct1))
 )
)

(assert_invalid
 (module
  (type $ft (func (param i32) (result i32)))
  (type $ct (cont $ft))

  (func $id (param $x $ct) (result i32)
   (i32.const 123)
  )
 )
)

(assert_invalid
 (module
  (type $ft (func (param i32) (result i32)))
  (type $ct (cont $ft))

  (func $id (type $ct)
   (i32.const 123)
  )
 )
)
