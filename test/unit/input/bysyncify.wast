(module
  (memory 1 2)
  (import "env" "sleep" (func $sleep))
  (export "memory" (memory 0))
  (func "run" (result i32)
    ;; sleep twice, then return 42
    (call $sleep)
    (call $sleep)
    (i32.const 42)
  )
)

