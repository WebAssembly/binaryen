;; Test that exact imports require custom descriptors.

;; RUN: not wasm-opt %s -all --disable-custom-descriptors 2>&1 | filecheck %s

;; CHECK: exact imports require custom descriptors [--enable-custom-descriptors]

(module
  (import "" "" (func $f (exact)))
)
