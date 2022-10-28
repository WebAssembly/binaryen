;; Test for a validation error on bad usage of call.without.effects

;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

;; CHECK: param number must match

(module
  (import "binaryen-intrinsics" "call.without.effects" (func $cwe (param i32 funcref) (result i32)))

  (func "get-ref" (result i32)
    ;; This call-without-effects is done to a $func, but $func has the wrong
    ;; signature - it lacks the i32 parameter.
    (call $cwe
      (i32.const 41)
      (ref.func $func)
    )
  )

  (func $func (result i32)
    (i32.const 1)
  )
)

