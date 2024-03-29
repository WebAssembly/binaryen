;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt -all --reorder-functions-by-name -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (func $a (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 10)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $b (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 20)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $c (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 30)
  ;; CHECK-NEXT: )
  (func $c (result i32)
    (i32.const 30)
  )

  (func $b (result i32)
    (i32.const 20)
  )

  (func $a (result i32)
    (i32.const 10)
  )
)

(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (func $a (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 10)
  ;; CHECK-NEXT: )
  (func $a (result i32)
    (i32.const 10)
  )

  ;; CHECK:      (func $b (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 20)
  ;; CHECK-NEXT: )
  (func $b (result i32)
    (i32.const 20)
  )

  ;; CHECK:      (func $c (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 30)
  ;; CHECK-NEXT: )
  (func $c (result i32)
    (i32.const 30)
  )
)

(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (func $a (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 10)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $b (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 20)
  ;; CHECK-NEXT: )
  (func $b (result i32)
    (i32.const 20)
  )

  (func $a (result i32)
    (i32.const 10)
  )

  ;; CHECK:      (func $c (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 30)
  ;; CHECK-NEXT: )
  (func $c (result i32)
    (i32.const 30)
  )
)

(module
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (func $a (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 10)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $b (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 20)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $c (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 30)
  ;; CHECK-NEXT: )
  (func $c (result i32)
    (i32.const 30)
  )

  (func $a (result i32)
    (i32.const 10)
  )

  (func $b (result i32)
    (i32.const 20)
  )
)
