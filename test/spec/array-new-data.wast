(module
  (type $vec (array i8))
  (type $mvec (array (mut i8)))

  (data "\00\01\02\03\04")

  (func $new (export "new") (result (ref $vec))
    (array.new_data $vec 0 (i32.const 1) (i32.const 3))
  )

  (func $get (param $i i32) (param $v (ref $vec)) (result i32)
    (array.get_u $vec (local.get $v) (local.get $i))
  )
  (func (export "get") (param $i i32) (result i32)
    (call $get (local.get $i) (call $new))
  )

  (func $set_get (param $i i32) (param $v (ref $mvec)) (param $y i32) (result i32)
    (array.set $mvec (local.get $v) (local.get $i) (local.get $y))
    (array.get_u $mvec (local.get $v) (local.get $i))
  )
  (func (export "set_get") (param $i i32) (param $y i32) (result i32)
    (call $set_get (local.get $i)
      (array.new_data $mvec 0 (i32.const 1) (i32.const 3))
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
(assert_return (invoke "set_get" (i32.const 1) (i32.const 7)) (i32.const 7))
(assert_return (invoke "len") (i32.const 3))

(module
  (type $vec (array i32))
  (type $mvec (array (mut i8)))

  (data "\00\01\00\00\00\02\00\00\00\03\00\00\00\04\00\00\00")

  (func $new (export "new") (result (ref $vec))
    (array.new_data $vec 0 (i32.const 1) (i32.const 3))
  )

  (func $get (param $i i32) (param $v (ref $vec)) (result i32)
    (array.get $vec (local.get $v) (local.get $i))
  )
  (func (export "get") (param $i i32) (result i32)
    (call $get (local.get $i) (call $new))
  )

  (func $set_get (param $i i32) (param $v (ref $mvec)) (param $y i32) (result i32)
    (array.set $mvec (local.get $v) (local.get $i) (local.get $y))
    (array.get $mvec (local.get $v) (local.get $i))
  )
  (func (export "set_get") (param $i i32) (param $y i32) (result i32)
    (call $set_get (local.get $i)
      (array.new_data $mvec 0 (i32.const 1) (i32.const 3))
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
(assert_return (invoke "set_get" (i32.const 1) (i32.const 7)) (i32.const 7))
(assert_return (invoke "len") (i32.const 3))

(module
  (type $vec (array i32))

  (data "")

  (func $new-huge (export "new-huge") (result (ref $vec))
    (array.new_data $vec 0 (i32.const 4) (i32.const -1))
  )
)

(assert_trap (invoke "new-huge") "out of bounds segment access in array.new_data")
