;; Check that the instrumentation is correct when the output memory is 64-bit.
;; This test output cannot be auto-generated because it includes a hash of this
;; file.

;; RUN: wasm-split %s -all --instrument -S -o - | filecheck %s

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s -all --instrument -g -o %t
;; RUN: wasm-opt %t -all --print | filecheck %s

(module
  (import "env" "foo" (func $foo))
  (export "bar" (func $bar))

  (memory $mem i64 1 1)

  (func $bar
    (call $foo)
  )
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
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (i64.store align=1
;; CHECK-NEXT:     (local.get $addr)
;; CHECK-NEXT:     (i64.const {{.*}})
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
