;; Test that we validate imported functions.

;; RUN: not wasm-opt %s -all --disable-simd 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (import "env" "imported-v128" (func $imported-v128 (result v128)))
)
