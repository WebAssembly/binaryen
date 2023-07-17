;; RUN: not wasm-merge %s first %s.second second 2>&1 | filecheck %s

;; Test that wasm-merge terminates with an error when there is an import cycle.

;; CHECK: Fatal: wasm-merge: infinite loop of imports on f

(module
  (import "second" "g" (func $f))
  (export "f" (func $f))
)
