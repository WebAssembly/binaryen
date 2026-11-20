;; RUN: not wasm-opt -all %s -o /dev/null > %t 2>&1
;; RUN: filecheck %s < %t

;; CHECK: child type does not match its constraint

(module
  (func (result i32)
    (ref.is_null (i32.const 0))
  )
)
