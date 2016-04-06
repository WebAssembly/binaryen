(module
  (memory 1
    (segment 8 "\01\00\00\00\00\00\00\00\00\00\00\00")
  )
  (export "memory" memory)
  (export "f" $f)
  (func $f (param $$0 i32) (param $$1 i32)
    (i32.store offset=12
      (get_local $$0)
      (get_local $$1)
    )
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 20, "initializers": [] }
