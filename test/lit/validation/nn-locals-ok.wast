;; Test for validation of non-nullable locals

;; RUN: wasm-opt -all %s --print | filecheck %s

;; CHECK: (module

(module
  (func $foo (param $nn (ref any))
    ;; It is ok to read a non-nullable param.
    (drop
      (local.get $nn)
    )
  )
)
