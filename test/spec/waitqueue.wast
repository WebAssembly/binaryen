(assert_invalid
  (module
    (type $t (shared (struct (field i32))))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 0 (ref.null $t) (ref.null waitqueue) (local.get $expected) (local.get $timeout))
    )
  ) "struct.wait waitqueue must be a shared waitqueue reference"
)

(assert_invalid
  (module
    (type $t (shared (struct (field i32))))
    (global $wq (ref (shared waitqueue)) (waitqueue.new))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 2 (ref.null $t) (global.get $wq) (local.get $expected) (local.get $timeout))
    )
  ) "struct index out of bounds"
)

(assert_invalid
  (module
    (type $t (shared (struct (field i32))))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (global $wq (ref (shared waitqueue)) (waitqueue.new))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 0 (global.get $g) (global.get $wq) (i64.const 0) (local.get $timeout))
    )
  ) "struct.wait expected must be an i32"
)

(assert_invalid
  (module
    (type $t (shared (struct (field i32))))
    (global $g (ref $t) (struct.new $t (i32.const 0)))
    (global $wq (ref (shared waitqueue)) (waitqueue.new))
    (func (param $expected i32) (param $timeout i64) (result i32)
      (struct.wait $t 0 (global.get $g) (global.get $wq) (local.get $expected) (i32.const 0))
    )
  ) "struct.wait timeout must be an i64"
)

(assert_invalid
  (module
    (type $t (shared (struct (field i32))))
    (global $wq (ref (shared waitqueue)) (waitqueue.new))
    (func (param $count i32) (result i32)
      (waitqueue.notify (ref.null waitqueue) (local.get $count))
    )
  ) "waitqueue.notify waitqueue must be a shared waitqueue reference"
)

(assert_invalid
  (module
    (type $t (shared (struct (field i32))))
    (global $wq (ref (shared waitqueue)) (waitqueue.new))
    (func (param $count i32) (result i32)
      (waitqueue.notify (global.get $wq) (i64.const 0))
    )
  ) "waitqueue.notify count must be an i32"
)

;; unreachable is allowed
(module
  (type $t (shared (struct (field i32))))
  (global $wq (ref (shared waitqueue)) (waitqueue.new))
  (func (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (unreachable) (global.get $wq) (local.get $expected) (local.get $timeout))
  )
  (func (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (ref.null $t) (unreachable) (local.get $expected) (local.get $timeout))
  )
  (func (param $count i32) (result i32)
    (waitqueue.notify (unreachable) (local.get $count))
  )
)

(module
  (type $t (shared (struct (field (mut i32)))))

  (global $g (mut (ref null $t)) (struct.new $t (i32.const 0)))
  (global $wq (mut (ref null (shared waitqueue))) (waitqueue.new))

  (func (export "setToNull")
    (global.set $g (ref.null $t))
    (global.set $wq (ref.null (shared waitqueue)))
  )

  (func (export "struct.wait") (param $expected i32) (param $timeout i64) (result i32)
    (struct.wait $t 0 (global.get $g) (global.get $wq) (local.get $expected) (local.get $timeout))
  )

  (func (export "waitqueue.notify") (param $count i32) (result i32)
    (waitqueue.notify (global.get $wq) (local.get $count))
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
(assert_return (invoke "waitqueue.notify" (i32.const 1)) (i32.const 0))

(invoke "setToNull")

(assert_trap (invoke "struct.wait" (i32.const 0) (i64.const 0)) "null ref")
(assert_trap (invoke "waitqueue.notify" (i32.const 0)) "null ref")

;; Binary format test for waitqueue and nowaitqueue.
(module binary
  "\00asm\01\00\00\00" ;; Wasm header

  "\01\0b\02" ;; Type section, 11 bytes, 2 types
    "\65\5f\01\7f\01" ;; Type 0: (shared (struct (field (mut i32))))
    "\60\01\64\00\00" ;; Type 1: (func (param (ref 0)))

  "\03\02\01\01" ;; Function section, 2 bytes, 1 function of type 1

  "\06\09\01" ;; Global section, 9 bytes, 1 global
    "\63\65\5b" ;; ref null shared nowaitqueue
    "\01" ;; mut
    "\d0\65\5b" ;; ref.null shared nowaitqueue
    "\0b" ;; end

  "\0a\20\01" ;; Code section, 32 bytes, 1 function
    "\1e\01" ;; Function size 30, 1 local entry
      "\01\63\65\5c" ;; 1 local of type (ref null shared waitqueue)

      "\fe\07" ;; waitqueue.new
      "\21\01" ;; local.set 1

      "\20\00" ;; local.get 0 (s)
      "\20\01" ;; local.get 1 (wq)
      "\41\00" ;; i32.const 0
      "\42\00" ;; i64.const 0
      "\fe\05" ;; struct.wait
      "\00"    ;; struct type 0
      "\00"    ;; field index 0
      "\1a"    ;; drop

      "\20\01" ;; local.get 1 (wq)
      "\41\01" ;; i32.const 1
      "\fe\06" ;; waitqueue.notify
      "\1a"    ;; drop
      "\0b"    ;; end
)
