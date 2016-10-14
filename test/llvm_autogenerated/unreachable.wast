(module
  (type $FUNCSIG$v (func))
  (import "env" "abort" (func $abort))
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "f1" (func $f1))
  (export "f2" (func $f2))
  (export "f3" (func $f3))
  (func $f1 (result i32)
    (call $abort)
    (unreachable)
  )
  (func $f2
    (unreachable)
  )
  (func $f3
    (unreachable)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
