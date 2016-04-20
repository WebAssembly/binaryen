(module
  (memory 1)
  (export "memory" memory)
  (export "main" $main)
  (export "f1" $f1)
  (export "f2" $f2)
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
