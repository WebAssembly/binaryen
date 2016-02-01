(module
  (memory 0 4294967295)
  (export "foo" $foo)
  (func $foo
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
