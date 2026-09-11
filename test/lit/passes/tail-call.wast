;; Test converting calls in tail position to return calls.

;; RUN: wasm-opt %s --tail-call --enable-tail-call --enable-gc --enable-reference-types -S -o - | filecheck %s

(module
  (type $none-to-none (func))
  (type $none-to-i32 (func (result i32)))
  (table $table 1 funcref)

  (func $void-callee)
  (func $value-callee (result i32)
    (i32.const 1)
  )
  (func $ref-callee (result i32)
    (i32.const 2)
  )
  (elem (i32.const 0) $value-callee)

  ;; CHECK-LABEL: (func $direct-void
  ;; CHECK-NEXT:  (return_call $void-callee)
  ;; CHECK-NEXT: )
  (func $direct-void
    (call $void-callee)
  )

  ;; CHECK-LABEL: (func $direct-value
  ;; CHECK-NEXT:  (return_call $value-callee)
  ;; CHECK-NEXT: )
  (func $direct-value (result i32)
    (call $value-callee)
    (return)
  )

  ;; CHECK-LABEL: (func $conditional
  ;; CHECK:       (if
  ;; CHECK-NEXT:   (local.get $condition)
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (return_call $value-callee)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (else
  ;; CHECK-NEXT:    (return_call $ref-callee)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $conditional (param $condition i32) (result i32)
    (if (result i32)
      (local.get $condition)
      (then (call $value-callee))
      (else (call $ref-callee))
    )
  )

  ;; CHECK-LABEL: (func $indirect
  ;; CHECK-NEXT:  (return_call_indirect $table (type $none-to-i32)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $indirect (result i32)
    (i32.const 0)
    (call_indirect $table (type $none-to-i32))
  )

  ;; CHECK-LABEL: (func $ref
  ;; CHECK-NEXT:  (return_call_ref $none-to-i32
  ;; CHECK-NEXT:   (ref.func $value-callee)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $ref (result i32)
    (call_ref $none-to-i32
      (ref.func $value-callee)
    )
  )

  ;; CHECK-LABEL: (func $break
  ;; CHECK-NEXT:  (block $out
  ;; CHECK-NEXT:   (if
  ;; CHECK-NEXT:    (local.get $condition)
  ;; CHECK-NEXT:    (then
  ;; CHECK-NEXT:     (return_call $value-callee)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (return_call $ref-callee)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $break (param $condition i32) (result i32)
    (block $out (result i32)
      (if (local.get $condition)
        (then (br $out (call $value-callee)))
      )
      (call $ref-callee)
    )
  )

  ;; CHECK-LABEL: (func $not-tail
  ;; CHECK-NEXT:  (call $void-callee)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $not-tail
    (call $void-callee)
    (nop)
  )

  ;; CHECK-LABEL: (func $mismatched-result
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $value-callee)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $mismatched-result
    (drop (call $value-callee))
  )
)