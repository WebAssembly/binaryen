(module
  (memory 0)
  (export "memory" memory)
  (export "main" $main)
  (export "f2" $f2)
  (func $main (result i32)
    (return
      (i32.const 5)
    )
  )
  (func $f2
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": ["main", "f2", ] }
