;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; -g --roundtrip are added to show that we properly handle non-nullable locals
;; through the binary format as well (-g is for the function names).
;; RUN: wasm-opt %s -all --ssa -g --roundtrip -S -o - | filecheck %s

(module
 ;; CHECK:      (func $nn-locals (type $0)
 ;; CHECK-NEXT:  (local $x (ref func))
 ;; CHECK-NEXT:  (local.set $x
 ;; CHECK-NEXT:   (ref.func $nn-locals)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $nn-locals
  ;; A non-nullable local
  (local $x (ref func))
  ;; Set the local, and get it later. The SSA pass handles non- nullability
  ;; using ref.as_non_null.
  (local.set $x (ref.func $nn-locals))
  (drop (local.get $x))
  (drop (local.get $x))
 )
)
