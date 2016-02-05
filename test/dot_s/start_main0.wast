(module
  (memory 0 4294967295)
  (start $_start)
  (export "main" $main)
  (export "_start" $_start)
  (func $main
  )
  (func $_start
    (call $main)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
