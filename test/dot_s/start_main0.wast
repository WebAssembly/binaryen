(module
  (memory 0)
  (export "memory" memory)
  (start $_start)
  (export "main" $main)
  (export "_start" $_start)
  (func $main
  )
  (func $_start
    (call $main)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
