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

(module $Mem
  (type $Wq (struct (field (mut waitqueue))))
  (global $wq (export "wq") (mut (ref null $Wq)) (ref.null $Wq))

  (func $init (export "init")
    (global.set $wq (struct.new $Wq (i32.const 0)))
  )
)

(register "mem")

(invoke $Mem "init")

(thread $T1 (shared (module $Mem))
  (register "mem" $Mem)
  (module
    (type $Wq (struct (field (mut waitqueue))))
    (global $wq (import "mem" "wq") (mut (ref null $Wq)))

    (func (export "run_wait") (result i32)
      ;; Wait on the waitqueue, expecting value 0, infinite timeout (-1)
      (struct.wait $Wq 0 (global.get $wq) (i32.const 0) (i64.const -1))
    )
  )
  ;; This thread will suspend on struct.wait
  (invoke "run_wait")
)

(thread $T2 (shared (module $Mem))
  (register "mem" $Mem)
  (module
    (type $Wq (struct (field (mut waitqueue))))
    (global $wq (import "mem" "wq") (mut (ref null $Wq)))

    (func (export "run_notify") (result i32)
      ;; Notify 1 waiter on the waitqueue
      (struct.notify $Wq 0 (global.get $wq) (i32.const 1))
    )
  )
  ;; This thread will notify the waitqueue and wake 1 thread
  (assert_return (invoke "run_notify") (i32.const 1))
)

;; Wait for threads to complete
(wait $T1)
(wait $T2)
