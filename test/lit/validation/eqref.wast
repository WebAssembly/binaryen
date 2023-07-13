;; Test for eqref validating only with GC, and not just reference types, even
;; when only declared in a null.

;; RUN: not wasm-opt --enable-reference-types %s -o - -S 2>&1 | filecheck %s --check-prefix NO-GC
;; RUN:     wasm-opt --enable-reference-types --enable-gc %s -o - -S | filecheck %s --check-prefix GC

;; NO-GC: all used types should be allowed

;; GC:   (func $foo (type $0) (param $x eqref)

(module
  (func $foo (param $x eqref)
    (nop)
  )
)
