(assert_invalid
  (module
    (type $t (struct (field i32) (field waitqueue)))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 0 (ref.null $t) (local.get $expected) (local.get $timeout))
    )
  ) "struct.wait struct field index must contain a `waitqueue`"
)

(assert_invalid
  (module
    (type $t (struct (field i32) (field waitqueue)))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 2 (ref.null $t) (local.get $expected) (local.get $timeout))
    )
  ) "struct index out of bounds"
)

(assert_invalid
  (module
    (type $t (struct (field waitqueue)))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 0 (global.get $g) (i64.const 0) (local.get $timeout))
    )
  ) "struct.wait expected must be an i32"
)

(assert_invalid
  (module
    (type $t (struct (field waitqueue)))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 0 (global.get $g) (local.get $expected) (i32.const 0))
    )
  ) "struct.wait timeout must be an i64"
)

(assert_invalid
  (module
    (type $t (struct (field i32) (field waitqueue)))
    (func (param $count i32) (result i32)
      (struct.notify $t 0 (ref.null $t) (local.get $count))
    )
  ) "struct.notify struct field index must contain a waitqueue"
)

(assert_invalid
  (module
    (type $t (struct (field i32) (field waitqueue)))
    (func (param $count i32) (result i32)
      (struct.notify $t 2 (ref.null $t) (local.get $count))
    )
  ) "struct index out of bounds"
)

(assert_invalid
  (module
    (type $t (struct (field waitqueue)))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (func (param $count i32) (result i32)
      (struct.notify $t 0 (global.get $g) (i64.const 0))
    )
  ) "struct.notify count must be an i32"
)

;; unreachable is allowed
(module
  (type $t (struct (field waitqueue)))
  (func (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (unreachable) (local.get $expected) (local.get $timeout))
  )
  (func (param $count i32) (result i32)
    (struct.notify $t 0 (unreachable) (local.get $count))
  )
)

(module
  (type $t (struct (field (mut waitqueue))))

  (global $g (ref null $t) (struct.new $t (i32.const 0)))

  (func (export "struct.wait") (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (global.get $g) (local.get $expected) (local.get $timeout))
  )

  (func (export "struct.notify") (param $count i32) (result i32)
    (struct.notify $t 0 (global.get $g) (local.get $count))
  )

  (func (export "struct.set") (param $count i32)
    (struct.set $t 0 (global.get $g) (i32.const 1))
  )

  (func (export "struct.get") (param $count i32) (result i32)
    (struct.get $t 0 (global.get $g))
  )
)
