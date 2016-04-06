(module
  (memory 0)
  (export "memory" memory)
  (export "main" $main)
  (func $main (result i32)
    (return
      (i32.const 5)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0, "initializers": [] }
