(module
  (memory 1)
  (export "memory" memory)
  (export "main" $main)
  (func $main (result i32)
    (return
      (i32.const 5)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 8, "initializers": [] }
