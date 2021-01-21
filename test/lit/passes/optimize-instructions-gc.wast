;; NOTE: Assertions have been generated by update_lit_checks.py
;; RUN: wasm-opt %s --optimize-instructions --enable-reference-types --enable-gc -S -o - \
;; RUN:   | filecheck %s

(module
  ;; These functions test if an `if` with subtyped arms is correctly folded
  ;; 1. if its `ifTrue` and `ifFalse` arms are identical (can fold)
 ;; CHECK: (func $if-arms-subtype-fold (result anyref)
 ;; CHECK:  (ref.null extern)
 ;; CHECK: )
  (func $if-arms-subtype-fold (result anyref)
    (if (result anyref)
      (i32.const 0)
      (ref.null extern)
      (ref.null extern)
    )
  )
  ;; 2. if its `ifTrue` and `ifFalse` arms are not identical (cannot fold)
 ;; CHECK: (func $if-arms-subtype-nofold (result anyref)
 ;; CHECK:  (if (result anyref)
 ;; CHECK:   (i32.const 0)
 ;; CHECK:   (ref.null extern)
 ;; CHECK:   (ref.null func)
 ;; CHECK:  )
 ;; CHECK: )
  (func $if-arms-subtype-nofold (result anyref)
    (if (result anyref)
      (i32.const 0)
      (ref.null extern)
      (ref.null func)
    )
  )
)
