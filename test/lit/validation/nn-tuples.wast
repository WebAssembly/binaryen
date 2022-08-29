;; Test for non-nullable types in tuples

;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s --check-prefix NO-NN-LOCALS
;; RUN:     wasm-opt -all %s --enable-gc-nn-locals -o - -S | filecheck %s --check-prefix NN-LOCALS

;; NO-NN-LOCALS: vars must be defaultable

;; NN-LOCALS: (module
;; NN-LOCALS:  (local $tuple ((ref any) (ref any)))
;; NN-LOCALS:  (nop)
;; NN-LOCALS: )

(module
  (func $foo
    (local $tuple ((ref any) (ref any)))
  )
)
