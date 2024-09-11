;; RUN: not wasm-opt %s -S -o - 2>&1 | filecheck %s

;; CHECK: 8:11: error: block parameters not yet supported

(module
  (func
    (i32.const 0)
    (block (param i32)
      (drop)
    )
  )
)
