;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --coalesce-locals -all -S -o - | filecheck %s

(module
 ;; CHECK:      (func $nn-locals (type $0) (param $0 (ref any))
 ;; CHECK-NEXT:  (local $1 ((ref any) (ref any)))
 ;; CHECK-NEXT:  (local $2 ((ref any) (ref any)))
 ;; CHECK-NEXT:  (local.set $1
 ;; CHECK-NEXT:   (tuple.make
 ;; CHECK-NEXT:    (local.get $0)
 ;; CHECK-NEXT:    (local.get $0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $2
 ;; CHECK-NEXT:   (tuple.make
 ;; CHECK-NEXT:    (local.get $0)
 ;; CHECK-NEXT:    (local.get $0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $nn-locals
 ;; CHECK-NEXT:   (tuple.extract 0
 ;; CHECK-NEXT:    (local.get $1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $nn-locals
 ;; CHECK-NEXT:   (tuple.extract 0
 ;; CHECK-NEXT:    (local.get $2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $nn-locals
 ;; CHECK-NEXT:   (tuple.extract 1
 ;; CHECK-NEXT:    (local.get $1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $nn-locals
 ;; CHECK-NEXT:   (tuple.extract 1
 ;; CHECK-NEXT:    (local.get $2)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $nn-locals (param $any (ref any))
  ;; When computing interferences, coalesce locals should not error on tuples
  ;; that contain non-nullable locals.
  (local $x ((ref any) (ref any)))
  (local $y ((ref any) (ref any)))
  ;; Set values into the tuple locals and use them.
  ;; Note that while the values are the same, we do not optimize them because
  ;; of current limitations on tuple handling in this pass, so we are mainly
  ;; testing for not crashing here.
  (local.set $x
   (tuple.make
    (local.get $any)
    (local.get $any)
   )
  )
  (local.set $y
   (tuple.make
    (local.get $any)
    (local.get $any)
   )
  )
  (call $nn-locals
   (tuple.extract 0
    (local.get $x)
   )
  )
  (call $nn-locals
   (tuple.extract 0
    (local.get $y)
   )
  )
  (call $nn-locals
   (tuple.extract 1
    (local.get $x)
   )
  )
  (call $nn-locals
   (tuple.extract 1
    (local.get $y)
   )
  )
 )

 ;; CHECK:      (func $unreachable-get-of-non-nullable (type $1)
 ;; CHECK-NEXT:  (local $0 (ref any))
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block (result (ref any))
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $unreachable-get-of-non-nullable
  ;; One local is unused entirely, the other is used but only in unreachable
  ;; code. It does not really matter what we do here (coalesce, or not), but we
  ;; should emit valid IR. Normally we would apply a constant to replace the
  ;; local.get, however, the types here are non-nullable, so we must do
  ;; something else.
  (local $unused (ref any))
  (local $used-in-unreachable (ref any))
  (unreachable)
  (drop
   (local.get $used-in-unreachable)
  )
 )
)
