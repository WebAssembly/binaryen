;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: wasm-merge %s first %s.second.wat second %s.third.wat third -all -S -o - | filecheck %s

;; Test a cycle of imports: the first module imports from the second, which
;; imports from the third, and we have a reverse cycle as well.

(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (import "second" "forward" (func $second.forward))
  (import "second" "forward" (func $second.forward))

  ;; CHECK:      (import "second" "reverse" (func $second.reverse))
  (import "second" "reverse" (func $second.reverse))

  ;; CHECK:      (import "third" "forward" (func $third.forward))
  (import "third" "forward" (func $third.forward))

  ;; CHECK:      (import "third" "reverse" (func $third.reverse))
  (import "third" "reverse" (func $third.reverse))



  ;; CHECK:      (import "first" "forward" (func $first.forward))

  ;; CHECK:      (import "first" "reverse" (func $first.reverse))

  ;; CHECK:      (import "third" "forward" (func $third.forward_6))

  ;; CHECK:      (import "third" "reverse" (func $third.reverse_6))

  ;; CHECK:      (import "first" "forward" (func $first.forward_12))

  ;; CHECK:      (import "first" "reverse" (func $first.reverse_12))

  ;; CHECK:      (import "second" "forward" (func $second.forward_12))

  ;; CHECK:      (import "second" "reverse" (func $second.reverse_12))

  ;; CHECK:      (export "forward" (func $forward))

  ;; CHECK:      (export "reverse" (func $reverse))

  ;; CHECK:      (export "forward_2" (func $forward_6))

  ;; CHECK:      (export "reverse_3" (func $reverse_6))

  ;; CHECK:      (export "forward_4" (func $forward_12))

  ;; CHECK:      (export "reverse_5" (func $reverse_12))

  ;; CHECK:      (func $forward (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $forward_6)
  ;; CHECK-NEXT: )
  (func $forward (export "forward")
    (drop
      (i32.const 1)
    )
    (call $second.forward)
  )

  ;; CHECK:      (func $reverse (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const -1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call $reverse_12)
  ;; CHECK-NEXT: )
  (func $reverse (export "reverse")
    (drop
      (i32.const -1)
    )
    (call $third.reverse)
  )
)
;; CHECK:      (func $forward_6 (type $none_=>_none)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 2)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $forward_12)
;; CHECK-NEXT: )

;; CHECK:      (func $reverse_6 (type $none_=>_none)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const -2)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $reverse)
;; CHECK-NEXT: )

;; CHECK:      (func $forward_12 (type $none_=>_none)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const 3)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $forward)
;; CHECK-NEXT: )

;; CHECK:      (func $reverse_12 (type $none_=>_none)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.const -3)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $reverse_6)
;; CHECK-NEXT: )
