;; RUN: wasm-split %s --instrument --in-memory --enable-threads -S -o - | filecheck %s

;; Check that the output round trips and validates as well
;; RUN: wasm-split %s --instrument --in-memory --enable-threads -g -o %t.wasm
;; RUN: wasm-opt %t.wasm --enable-threads -S -o -

(module
  (import "env" "foo" (func $foo))
  (export "bar" (func $bar))
  (memory $0 1 1)
  (func $bar
    (call $foo)
  )
  (func $baz (param i32) (result i32)
    (local.get 0)
  )
)

;; Check that a memory has been added
;; CHECK: (memory $0 1 1)

;; And the profiling function exported
;; CHECK: (export "__write_profile" (func $__write_profile))

;; Check that the function instrumentation is correct

;; CHECK:      (func $bar
;; CHECK-NEXT:  (i32.atomic.store8
;; CHECK-NEXT:   (i32.const 0)
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $foo)
;; CHECK-NEXT: )

;; CHECK-NEXT: (func $baz (param $0 i32) (result i32)
;; CHECK-NEXT:  (i32.atomic.store8 offset=1
;; CHECK-NEXT:   (i32.const 0)
;; CHECK-NEXT:   (i32.const 1)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.get $0)
;; CHECK-NEXT: )

;; Check that the profiling function is correct.

;; CHECK:      (func $__write_profile (param $addr i32) (param $size i32) (result i32)
;; CHECK-NEXT:  (local $funcIdx i32)
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.ge_u
;; CHECK-NEXT:    (local.get $size)
;; CHECK-NEXT:    (i32.const 16)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (block
;; CHECK-NEXT:    (i64.store align=1
;; CHECK-NEXT:     (local.get $addr)
;; CHECK-NEXT:     (i64.const {{.*}})
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (block $outer
;; CHECK-NEXT:     (loop $l
;; CHECK-NEXT:      (br_if $outer
;; CHECK-NEXT:       (i32.eq
;; CHECK-NEXT:        (local.get $funcIdx)
;; CHECK-NEXT:        (i32.const 2)
;; CHECK-NEXT:       )
;; CHECK-NEXT:      )
;; CHECK-NEXT:      (i32.store offset=8
;; CHECK-NEXT:       (i32.add
;; CHECK-NEXT:        (local.get $addr)
;; CHECK-NEXT:        (i32.mul
;; CHECK-NEXT:         (local.get $funcIdx)
;; CHECK-NEXT:         (i32.const 4)
;; CHECK-NEXT:        )
;; CHECK-NEXT:       )
;; CHECK-NEXT:       (i32.atomic.load8_u
;; CHECK-NEXT:        (local.get $funcIdx)
;; CHECK-NEXT:       )
;; CHECK-NEXT:      )
;; CHECK-NEXT:      (local.set $funcIdx
;; CHECK-NEXT:       (i32.add
;; CHECK-NEXT:        (local.get $funcIdx)
;; CHECK-NEXT:        (i32.const 1)
;; CHECK-NEXT:       )
;; CHECK-NEXT:      )
;; CHECK-NEXT:      (br $l)
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (i32.const 16)
;; CHECK-NEXT: )
