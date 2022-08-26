;; Test for validation of non-nullable locals

;; RUN: not wasm-opt -all --enable-gc-nn-locals %s 2>&1 | filecheck %s

;; CHECK: non-nullable local must not read null

(module
  (func $foo
    (local $nn (ref any))
    ;; It is not ok to read a non-nullable local.
    (drop
      (local.get $nn)
    )
  )
)
