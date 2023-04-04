;; Test for a validation error on bad usage of call.without.effects

;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

;; CHECK: unknown data segment

(module
 (memory $0 16)
 (func $1
  (data.drop 1)
  (unreachable)
 )
)
