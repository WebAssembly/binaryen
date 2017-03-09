(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "main" (func $main))
 (func $main (result i32)
  (call $foo)
  (i32.const 0)
 )
 (func $foo
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
