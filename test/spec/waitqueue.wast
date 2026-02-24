(assert_invalid
  (module
    (type $t (struct (field i32)))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 0 (ref.null $t) (local.get $expected) (local.get $timeout))
    )
  ) "struct.wait struct field must be a waitqueue"
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

;; passes validation
(module
  (type $t (struct (field i32)))
  (func (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (unreachable) (local.get $expected) (local.get $timeout))
  )
)


(module
  (type $t (struct (field waitqueue)))

  (global $g (ref null $t) (struct.new $t (i32.const 0)))

  (func (export "waitqueue.wait") (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (global.get $g) (local.get $expected) (local.get $timeout))
  )
)
