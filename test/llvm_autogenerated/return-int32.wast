(module
  (memory 1
    (segment 4 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "return_i32" $return_i32)
  (func $return_i32 (param $$0 i32) (result i32)
    (return
      (get_local $$0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }