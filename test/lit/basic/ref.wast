;; RUN: not wasm-shell %s 2>&1 | filecheck %s

(module
  (func (export "f") (result (ref null i31))
    (ref.null i31)
  )
)

;; CHECK: expected i31, got nullref
(assert_return (invoke "f") (ref.i31))
