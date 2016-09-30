(module
  (memory $0 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (table 0 anyfunc)
  
  (func $main (result i32)
    (call $foo)
    (i32.const 0)
  )
  (func $foo
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
