;; Check that the instrumentation is correct when the output memory is 64-bit.
;; This test output cannot be auto-generated because it includes a hash of this
;; file.

;; RUN: wasm-split %s -all --instrument -S -o - | filecheck %s

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s -all --instrument -g -o %t
;; RUN: wasm-opt %t -all --print | filecheck %s

(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (param i32) (result i32)))

  ;; CHECK:      (type $2 (func (param i64 i32) (result i32)))

  ;; CHECK:      (import "env" "foo" (func $foo (type $0)))
  (import "env" "foo" (func $foo))
  ;; CHECK:      (global $monotonic_counter (mut i32) (i32.const 0))

  ;; CHECK:      (global $bar_timestamp (mut i32) (i32.const 0))

  ;; CHECK:      (global $baz_timestamp (mut i32) (i32.const 0))

  ;; CHECK:      (memory $mem i64 1 1)

  ;; CHECK:      (export "bar" (func $bar))
  (export "bar" (func $bar))

  (memory $mem i64 1 1)

  ;; CHECK:      (export "__write_profile" (func $__write_profile))

  ;; CHECK:      (export "profile-memory" (memory $mem))

  ;; CHECK:      (func $bar (type $0)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (global.get $bar_timestamp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (global.set $monotonic_counter
  ;; CHECK-NEXT:     (i32.add
  ;; CHECK-NEXT:      (global.get $monotonic_counter)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (global.set $bar_timestamp
  ;; CHECK-NEXT:     (global.get $monotonic_counter)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $foo)
  ;; CHECK-NEXT: )
  (func $bar
    (call $foo)
  )
  ;; CHECK:      (func $baz (type $1) (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.eqz
  ;; CHECK-NEXT:    (global.get $baz_timestamp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (global.set $monotonic_counter
  ;; CHECK-NEXT:     (i32.add
  ;; CHECK-NEXT:      (global.get $monotonic_counter)
  ;; CHECK-NEXT:      (i32.const 1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (global.set $baz_timestamp
  ;; CHECK-NEXT:     (global.get $monotonic_counter)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $0)
  ;; CHECK-NEXT: )
  (func $baz (param i32) (result i32)
    (local.get 0)
  )
)

;; Check that the $addr parameter is an i64.

;; CHECK:      (func $__write_profile (type $2) (param $addr i64) (param $size i32) (result i32)
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.ge_u
;; CHECK-NEXT:    (local.get $size)
;; CHECK-NEXT:    (i32.const 16)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (block
;; CHECK-NEXT:    (i64.store align=1
;; CHECK-NEXT:     (local.get $addr)
;; CHECK-NEXT:     (i64.const -6733849689813251748)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.store offset=8 align=1
;; CHECK-NEXT:     (local.get $addr)
;; CHECK-NEXT:     (global.get $bar_timestamp)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.store offset=12 align=1
;; CHECK-NEXT:     (local.get $addr)
;; CHECK-NEXT:     (global.get $baz_timestamp)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (i32.const 16)
;; CHECK-NEXT: )
