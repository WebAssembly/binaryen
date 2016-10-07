(module
  (table 0 anyfunc)
  (memory $0 1)
  (data (i32.const 4) "\10\04\00\00")
  (export "memory" (memory $0))
  (export "f" (func $f))
  (func $f (param $0 i32) (result i32)
    (get_local $0)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
