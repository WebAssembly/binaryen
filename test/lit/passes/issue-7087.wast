;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; Regression test for an interesting double bug between TypeSSA and
;; Unsubtyping. TypeSSA creates a new subtype, $t_1, for use in the struct.new
;; in the global initializer, but then only runs ReFinalize on function code,
;; not on module-level code. As a result, the tuple.make result type still uses
;; $t instead of $t_1 after TypeSSA.

;; The second part of the bug was that unsubtyping did not properly note that
;; tuple.make operands had to remain subtypes of the corresponding tuple element
;; types. As a result, Unsubtyping made $t_1 a sibling of $t rather than keeping
;; it a subtype of $t, breaking validation for tuple.make.

;; RUN: wasm-opt %s -all --type-ssa --unsubtyping -S -o - | filecheck %s

(module
 ;; CHECK:      (rec
 ;; CHECK-NEXT:  (type $t (sub (struct)))
 (type $t (sub (struct)))

 ;; CHECK:       (type $t_1 (sub $t (struct)))

 ;; CHECK:      (global $g (tuple i32 (ref null $t)) (tuple.make 2
 ;; CHECK-NEXT:  (i32.const 0)
 ;; CHECK-NEXT:  (struct.new_default $t_1)
 ;; CHECK-NEXT: ))
 (global $g (tuple i32 (ref null $t))
  (tuple.make 2
   (i32.const 0)
   (struct.new $t)
  )
 )
)
