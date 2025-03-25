;; Test that tuple types in signatures lead to errors

;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}:9:1: error: tuple types not allowed in signature

(module
 (func $tuple-in-sig (param (tuple i32 i32))
 )
)
