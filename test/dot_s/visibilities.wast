(module
  (memory 0 4294967295)
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
;; METADATA: { "asmConsts": {},"staticBump": 4 }
