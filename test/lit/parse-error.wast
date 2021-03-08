;; Test that parse errors have helpful messages

;; RUN: not wasm-opt %s 2>&1 | filecheck %s
;; CHECK: [parse exception: abc (at 8:4)]

(module
  (func $foo
    (abc)
  )
)
