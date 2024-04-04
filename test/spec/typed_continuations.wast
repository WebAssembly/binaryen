(module
 (type $ft (func (param i32) (result i32)))
 (type $ct (cont $ft))

 (func $id (param $x (ref $ct)) (result (ref $ct))
  (local.get $x)
 )

 (func $cont-nocont (param $x (ref null $ct))
  (local $l1 (ref null cont))
  (local $l2 (ref null $ct))
  (local.set $l1 (local.get $x))    ;; $ct <: cont
  (local.set $l2 (ref.null nocont)) ;; nocont <: $ct
  (local.set $l1 (ref.null nocont)) ;; nocont <: cont
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
