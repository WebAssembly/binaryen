;; RUN: not wasm-split %s --instrument --profile-export=foo 2>&1 \
;; RUN:   | filecheck %s

;; CHECK: error: Export foo already exists.

(module
  (memory $m 0 0)
  (export "foo" (memory $m))
)
