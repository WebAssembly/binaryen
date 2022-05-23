;; RUN: wasm-split %s --instrument -S -o - | filecheck %s

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s --instrument -g -o %t
;; RUN: wasm-opt %t --print | filecheck %s

(module
  (import "env" "foo" (func $foo))
  (export "bar" (func $bar))
  (func $bar
    (call $foo)
  )
  (func $baz (param i32) (result i32)
    (local.get 0)
  )
)

;; Check that the counter and timestamps have been added
;; CHECK: (global $monotonic_counter (mut i32) (i32.const 0))
;; CHECK: (global $bar_timestamp (mut i32) (i32.const 0))
;; CHECK: (global $baz_timestamp (mut i32) (i32.const 0))

;; Check that a memory has been added
;; CHECK: (memory $0 1 1)

;; And the profiling function is exported
;; CHECK: (export "__write_profile" (func $__write_profile))

;; And the memory has been exported
;; CHECK: (export "profile-memory" (memory $0))

;; Check that the function instrumentation is correct

;; CHECK:      (func $baz (param $0 i32) (result i32)
;; CHECK-NEXT:   (if
;; CHECK-NEXT:     (i32.eqz
;; CHECK-NEXT:       (global.get $baz_timestamp)
;; CHECK-NEXT:     )
;; CHECK-NEXT:     (block
;; CHECK-NEXT:       (global.set $monotonic_counter
;; CHECK-NEXT:         (i32.add
;; CHECK-NEXT:           (global.get $monotonic_counter)
;; CHECK-NEXT:           (i32.const 1)
;; CHECK-NEXT:         )
;; CHECK-NEXT:       )
;; CHECK-NEXT:       (global.set $baz_timestamp
;; CHECK-NEXT:         (global.get $monotonic_counter)
;; CHECK-NEXT:       )
;; CHECK-NEXT:     )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (local.get $0)
;; CHECK-NEXT: )

;; Check that the profiling function is correct.

;; CHECK:      (func $__write_profile (param $addr i32) (param $size i32) (result i32)
;; CHECK-NEXT:   (if
;; CHECK-NEXT:     (i32.ge_u
;; CHECK-NEXT:       (local.get $size)
;; CHECK-NEXT:       (i32.const 16)
;; CHECK-NEXT:     )
;; CHECK-NEXT:     (block
;; CHECK-NEXT:       (i64.store align=1
;; CHECK-NEXT:         (local.get $addr)
;; CHECK-NEXT:         (i64.const {{.*}})
;; CHECK-NEXT:       )
;; CHECK-NEXT:       (i32.store offset=8 align=1
;; CHECK-NEXT:         (local.get $addr)
;; CHECK-NEXT:         (global.get $bar_timestamp)
;; CHECK-NEXT:       )
;; CHECK-NEXT:       (i32.store offset=12 align=1
;; CHECK-NEXT:         (local.get $addr)
;; CHECK-NEXT:         (global.get $baz_timestamp)
;; CHECK-NEXT:       )
;; CHECK-NEXT:     )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (i32.const 16)
;; CHECK-NEXT: )
