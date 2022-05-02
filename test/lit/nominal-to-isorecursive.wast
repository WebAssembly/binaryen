;; TODO: Autogenerate these checks! The current script cannot handle `rec`.

;; RUN: wasm-as %s -all --nominal -g -o %t.wasm
;; RUN: wasm-dis %t.wasm -all --hybrid -o - | filecheck %s

;; Check that the nominal binary format is parseable as isorecursive with a
;; single recursion group.

;; CHECK:      (module
;; CHECK-NEXT:  (rec
;; CHECK-NEXT:   (type $make-super-t (func_subtype (result (ref $super)) func))
;; CHECK-NEXT:   (type $make-sub-t (func_subtype (result (ref $sub)) func))
;; CHECK-NEXT:   (type $super (struct_subtype (field i32) data))
;; CHECK-NEXT:   (type $sub (struct_subtype (field i32) $super))
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (func $make-super (type $make-super-t) (result (ref $super))
;; CHECK-NEXT:   (unreachable)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (func $make-sub (type $make-sub-t) (result (ref $sub))
;; CHECK-NEXT:   (unreachable)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
(module
  (type $super (struct i32))
  (type $sub (struct_subtype i32 $super))
  (type $make-super-t (func (result (ref $super))))
  (type $make-sub-t (func (result (ref $sub))))

  (func $make-super (type $make-super-t)
    (unreachable)
  )

  (func $make-sub (type $make-sub-t)
    (unreachable)
  )
)
