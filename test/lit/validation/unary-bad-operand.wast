;; RUN: not wasm-opt %s -o /dev/null 2>&1 | filecheck %s

;; CHECK: child type does not match its constraint

(module
  (func (result i32)
    (i32.eqz (f64.const 0.0))
  )
)
