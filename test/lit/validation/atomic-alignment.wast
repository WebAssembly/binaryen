;; RUN: not wasm-opt %s --enable-threads -o /dev/null 2>&1 | filecheck %s --check-prefix=CHECK-VAL
;; RUN: wasm-as %s --enable-threads --validate=none -o %t.wasm
;; RUN: wasm-dis %t.wasm -o - | filecheck %s --check-prefix=CHECK-DIS
;; RUN: not wasm-opt %t.wasm --enable-threads -o /dev/null 2>&1 | filecheck %s --check-prefix=CHECK-VAL

(module
  (memory 1 1 shared)

  (func $bad-load (result i32)
    (i32.atomic.load align=1 (i32.const 0))
  )
  (func $bad-store
    (i32.atomic.store align=2 (i32.const 0) (i32.const 0))
  )
  (func $bad-rmw (result i32)
    (i32.atomic.rmw.add align=1 (i32.const 0) (i32.const 0))
  )
  (func $bad-cmpxchg (result i32)
    (i32.atomic.rmw.cmpxchg align=1 (i32.const 0) (i32.const 0) (i32.const 0))
  )
  (func $bad-wait32 (result i32)
    (memory.atomic.wait32 align=1 (i32.const 0) (i32.const 0) (i64.const 0))
  )
  (func $bad-wait64 (result i32)
    (memory.atomic.wait64 align=4 (i32.const 0) (i64.const 0) (i64.const 0))
  )
  (func $bad-notify (result i32)
    (memory.atomic.notify align=1 (i32.const 0) (i32.const 0))
  )
  (func $bad-packed (result i64)
    (i64.atomic.load32_u align=8 (i32.const 0))
  )
)

;; CHECK-VAL: atomic accesses must have natural alignment

;; CHECK-DIS: align=1
;; CHECK-DIS: align=2
;; CHECK-DIS: align=8
