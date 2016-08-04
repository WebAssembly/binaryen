(module
  (memory 1)
  (export "memory" memory)
  (export "main" $main)
  (func $main (result i32)
    (call $foo)
    (i32.const 0)
  )
  (func $foo
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
