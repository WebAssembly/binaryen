(module
  (memory 1)
  (export "memory" memory)
  (export "return_void" $return_void)
  (func $return_void
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
