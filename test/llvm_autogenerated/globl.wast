(module
  (memory $0 1)
  (data (i32.const 4) "\10\04\00\00")
  (export "memory" (memory $0))
  (export "foo" (func $foo))
  (table 0 anyfunc)
  
  (func $foo
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
