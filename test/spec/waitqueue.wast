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
  (type $t (shared (struct (field (mut waitqueue)))))

  (global $g (mut (ref null $t)) (struct.new $t (i32.const 0)))

  (func (export "setToNull")
    (global.set $g (ref.null $t))
  )

  (func (export "struct.wait") (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (global.get $g) (local.get $expected) (local.get $timeout))
  )

  (func (export "struct.notify") (param $count i32) (result i32)
    (struct.notify $t 0 (global.get $g) (local.get $count))
  )

  (func (export "struct.set") (param $count i32)
    (struct.set $t 0 (global.get $g) (i32.const 1))
  )

  (func (export "struct.get") (result i32)
    (struct.get $t 0 (global.get $g))
  )
)

(invoke "struct.set" (i32.const 1))
(assert_return (invoke "struct.get") (i32.const 1))

;; Control word didn't match, don't wait and return 1.
(assert_return (invoke "struct.wait" (i32.const 0) (i64.const 100)) (i32.const 1))

;; Control word matched, wait 0ns and return 2.
(assert_return (invoke "struct.wait" (i32.const 1) (i64.const 0)) (i32.const 2))

;; Try to wake up 1 thread, but no-one was waiting.
(assert_return (invoke "struct.notify" (i32.const 1)) (i32.const 0))

(invoke "setToNull")

(assert_trap (invoke "struct.wait" (i32.const 0) (i64.const 0)) "null ref")
(assert_trap (invoke "struct.notify" (i32.const 0)) "null ref")

;; Waiting on a non-shared struct traps.

(module
  (type $t (struct (field (mut waitqueue))))

  (global $g (mut (ref null $t)) (struct.new $t (i32.const 0)))

  (func (export "struct.wait") (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (global.get $g) (local.get $expected) (local.get $timeout))
  )
)
(assert_trap (invoke "struct.wait" (i32.const 0) (i64.const 100)) "not shared")

