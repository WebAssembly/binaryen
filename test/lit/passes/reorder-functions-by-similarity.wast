;; `reorder-functions-by-similarity=0` disables the size threshold, forcing the compiler to reorder functions.
;; RUN: foreach %s %t wasm-opt -all --reorder-functions-by-similarity=0 -S -o - | filecheck %s

(module
  ;; CHECK:      (type $0 (func (result i32)))
  ;; CHECK-NEXT: (type $1 (func (param i32) (result i32)))

  ;; CHECK:      (func $sig_b (type $1) (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (i32.const 100)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $sig_c (type $1) (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (i32.const 200)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $body_add_2 (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:   (i32.const 20)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $body_add_1 (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $body_sub (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.sub
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $locals_a (type $0) (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 f64)
  ;; CHECK-NEXT:  (i32.const 5)
  ;; CHECK-NEXT: )

  ;; CHECK:      (func $locals_b (type $0) (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 f64)
  ;; CHECK-NEXT:  (i32.const 10)
  ;; CHECK-NEXT: )

  ;; Functions in mixed order:

  ;; Signature A
  (func $body_sub (result i32)
    (i32.sub (i32.const 1) (i32.const 2))
  )

  ;; Signature B: (param i32) (result i32)
  (func $sig_b (param i32) (result i32)
    (i32.const 100)
  )

  ;; Signature A, same body shape as $body_add_1
  (func $body_add_2 (result i32)
    (i32.add (i32.const 10) (i32.const 20))
  )

  ;; Signature A, has local variables (i32 f64)
  (func $locals_a (result i32)
    (local i32 f64)
    (i32.const 5)
  )

  ;; Signature A, same body shape as $body_add_2
  (func $body_add_1 (result i32)
    (i32.add (i32.const 1) (i32.const 2))
  )

  ;; Signature A, has local variables (i32 f64), same as $locals_a
  (func $locals_b (result i32)
    (local i32 f64)
    (i32.const 10)
  )

  ;; Signature B: (param i32) (result i32), same as $sig_b
  (func $sig_c (param i32) (result i32)
    (i32.const 200)
  )
)
