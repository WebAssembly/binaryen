(module
  (table 0 anyfunc)
  (memory $0 1)
  (export "memory" (memory $0))
  (export "foo" (func $foo))
  (export "bar" (func $bar))
  (export "qux" (func $qux))
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
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
