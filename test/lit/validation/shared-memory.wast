;; Test that shared memory requires atomics

;; RUN: not wasm-opt %s 2>&1 | filecheck %s
;; CHECK: memory is shared, but atomics are disabled

;; RUN: wasm-opt %s --enable-threads -o - -S | filecheck %s --check-prefix ATOMICS
;; ATOMICS: (memory $0 (shared 10 20))

(module
  (memory (shared 10 20))
)