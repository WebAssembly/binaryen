;; RUN: wasm-opt %s -all --roundtrip -S -o - | filecheck %s

(module
 (memory $0 i64 1 4294967296)
)

;; CHECK:      (module
;; CHECK-NEXT:  (memory $0 i64 1 4294967296)
;; CHECK-NEXT: )
