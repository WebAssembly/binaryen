(module
  (memory $0 1)
  (data (i32.const 16) "Hello, World!\00")
  (type $FUNCSIG$ii (func (param i32) (result i32)))
  (import "env" "puts" (func $puts (param i32) (result i32)))
  (export "memory" (memory $0))
  (export "main" (func $main))
  (table 0 anyfunc)
  
  (func $main (param $0 i32) (param $1 i32) (result i32)
    (drop
      (call $puts
        (i32.const 16)
      )
    )
    (return
      (i32.const 0)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 30, "initializers": [] }
