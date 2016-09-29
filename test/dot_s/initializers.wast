(module
  (memory $0 1)
  (export "memory" (memory $0))
  (export "main" (func $main))
  (export "f1" (func $f1))
  (export "f2" (func $f2))
  (func $main (result i32)
    (return
      (i32.const 5)
    )
  )
  (func $f1
    (return)
  )
  (func $f2
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": ["main", "f1", "f2"] }
