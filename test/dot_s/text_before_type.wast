(module
  (memory 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (func $main (result i32)
    (drop
      (call $foo)
    )
    (i32.const 0)
  )
  (func $foo
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
