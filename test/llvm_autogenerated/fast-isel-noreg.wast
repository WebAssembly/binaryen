(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "a" (func $a))
 (export "b" (func $b))
 (export "c" (func $c))
 (func $a (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $b (result i32)
  (block $label$0
   (br_if $label$0
    (i32.const 1)
   )
   (unreachable)
  )
  (return
   (i32.const 0)
  )
 )
 (func $c (result i32)
  (i32.store
   (i32.const 0)
   (i32.const 0)
  )
  (return
   (i32.const 0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
