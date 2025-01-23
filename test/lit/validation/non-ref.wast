;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

;; CHECK: ref.as value must be reference

(module
  (func $test
    (drop
      (ref.as_non_null
        (i32.const 42)
      )
    )
  )
)
