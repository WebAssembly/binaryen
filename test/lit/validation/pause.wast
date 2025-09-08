;; Test that shared pause requires shared-everything threads

;; RUN: not wasm-opt %s 2>&1 | filecheck %s --check-prefix NO-SHARED
;; RUN: wasm-opt %s --enable-reference-types --enable-gc --enable-shared-everything -o - -S | filecheck %s --check-prefix SHARED

;; NO-SHARED: pause requires shared-everything [--enable-shared-everything]
;; SHARED: (pause)

(module
  (func (pause))
)
