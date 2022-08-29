;; Test that out-of-bounds tuple.extract indices produce parse errors.

;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; CHECK: [parse exception: Bad index on tuple.extract (at 9:17)]

(module
 (func
  (tuple.extract 2
   (tuple.make
    (i32.const 0)
    (i64.const 1)
   )
  )
 )
)
