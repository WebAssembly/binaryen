(module
  (memory 0)
  (export "memory" memory)
  (export "foo" $foo)
  (func $foo
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
