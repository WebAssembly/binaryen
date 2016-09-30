(module
  (memory $0 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (func $main (result i32)
    (return
      (i32.const 5)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
