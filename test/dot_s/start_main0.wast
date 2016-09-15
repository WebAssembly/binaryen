(module
  (memory 1)
  (start $_start)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (export "_start" (func $_start))
  (func $main
  )
  (func $_start
    (call $main)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
