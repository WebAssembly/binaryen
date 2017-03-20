(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "main" (func $main))
 (func $foo (param $0 i32)
 )
 (func $main (result i32)
  (call $foo
   (i32.const 16)
  )
  (i32.const 0)
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 172, "initializers": [] }
