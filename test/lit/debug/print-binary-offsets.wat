;; RUN: wasm-opt %s -o %t.wasm
;; RUN: wasm-opt %t.wasm --print-binary-offsets | filecheck %s

;; The command makes us print binary offsets in wat text. Note that it works
;; even without -g for the names section.

(module
  (func $test
    (call $test)
  )
)

;; CHECK:      ;; Code section offset: 0x14
;; CHECK-NEXT: ;; (binary offsets in VM stack traces include this; add it to the offsets below)

;; CHECK:      (func $0
;; CHECK-NEXT:  ;; code offset: 0x3
;; CHECK-NEXT:  (call $0)
;; CHECK-NEXT: )

