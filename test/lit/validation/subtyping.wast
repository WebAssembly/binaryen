;; Test that we emit clear validation errors including type names for
;; subtyping problems.

;; RUN: not wasm-opt %s -all -o - 2>&1 | filecheck %s

;; CHECK: [wasm-validator error in function foo] local.set's value type must be correct, on
;; CHECK-NEXT: (local.set $0
;; CHECK-NEXT:  (ref.null any)
;; CHECK-NEXT: )

;; CHECK: [wasm-validator error in function foo] local.set's value type must be correct, on
;; CHECK-NEXT: (local.set $0
;; CHECK-NEXT:  (ref.null $struct)
;; CHECK-NEXT: )
;; CHECK-NEXT: - first type (that should be a subtype of the other) has name: $struct

;; CHECK: [wasm-validator error in function foo] local.set's value type must be correct, on
;; CHECK-NEXT: (local.set $1
;; CHECK-NEXT:  (ref.null any)
;; CHECK-NEXT: )
;; CHECK-NEXT: - second type (that the other should be a subtype of it) has name: $struct

;; CHECK: [wasm-validator error in function foo] local.set's value type must be correct, on
;; CHECK-NEXT: (local.set $1
;; CHECK-NEXT:  (ref.null $array)
;; CHECK-NEXT: )
;; CHECK-NEXT: - first type (that should be a subtype of the other) has name: $array
;; CHECK-NEXT: - second type (that the other should be a subtype of it) has name: $struct

(module
  (type $struct (struct))
  (type $array (array i32))

  (func $foo
    (local $func (ref null func))
    (local $struct (ref null $struct))
    ;; Invalid assignment, neither type has a name.
    (local.set $func
      (ref.null any)
    )
    ;; Invalid assignment, the written type has a name.
    (local.set $func
      (ref.null $struct)
    )
    ;; Invalid assignment, the receiving type has a name.
    (local.set $struct
      (ref.null any)
    )
    ;; Invalid assignment, both types have names.
    (local.set $struct
      (ref.null $array)
    )
  )
)
