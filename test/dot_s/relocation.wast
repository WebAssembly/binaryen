(module
  (memory 1
    (segment 4 "\08\00\00\00")
    (segment 8 "\04\00\00\00")
  )
  (export "memory" memory)
  (export "main" $main)
  (func $main (result i32)
    (local $$0 i32)
    (return
      (i32.load
        (i32.const 8)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
