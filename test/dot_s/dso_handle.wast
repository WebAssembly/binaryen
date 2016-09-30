(module
  (memory $0 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (table 0 anyfunc)
  
  (func $main (result i32)
    (return
      (i32.const 8)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
