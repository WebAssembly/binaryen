(module
  (memory 1
    (segment 0 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "f" $f)
  (func $f (param $$0 i32) (result i32)
    (return
      (get_local $$0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
