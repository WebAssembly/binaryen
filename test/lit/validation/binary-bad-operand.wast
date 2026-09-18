;; RUN: not wasm-opt %s -o /dev/null > %t 2>&1
;; RUN: filecheck %s < %t

;; CHECK: binary child types must be equal
;; CHECK: child type does not match its constraint

(module
  (func (result i32)
    (i32.add (i32.const 0) (f64.const 0.0))
  )
)
