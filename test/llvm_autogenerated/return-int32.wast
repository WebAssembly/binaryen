(module
  (memory 0)
  (export "return_i32" $return_i32)
  (func $return_i32 (param $$0 i32) (result i32)
    (return
      (get_local $$0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
