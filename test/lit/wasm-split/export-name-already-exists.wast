;; RUN: not wasm-split %s --instrument --profile-export=foo 2>&1 \
;; RUN:   | filecheck %s

;; CHECK: error: Export foo already exists.

(module
  (export "foo" (memory 0 0))
)
