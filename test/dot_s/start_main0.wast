(module
  (table 0 anyfunc)
  (memory $0 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (export "_start" (func $_start))
  (start $_start)
  (func $main
  )
  (func $_start
    (call $main)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
