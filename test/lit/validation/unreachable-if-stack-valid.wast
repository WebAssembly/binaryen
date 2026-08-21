;; RUN: wasm-as %s -o /dev/null

(module
  (func (param i32)
    (if (result i32)
      (local.get 0)
      (then (unreachable))
      (else (unreachable))
    )
    (drop)
  )
)
