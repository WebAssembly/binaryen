;; Test for validation of non-nullable locals

;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

;; CHECK: non-nullable local's sets must dominate gets

(module
  (func $foo
    (local $nn (ref any))
    ;; It is not ok to read a non-nullable local.
    (drop
      (local.get $nn)
    )
  )
)
