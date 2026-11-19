;; Test for a validation error on out-of-bounds data index

;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

;; CHECK: data index out of bounds

(module
 (memory $0 16)
 (func $1
  (data.drop 1)
  (unreachable)
 )
)
