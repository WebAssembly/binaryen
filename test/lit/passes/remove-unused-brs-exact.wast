;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; RUN: wasm-opt %s -all --remove-unused-brs -S -o - | filecheck %s

;; Check that we optimize the cast correctly when the fallthrough has exact
;; type. In particular, we should not insert a ref.as_non_null, which would
;; trap.

(module
 ;; CHECK:      (func $br_on_cast_fail (type $0) (param $0 (exact nullref))
 ;; CHECK-NEXT:  (local $1 nullref)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block $block
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (ref.cast (exact nullref)
 ;; CHECK-NEXT:      (local.tee $1
 ;; CHECK-NEXT:       (local.get $0)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (return)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $br_on_cast_fail (param (ref null exact none))
  (local $1 nullref)
  (drop
   (block $block (result (ref none))
    (drop
     (br_on_cast_fail $block nullref nullref
      (local.tee $1
       (local.get 0)
      )
     )
    )
    (return)
   )
  )
 )
)
