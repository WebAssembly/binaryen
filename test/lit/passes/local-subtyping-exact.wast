;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; Check that LocalSubtyping handles exact references properly when it
;; determines that a local that would otherwise be non-nullable must be nullable
;; because of control flow dominance constraints.

;; RUN: wasm-opt %s -all --local-subtyping -S -o - | filecheck %s

(module
 ;; CHECK:      (type $struct (struct))
 (type $struct (struct))

 ;; CHECK:      (func $test (type $1) (param $0 (ref (exact $struct))) (result (ref null $struct))
 ;; CHECK-NEXT:  (local $1 (ref null (exact $struct)))
 ;; CHECK-NEXT:  (if
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:   (then
 ;; CHECK-NEXT:    (local.set $1
 ;; CHECK-NEXT:     (ref.as_non_null
 ;; CHECK-NEXT:      (local.get $0)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.get $1)
 ;; CHECK-NEXT: )
 (func $test (param (ref (exact $struct))) (result (ref null $struct))
  (local (ref null (exact $struct)))
  (if
   (i32.const 0)
   (then
    (local.set 1
     ;; This would let the local be (ref (exact $struct)) if it dominated the get.
     (ref.as_non_null
      (local.get 0)
     )
    )
   )
  )
  (local.get 1)
 )
)
