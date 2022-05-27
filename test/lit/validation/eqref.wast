;; Test for eqref validating only with GC, and not just reference types, even
;; when only declared in a null.

;; RUN: not wasm-opt --enable-reference-types %s 2>&1 | filecheck %s --check-prefix NO-GC
;; RUN:     wasm-opt --enable-reference-types --enable-gc %s -o - -S | filecheck %s --check-prefix GC

;; NO-GC: ref.null type should be allowed

;; GC:   (drop
;; GC:    (ref.null eq)
;; GC:   )

(module
  (func $foo
    (drop
      (ref.null eq)
    )
  )
)
