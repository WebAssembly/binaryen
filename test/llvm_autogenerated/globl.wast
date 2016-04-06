(module
  (memory 1
    (segment 0 "\10\04\00\00")
  )
  (export "memory" memory)
  (export "foo" $foo)
  (func $foo
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
