;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --pick-load-signs -all -S -o - | filecheck %s

(module
 ;; CHECK:      (memory $0 16 17 shared)
 (memory $0 16 17 shared)

 ;; CHECK:      (func $load-other-use (type $0) (result i32)
 ;; CHECK-NEXT:  (local $temp i32)
 ;; CHECK-NEXT:  (block $label (result i32)
 ;; CHECK-NEXT:   (local.set $temp
 ;; CHECK-NEXT:    (i32.load8_u
 ;; CHECK-NEXT:     (i32.const 22)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (i32.extend8_s
 ;; CHECK-NEXT:     (br_if $label
 ;; CHECK-NEXT:      (local.get $temp)
 ;; CHECK-NEXT:      (i32.const 1)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $load-other-use (result i32)
  (local $temp i32)
  ;; The load here is unsigned, while the value in the local is used in two
  ;; ways: it is sign-extended, and it is sent on a branch by a br_if. We must
  ;; not ignore the branch, as if we did then we'd think the only use is signed,
  ;; and we'd optimize load8_u => load8_s.
  (block $label (result i32)
   (local.set $temp
    (i32.load8_u
     (i32.const 22)
    )
   )
   (drop
    (i32.extend8_s
     (br_if $label
      (local.get $temp)
      (i32.const 1)
     )
    )
   )
   (unreachable)
  )
 )

 ;; CHECK:      (func $load-valid (type $1)
 ;; CHECK-NEXT:  (local $temp i32)
 ;; CHECK-NEXT:  (local.set $temp
 ;; CHECK-NEXT:   (i32.load8_s
 ;; CHECK-NEXT:    (i32.const 22)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.extend8_s
 ;; CHECK-NEXT:    (local.get $temp)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $load-valid
  (local $temp i32)
  ;; As above, but remove the br_if in the middle. Now this is a valid case to
  ;; optimize, load8_u => load8_s.
  (local.set $temp
   (i32.load8_u
    (i32.const 22)
   )
  )
  (drop
   (i32.extend8_s
    (local.get $temp)
   )
  )
 )
)

