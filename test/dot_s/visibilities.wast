(module
  (memory 1)
  (export "memory" memory)
  (export "foo" $foo)
  (export "bar" $bar)
  (export "qux" $qux)
  (func $foo
    (return)
  )
  (func $bar
    (return)
  )
  (func $qux
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
