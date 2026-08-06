;; RUN: not wasm-as %s -o /dev/null 2>&1 | filecheck %s

;; CHECK: popping from empty stack

(module
  (func (param i32)
    (if (result i32)
      (local.get 0)
      (then (unreachable))
      (else (unreachable))
    )
    (drop)
    (drop)
  )
)
