(module
  (memory 1)
  (export "memory" memory)
  (export "foo" $foo)
  (func $foo
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
