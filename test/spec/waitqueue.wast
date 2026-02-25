(assert_invalid
  (module
    (func (param $expected i32) (param $timeout i64) (result i32)
      (waitqueue.wait (i32.const 0) (local.get $expected) (local.get $timeout))
    )
  ) "waitqueue.wait waitqueue must be a subtype of (struct (field waitqueue))"
)

(assert_invalid
  (module
    (type $t (struct (field waitqueue)))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (waitqueue.wait (global.get $g) (i64.const 0) (local.get $timeout))
    )
  ) "waitqueue.wait value must be an i32"
)

(assert_invalid
  (module
    (type $t (struct (field waitqueue)))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (waitqueue.wait (global.get $g) (local.get $expected) (i32.const 0))
    )
  ) "waitqueue.wait timeout must be an i64"
)

(assert_invalid
  (module
    (func (param $count i32) (result i32)
      (waitqueue.notify (i32.const 0) (local.get $count))
    )
  ) "waitqueue.notify waitqueue must be a subtype of (struct (field waitqueue))"
)

(assert_invalid
  (module
    (type $t (struct (field waitqueue)))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (func (param $count i32) (result i32)
      (waitqueue.notify (global.get $g) (i64.const 0))
    )
  ) "waitqueue.notify count must be an i32"
)

(module
  (type $t (struct (field waitqueue)))

  (global $g (ref $t) (struct.new $t (i32.const 0)))

  (func (export "waitqueue.wait") (param $expected i32) (param $timeout i64) (result i32)
    (waitqueue.wait (global.get $g) (local.get $expected) (local.get $timeout))
  )

  (func (export "waitqueue.notify") (param $count i32) (result i32)
    (waitqueue.notify (global.get $g) (local.get $count))
  )
)
