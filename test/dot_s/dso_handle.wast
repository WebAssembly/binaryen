(module
  (memory 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (func $main (result i32)
    (return
      (i32.const 8)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
