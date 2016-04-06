(module
  (memory 1)
  (export "memory" memory)
  (export "f" $f)
  (func $f (param $$0 i32) (result i32)
    (return
      (get_local $$0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
