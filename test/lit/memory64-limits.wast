;; RUN: wasm-opt %s -all --roundtrip -S -o - | filecheck %s

;; CHECK:     (module
;; CHECK-NEXT: (type $none_=>_i64 (func (result i64)))
;; CHECK-NEXT: (type $none_=>_none (func))
;; CHECK-NEXT: (memory $0 i64 1 4294967296)
;; CHECK-NEXT: (func $load_i64 (result i64)
;; CHECK-NEXT:  (i64.load offset=8589934592
;; CHECK-NEXT:   (i64.const 4294967296)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
;; CHECK-NEXT: (func $store
;; CHECK-NEXT:  (i64.store offset=8589934592
;; CHECK-NEXT:   (i64.const 4294967296)
;; CHECK-NEXT:   (i64.const 123)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
;; CHECK-NEXT:)

(module
 (memory $0 i64 1 4294967296)

  (func $load_i64 (result i64)
    (i64.load offset=8589934592
      (i64.const 0x100000000)
    )
  )

  (func $store (result)
    (i64.store offset=8589934592
      (i64.const 0x100000000)
      (i64.const 123)
    )
  )
)
