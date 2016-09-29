(module
  (memory $0 1)
  (export "memory" (memory $0))
  (export "return_i32" (func $return_i32))
  (export "return_void" (func $return_void))
  (func $return_i32 (result i32)
    (i32.const 5)
  )
  (func $return_void
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
