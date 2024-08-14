;; Test that nullref without GC is a validation error.

;; RUN: not wasm-opt %s -all --disable-gc 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (func $test
    (local nullref)
  )
)
