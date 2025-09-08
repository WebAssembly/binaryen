;; Test that out-of-bounds tuple.extract indices produce parse errors.

;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}:9:3: error: tuple index out of bounds

(module
 (func
  (tuple.extract 2 2
   (tuple.make 2
    (i32.const 0)
    (i64.const 1)
   )
  )
 )
)
