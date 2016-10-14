(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (export "main" (func $main))
  (func $main (result i32)
    (return
      (i32.const 8)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
