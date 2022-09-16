;; RUN: wasm-opt %s -all --roundtrip --optimize-added-constants --low-memory-unused -S -o - | filecheck %s

(module
 (memory $0 i64 1 4294967296)

;; CHECK:      (func $load_i64 (result i64)
;; CHECK-NEXT:  (i64.load
;; CHECK-NEXT:   (i64.const 579)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
;; CHECK-NEXT: (func $store
;; CHECK-NEXT:  (i64.store
;; CHECK-NEXT:   (i64.const 579)
;; CHECK-NEXT:   (i64.const 123)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

  (func $load_i64 (result i64)
    (i64.load offset=123
      (i64.const 456)
    )
  )

  (func $store (result)
    (i64.store offset=123
      (i64.const 456)
      (i64.const 123)
    )
  )
)
