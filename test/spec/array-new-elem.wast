(module
  (type $vec (array funcref))
  (type $mvec (array (mut funcref)))
  (type $f (func (result i32)))

  (elem func $ret0 $ret1 $ret2 $ret3 $ret4)

  (func $ret0 (type $f) (i32.const 0))
  (func $ret1 (type $f) (i32.const 1))
  (func $ret2 (type $f) (i32.const 2))
  (func $ret3 (type $f) (i32.const 3))
  (func $ret4 (type $f) (i32.const 4))

  (func $new (export "new") (result (ref $vec))
    (array.new_elem $vec 0 (i32.const 1) (i32.const 3))
  )

  (func $get (param $i i32) (param $v (ref $vec)) (result i32)
    (call_ref $f (ref.cast null $f (array.get $vec (local.get $v) (local.get $i))))
  )
  (func (export "get") (param $i i32) (result i32)
    (call $get (local.get $i) (call $new))
  )

  (func $set_get (param $i i32) (param $v (ref $mvec)) (param $y i32) (result i32)
    (array.set $mvec (local.get $v) (local.get $i) (array.get $mvec (local.get $v) (local.get $y)))
    (call_ref $f (ref.cast null $f (array.get $mvec (local.get $v) (local.get $i))))
  )
  (func (export "set_get") (param $i i32) (param $y i32) (result i32)
    (call $set_get
      (local.get $i)
      (array.new_elem $mvec 0 (i32.const 1) (i32.const 3))
      (local.get $y)
    )
  )

  (func $len (param $v (ref array)) (result i32)
    (array.len (local.get $v))
  )
  (func (export "len") (result i32)
    (call $len (call $new))
  )
)

(assert_return (invoke "get" (i32.const 0)) (i32.const 1))
(assert_return (invoke "get" (i32.const 1)) (i32.const 2))
(assert_return (invoke "set_get" (i32.const 0) (i32.const 2)) (i32.const 3))
(assert_return (invoke "len") (i32.const 3))

(module
  (type $vec (array funcref))

  (elem func)

  (func $new-huge (export "new-huge") (result (ref $vec))
    (array.new_elem $vec 0 (i32.const 1) (i32.const -1))
  )
)

(assert_trap (invoke "new-huge") "out of bounds segment access in array.new_data")
