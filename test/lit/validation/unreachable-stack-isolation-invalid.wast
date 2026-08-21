;; RUN: not wasm-opt %s -all -o /dev/null 2>&1 | filecheck %s
;; RUN: not wasm-as %s -all -o /dev/null 2>&1 | filecheck %s

;; CHECK: popping from empty stack

(module
  (func
    (i32.const 1)
    (block
      (drop)
    )
  )
)
