;; RUN: wasm-opt %s -all -o /dev/null
;; RUN: wasm-as %s -all -o /dev/null

(module
  (func
    (block (result i32 i64)
      (unreachable)
    )
    (drop)
    (drop)
  )
)
